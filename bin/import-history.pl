#!/usr/local/bin/perl

# Load history data to SQL tables.
# Does direct inserts - not really worried about performance, as this only
#  needs to run once

use strict;
use warnings;
use DBI;
use File::Basename;
use XML::LibXML;
use constant {
#	DEBUG => 1, # set to display debugging info
	XML_DIR => '../history/',
	CLUBS_XML => '../clubs.xml',
	XML_CATALOG => '../lax.xmlcatalog'
};
if ($#ARGV > 0 && $#ARGV != 5) {
    print "Usage: import-history.pl [database user password host port]";
    exit 1;
}
my ($db, $user, $pw, $host, $port) = $#ARGV > 0 ? @ARGV : ('local','root','root','127.0.0.1','10004');

my $compId = 0;
my %comp;
my %compAbbrev = (
	'Snr' => 'Senior',
	'Int' => 'Intermediate',
	'Mnr' => 'Minor',
	'Mid' => 'Midlands',
	'W&M' => 'West & Midlands',
	'EvW' => 'East v West',
	'Prem' => 'Premier Division'
);
my %compFullToAbbrev = (
	'Senior' => 'Snr',
	'Intermediate' => 'Int',
	'Minor' => 'Mnr',
	'Junior' => 'Jnr',
	'Midlands' => 'Mid',
	'West & Midlands' => 'W&M',
	'East v West' => 'EvW',
	'Premier Division' => 'Prem',
	'Western Region' => 'West'
);
my $compFullToAbbrevRegex = join '|', keys %compFullToAbbrev;
$compFullToAbbrevRegex = qr/($compFullToAbbrevRegex)/;

my %compType = ();
my %teamAbbrev = ();
my $dbh = DBI->connect("DBI:mysql:database=$db;host=$host;port=$port", $user, $pw, { RaiseError => 1, PrintError => 0 }) or die $DBI::errstr;

# my $competition = $dbh->prepare( "INSERT INTO sl_competition (`id`,
# 	`name`, `league_id`, `abbrev`, `seq`,`type`,`head_to_head`,`has_history`, `history_page`
# 	) VALUES (?,?,?,?,?,?,?,?,?)");
# was	`win_goals`, `lose_goals`, `has_data`
my $hist_winner = $dbh->prepare( "INSERT INTO slh_winner (`comp_id`,
	`year`, `winner`, `runner_up`, `result`,
	`has_data`
	) VALUES (?,?,?,?,?,?)");
# , `team_minimal`	
my $hist_table = $dbh->prepare( "INSERT INTO slh_table (
	`year`, `comp_id`, `position`, `team`,
	`played`, `won`, `drawn`, `lost`, `goals_for`, `goals_against`,
	`goal_avg`, `points_deducted`, `points`, `points_avg`, `divider`
	) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
my $hist_cup_draw = $dbh->prepare( "INSERT INTO slh_cup_draw (
	`year`,	`comp_id`, `round`, `match_num`, `team1`,
	`team2`, `team1_goals`, `team2_goals`,
	`result_extra`, `home_team`
  	) VALUES (?,?,?,?,?,?,?,?,?,?)");
my $hist_result = $dbh->prepare( "INSERT INTO slh_result (
	`year`, `match_date`, `comp_id`, `comp_id2`,
	`competition`, `home`, `away`, `home_goals`, `away_goals`,
	`result`, `home_points`, `away_points`, `points_multi`
  	) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");
my $hist_remarks = $dbh->prepare( "INSERT INTO slh_remarks ( `comp_id`, `year`, `remarks`) VALUES (?,?,?)");
my $team_abbrev = $dbh->prepare( "INSERT INTO sl_team_abbrev (`team`, `abbrev`) VALUES (?,?)");

