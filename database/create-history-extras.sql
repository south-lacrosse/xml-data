-- -----------------------------------------------------
-- Schema local
--
-- Extra tables for historical tables/flags/results
-- -----------------------------------------------------
USE local;


-- -----------------------------------------------------
-- Table hist_cup_year
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_hist_cup_year`;
CREATE TABLE IF NOT EXISTS `semla_hist_cup_year` (
  `type` VARCHAR(20) NOT NULL,
  `year` SMALLINT NOT NULL,
  PRIMARY KEY (`type`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
INSERT INTO `semla_hist_cup_year` (`type`, `year`)
  SELECT DISTINCT c.type, a.year
  FROM
  (SELECT DISTINCT cd.year, cd.comp_id
    FROM semla_hist_cup_draw AS cd) AS a
  , semla_competition AS c
  WHERE c.id = a.comp_id        
  ORDER BY c.type, a.year;

-- -----------------------------------------------------
-- Table hist_league_year
-- -----------------------------------------------------
DROP TABLE IF EXISTS `semla_hist_league_year`;
CREATE TABLE IF NOT EXISTS `semla_hist_league_year` (
  `league_id` SMALLINT NOT NULL,
  `year` SMALLINT NOT NULL,
  PRIMARY KEY (`league_id`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
INSERT INTO `semla_hist_league_year` (`league_id`, `year`)
  SELECT DISTINCT league_id, year
  FROM (SELECT DISTINCT comp_id, year FROM semla_hist_table) AS t,
    semla_competition AS c
  WHERE c.id = t.comp_id
  ORDER BY league_id, year;
  
-- -----------------------------------------------------
-- Table hist_competition_result
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `semla_hist_competition_result`;
-- CREATE TABLE IF NOT EXISTS `semla_hist_competition_result` (
--   `year` SMALLINT NOT NULL,
--   `comp_id` INT NOT NULL,
--   `result_id` INT NOT NULL,
--   PRIMARY KEY (`year`, `comp_id`, `result_id`),
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
-- INSERT INTO `semla_hist_competition_fixture` (`year`, `comp_id`, `result_id`)
--   SELECT * FROM
--     (SELECT year,comp_id AS cid, id FROM semla_hist_result
--       WHERE comp_id <> 0
--     UNION ALL
--     SELECT year, comp_id2 AS cid, id FROM semla_hist_result
--       WHERE comp_id2 <> 0
--     ORDER BY year,cid,id) a;
