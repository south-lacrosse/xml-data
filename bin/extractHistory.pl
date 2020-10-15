#!/usr/bin/perl -w
# Extract history from spreadsheet supplied by Jon Cooper, and format into XML
# Includes tables, competitions etc

use strict;
use Spreadsheet::ParseExcel;
use File::Path qw(make_path);

my $src = '../Historic results.xls';
my $destdir = 'C:/tmp/build/history';
make_path("$destdir/league");

my $parser   = Spreadsheet::ParseExcel->new();
my $workbook = $parser->parse($src);

if ( !defined $workbook ) {
	die $parser->error(), ".\n";
}

print "File: ", $workbook->{File} , "\n";
print "Sheet count: ", $workbook->{SheetCount} , "\n";

extractLeague($workbook->worksheet('League winners'));
extractCompetitions($workbook->worksheet('League winners'),
	[2], # title rows
	0,		 # year column
	['Premiership playoff winner','9th place v Loser'],	# competition titles
	[], # competition columns - used if titles cannot be found, usually left blank
	['East v West Playoff','Premiership Playoff'],	# competition names
	['e-v-w','playoff'], # ids
	[], # alt names
	[0,0],		# offset of runner up
	'League Playoffs'  # title to put in results file
	,'playoffs'); # results file name (no .xml)
# All the league tables
for my $sheet ( $workbook->worksheets() ) {
	my $sheetName = $sheet->{Name};
	my $year = 0;
	if ( ($sheetName =~ /^\d\d\d\d (\d\d\d\d)/) || ($sheetName =~ /^(\d\d\d\d)$/) ) {
		$year = $1;
	}
	next unless $year;
	next if $year > 2002;
	extractLeagueTable($sheet, $year);
}

extractCompetitions($workbook->worksheet('Sixes winners'),
	[2], # title rows
	0,		 # year column
	['Senior','Intermediate','Minor','4th'],	# competition titles
	[], # competition columns - used if titles cannot be found, usually left blank
	['Senior','Intermediate','Minor','Division 4'],	# competition names
	['snr','int','mnr','div4'], # ids
	[], # alt names
	[0,0,0,0],		# offset of runner up
	'Six-a-Sides Winners'  # title to put in results file
	,'sixes'); # results file name (no .xml)

#extractCompetitions($workbook->worksheet('Other SEMLA competitions'),
#	[16,17], # title rows
#	0,		 # year column
#	['Southern Counties competition','Varsity matches','Brine Trophy','Final four'],	# competition titles
#	[], # competition columns - used if titles cannot be found, usually left blank
#	['Southern Counties','Varsity','Brine Trophy','Final Four'],	# competition names
#	['county','varsity','brine','final-four'], # ids
#	[undef,'varsity'], # alt names
#	[0,4,0,0],		# offset of runner up
#	'Other SEMLA Competitions'  # title to put in results file
#	,'other'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Other SEMLA competitions'),
  [16,17], # title rows
  0,     # year column
  'Southern Counties competition',  # competition title
  0, # competition column - used if titles cannot be found, usually left blank
  0,   # offset of runner up
  'Southern Counties'  # title to put in results file
  ,'county'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Other SEMLA competitions'),
	[16,17], # title rows
	0,		 # year column
	'Varsity matches',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	4,		# offset of runner up
	'Varsity'  # title to put in results file
	,'varsity'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Other SEMLA competitions'),
	[16,17], # title rows
	0,		 # year column
	'Brine Trophy',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	'Brine Trophy'  # title to put in results file
	,'brine-trophy'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Other SEMLA competitions'),
	[16,17], # title rows
	0,		 # year column
	'Final four',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	'Final Four'  # title to put in results file
	,'final-four'); # results file name (no .xml)
	
extractFlags($workbook->worksheet('Flags winners'));