$team_abbrev->execute('Chislehurst &amp; Sidcup Grammar School', 'Chislehurst &amp; Sidcup');
$teamAbbrev{'Chislehurst &amp; Sidcup Grammar School'} = 1;
$team_abbrev->execute('Henry Thorton School II', 'Henry Thorton II');
$teamAbbrev{'Henry Thorton School II'} = 1;
$team_abbrev->execute('St Dunstans College II', 'St Dunstans II');
$teamAbbrev{'St Dunstans College II'} = 1;
$team_abbrev->execute('Loughborough Uni', 'Loughborough');
$teamAbbrev{'Loughborough Uni'} = 1;
$team_abbrev->execute('Leicester Badgers', 'Leicester');
$teamAbbrev{'Leicester Badgers'} = 1;
$team_abbrev->execute('Chichester Crusaders', 'Chichester');
$teamAbbrev{'Chichester Crusaders'} = 1;
# $team_abbrev->execute('Camborne School of Mines', 'CSM');
# $teamAbbrev{'Camborne School of Mines'} = 1;
# $team_abbrev->execute('Camden Capybaras 3', 'Camden 3');
# $teamAbbrev{'Camden Capybaras 3'} = 1;
# $team_abbrev->execute('Loughborough Lions', 'Loughborough');
# $teamAbbrev{'Loughborough Lions'} = 1;
# $team_abbrev->execute('Lincoln City', 'Lincoln');
# $teamAbbrev{'Lincoln City'} = 1;
# $team_abbrev->execute('Leicester City', 'Leicester');
# $teamAbbrev{'Leicester City'} = 1;

# my $parser = XML::LibXML->new();
my $parser = XML::LibXML->new( { expand_entities => 0 } );
$parser->load_catalog( XML_CATALOG );

loadCompetitions(); # comment this out to create competitions as we go
loadAbbrevsFromClubsXml();
loadLeagues();
loadWinners();
loadFlags('westmidscup/westmidscup-2008.xml',1);
# fixtures needs to be at the end so all competitions have an id!
loadFixtures();
$hist_remarks->execute(getCompetitionId('Intermediate West Plate'), 2016, 'The quarter final and semi final were played over 2 legs.');
$hist_remarks->execute(getCompetitionId('Intermediate East Plate'), 2016, 'The quarter final and semi final were played over 2 legs.');
exit 0;

# Load in competitions from csv file
sub loadCompetitions {
	my $file = 'comps.csv';
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";
 
	while (my $line = <$data>) {
  		chomp $line;
		$line =~ s/"//g;
		$line =~ s/NULL//g;
		my @fields = split "," , $line;
		$compId++;
		my $league = $fields[1] ? $fields[1] : undef;
		my $abbrev = $fields[2] ? $fields[2] : undef;
		# $competition->execute( $compId, $fields[0], $league, $abbrev, $compId * 10,
		# 	$fields[3], $fields[4], $fields[5], $fields[6]);
		if ($league && $league eq '2') {
			$comp{'Local ' . $fields[0]} = $compId;
		} else {
			$comp{$fields[0]} = $compId;
		}
		if ($fields[2]) {
			$comp{$fields[2]} = $compId;
		}
		$compType{$compId} = $fields[4];
	}	
}
sub getCompetitionId {
	my ($name, $type, $abbrev) = @_;
	return $comp{$name} if $comp{$name};
	die("Unable to find competition $name");
	# $compId++;
	# if ($name =~ /Plate/ && $name !~ /Baird/) {
	# 	$type = 'plate';
	# } elsif ($name =~ /Midlands Cup/) {
	# 	$type = 'westmidscup';
	# }
	# if (!$abbrev && $type =~ /^(flags|plate|westmidscup)$/) {
	# 	$abbrev = $name;
	# 	$abbrev =~ s/$compFullToAbbrevRegex/$compFullToAbbrev{$1}/g;
	# 	$abbrev = undef if $abbrev eq $name;
	# }
	# $abbrev = undef if !$abbrev;
	# my $league = undef;
	# $type = 'league' if !$type;
	# if ($type == 'league') {
	# 	if ($name =~ /Local /) {
	# 		$name =~ s/Local //;
	# 		$league = 2;
	# 	} else {
	# 		$league = 1;
	# 	}
	# }
	# $competition->execute( $compId, $name, $league, $abbrev, $compId * 10, $type,
	# 	($name =~ /Varsity|North v South/ ? 1 : 0), 1);
	# $comp{$name} = $compId;
	# $compType{$compId} = $type;
	# if ($abbrev) {
	# 	$comp{$abbrev} = $compId;
	# }
	# return $compId;
}

