-- -----------------------------------------------------
-- Schema local
--
-- Tables for historical tables/flags/results
-- -----------------------------------------------------
USE local;

DROP TABLE IF EXISTS `semla_league`;
CREATE TABLE `semla_league` (
  `id` SMALLINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `suffix` VARCHAR(30) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX `name_uq` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
INSERT INTO `semla_league` (`name`, `suffix`)
VALUES ('SEMLA','')
,('Local','-local')
;
-- -----------------------------------------------------
-- Table competition
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_competition`;
CREATE TABLE `semla_competition` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `league_id` smallint(6) NOT NULL,
  `abbrev` varchar(20) DEFAULT NULL,
  `seq` smallint(6) NOT NULL,
  `type` varchar(20) NOT NULL,
  `head_to_head` tinyint(1) NOT NULL,
  `has_history` tinyint(1) NOT NULL,
  `history_page` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_uq` (`name`,`league_id`),
  KEY `abbrev_idx` (`abbrev`),
  KEY `league_idx` (`league_id`,`name`),
  KEY `hist_page_idx` (`history_page`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

LOCK TABLES `semla_competition` WRITE;
/*!40000 ALTER TABLE `semla_competition` DISABLE KEYS */;
INSERT INTO `semla_competition` VALUES
(1,'Premier Division',1,'Prem',10,'league',0,1,''),
(2,'Division 1',1,'D1',20,'league',0,1,''),
(3,'Senior Championship',1,NULL,30,'league',0,1,''),
(4,'Upper Conference',1,NULL,40,'league',0,1,''),
(5,'Conference A',1,NULL,50,'league-prelim',0,1,''),
(6,'Conference B',1,NULL,60,'league-prelim',0,1,''),
(7,'Division 2',1,'D2',70,'league',0,1,''),
(8,'Junior Championship',1,NULL,80,'league',0,1,''),
(9,'Lower Conference',1,NULL,90,'league',0,1,''),
(10,'Lower Conference North',1,NULL,100,'league-prelim',0,1,''),
(11,'Lower Conference South',1,NULL,110,'league-prelim',0,1,''),
(12,'Division 3',1,'D3',120,'league',0,1,''),
(13,'Division 3 (Autumn)',1,NULL,130,'league',0,1,''),
(14,'Division 3 (Spring)',1,NULL,140,'league',0,1,''),
(15,'Division 4',1,'D4',150,'league',0,1,''),
(16,'East',1,'East',160,'league',0,1,''),
(17,'East One',1,'East1',170,'league',0,1,''),
(18,'East Two',1,'East2',180,'league',0,1,''),
(19,'East Three',1,'East3',190,'league',0,1,''),
(20,'East (North)',1,'E-N',200,'league',0,1,''),
(21,'East (South)',1,'E-S',210,'league',0,0,''),
(22,'East (South) D1',1,'E-S1',220,'league',0,1,''),
(23,'East (South) D2',1,'E-S2',230,'league',0,1,''),
(24,'West',1,'West',240,'league',0,1,''),
(25,'West One',1,'West1',250,'league',0,1,''),
(26,'West Two',1,'West2',260,'league',0,1,''),
(27,'West (North)',1,'W-N',270,'league',0,1,''),
(28,'West (South)',1,'W-S',280,'league',0,1,''),
(29,'Midlands',1,'Mids',290,'league',0,1,''),
(30,'London D1',2,'L-Lon1',300,'league',0,1,''),
(31,'London D2',2,'L-Lon2',310,'league',0,1,''),
(32,'London D3',2,'L-Lon3',320,'league',0,1,''),
(33,'London D4',2,'L-Lon4',330,'league',0,0,''),
(34,'Home Counties',2,'L-HC',340,'league',0,0,''),
(35,'Home Counties D1',2,'L-HC1',350,'league',0,1,''),
(36,'Home Counties D2',2,'L-HC2',360,'league',0,1,''),
(37,'South Central',2,'L-SC',370,'league',0,1,''),
(38,'Peninsula',2,'L-Pen',380,'league',0,1,''),
(39,'Cotswolds D1',2,'L-Cot1',390,'league',0,1,''),
(40,'Cotswolds D2',2,'L-Cot2',400,'league',0,1,''),
(41,'Midlands',2,'L-Mid',410,'league',0,1,''),
(42,'East Anglia',2,'L-EA',420,'league',0,1,''),
(43,'East Anglia D1',2,'L-EA1',430,'league',0,1,''),
(44,'East Anglia D2',2,'L-EA2',440,'league',0,1,''),
(45,'Senior Flags',0,'Snr Flags',450,'flags',0,1,'flags-senior'),
(46,'Intermediate Flags',0,'Int Flags',460,'flags',0,1,'flags-intermediate'),
(47,'Minor Flags',0,'Mnr Flags',470,'flags',0,1,'flags-minor'),
(48,'Midlands Flags',0,'Mid Flags',480,'mids-flags',0,1,'midlands-flags'),
(49,'Intermediate Plate',0,'Int Plate',490,'plate',0,1,'plate-intermediate'),
(50,'Minor Plate',0,'Mnr Plate',500,'plate',0,1,'plate-minor'),
(51,'Intermediate East Plate',0,'Int East Plate',510,'plate',0,1,'plate-intermediate-east'),
(52,'Intermediate West Plate',0,'Int West Plate',520,'plate',0,1,'plate-intermediate-west'),
(53,'Minor East Plate',0,'Mnr East Plate',530,'plate',0,1,'plate-minor-east'),
(54,'Minor West Plate',0,'Mnr West Plate',540,'plate',0,1,'plate-minor-west'),
(55,'Western Region Senior Flags',0,'West Snr Flags',0,'results',0,1,'western-flags-senior'),
(56,'Western Region Junior Flags',0,'West Jnr Flags',560,'results',0,1,'western-flags-junior'),
(57,'Senior West & Midlands Cup',0,'Snr W&M Cup',570,'westmidscup',0,1,''),
(58,'Intermediate West & Midlands Cup',0,'Int W&M Cup',580,'westmidscup',0,1,''),
(59,'Minor West & Midlands Cup',0,'Mnr W&M Cup',590,'westmidscup',0,1,''),
(60,'Baird Plate (Juniors)',0,NULL,0,'results',0,1,'baird-plate'),
(61,'Brine Trophy',0,NULL,0,'results',0,1,'brine-trophy'),
(62,'Southern Counties',0,NULL,0,'results',0,1,'southern-counties'),
(63,'English Universities Cup',0,NULL,0,'results',0,1,'english-universities-cup'),
(64,'Eric Jones Trophy (Juniors)',0,NULL,0,'results',0,1,'eric-jones-trophy'),
(65,'Final Four',0,NULL,0,'results',0,1,'final-four'),
(66,'West of England League Champions',0,NULL,0,'results',0,1,'west-of-england-league'),
(67,'Division 3 Knockout Trophy',0,NULL,0,'results',0,1,'division-3-knockout-trophy'),
(68,'Division 4 Flags',0,NULL,0,'results',0,1,'division-4-flags'),
(69,'Iroquois Cup',0,NULL,0,'results',0,1,'iroquois-cup'),
(70,'National Club Championship',0,NULL,0,'results',0,1,'national-club-championship'),
(71,'North v South',0,NULL,0,'results',1,1,'north-south'),
(72,'Varsity',0,NULL,0,'results',1,1,'varsity'),
(73,'Wilkinson Sword',0,NULL,0,'results',0,1,'wilkinson-sword'),
(74,"Wills' Challenge Shield",0,NULL,0,'results',0,1,'wills-challenge-shield'),
(75,'Senior Sixes',0,NULL,750,'results',0,1,'sixes'),
(76,'Intermediate Sixes',0,NULL,760,'results',0,1,'sixes'),
(77,'Minor Sixes',0,NULL,610,'results',0,1,'sixes'),
(78,'Division 4 Sixes',0,NULL,0,'results',0,1,'division-4-sixes'),
(79,'Junior Lacrosse',1,NULL,790,'league-prelim',0,1,'junior-lacrosse'),
(80,'Junior Flags',0,NULL,0,'results',0,1,'junior-flags'),
(81,'U14 Flags',0,NULL,0,'results',0,1,'u14-flags'),
(82,'U12 Flags',0,NULL,0,'results',0,1,'u12-flags'),
(83,'Junior Six-A-Sides',0,NULL,0,'results',0,1,'junior-sixes'),
(84,'North v South Juniors',0,NULL,0,'results',1,1,'north-south-juniors');
/*!40000 ALTER TABLE `semla_competition` ENABLE KEYS */;
UNLOCK TABLES;

-- -----------------------------------------------------
-- Table hist_winner
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_hist_winner`;
CREATE TABLE IF NOT EXISTS `semla_hist_winner` (
  `comp_id` SMALLINT NOT NULL,
  `year` SMALLINT NOT NULL,
  `winner` VARCHAR(50) NOT NULL,
  `runner_up` VARCHAR(50),
  -- result can have things like '10 - 0 w/o'
  `result` VARCHAR(20),
  `win_goals` TINYINT NOT NULL,
  `lose_goals` TINYINT NOT NULL,
  `has_data` BOOLEAN NOT NULL,
  PRIMARY KEY (`comp_id`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_table
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_hist_table`;
CREATE TABLE IF NOT EXISTS `semla_hist_table` (
  `year` SMALLINT NOT NULL,
  `comp_id` SMALLINT NOT NULL,
  `position` TINYINT NOT NULL,
  `team` VARCHAR(50) NOT NULL,
  `team_minimal` VARCHAR(10) NOT NULL,
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
DROP TABLE IF EXISTS `semla_hist_cup_draw`;
CREATE TABLE IF NOT EXISTS `semla_hist_cup_draw` (
  `year` SMALLINT NOT NULL,
  `comp_id` SMALLINT NOT NULL,
  `round` TINYINT NOT NULL,
  `match_num` TINYINT NOT NULL,
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
DROP TABLE IF EXISTS `semla_hist_result`;
CREATE TABLE IF NOT EXISTS `semla_hist_result` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `year` SMALLINT NOT NULL,
  `match_date` DATE NOT NULL,
  `comp_id` SMALLINT NOT NULL,
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
  UNIQUE INDEX `year_date_id` (`year`, `match_date`, `id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table hist_remarks
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_hist_remarks`;
CREATE TABLE IF NOT EXISTS `semla_hist_remarks` (
  `comp_id` SMALLINT NOT NULL,
  `year` SMALLINT NOT NULL,
  `remarks` TEXT,
  PRIMARY KEY (`comp_id`, `year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- -----------------------------------------------------
-- Table team_abbrev
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_team_abbrev`;
CREATE TABLE IF NOT EXISTS `semla_team_abbrev` (
  `team` VARCHAR(50) NOT NULL,
  `abbrev` VARCHAR(30),
  PRIMARY KEY (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