extractSingleCompetition($workbook->worksheet('Flags winners'),
	[30], # title rows
  1,     # year column
  'Division 3 knockout Trophy',  # competition title
  0, # competition column - used if titles cannot be found, usually left blank
  4,   # offset of runner up
  'Division 3 Knockout Trophy'  # title to put in results file
  ,'division3-knockout-trophy'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Flags winners'),
	[1], # title rows
  1,     # year column
  'Division 4',  # competition title
  0, # competition column - used if titles cannot be found, usually left blank
  2,   # offset of runner up
  'Division 4 Flags'  # title to put in results file
  ,'division4-flags'); # results file name (no .xml)
extractSingleCompetition($workbook->worksheet('Flags winners'),
	[1], # title rows
  1,     # year column
  'Midlands',  # competition title
  0, # competition column - used if titles cannot be found, usually left blank
  4,   # offset of runner up
  'Midlands Flags'  # title to put in results file
  ,'midlands-flags'); # results file name (no .xml)


#extractCompetitions($workbook->worksheet('Junior Competitions'), 
#	[1,3], # title rows
#	1,		 # year column
#	['Junior','U14','U12','Junior Sixes','Baird Plate','Eric Jones Trophy'],	# competition titles
#	[], # competition columns - used if titles cannot be found, usually left blank
#	['Junior Flags','U14 Flags','U12 Flags','Junior Six-A-Sides','Baird Plate','Eric Jones Trophy'],	# competition names
#	['flags','u14flags','u12flags','sixes','baird','jones'], # ids
#	[], # alt names
#	[0,0,0,0],		# offset of runner up
#	"Junior Competition Winners", # title to put in results file
#	'juniors' # results file name (no .xml)
#);
extractCompetitions($workbook->worksheet('Junior Competitions'), 
	[1,3], # title rows
	1,		 # year column
	['Junior','U14','U12'],	# competition titles
	[], # competition columns - used if titles cannot be found, usually left blank
	['Junior Flags','U14 Flags','U12 Flags'],	# competition names
	['flags','u14flags','u12flags'], # ids
	[], # alt names
	[0,0,0],		# offset of runner up
	"Junior Flags Winners", # title to put in results file
	'junior-flags' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('Junior Competitions'), 
	[1,3], # title rows
	1,		 # year column
	'Junior Sixes',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	"Junior Six-A-Sides", # title to put in results file
	'junior-sixes' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('Junior Competitions'), 
	[1,3], # title rows
	1,		 # year column
	'Baird Plate',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	"Baird Plate (Juniors)", # title to put in results file
	'baird-plate' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('Junior Competitions'), 
	[1,3], # title rows
	1,		 # year column
	'Eric Jones Trophy',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	'Eric Jones Trophy', # title to put in results file
	'eric-jones-trophy' # results file name (no .xml)
);

#extractCompetitions($workbook->worksheet('National competitions'), 
#	[1], # title rows
#	0,		 # year column
#	['Iroquois cup','Wilkinson Sword'
#		,'North v South (instigated 1877)','North v South Juniors (Instigated 1958)','English Universities cup'],	# competition titles
#	[], # competition columns - used if titles cannot be found, usually left blank
#	['Iroquois Cup','Wilkinson Sword','North v South','North v South Juniors','English Universities Cup'],	# competition names
#	['iroq','wilk','n-s','n-s-jnr','univ'], # ids
#	['iroquois-cup','wilkinson-sword','north-south','north-south-junior'], # alt names
#	[4,4,2,2,0],		# offset of runner up
#	"National Competitions", # title to put in results file
#	'national' # results file name (no .xml)
#);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'Iroquois cup',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	4,		# offset of runner up
	"Iroquois Cup", # title to put in results file
	'iroquois-cup' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'Wilkinson Sword',	# competition titles
	0, # competition column - used if titles cannot be found, usually left blank
	4,		# offset of runner up
	"Wilkinson Sword", # title to put in results file
	'wilkinson-sword' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'North v South (instigated 1877)',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	2,		# offset of runner up
	"North v South", # title to put in results file
	'north-south' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'North v South Juniors (Instigated 1958)',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	2,		# offset of runner up
	"North v South Juniors", # title to put in results file
	'north-south-junior' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'English Universities cup',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	'English Universities Cup', # title to put in results file
	'english-universities-cup' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('National competitions'), 
	[1], # title rows
	0,		 # year column
	'National Club Championship',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	4,   # offset of runner up
	'National Club Championship', # title to put in results file
	'national-club-championship' # results file name (no .xml)
);