sub loadAbbrevsFromClubsXml {
	my $clubsXml = $parser->parse_file(CLUBS_XML) or die "unable to parse CLUBS_XML $!";
	foreach my $team ($clubsXml->findnodes('//team/name[@short]')) {
		my $name = $team->to_literal();
		my $abbrev = $team->{short};
		$team_abbrev->execute($name, $abbrev);
		$teamAbbrev{$abbrev} = 1;
	}
}

# Get competition id from name, but don't create, and handle things
# like Mnr Flags R1 which should map to Minor Flags
sub getCompetitionIdFixtures {
	my ($name) = @_;
	my $compId;
	if ($name =~ /Friendly|Alumni|Playoff|Harrop|Veterans/) {
		return 0;
	}
	$name =~ s/(Flags|Plate|Cup).+$/$1/;
	$compId = $comp{$name} or die "no competition for $name";
	return $compId;

	if ($name =~ /^(.+)( (Flags|Plate|Cup))/) {
		my $type = $2;
		my $title = '';
		foreach my $part (split(/ /, $1)) {
			$title .= ' ' if $title;			
			if ($compAbbrev{$part}) {
				$title .= $compAbbrev{$part};
			} else {
				$title .= $part;
			}
		}
		$title .= $type;
		$compId = $comp{$title} or die "no competition for $name - $title";
	} else {
		$compId = $comp{$name} or die "no competition for $name";
	}
	return $compId;
}

