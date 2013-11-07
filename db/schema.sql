-- MySQL dump 10.13  Distrib 5.5.34, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: rdata
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.13.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cran_changes`
--

DROP TABLE IF EXISTS `cran_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cran_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flavor_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `type` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `old` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `new` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`type`,`flavor_id`,`date`,`package_id`),
  KEY `fk_cran_changes_packages1_idx` (`package_id`),
  KEY `fk_cran_changes_flavors1_idx` (`flavor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cran_checking`
--

DROP TABLE IF EXISTS `cran_checking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cran_checking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `status` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `output` longtext COLLATE utf8_bin,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`type`,`status_id`),
  KEY `fk_cran_status` (`status_id`),
  KEY `type_idx` (`type`),
  KEY `status_index` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=2854243 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cran_status`
--

DROP TABLE IF EXISTS `cran_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cran_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `version_id` int(11) DEFAULT NULL,
  `flavor_id` int(11) DEFAULT NULL,
  `maintainer_id` int(11) DEFAULT NULL,
  `priority` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `status` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`date`,`version_id`,`flavor_id`),
  KEY `fk_cran_status_flavors1_idx` (`flavor_id`),
  KEY `fk_cran_status_package_versions1_idx` (`version_id`),
  KEY `fk_cran_status_people1_idx` (`maintainer_id`),
  KEY `priority_idx` (`priority`),
  KEY `status_idx` (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dates`
--

DROP TABLE IF EXISTS `dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_id` int(11) DEFAULT NULL,
  `type` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`version_id`,`type`),
  KEY `fk_package_versions` (`version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=92520 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dependency_constraints`
--

DROP TABLE IF EXISTS `dependency_constraints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dependency_constraints` (
  `dependency_id` int(11) DEFAULT NULL,
  `type` varchar(2) COLLATE utf8_bin DEFAULT NULL,
  `version` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  UNIQUE KEY `unique_idx` (`dependency_id`,`type`),
  KEY `fk_dependency_idx` (`dependency_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `description_files`
--

DROP TABLE IF EXISTS `description_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `description_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_id` int(11) DEFAULT NULL,
  `keyword` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `value` text COLLATE utf8_bin,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`version_id`,`keyword`),
  KEY `fk_version_idx` (`version_id`),
  KEY `key_idx` (`keyword`)
) ENGINE=MyISAM AUTO_INCREMENT=519288 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flavors`
--

DROP TABLE IF EXISTS `flavors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flavors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `identity_merging`
--

DROP TABLE IF EXISTS `identity_merging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `identity_merging` (
  `merged_id` int(11) NOT NULL,
  `orig_id` int(11) NOT NULL,
  PRIMARY KEY (`orig_id`),
  KEY `fk_orig_idx` (`orig_id`),
  KEY `fk_merged_idx` (`merged_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `merged_people`
--

DROP TABLE IF EXISTS `merged_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `merged_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_idx` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `package_dependencies`
--

DROP TABLE IF EXISTS `package_dependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_dependencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_id` int(11) DEFAULT NULL,
  `dependency` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `type` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`version_id`,`dependency`,`type`),
  KEY `fk_version_idx` (`version_id`),
  KEY `dependency_idx` (`dependency`)
) ENGINE=MyISAM AUTO_INCREMENT=167976 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `package_versions`
--

DROP TABLE IF EXISTS `package_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `package_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_id` int(11) NOT NULL,
  `version` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `mtime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`package_id`,`version`),
  KEY `fk_package_idx` (`package_id`),
  KEY `mtime_idx` (`mtime`),
  KEY `size_idx` (`size`)
) ENGINE=MyISAM AUTO_INCREMENT=38189 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='		';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_idx` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=5760 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `packages_timeline`
--

DROP TABLE IF EXISTS `packages_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages_timeline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `version_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`version_id`),
  KEY `fk_package_timelines_package_versions1_idx` (`version_id`)
) ENGINE=MyISAM AUTO_INCREMENT=37114 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_email_idx` (`name`(200),`email`(50))
) ENGINE=MyISAM AUTO_INCREMENT=14168 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recommended_packages`
--

DROP TABLE IF EXISTS `recommended_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recommended_packages` (
  `version_id` int(11) DEFAULT NULL,
  `rversion_id` int(11) DEFAULT NULL,
  UNIQUE KEY `unique_idx` (`version_id`,`rversion_id`),
  KEY `fk_version_idx` (`version_id`),
  KEY `fk_rversion_idx` (`rversion_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `version_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `role` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  UNIQUE KEY `unique_idx` (`person_id`,`version_id`,`role`),
  KEY `fk_person_idx` (`person_id`),
  KEY `fk_version_idx` (`version_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taskview_content`
--

DROP TABLE IF EXISTS `taskview_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taskview_content` (
  `taskview_id` int(11) DEFAULT NULL,
  `package_id` int(11) DEFAULT NULL,
  `core` tinyint(1) DEFAULT NULL,
  UNIQUE KEY `unique_idx` (`taskview_id`,`package_id`),
  KEY `fk_taskview_content_taskview_versions1_idx` (`taskview_id`),
  KEY `fk_taskview_content_packages1_idx` (`package_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taskview_versions`
--

DROP TABLE IF EXISTS `taskview_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taskview_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `taskview_id` int(11) DEFAULT NULL,
  `maintainer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx` (`version`,`taskview_id`),
  KEY `version_idx` (`version`),
  KEY `fk_taskview_versions_taskviews1_idx` (`taskview_id`),
  KEY `fk_taskview_versions_people1_idx` (`maintainer_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taskviews`
--

DROP TABLE IF EXISTS `taskviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taskviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `topic` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_idx` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-11-07 13:40:07
