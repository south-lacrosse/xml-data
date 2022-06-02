-- -----------------------------------------------------
-- Schema local
--
-- Tables for historical tables/flags/results
-- -----------------------------------------------------
USE local;

-- -----------------------------------------------------
-- Table competition_group
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sl_competition_group`;
CREATE TABLE `sl_competition_group` (
  `id` smallint(6) unsigned  NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `page` VARCHAR(200) NOT NULL,
  `history_page` varchar(200) NOT NULL,
  `grid_page` varchar(200) NOT NULL,
  `history_group_page` BOOLEAN NOT NULL,
  `history_only` BOOLEAN NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY `type_name_uq` (`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
INSERT INTO `sl_competition_group` VALUES
(1,'league','SEMLA','tables','league','fixtures-grid',1,0)
,(2,'league','Local','tables-local','league-local','fixtures-grid-local',1,0)
,(3,'cup','Flags','flags','flags','',1,0)
,(4,'cup','Plate','plate','plate','',1,1)
,(5,'cup','Midlands Flags','midlands-flags','midlands-flags','',0,1)
,(6,'cup','West & Midlands Cup','westmidscup','westmidscup','',0,1)
,(7,'results','Sixes','','sixes','',1,0)
,(8,'results','Junior Flags','','junior-flags','',1,0)
;
-- -----------------------------------------------------
-- Table competition
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sl_competition`;
CREATE TABLE `sl_competition` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `group_id` smallint(6) unsigned NOT NULL,
  `abbrev` varchar(20) DEFAULT NULL,
  `section_name` varchar(30) DEFAULT NULL,
  `seq` smallint(6) unsigned NOT NULL,
  `type` varchar(20) NOT NULL,
  `head_to_head` BOOLEAN NOT NULL,
  `has_history` BOOLEAN NOT NULL,
  `history_page` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`),
  KEY `abbrev_idx` (`abbrev`),
  KEY `group_idx` (`group_id`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

INSERT INTO `sl_competition` VALUES
(1,'SEMLA Premier Division',1,'Prem','Premier Division',100,'league',0,1,''),
(2,'SEMLA Division 1',1,'D1','Division 1',200,'league',0,1,''),
(3,'SEMLA Senior Championship',1,NULL,'Senior Championship',300,'league',0,1,''),
(4,'SEMLA Upper Conference',1,NULL,'Upper Conference',400,'league',0,1,''),
(5,'SEMLA Conference A',1,NULL,'Conference A',500,'league-prelim',0,1,''),
(6,'SEMLA Conference B',1,NULL,'Conference B',600,'league-prelim',0,1,''),
(7,'SEMLA Division 2',1,'D2','Division 2',700,'league',0,1,''),
(8,'SEMLA Junior Championship',1,NULL,'Junior Championship',800,'league',0,1,''),
(9,'SEMLA Lower Conference',1,NULL,'Lower Conference',900,'league',0,1,''),
(10,'SEMLA Lower Conference North',1,NULL,'Lower Conference North',1000,'league-prelim',0,1,''),
(11,'SEMLA Lower Conference South',1,NULL,'Lower Conference South',1100,'league-prelim',0,1,''),
(12,'SEMLA Division 3',1,'D3','Division 3',1200,'league',0,1,''),
(13,'SEMLA Division 3 (Autumn)',1,NULL,'Division 3 (Autumn)',1300,'league',0,1,''),
(14,'SEMLA Division 3 (Spring)',1,NULL,'Division 3 (Spring)',1400,'league',0,1,''),
(15,'SEMLA Division 4',1,'D4','Division 4',1500,'league',0,1,''),
(16,'SEMLA East',1,'East','East',1600,'league',0,1,''),
(17,'SEMLA East One',1,'East1','East One',1700,'league',0,1,''),
(18,'SEMLA East Two',1,'East2','East Two',1800,'league',0,1,''),
(19,'SEMLA East Three',1,'East3','East Three',1900,'league',0,1,''),
(20,'SEMLA East (North)',1,'E-N','East (North)',2000,'league',0,1,''),
(21,'SEMLA East (South)',1,'E-S','East (South)',2100,'league',0,0,''),
(22,'SEMLA East (South) D1',1,'E-S1','East (South) D1',2200,'league',0,1,''),
(23,'SEMLA East (South) D2',1,'E-S2','East (South) D2',2300,'league',0,1,''),
(24,'SEMLA West',1,'West','West',2400,'league',0,1,''),
(25,'SEMLA West One',1,'West1','West One',2500,'league',0,1,''),
(26,'SEMLA West Two',1,'West2','West Two',2600,'league',0,1,''),
(27,'SEMLA West (North)',1,'W-N','West (North)',2700,'league',0,1,''),
(28,'SEMLA West (South)',1,'W-S','West (South)',2800,'league',0,1,''),
(29,'SEMLA Midlands',1,'Mids','Midlands',2900,'league',0,1,''),
(30,'Local London D1',2,'L-Lon1','London D1',3000,'league',0,1,''),
(31,'Local London D2',2,'L-Lon2','London D2',3100,'league',0,1,''),
(32,'Local London D3',2,'L-Lon3','London D3',3200,'league',0,1,''),
(33,'Local London D4',2,'L-Lon4','London D4',3300,'league',0,0,''),
(34,'Local Home Counties',2,'L-HC','Home Counties',3400,'league',0,0,''),
(35,'Local Home Counties D1',2,'L-HC1','Home Counties D1',3500,'league',0,1,''),
(36,'Local Home Counties D2',2,'L-HC2','Home Counties D2',3600,'league',0,1,''),
(37,'Local South Central',2,'L-SC','South Central',3700,'league',0,1,''),
(38,'Local Peninsula',2,'L-Pen','Peninsula',3800,'league',0,1,''),
(39,'Local Cotswolds',2,'L-Cot','Cotswolds',3900,'league',0,1,''),
(40,'Local Cotswolds D1',2,'L-Cot1','Cotswolds D1',4000,'league',0,1,''),
(41,'Local Cotswolds D2',2,'L-Cot2','Cotswolds D2',4100,'league',0,1,''),
(42,'Local Midlands',2,'L-Mid','Midlands',4200,'league',0,1,''),
(43,'Local East Anglia',2,'L-EA','East Anglia',4300,'league',0,1,''),
(44,'Local East Anglia D1',2,'L-EA1','East Anglia D1',4400,'league',0,1,''),
(45,'Local East Anglia D2',2,'L-EA2','East Anglia D2',4500,'league',0,1,''),
(46,'Senior Flags',3,'Snr Flags','Senior',4600,'cup',0,1,'flags-senior'),
(47,'Intermediate Flags',3,'Int Flags','Intermediate',4700,'cup',0,1,'flags-intermediate'),
(48,'Minor Flags',3,'Mnr Flags','Minor',4800,'cup',0,1,'flags-minor'),
(49,'Midlands Flags',5,'Mid Flags',NULL,4900,'cup',0,1,'midlands-flags'),
(50,'Intermediate Plate',4,'Int Plate','Intermediate',5000,'cup',0,1,'plate-intermediate'),
(51,'Minor Plate',4,'Mnr Plate','Minor',5100,'cup',0,1,'plate-minor'),
(52,'Intermediate East Plate',4,'Int East Plate','Intermediate East',5200,'cup',0,1,'plate-intermediate-east'),
(53,'Intermediate West Plate',4,'Int West Plate','Intermediate West',5300,'cup',0,1,'plate-intermediate-west'),
(54,'Minor East Plate',4,'Mnr East Plate','Minor East',5400,'cup',0,1,'plate-minor-east'),
(55,'Minor West Plate',4,'Mnr West Plate','Minor West',5500,'cup',0,1,'plate-minor-west'),
(56,'Western Region Senior Flags',0,'West Snr Flags',NULL,100,'results',0,1,'western-flags-senior'),
(57,'Western Region Junior Flags',0,'West Jnr Flags',NULL,100,'results',0,1,'western-flags-junior'),
(58,'Senior West & Midlands Cup',6,'Snr W&M Cup','Senior',5800,'cup',0,1,''),
(59,'Intermediate West & Midlands Cup',6,'Int W&M Cup','Intermediate',5900,'cup',0,1,''),
(60,'Minor West & Midlands Cup',6,'Mnr W&M Cup','Minor',6000,'cup',0,1,''),
(61,'Baird Plate (Juniors)',0,NULL,NULL,100,'results',0,1,'baird-plate'),
(62,'Brine Trophy',0,NULL,NULL,100,'results',0,1,'brine-trophy'),
(63,'Southern Counties',0,NULL,NULL,100,'results',0,1,'southern-counties'),
(64,'English Universities Cup',0,NULL,NULL,100,'results',0,1,'english-universities-cup'),
(65,'Eric Jones Trophy (Juniors)',0,NULL,NULL,100,'results',0,1,'eric-jones-trophy'),
(66,'Final Four',0,NULL,NULL,100,'results',0,1,'final-four'),
(67,'West of England League Champions',0,NULL,NULL,100,'results',0,1,'west-of-england-league'),
(68,'Division 3 Knockout Trophy',0,NULL,NULL,100,'results',0,1,'division-3-knockout-trophy'),
(69,'Division 4 Flags',0,NULL,NULL,100,'results',0,1,'division-4-flags'),
(70,'Iroquois Cup',0,NULL,NULL,100,'results',0,1,'iroquois-cup'),
(71,'National Club Championship',0,NULL,NULL,100,'results',0,1,'national-club-championship'),
(72,'North v South',0,NULL,NULL,100,'results',1,1,'north-south'),
(73,'Varsity',0,NULL,NULL,100,'results',1,1,'varsity'),
(74,'Wilkinson Sword',0,NULL,NULL,100,'results',0,1,'wilkinson-sword'),
(75,"Wills' Challenge Shield",0,NULL,NULL,100,'results',0,1,'wills-challenge-shield'),
(76,'Senior Sixes',7,NULL,'Senior',7600,'results',0,1,''),
(77,'Intermediate Sixes',7,NULL,'Intermediate',7700,'results',0,1,''),
(78,'Minor Sixes',7,NULL,'Minor',7800,'results',0,1,''),
(79,'Division 4 Sixes',0,NULL,NULL,100,'results',0,1,'division-4-sixes'),
(80,'SEMLA Junior Lacrosse',1,NULL,'Junior Lacrosse',8000,'league-prelim',0,0,'junior-lacrosse'),
(81,'Junior Flags',8,NULL,NULL,100,'results',0,1,''),
(82,'U14 Flags',8,NULL,NULL,100,'results',0,1,''),
(83,'U12 Flags',8,NULL,NULL,100,'results',0,1,''),
(84,'Junior Six-A-Sides',0,NULL,NULL,100,'results',0,1,'junior-sixes'),
(85,'North v South Juniors',0,NULL,NULL,100,'results',1,1,'north-south-juniors');

-- -----------------------------------------------------
-- Table hist_winner
-- -----------------------------------------------------
DROP TABLE IF EXISTS `slh_winner`;
CREATE TABLE IF NOT EXISTS `slh_winner` (
  `comp_id` smallint(6) unsigned  NOT NULL,
  `year` SMALLINT unsigned NOT NULL,
  `winner` VARCHAR(50) NOT NULL,
  `runner_up` VARCHAR(50),
  -- result can have things like '10 - 0 w/o'
  `result` VARCHAR(20),
  -- `win_goals` TINYINT NOT NULL,
  -- `lose_goals` TINYINT NOT NULL,
  `has_data` BOOLEAN NOT NULL,
  PRIMARY KEY (`comp_id`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_table
-- -----------------------------------------------------
DROP TABLE IF EXISTS `slh_table`;
CREATE TABLE IF NOT EXISTS `slh_table` (
  `year` SMALLINT unsigned NOT NULL,
  `comp_id` smallint(6) unsigned  NOT NULL,
  `position` TINYINT UNSIGNED NOT NULL,
  `team` VARCHAR(50) NOT NULL,
	`played` TINYINT NOT NULL,
	`won` TINYINT NOT NULL,
	`drawn` TINYINT NOT NULL,
	`lost` TINYINT NOT NULL,
	`goals_for` SMALLINT NOT NULL,
	`goals_against` SMALLINT NOT NULL,
  `goal_avg` DECIMAL (5,2),
	`points_deducted` DECIMAL (4,1) NOT NULL,
	`points` DECIMAL (4,1) NOT NULL,
  `points_avg` DECIMAL (5,2),
  `divider` BOOLEAN NOT NULL,
  PRIMARY KEY (`year`, `comp_id`, `position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_cup_draw
-- -----------------------------------------------------
DROP TABLE IF EXISTS `slh_cup_draw`;
CREATE TABLE IF NOT EXISTS `slh_cup_draw` (
  `year` SMALLINT unsigned NOT NULL,
  `comp_id` smallint(6) unsigned  NOT NULL,
  `round` TINYINT unsigned NOT NULL,
  `match_num` TINYINT unsigned NOT NULL,
  `team1` VARCHAR(50) NOT NULL,
  `team2` VARCHAR(50) NOT NULL,
  `team1_goals` TINYINT,
  `team2_goals` TINYINT,
  `result_extra` VARCHAR(20) NOT NULL,
  `home_team` TINYINT NOT NULL,
  PRIMARY KEY (`year`, `comp_id`, `round`, `match_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_result
-- -----------------------------------------------------
DROP TABLE IF EXISTS `slh_result`;
CREATE TABLE IF NOT EXISTS `slh_result` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year` SMALLINT unsigned NOT NULL,
  `match_date` DATE NOT NULL,
  `comp_id` smallint(6) unsigned  NOT NULL,
  `comp_id2` SMALLINT NOT NULL, -- ladder!
  `competition` VARCHAR(40) NOT NULL,
  `home` VARCHAR(50) NOT NULL,
  `away` VARCHAR(50) NOT NULL,
  `home_goals` TINYINT,
  `away_goals` TINYINT,
  `result` VARCHAR(20) NOT NULL,
  `home_points` TINYINT,
  `away_points` TINYINT,
  `points_multi` TINYINT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY `year_date_id` (`year`, `match_date`, `id`),
  UNIQUE KEY `comp_idx` (`year`,`comp_id`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_remarks
-- -----------------------------------------------------
DROP TABLE IF EXISTS `slh_remarks`;
CREATE TABLE IF NOT EXISTS `slh_remarks` (
  `comp_id` smallint(6) unsigned  NOT NULL,
  `year` SMALLINT unsigned NOT NULL,
  `remarks` TEXT,
  PRIMARY KEY (`comp_id`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table team_abbrev
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sl_team_abbrev`;
CREATE TABLE IF NOT EXISTS `sl_team_abbrev` (
  `team` VARCHAR(50) NOT NULL,
  `abbrev` VARCHAR(30),
  PRIMARY KEY (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;


-- -----------------------------------------------------
-- Table team_minimal
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sl_team_minimal`;
CREATE TABLE IF NOT EXISTS `sl_team_minimal` (
  `team` VARCHAR(50) NOT NULL,
  `minimal` VARCHAR(30),
  PRIMARY KEY (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
INSERT INTO `sl_team_minimal` VALUES
('Aberystwyth Uni','Abe'),
('Bath','Bth'),
('Bath 2','Bth2'),
('Bath 3','Bth3'),
('Bath Uni','BtUni'),
('Birmingham','Bhm'),
('Birmingham Bulls','Bhm'),
('Birmingham Uni','Bhm'),
('Bournemouth','Bou'),
('Bournemouth Uni','Bou'),
('Brighton Panthers','Pan'),
('Bristol Bombers','Bri'),
('Bristol Bombers 2','Bri2'),
('Bristol Sharks','Sha'),
('British Army','Army'),
('Brunel','Bru'),
('Buckhurst Hill','Buc'),
('Camborne School of Mines','CSM'),
('Cambridge Eagles','Eag'),
('Cambridge Uni','Cam'),
('Camden Capybaras','Cdn'),
('Camden Capybaras 2','Cdn2'),
('Camden Capybaras 3','Cdn3'),
('Canterbury','Can'),
('Canterbury City','Can'),
('Cardiff Harlequins','Qui'),
('Cardiff Harlequins A','Qui A'),
('Cardiff Uni','Car'),
('Cheltenham','Che'),
('Cheltenham 2','Che2'),
('Chichester Crusaders','Chi'),
('Chichester Uni','Chi'),
('City of Stoke','CoS'),
('City of Stoke 2','CoS2'),
('Colchester','Col'),
('Croydon','Cro'),
('Croydon A','Cro A'),
('East Coast','EC'),
('East Grinstead','EG'),
('East Grinstead A','EG A'),
('Epsom','Eps'),
('Epsom 2','Eps 2'),
('Exeter City','Ex'),
('Exeter Uni','Ex'),
('Gloucester Uni','Glo'),
('Gloucester Uni 2','Glo2'),
('Guildford Gators','Gui'),
('Hampstead','Hmp'),
('Hertfordshire Comets','Her'),
('Hillcroft','Hcr'),
('Hillcroft A','Hcr A'),
('Hillcroft B','Hcr B'),
('Hitchin','Hit'),
('Hitchin A','Hit A'),
('Imperial College','Imp'),
('Keele Uni','Kee'),
('Kent Uni','Ken'),
('Leicester Badgers','Lei'),
('Leicester City','Lei'),
('Lincoln City','Lin'),
('London Raptors','Rap'),
('London Raptors 2','Rap2'),
('London Uni','Lon'),
('Loughborough Lions','Lou'),
('Loughborough Uni','Lou'),
('Maidstone','Mds'),
('Maidstone 2','Mds2'),
('Maidstone 3','Mds3'),
('Milton Keynes Minotaurs','MK'),
('Northampton Town','Nor'),
('Northampton Uni','Nor'),
('Norwich','Nor'),
('Nottingham Uni','Not'),
('Nuneaton','Nun'),
('Nuneaton 2','Nun2'),
('Oxford City','OxC'),
('Oxford Iroquois','Irq'),
('Oxford Owls','Owl'),
('Oxford Uni','OxU'),
('Penarth','Pen'),
('Plymouth City','Ply Cty'),
('Plymouth Privateers','Ply Prv'),
('Plymouth Uni','Ply U'),
('Portsmouth Pythons','Pyt'),
('Portsmouth Uni','Pts'),
('Portsmouth Uni 2','Pts2'),
('Purley','Pur'),
('Purley A','Pur A'),
('RAF Marham','RAF'),
('Reading Wildcats','Rdg'),
('Reading Wildcats 2','Rdg2'),
('Reading Wildcats 3','Rdg3'),
('Royal Holloway','RHU'),
('Royal Navy Yeovil','Nvy'),
('Southampton','Stn'),
('Southampton A','Stn A'),
('Southampton City','Stn'),
('Southampton Tridents','Tri'),
('Southampton Tridents 2','Tri2'),
('Spencer','Spn'),
('Spencer 2','Spn2'),
('Spencer 3','Spn3'),
('Spencer 4','Spn4'),
('Staffordshire Uni','Sta'),
('Swansea Hawks','Swa'),
('Swansea Hawks 2','Swa2'),
('Swindon Raptors','Swi'),
('UEA','UEA'),
('UWIC','UWI'),
('Walcountian Blues','Blu'),
('Walcountian Blues 2','Blu2'),
('Walcountian Blues 3','Blu3'),
('Warwick Uni','War'),
('Wasps','Wsp'),
('Welwyn Warriors','Wel'),
('Welwyn Warriors 2','Wel2'),
('Welwyn Warriors 3','Wel3')
;