sub loadWinners {
	print "Winners\n";
	my @multiResults = (
		'flags.xml',
		'plate.xml',
		'plate-east-west.xml',
		'western-flags.xml',
	);
	my @winnerOnly = ('baird-plate.xml',
		'brine-trophy.xml',
		'county.xml',
		'english-universities-cup.xml',
		'eric-jones-trophy.xml',
		'final-four.xml',
		'junior-sixes.xml',
		'west-of-england-league.xml',
	);
	my @results = (
		'division3-knockout-trophy.xml',
		'division4-flags.xml',
		'iroquois-cup.xml',
		'midlands-flags.xml',
		'national-club-championship.xml',
		'north-south-junior.xml',
		'north-south.xml',
		'varsity.xml',
		'wilkinson-sword.xml',
		'wills-challenge-shield.xml'
	);
	my @multi = (
		'junior-flags.xml',
		'sixes.xml',
	);
	foreach my $file (@multiResults) {
		my $dom = $parser->parse_file(XML_DIR . $file) or die "unable to parse $file XML $!";
		my $prefix = $dom->findvalue('/results/competitions/@prefix');
		foreach my $comp ($dom->findnodes('/results/competitions/comp')) {
			my $title = $comp->to_literal();
			if ($prefix) {
				$title = $prefix . ' ' .$title;
			}
			print "  $title\n";
			my $compId = getCompetitionId($title,'flags');
			foreach my $winner ($dom->findnodes('/results/season/winner[@compId="' . $comp->{id}. '"]')) {
				my ($wg,$lg) = ( 0, 0 );
				if ($winner->{result}) {
					if ($winner->{result} =~ /^(\d*) - (\d*)/) {
						($wg,$lg) = ($1,$2);
					}
				}
				$hist_winner->execute($compId, $winner->parentNode->{year},
					$winner->to_literal(), $winner->{rup}, $winner->{result}, # $wg, $lg,
					$winner->parentNode->hasAttribute('ref'));
			}
		}
		foreach my $ref ($dom->findnodes('/results/season/@ref')) {
			loadFlags($ref->to_literal());
		}
	}
	foreach my $file (@winnerOnly) {
    	my $dom = $parser->parse_file(XML_DIR . $file) or die "unable to parse $file XML $!";
		my $title = $dom->findnodes('/results/@title');
		print "  $title\n";
		my $compId = getCompetitionId($title,'winner');
	    foreach my $winner ($dom->findnodes('/results/winner')) {
    		$hist_winner->execute($compId, $winner->{year}, $winner->to_literal(),
				undef, undef,
				# 0, 0,
				0);
		}
	}
	foreach my $file (@results) {
		my $has_data = $file eq 'midlands-flags.xml' ? 1 : 0;
    	my $dom = $parser->parse_file(XML_DIR . $file) or die "unable to parse $file XML $!";
		my $title = $dom->findnodes('/results/@title');
		print "  $title\n";
		my $compId = getCompetitionId($title,'winner');
	    foreach my $winner ($dom->findnodes('/results/winner')) {
			# my ($wg,$lg) = ( 0, 0 );
			# if ($winner->{result}) {
			# 	if ($winner->{result} =~ /^(\d*) - (\d*)/) {
			# 		($wg,$lg) = ($1,$2);
			# 	}
			# }
    		$hist_winner->execute($compId, $winner->{year}, $winner->to_literal(), $winner->{rup},
				$winner->{result},
				# $wg, $lg,
				$has_data);
		}
	}
	foreach my $file (@multi) {
		my $dom = $parser->parse_file(XML_DIR . $file) or die "unable to parse $file XML $!";
		foreach my $comp ($dom->findnodes('/results/competitions/comp')) {
			my $title = $comp->to_literal();
			$title = $title . ' Sixes' if ($file =~ /sixes/) ;
			print "  $title\n";
			my $compId = getCompetitionId($title,'winner');
			foreach my $winner ($dom->findnodes('/results/season/winner[@compId="' . $comp->{id}. '"]')) {
				$hist_winner->execute($compId, $winner->parentNode->{year}, $winner->to_literal(), undef, undef,
				# 0, 0,
				0);
			}
		}
	}
}

sub loadLeagues {
	print "Leagues\n";
	my $dom = $parser->parse_file(XML_DIR . 'league.xml') or die "unable to parse league XML $!";
	foreach my $league ($dom->findnodes('/league-results/league')) {
		if ($league->{ref}) {
			loadTables($league->{year}, $league->{ref});
		} else {
			foreach my $winner ($league->findnodes('winner')) {
				my $compId = getCompetitionId($winner->{division},'league');
	    		$hist_winner->execute($compId, $league->{year}, $winner->to_literal(), undef, undef,
				# 0, 0,
				0);
			}
		}
	}
}