#extractCompetitions($workbook->worksheet('Western winners'), 
#	[1], # title rows
#	0,		 # year column
#	['Western Flag tournament','Junior Western Flag'
#		,'West of England League Championship','Wills\' Challenge Shield'],	# competition titles
#	[], # competition columns - used if titles cannot be found, usually left blank
#	['Senior Flags','Junior Flags','League','Wills\' Challenge Shield'],	# competition names
#	['snr','jnr','lge','wills'],	# ids
#	['western-flags-senior'], # alt names
#	[4,0,0,0],		# offset of runner up
#	"Western Region", # title to put in results file
#	'western' # results file name (no .xml)
#);
extractCompetitions($workbook->worksheet('Western winners'), 
	[1], # title rows
	0,		 # year column
	['Western Flag tournament','Junior Western Flag'],	# competition titles
	[], # competition columns - used if titles cannot be found, usually left blank
	['Senior Flags','Junior Flags'],	# competition names
	['snr','jnr'],	# ids
	['western-flags-senior'], # alt names
	[4,0],		# offset of runner up
	"Western Region Flags", # title to put in results file
	'western-flags' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('Western winners'), 
	[1], # title rows
	0,		 # year column
	'West of England League Championship',	# competition titles
	[], # competition columns - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	"West of England League Champions", # title to put in results file
	'west-of-england-league' # results file name (no .xml)
);
extractSingleCompetition($workbook->worksheet('Western winners'), 
	[1], # title rows
	0,		 # year column
	'Wills\' Challenge Shield',	# competition title
	0, # competition column - used if titles cannot be found, usually left blank
	0,		# offset of runner up
	'Wills\' Challenge Shield', # title to put in results file
	'wills-challenge-shield' # results file name (no .xml)
);

print "Completed\n";
exit(0);

