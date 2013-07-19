SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `finaldb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `finaldb` ;

-- -----------------------------------------------------
-- Table `finaldb`.`pkgname`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`pkgname` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`pkgname` (
  `idpkgname` INT NOT NULL AUTO_INCREMENT ,
  `pkgname` TEXT NOT NULL ,
  PRIMARY KEY (`idpkgname`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`package`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`package` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`package` (
  `pkgid` INT NOT NULL AUTO_INCREMENT ,
  `pkgnameid` INT NOT NULL ,
  `priority` TEXT NULL ,
  `version` TEXT NULL ,
  `date` TEXT NULL ,
  `title` TEXT NULL ,
  `author` TEXT NULL ,
  `maintainer` TEXT NULL ,
  `description` MEDIUMTEXT NULL ,
  `license` TEXT NULL ,
  PRIMARY KEY (`pkgid`) ,
  INDEX `fk_pkgn_idx` (`pkgnameid` ASC) ,
  CONSTRAINT `fk_pkgn`
    FOREIGN KEY (`pkgnameid` )
    REFERENCES `finaldb`.`pkgname` (`idpkgname` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '		';


-- -----------------------------------------------------
-- Table `finaldb`.`depends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`depends` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`depends` (
  `pkgid` INT NOT NULL ,
  `name` TEXT NOT NULL ,
  INDEX `fk_pkg_idx` (`pkgid` ASC) ,
  CONSTRAINT `fk_pkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`suggests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`suggests` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`suggests` (
  `pkgid` INT NOT NULL ,
  `name` TEXT NOT NULL ,
  INDEX `fk_pkg_idx` (`pkgid` ASC) ,
  CONSTRAINT `fk_pkg0`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`enhances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`enhances` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`enhances` (
  `pkgid` INT NOT NULL ,
  `name` TEXT NOT NULL ,
  INDEX `fk_pkg_idx` (`pkgid` ASC) ,
  CONSTRAINT `fk_pkg00`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`persons`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`persons` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`persons` (
  `aid` INT NOT NULL AUTO_INCREMENT ,
  `name` TEXT NULL ,
  `email` TEXT NULL ,
  PRIMARY KEY (`aid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`role` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`role` (
  `pkgid` INT NOT NULL ,
  `personid` INT NOT NULL ,
  `rolecol` VARCHAR(45) NULL ,
  INDEX `fk_person_idx` (`personid` ASC) ,
  INDEX `fk_pkg_idx` (`pkgid` ASC) ,
  CONSTRAINT `fk_rolepkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_roleperson`
    FOREIGN KEY (`personid` )
    REFERENCES `finaldb`.`persons` (`aid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`mergedid`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`mergedid` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`mergedid` (
  `idmergedid` INT NOT NULL ,
  PRIMARY KEY (`idmergedid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`mergedauthors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`mergedauthors` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`mergedauthors` (
  `mergeid` INT NOT NULL ,
  `aid` INT NOT NULL ,
  INDEX `fk_persons_idx` (`aid` ASC) ,
  INDEX `fk_merge_idx` (`mergeid` ASC) ,
  CONSTRAINT `fk_persons`
    FOREIGN KEY (`aid` )
    REFERENCES `finaldb`.`persons` (`aid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_merge`
    FOREIGN KEY (`mergeid` )
    REFERENCES `finaldb`.`mergedid` (`idmergedid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`snap`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`snap` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`snap` (
  `pkgid` INT NOT NULL ,
  `version` TEXT NOT NULL ,
  `rversion` TEXT NOT NULL ,
  `date` DATE NULL ,
  PRIMARY KEY (`pkgid`) ,
  CONSTRAINT `fk_snappkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`os`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`os` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`os` (
  `idos` INT NOT NULL ,
  `os` TEXT NULL ,
  CONSTRAINT `fk_ossnap`
    FOREIGN KEY (`idos` )
    REFERENCES `finaldb`.`snap` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`function`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`function` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`function` (
  `idfunction` INT NOT NULL AUTO_INCREMENT ,
  `fname` TEXT NOT NULL ,
  `generic` TINYINT(1) NOT NULL ,
  `pkgid` INT NOT NULL ,
  PRIMARY KEY (`idfunction`) ,
  INDEX `funpkg_idx` (`pkgid` ASC) ,
  CONSTRAINT `funpkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`externalfun`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`externalfun` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`externalfun` (
  `idextfun` INT NOT NULL ,
  `extfun` TEXT NOT NULL ,
  `pkgname` TEXT NOT NULL ,
  INDEX `fk_externalfun_idx` (`idextfun` ASC) ,
  CONSTRAINT `fk_externalfun`
    FOREIGN KEY (`idextfun` )
    REFERENCES `finaldb`.`function` (`idfunction` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`internalfun`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`internalfun` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`internalfun` (
  `idinternalfun` INT NOT NULL ,
  `callees` INT NOT NULL ,
  INDEX `fk_intfun_idx` (`idinternalfun` ASC) ,
  INDEX `fk_intfuncallees_idx` (`callees` ASC) ,
  CONSTRAINT `fk_intfun`
    FOREIGN KEY (`idinternalfun` )
    REFERENCES `finaldb`.`function` (`idfunction` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_intfuncallees`
    FOREIGN KEY (`callees` )
    REFERENCES `finaldb`.`function` (`idfunction` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`package4`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`package4` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`package4` (
  `pkgid` INT NOT NULL ,
  `biarch` TEXT NULL ,
  `buildvignettes` TEXT NULL ,
  `vignettebuilder` TEXT NULL ,
  `needscompilation` TEXT NULL ,
  `os` TEXT NULL ,
  `ACM` TEXT NULL ,
  `JEL` TEXT NULL ,
  `MSC` TEXT NULL ,
  `language` TEXT NULL ,
  PRIMARY KEY (`pkgid`) ,
  CONSTRAINT `pkg4topkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`package2`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`package2` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`package2` (
  `pkgid` INT NOT NULL ,
  `url` TEXT NULL ,
  `packaged` TEXT NULL ,
  `ar` TEXT NULL ,
  `encoding` TEXT NULL ,
  `copyright` TEXT NULL ,
  `sysreq` TEXT NULL ,
  `revision` TEXT NULL ,
  `bug` TEXT NULL ,
  `biocviews` TEXT NULL ,
  PRIMARY KEY (`pkgid`) ,
  CONSTRAINT `pkg2topkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`package3`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`package3` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`package3` (
  `pkgid` INT NOT NULL ,
  `bundledes` TEXT NULL ,
  `collate` TEXT NULL ,
  `collatewin` TEXT NULL ,
  `collateunix` TEXT NULL ,
  `keepsrc` VARCHAR(45) NULL ,
  `lazydata` VARCHAR(45) NULL ,
  `lazyload` VARCHAR(45) NULL ,
  `bytecompile` VARCHAR(45) NULL ,
  `zipdata` TEXT NULL ,
  PRIMARY KEY (`pkgid`) ,
  CONSTRAINT `pkg3topkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finaldb`.`package5`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `finaldb`.`package5` ;

CREATE  TABLE IF NOT EXISTS `finaldb`.`package5` (
  `pkgid` INT NOT NULL ,
  `built` TEXT NULL ,
  `note` TEXT NULL ,
  `contact` TEXT NULL ,
  `mailinglist` TEXT NULL ,
  `repo` TEXT NULL ,
  `publication` TEXT NULL ,
  `architecture` TEXT NULL ,
  `contains` TEXT NULL ,
  `type` TEXT NULL ,
  PRIMARY KEY (`pkgid`) ,
  CONSTRAINT `pkg5topkg`
    FOREIGN KEY (`pkgid` )
    REFERENCES `finaldb`.`package` (`pkgid` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `finaldb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