sub loadTables {
	my ($year, $ref) = @_;
	print "  Tables $ref\n";
	my $dom = $parser->parse_file(XML_DIR . $ref) or die "unable to parse $ref XML $!";
	my $cols = $dom->documentElement()->{cols};
	my $doGoalAvg = $cols && $cols eq 'goal-avg' ? 1 : 0;
	my $doPtsAvg = $cols && $cols eq 'pts-avg' ? 1 : 0;
	foreach my $division ($dom->findnodes('/league-tables/division')) {
		my $divisionName = $division->findvalue('division-name');
		my $short = $division->findvalue('division-name/@short');
		my $compId = getCompetitionId($divisionName,
			$division->{'preliminary'} ? 'league-prelim':'league',	$short);

		my $pos = 0;
		foreach my $team ($division->findnodes('team')) {
			my $teamName = $team->findvalue('team-name');
			# my $teamMinimal = $year > 2002 ? $team->findvalue('team-name/@minimal') : '';
			my $won = notNull($team->findvalue('won'));
			my $drawn = notNull($team->findvalue('drawn'));
			my $lost = notNull($team->findvalue('lost'));
			my $played = $team->findvalue('played');
			if (!$played) {
				$played = $won + $drawn + $lost;
			}
			if ($pos == 0 && $played != 0) {
				if (! $division->{'preliminary'}) {
					$hist_winner->execute($compId, $year, $teamName, undef, undef,
					# 0, 0,
					1);
				}
			}
			my $for = $team->findvalue('for');
			my $against = $team->findvalue('against');
			my $goalAvg = $doGoalAvg && $against ? $for / $against : undef;
			my $points = $team->findvalue('points');
			my $ptsAvg = $doPtsAvg && $played ? $points / $played : undef;
			my $divider = $team->{class} && $team->{class} eq 'divider' ? 1 : 0;
    		$hist_table->execute($year, $compId, ++$pos,
				$teamName, # $teamMinimal,
				$played, $won, $drawn, $lost,
				notNull($for),
				notNull($against),
				$goalAvg,
				notNull($team->findvalue('deducted')),
				notNull($points),
				$ptsAvg,$divider
			);

			my $abbrev = $team->findvalue('team-name/@short');
			if ($abbrev && !$teamAbbrev{$abbrev}) {
				$teamAbbrev{$abbrev} = 1;
				$team_abbrev->execute($teamName, $abbrev);
			}
		}
		my $remarks = $division->findnodes('remarks');
		if ($remarks) {
			$remarks = $remarks->[0]->toString();
			$remarks =~ s/<.?remarks>//g;
			$remarks =~ s!<br ?/>!<br>!g;
			$hist_remarks->execute($compId, $year, $remarks);
		}
	}
}

sub loadFixtures {
	my $dir = XML_DIR . 'league';
	print "Fixtures\n";
	opendir(DIR, $dir) || die "opendir failed on $dir: $!";
    my @list = grep(/fixture.*\.xml$/,readdir(DIR));
    closedir(DIR);
	my $is_league;
    foreach my $item (@list) {
		my $dom = $parser->parse_file($dir . '/' . $item) or die "unable to parse $item XML $!";
		my ($year) = $item =~ /(\d\d\d\d)/;
		print "  $year\n";

		foreach my $fixture ($dom->findnodes('/fixtures/fixture')) {
			my $competition = $fixture->findvalue('competition');
			die "no competition $fixture" if (!$competition);
			my $homeTeam = $fixture->findvalue('home-team');
			next if $homeTeam =~ /Rearrang/;
			my ($homeGoals, $awayGoals, $homePoints, $awayPoints, $result);
			my $multi = 1;
			if (! $fixture->find('home-goals') ) {
				$homeGoals = $awayGoals = undef;
				$homePoints = $awayPoints = undef;
				$result = 'Void';
			} else {
				$homeGoals = $fixture->findvalue('home-goals');
				if ($homeGoals !~ /^\d+$/) {
					if ($homeGoals eq 'A') {
						$result = 'Abandonded';
					} elsif ($homeGoals eq 'C') {
						$result = 'Cancelled';
					} elsif ($homeGoals =~ /[VXx?]/ || $homeGoals eq '') {
						$result = 'Void';
					} elsif ($homeGoals =~ /[PMNF]/) {
						$result = 'R - R';
					} else {
						$result = $homeGoals . ' - ' . $fixture->findvalue('away-goals');
					}
					$homeGoals = $awayGoals = undef;
					$homePoints = $awayPoints = undef;
				} else {
					$awayGoals = $fixture->findvalue('away-goals');
					$result = $homeGoals . ' - ' . $awayGoals;
					my $penalty = $fixture->findvalue('penalty');
					if ($penalty) {
						$result .= ' w/o';
						my $minus = $penalty eq 'C24' ? -1 : 0;
						if ($homeGoals == 10) {
							$homePoints = 4;
							$awayPoints = $minus;
						} else {
							$homePoints = $minus;
							$awayPoints = 4;
						}
					} else {
						if ($year < 2016) {
							# w=3,d=2,l=1,c=0
							if ($homeGoals == $awayGoals) {
								$homePoints = $awayPoints = 2;
							} elsif ($homeGoals > $awayGoals) {
								$homePoints = 3;
								$awayPoints = 1;
							} else {
								$homePoints = 1;
								$awayPoints = 3;
							}
						} else {
							# w=4,d=3,l=2,c=0,c24=-1
							if ($homeGoals == $awayGoals) {
								$homePoints = $awayPoints = 3;
							} elsif ($homeGoals > $awayGoals) {
								$homePoints = 4;
								$awayPoints = 2;
							} else {
								$homePoints = 2;
								$awayPoints = 4;
							}
						}
					}
					my $newMulti = $fixture->findvalue('multi');
					$multi = $newMulti if $newMulti;
				}
			}
			# split multi competition lines
			foreach my $compName (split(/ & /, $competition)) {
				my ($compId1, $compId2);
				if ($compName =~ /^(.+)\/(.+)$/) { # ladder
					$compId1 = getCompetitionIdFixtures($1);
					$compId2 = getCompetitionIdFixtures($2);
					$is_league = 1;
				} else {
					$compId1 = getCompetitionIdFixtures($compName);
					$compId2 = 0;
					$is_league = $compId1 && $compType{$compId1} =~ /^l/ ? 1 : 0;
				}
				if ($is_league) {
					$hist_result->execute($year,
						$fixture->findvalue('date'),
						$compId1, $compId2,
						$compName,
						$homeTeam,
						$fixture->findvalue('away-team'),
						$homeGoals,$awayGoals,$result,
						$homePoints,$awayPoints,
						$multi ? $multi : 1
					);
				} else {
					$hist_result->execute($year,
						$fixture->findvalue('date'),
						$compId1, $compId2,
						$compName,
						$homeTeam,
						$fixture->findvalue('away-team'),
						$homeGoals,$awayGoals,$result,
						undef, undef, 0
					);
				}
			}
		}
	}
} 