sub extractLeagueTable {
	my ($sheet, $year) = @_;
	
    my ( $row_min, $row_max ) = $sheet->row_range();
    my ( $col_min, $col_max ) = $sheet->col_range();
	
	print "  Extracting league tables for year: $year - rows $row_min-$row_max cols $col_min-$col_max\n";
	
	open (OUTFILE, ">$destdir/league/tables-$year.xml");
	print OUTFILE  << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE league-tables PUBLIC "-//Purleylax//DTD Document 1.0//EN" "document.dtd">
<league-tables year="$year">
EOF
;

	# find each division - has heading in col2 of P./P/Played
    for my $row ( $row_min .. $row_max ) {
        my $cell = cellValue($sheet,  $row, 1 );
        next unless $cell;
        my ($wonCol,$drawnCol,$lostCol,$forCol,$againstCol,$deductCol,$pointsCol);
       	my $avgtag = '';
        if ($cell eq 'P.' || $cell eq 'P') {
        	($wonCol,$drawnCol,$lostCol,$forCol,$againstCol,$deductCol) = (2,3,4,5,6,0);
	       	$pointsCol = cellValue($sheet, $row, 7 ) ? 7 : 0;
	       	my $avg = cellValue($sheet, $row, 8 );
	      		if ($avg =~ /[Pp]ts.*[Aa]v[eg]/ || $avg =~ /\%/) {
	      			$avgtag = ' cols="pts-avg"';
	       	}
        } elsif ($cell eq 'Played') {
        	if (cellValue($sheet, $row, 5 ) eq 'Points') {
	        	($wonCol,$drawnCol,$lostCol,$forCol,$againstCol,$deductCol,$pointsCol) = (2,3,4,6,7,0,5);
        	} else {
        	($wonCol,$drawnCol,$lostCol,$forCol,$againstCol) = (2,3,4,5,6);
	        	if (cellValue($sheet, $row, 7 ) eq 'Points') {
	        		($deductCol,$pointsCol) = (0,7);
	        	} elsif (cellValue($sheet, $row, 8 ) eq 'Deduct') {
	        		($deductCol,$pointsCol) = (8,9);
	        	} else {
	        		($deductCol,$pointsCol) = (0,8);
	        	}	
        	}
        	if (cellValue($sheet, $row, $pointsCol+1 ) eq 'Ave.') {
	      		$avgtag = ' cols="pts-avg"';
        	}
        } else {
        	next;
        }
       	my $division = cellValue($sheet, $row, 0 ) ||  cellValue($sheet, $row - 1, 1 )
       	 ||  cellValue($sheet, $row - 1, 0 ) ||  cellValue($sheet, $row - 2, 0 );
       	if ($division) {
			$division =~ s/([A-Z])/lc($1)/eg; # lowercase all letters
			$division =~ s/\b(\w)/uc($1)/eg; # then capitalize all words
       	}
        	
       	print "    Division $division\n";
		print OUTFILE "<division$avgtag><division-name>$division</division-name>\n";
		if (!(teamName($sheet, $row+1, 0 ))) {
			$row++;
		}
	    for my $divrow ( $row+1 .. $row_max ) {
	    	my $team = teamName($sheet, $divrow, 0 );
	    	last unless $team;
		    	
	    	my $won = cellValue($sheet, $divrow, $wonCol );
	    	my $drawn = cellValue($sheet, $divrow, $drawnCol ) || '0';
	    	my $lost = cellValue($sheet, $divrow, $lostCol );
	    	my $for = cellValue($sheet, $divrow, $forCol );
	    	my $against = cellValue($sheet, $divrow, $againstCol );
		    	
			print OUTFILE "<team><team-name>$team</team-name><won>$won</won><drawn>$drawn</drawn><lost>$lost</lost>";
			if ($deductCol) {
		    	my $deduct = cellValue($sheet, $divrow, $deductCol );
		    	if ($deduct) {
					print OUTFILE "<deducted>$deduct</deducted>";
		    	}
	    	}
			if ($pointsCol) {
		    	my $points = cellValue($sheet, $divrow, $pointsCol );
				print OUTFILE "<points>$points</points>";
	    	}
			print OUTFILE "<for>$for</for><against>$against</against></team>\n";
			$row = $divrow;
	    }
		print OUTFILE "</division>\n";
    }

	print OUTFILE "</league-tables>\n";	
	close (OUTFILE); 			
}
sub cellValue {
	my ($sheet,$row,$col) = @_;
	my $cell = $sheet->get_cell( $row, $col );
	return '' unless $cell;
	my $value = $cell->value();
	return ($value eq '-') ? '0' : $value;
}
sub teamName {
	my ($sheet,$row,$col) = @_;
	
	my $cell = $sheet->get_cell( $row, $col );
	return '' unless $cell;
	my $team = $cell->value();
	$team =~ s/ *$//;
	
	return '' if ($team =~ /none|contest|^not? |no game| war$|Unfinished| year |Division|Results for|Started in| the |^the | [Tt]rophy|Played/i);
	return '' if length($team) > 40;
	
	my $format = $cell->{Format};
	# NB: Spreadsheet::XLSX doesn't read cell formats, so if we move to that format then:
	# my $type = reftype $format;
	# if ($type && $type eq 'HASH') {...}
	# Bold & underlined cells are actually titles, not teams
	my $font = $format->{Font};
	return if $font->{Bold} && $font->{Underline};
	
   	$team =~ s/&/&amp;/;
   	$team =~ s/ and / &amp; /;
   	$team =~ s/Uni?ver(si|is)ty/Uni/;
   	$team =~ s/Uni of (.*)$/$1 Uni/;
   	$team =~ s/Univ$/Uni/;
   	$team =~ s/Bexley +Hheath/Bexleyheath/i;
   	$team =~ s/Bristol City Bombers/Bristol Bombers/;
   	$team =~ s/Cambridge Uni (Eagles|Ospreys)/Cambridge $1/;
   	$team =~ s/Cambridge Uni $/Cambridge Uni/;
   	$team =~ s/Carlshalton/Carshalton/;
   	$team =~ s/[Cc]hislehurst.*[Ss]idcup.*[Ss]ch(ool|)/Chislehurst &amp; Sidcup School/;
   	$team =~ s/^drawn?$/Drawn/i;
   	$team =~ s/H Thornton/Henry Thornton/i;
   	$team =~ s/Hamptead/Hampstead/;
   	$team =~ s/juniors/Juniors/;
#   	$team =~ s/ juniors//i;
   	$team =~ s/J Ruskin/John Ruskin/i;
   	$team =~ s/Oxford Uni Iroquois/Oxford Iroquois/;
   	$team =~ s/Reading$/Reading Wildcats/;
   	$team =~ s/S Mancheser/South Manchester/;
   	$team =~ s/school/School/;
   	$team =~ s/St.? ?Hell?ier/St Helier/;
   	$team =~ s/South Manchester &amp; Wythenshawe/S Manchester &amp; Wythenshawe/;
   	$team =~ s/W London/West London/;
   	$team =~ s/^Wills$/WD &amp; HO Wills/;
   	$team =~ s/ Lacrosse$//;
   	$team =~ s/Sec Sch(ool|)/School/;
   	$team =~ s/ Juniors//;
   	$team =~ s/Welwyn$/Welwyn Warriors/;
   	$team =~ s/Cardiff City/Cardiff/;
   	$team =~ s/ (in|by|beat) .*$//;
   	$team =~ s/ \(.*$//;
   	$team =~ s/'([A-D])'/$1/;
   	return $team;
}
sub extractFlags {
	my ($sheet) = @_;
	print "  Extracting Flags\n";
	
	open (OUTFILE, ">$destdir/flags.xml");
	print OUTFILE  << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<results title="Flags Winners">
  <competitions>
    <comp id="snr" alt="flags-senior" short="Senior" match="Finals">Senior Flags</comp>
    <comp id="int" alt="flags-int" short="Intermediate" match="Finals">Intermediate Flags</comp>
    <comp id="mnr" alt="flags-minor" short="Minor" match="Finals">Minor Flags</comp>
  </competitions>
EOF
;
	my @compIds = ("snr","int","mnr");
	my @comps = ("Senior flags","Intermediate flags","Minor flags");
	my (@compCol, @rupOffset);
	
    my ( $col_min, $col_max ) = $sheet->col_range();
	for my $col ( 2 .. $col_max ) {
		my $cell = cellValue($sheet, 1, $col);
		if ($cell) {
			for my $compNo ( 0 .. $#comps ) {
				if ( $cell =~ /$comps[$compNo]/ ) {
					$compCol[$compNo] = $col;
					$rupOffset[$compNo] = cellValue($sheet, 2, $col+2) =~ /beat/ ? 4 : 2;
				}
			}
		}
	}
	
	my ( $row_min, $row_max ) = $sheet->row_range();
	for my $row ( 3 .. $row_max ) {
		if (my $year = cellValue($sheet, $row, 1 )) {
			next if not($year =~ /^\d\d\d\d/);
			print OUTFILE "  <season year=\"$year\"";
			if ($year =~ /^\d+$/ && ($year >= 2002 || $year == 1998)) {
				print OUTFILE " ref=\"flags/flags-$year.xml\"";
			}
			print OUTFILE  ">\n";
			for my $compNo ( 0 .. $#comps ) {
				my $col = $compCol[$compNo];
				if (my $winner = teamName($sheet, $row, $col )) {
					my $compId = $compIds[$compNo];
					print OUTFILE "    <winner compId=\"$compId\"";
					my $rupOff = $rupOffset[$compNo];
					if ($rupOff) {
						if (my $rupname = teamName($sheet, $row, $col + $rupOff )) {
							print OUTFILE " rup=\"$rupname\"";
						}
						if (my $result = cellValue($sheet, $row, $col + 1 )) {
							print OUTFILE " result=\"";
							if ($rupOff == 4) {
								print OUTFILE $result;
								print OUTFILE " - ";
								print OUTFILE cellValue($sheet, $row, $col + 3 );
								if (cellValue($sheet, $row, $col+2) =~ /OT/) {
									print OUTFILE " (OT)";
								}
							} else {
								$result =~ s/Conceded by .*$/Conceded/;
								$result =~ s/(\d)-(\d)/$1 - $2/;
								$result =~ s/ v / - /;
								print OUTFILE $result;
							}
							print OUTFILE "\"";
						}
					}
					print OUTFILE ">$winner</winner>\n";
				}
			}
			print OUTFILE "  </season>\n";
		}
	}
	
	print OUTFILE "</results>\n";	
	close (OUTFILE); 			
}
sub extractCompetitions {
	my ($sheet,$titleRows_ref,$yearCol,$comps_ref,$compCol_ref,$compNames_ref,$ids_ref,$altNames_ref,$rupOffset_ref,$title,$filename) = @_;
	my @titleRows = @$titleRows_ref;
	my @comps = @$comps_ref;
	my @compCol = @$compCol_ref;
	my @compNames = @$compNames_ref;
	my @ids = @$ids_ref;
	my @altNames = @$altNames_ref;
	my @rupOffset = @$rupOffset_ref;
	
	print "  Extracting $title to $filename\n";
	open (OUTFILE, ">$destdir/$filename.xml");
	
	print OUTFILE  << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<results title="$title">
  <competitions>
EOF
;
	my @noUniv = ();
	for my $compNo ( 0 .. $#comps ) {
	    print OUTFILE "    <comp id=\"$ids[$compNo]\"";
	    if ($altNames[$compNo]) {
		    print OUTFILE " alt=\"$altNames[$compNo]\"";
	    }
	    print OUTFILE ">$compNames[$compNo]</comp>\n";
	    $noUniv[$compNo] = ($ids[$compNo] eq 'varsity') 
	    			|| ($compNames[$compNo] eq 'English Universities Cup');
	}
    print OUTFILE "  </competitions>\n";

    my ( $col_min, $col_max ) = $sheet->col_range();
	
	# find columns of competition titles on sheet
	for my $col ( 1 .. $col_max ) {
		rowloop: foreach my $titleRow (@titleRows) {
			my $cell = cellValue($sheet, $titleRow, $col);
			if ($cell) {
				for my $compNo ( 0 .. $#comps ) {
					if ( $cell eq $comps[$compNo] ) {
						$compCol[$compNo] = $col;
	#					print "found $comps[$compNo] at $col\n"
						last rowloop;
					}
				}
			}
		}
	}
	
	my ( $row_min, $row_max ) = $sheet->row_range();
	for my $row ( $titleRows[$#titleRows]+1 .. $row_max ) {
		if (my $year = cellValue($sheet, $row, $yearCol )) {
			next if not($year =~ /^\d\d\d\d/);
			my $season = '';
			for my $compNo ( 0 .. $#comps ) {
				my $col = $compCol[$compNo];
				if (my $winner = teamName($sheet, $row, $col )) {
					$winner =~ s/ Univ(ersities|\.)// if $noUniv[$compNo]; 
					$season .= "    <winner compId=\"$ids[$compNo]\"";
					my $rupOff = $rupOffset[$compNo];
					if ($rupOff) {
						if (my $rupname = teamName($sheet, $row, $col + $rupOff )) {
							$rupname =~ s/ Univ(ersities|\.)// if $noUniv[$compNo];
							$season .= " rup=\"$rupname\"";
						}
						if (my $result = cellValue($sheet, $row, $col + 1 )) {
							$season .= " result=\"";
							if ($rupOff == 4) {
								$season .= $result;
								$season .= " - ";
								$season .= cellValue($sheet, $row, $col + 3 );
							} else {
								$result =~ s/Conceded by .*$/Conceded/;
								$result =~ s/(\d)-(\d)/$1 - $2/;
								$result =~ s/ v / - /;
								$season .= $result;
							}
							$season .= "\"";
						}
					}
					$season .= ">$winner</winner>\n";
				}
			}
			if ($season) {
				print OUTFILE "  <season year=\"$year\">\n";
				print OUTFILE $season;
				print OUTFILE "  </season>\n";
			}
		}
	}
	
	print OUTFILE "</results>\n";	
	close (OUTFILE); 			
}
# probably shold refactor this, but since tis is essentially a one-off hack there's no need
sub extractSingleCompetition {
	my ($sheet,$titleRows_ref,$yearCol,$comp,$compCol,$rupOffset,$title,$filename) = @_;
	my @titleRows = @$titleRows_ref;
	
	print "  Extracting $title to $filename\n";
	open (OUTFILE, ">$destdir/$filename.xml");
	
	print OUTFILE  << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<results title="$title">
EOF
;
	my $noUniv = $title =~/(Varsity|English Universities Cup)/;

    my ( $col_min, $col_max ) = $sheet->col_range();
	
	# find columns of competition title on sheet
	comploop: for my $col ( 1 .. $col_max ) {
		foreach my $titleRow (@titleRows) {
			my $cell = cellValue($sheet, $titleRow, $col);
			if ($cell && $cell eq $comp ) {
				$compCol = $col;
				last comploop;
			}
		}
	}
	
	my ( $row_min, $row_max ) = $sheet->row_range();
	for my $row ( $titleRows[$#titleRows]+1 .. $row_max ) {
		if (my $year = cellValue($sheet, $row, $yearCol )) {
			next if not($year =~ /^\d\d\d\d/);
			if (my $winner = teamName($sheet, $row, $compCol )) {
				$winner =~ s/ Univ(ersities|\.)// if $noUniv; 
				print OUTFILE "  <winner year=\"$year\"";
				my $rupOff = $rupOffset;
				if ($rupOff) {
					if (my $rupname = teamName($sheet, $row, $compCol + $rupOff )) {
						$rupname =~ s/ Univ(ersities|\.)// if $noUniv;
						print OUTFILE " rup=\"$rupname\"";
					}
					if (my $result = cellValue($sheet, $row, $compCol + 1 )) {
						print OUTFILE " result=\"";
						if ($rupOff == 4) {
							print OUTFILE $result . " - "
								 . cellValue($sheet, $row, $compCol + 3 );
						} else {
							$result =~ s/Conceded by .*$/Conceded/;
							$result =~ s/(\d)-(\d)/$1 - $2/;
							$result =~ s/ v / - /;
							print OUTFILE  $result;
						}
						print OUTFILE "\"";
					}
				}
				print OUTFILE ">$winner</winner>\n";
			}
		}
	}
	
	print OUTFILE "</results>\n";	
	close (OUTFILE); 			
}
sub extractLeague {
	my ($sheet) = @_;
	print "  Extracting League\n";
	
	open (OUTFILE, ">$destdir/league.xml");
	print OUTFILE  << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<league-results>
EOF
;

	my (@comps, @compCol);
		
	my ( $row_min, $row_max ) = $sheet->row_range();
	my ( $col_min, $col_max ) = $sheet->col_range();
	for my $row ( 2 .. $row_max ) {
		my $year = cellValue($sheet, $row, 0 );
		if (!($year =~ /^\d\d\d\d/)) {
			# heading row - reset comps
			@comps = ();
			@compCol = ();
			for my $col ( 2 .. $col_max) {
				my $heading = cellValue($sheet, $row, $col );
				last if not $heading;
				next if length($heading) > 30;
				$heading =~ s/ One/ 1/;
				$heading =~ s/ Two/ 2/;
				$heading =~ s/ Three/ 3/;
				$heading =~ s/ Four/ 4/;
				push(@comps,$heading);
				push(@compCol,$col);
			}
		} else {
			print OUTFILE "  <league year=\"$year\"";
			# has a link to tables
			my $tableLink = cellValue($sheet, $row, 1 );
			if ($tableLink ne '') {
				print OUTFILE " ref=\"league/tables-$year.xml\" />\n";
			} else { 
				print OUTFILE ">\n";
				for my $compNo ( 0 .. $#comps ) {
					my $col = $compCol[$compNo];
					if (my $winner = teamName($sheet, $row, $col )) {
						print OUTFILE "    <winner division=\"$comps[$compNo]\">$winner</winner>\n";
					}
				}
				print OUTFILE "  </league>\n";
			}
		}
	}
	
	print OUTFILE "</league-results>\n";	
	close (OUTFILE); 			
}
