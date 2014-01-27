SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


-- -----------------------------------------------------
-- Table `packages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `packages` ;

CREATE  TABLE IF NOT EXISTS `packages` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_idx` (`name` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `package_versions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `package_versions` ;

CREATE  TABLE IF NOT EXISTS `package_versions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `package_id` INT NOT NULL ,
  `version` VARCHAR(255) NULL ,
  `size` INT NULL ,
  `mtime` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_package_idx` (`package_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`package_id` ASC, `version` ASC) ,
  INDEX `mtime_idx` (`mtime` ASC) ,
  INDEX `size_idx` (`size` ASC) )
ENGINE = MyISAM
COMMENT = '		';


-- -----------------------------------------------------
-- Table `people`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `people` ;

CREATE  TABLE IF NOT EXISTS `people` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL ,
  `email` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_email_idx` (`name`(200) ASC, `email`(50) ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `roles` ;

CREATE  TABLE IF NOT EXISTS `roles` (
  `version_id` INT NOT NULL ,
  `person_id` INT NOT NULL ,
  `role` VARCHAR(45) NULL ,
  INDEX `fk_person_idx` (`person_id` ASC) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`person_id` ASC, `version_id` ASC, `role` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `merged_people`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `merged_people` ;

CREATE  TABLE IF NOT EXISTS `merged_people` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_idx` (`name` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `identity_merging`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `identity_merging` ;

CREATE  TABLE IF NOT EXISTS `identity_merging` (
  `merged_id` INT NOT NULL ,
  `orig_id` INT NOT NULL ,
  INDEX `fk_orig_idx` (`orig_id` ASC) ,
  INDEX `fk_merged_idx` (`merged_id` ASC) ,
  PRIMARY KEY (`orig_id`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `package_dependencies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `package_dependencies` ;

CREATE  TABLE IF NOT EXISTS `package_dependencies` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `version_id` INT NULL ,
  `dependency` VARCHAR(255) NULL ,
  `type` VARCHAR(10) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  UNIQUE INDEX `unique_idx` (`version_id` ASC, `dependency` ASC, `type` ASC) ,
  INDEX `dependency_idx` (`dependency` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `description_files`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `description_files` ;

CREATE  TABLE IF NOT EXISTS `description_files` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `version_id` INT(11) NULL ,
  `keyword` VARCHAR(255) NULL ,
  `value` TEXT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  INDEX `keyword_idx` (`keyword` ASC) ,
  UNIQUE INDEX `UNIQUE` (`version_id` ASC, `keyword` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `flavors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flavors` ;

CREATE  TABLE IF NOT EXISTS `flavors` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `cran_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cran_status` ;

CREATE  TABLE IF NOT EXISTS `cran_status` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NULL ,
  `version_id` INT NULL ,
  `flavor_id` INT NULL ,
  `maintainer_id` INT NULL DEFAULT NULL ,
  `priority` VARCHAR(45) NULL ,
  `status` VARCHAR(10) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UNIQUE` (`date` ASC, `version_id` ASC, `flavor_id` ASC) ,
  INDEX `fk_flavor_idx` (`flavor_id` ASC) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  INDEX `fk_maintainer_idx` (`maintainer_id` ASC) ,
  INDEX `priority_idx` (`priority` ASC) ,
  INDEX `status_idx` (`status` ASC) ,
  INDEX `date_idx` (`date` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `dependency_constraints`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dependency_constraints` ;

CREATE  TABLE IF NOT EXISTS `dependency_constraints` (
  `dependency_id` INT NOT NULL ,
  `type` VARCHAR(2) NOT NULL ,
  `version` VARCHAR(45) NULL ,
  INDEX `fk_dependency_idx` (`dependency_id` ASC) ,
  PRIMARY KEY (`dependency_id`, `type`) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `dates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dates` ;

CREATE  TABLE IF NOT EXISTS `dates` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `version_id` INT NULL ,
  `type` VARCHAR(45) NULL ,
  `date` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`version_id` ASC, `type` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `recommended_packages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `recommended_packages` ;

CREATE  TABLE IF NOT EXISTS `recommended_packages` (
  `version_id` INT NULL ,
  `rversion_id` INT NULL ,
  UNIQUE INDEX `UNIQUE` (`version_id` ASC, `rversion_id` ASC) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  INDEX `fk_rversion_idx` (`rversion_id` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `taskviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `taskviews` ;

CREATE  TABLE IF NOT EXISTS `taskviews` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(45) NULL ,
  `topic` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name_idx` (`name` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `taskview_versions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `taskview_versions` ;

CREATE  TABLE IF NOT EXISTS `taskview_versions` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `version` VARCHAR(45) NULL ,
  `taskview_id` INT NULL ,
  `maintainer_id` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `version_idx` (`version` ASC) ,
  INDEX `fk_taskview_idx` (`taskview_id` ASC) ,
  INDEX `fk_maintainer_idx` (`maintainer_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`version` ASC, `taskview_id` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `taskview_content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `taskview_content` ;

CREATE  TABLE IF NOT EXISTS `taskview_content` (
  `taskview_id` INT NULL ,
  `package_id` INT NULL ,
  `core` TINYINT(1) NULL ,
  UNIQUE INDEX `unique_idx` (`taskview_id` ASC, `package_id` ASC) ,
  INDEX `fk_taskview_content_taskview_versions1_idx` (`taskview_id` ASC) ,
  INDEX `fk_taskview_content_packages1_idx` (`package_id` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `packages_timeline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `packages_timeline` ;

CREATE  TABLE IF NOT EXISTS `packages_timeline` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NULL ,
  `version_id` INT UNSIGNED NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`version_id` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `cran_changes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cran_changes` ;

CREATE  TABLE IF NOT EXISTS `cran_changes` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `flavor_id` INT NULL ,
  `date` DATETIME NULL ,
  `package_id` INT NULL ,
  `type` VARCHAR(10) NULL ,
  `old` VARCHAR(255) NULL ,
  `new` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_cran_changes_packages1_idx` (`package_id` ASC) ,
  INDEX `fk_cran_changes_flavors1_idx` (`flavor_id` ASC) ,
  UNIQUE INDEX `unique_idx` (`type` ASC, `flavor_id` ASC, `date` ASC, `package_id` ASC) )
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `cran_mirror_log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cran_mirror_log` ;

CREATE  TABLE IF NOT EXISTS `cran_mirror_log` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `date` DATETIME NULL ,
  `version_id` INT NULL ,
  `size` INT NULL ,
  `ip_id` INT NULL ,
  `country` VARCHAR(2) NULL ,
  `rversion` VARCHAR(45) NULL ,
  `arch` VARCHAR(45) NULL ,
  `os` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_version_idx` (`version_id` ASC) ,
  UNIQUE INDEX `UNIQUE` (`date` ASC, `ip_id` ASC, `version_id` ASC) ,
  INDEX `rversion_idx` (`rversion` ASC) ,
  INDEX `os_idx` (`os` ASC) ,
  INDEX `ip_idx` (`ip_id` ASC) ,
  INDEX `country_idx` (`country` ASC) ,
  INDEX `arch_idx` (`arch` ASC) )
ENGINE = MyISAM;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