sub notNull{
	my ($val) = @_;
	return $val ? $val : 0;
}

sub loadFlags {
	my ($ref,$getComp) = @_;
	print "    Flags $ref\n";
	my $dom = $parser->parse_file(XML_DIR . $ref) or die "unable to parse $ref XML $!";
	my $flags = $dom->getDocumentElement;
	my $year = $flags->{year};
	foreach my $flagsComp ($dom->findnodes('/flags/flags-competition')) {
		my $title = $flagsComp->{'name'} . ' ' . $flags->{'name'};
		my $compId;
		if ($getComp || $title eq 'Midlands Flags') {
			$compId = getCompetitionId($title,'flags');
		} else {
			$compId = $comp{$title} or die "no competition for $title";
		}
		my $roundNum = 0;

		foreach my $round ($flagsComp->findnodes('round')) {
			$roundNum++;
			foreach my $match ($round->findnodes('match')) {
				my $score = $match->findvalue('score');
				my $extra = $match->findvalue('score/@extra');
				my ($goals1, $goals2) = $score =~ /(\d+) - (\d+)/;
				my $home_team = notNull($match->{'home'});
				if ($match->{'neutral'}) {
					$home_team += 2;
				}
				my $team1 = $match->findvalue('team1');
				my $team2 = $match->findvalue('team2');
				# $team1 =~ s/Henry Thorton II/Henry Thorton School II/;
				$team2 =~ s/Henry Thorton II/Henry Thorton School II/;
				$hist_cup_draw->execute($year, $compId, $roundNum,
					$match->{'matchNum'},
					$team1,
					$team2,
					$goals1, $goals2,
					$extra ? $extra : '',
					$home_team
				);
			}
		}

		my $remarks = $flagsComp->findnodes('remarks');
		if ($remarks) {
			$remarks = $remarks->[0]->toString();
			$remarks =~ s/<.?remarks>//g;
			$remarks =~ s!<br ?/>!<br>!g;
			$hist_remarks->execute($compId, $year, $remarks);
		}
	}
}
