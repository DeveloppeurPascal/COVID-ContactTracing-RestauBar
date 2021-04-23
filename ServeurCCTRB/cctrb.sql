-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 23 avr. 2021 à 13:43
-- Version du serveur :  5.7.31
-- Version de PHP : 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cctrb`
--

-- --------------------------------------------------------

--
-- Structure de la table `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `IDClient` bigint(20) NOT NULL AUTO_INCREMENT,
  `ClePrivee` char(64) DEFAULT NULL,
  `ClePublique` char(64) DEFAULT NULL,
  PRIMARY KEY (`IDClient`),
  UNIQUE KEY `ClientsParClePublique` (`ClePublique`,`IDClient`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `declarations`
--

DROP TABLE IF EXISTS `declarations`;
CREATE TABLE IF NOT EXISTS `declarations` (
  `IDClient` bigint(20) NOT NULL DEFAULT '0',
  `DateHeureDeclarationPositif` char(12) NOT NULL DEFAULT '000000000000',
  PRIMARY KEY (`IDClient`,`DateHeureDeclarationPositif`),
  KEY `DeclarationsParDate` (`DateHeureDeclarationPositif`,`IDClient`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `etablissements`
--

DROP TABLE IF EXISTS `etablissements`;
CREATE TABLE IF NOT EXISTS `etablissements` (
  `IDEtablissement` bigint(20) NOT NULL AUTO_INCREMENT,
  `RaisonSociale` varchar(255) NOT NULL,
  `IDTypeEtablissement` bigint(20) NOT NULL DEFAULT '0',
  `ClePrivee` char(64) DEFAULT NULL,
  `ClePublique` char(64) DEFAULT NULL,
  PRIMARY KEY (`IDEtablissement`),
  UNIQUE KEY `EtablissementsParClePublique` (`ClePublique`,`IDEtablissement`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `historiques`
--

DROP TABLE IF EXISTS `historiques`;
CREATE TABLE IF NOT EXISTS `historiques` (
  `IDClient` bigint(20) NOT NULL,
  `IDEtablissement` bigint(20) NOT NULL,
  `DateHeureEntree` char(12) NOT NULL DEFAULT '000000000000',
  `DateHeureSortie` char(12) NOT NULL DEFAULT '000000000000',
  `CasContact` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IDClient`,`IDEtablissement`,`DateHeureEntree`),
  KEY `HistoriqueClieEtbSortie` (`IDClient`,`IDEtablissement`,`DateHeureSortie`,`DateHeureEntree`),
  KEY `HistoCOVIDEtbEntSor` (`CasContact`,`IDEtablissement`,`DateHeureEntree`,`DateHeureSortie`,`IDClient`),
  KEY `HistoCOVIDCliEntSor` (`CasContact`,`IDClient`,`DateHeureEntree`,`DateHeureSortie`),
  KEY `HistoriquesParDate` (`DateHeureEntree`,`IDClient`,`IDEtablissement`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `typesetablissements`
--

DROP TABLE IF EXISTS `typesetablissements`;
CREATE TABLE IF NOT EXISTS `typesetablissements` (
  `IDTypeEtablissement` bigint(20) NOT NULL AUTO_INCREMENT,
  `libelle` varchar(255) NOT NULL,
  PRIMARY KEY (`IDTypeEtablissement`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `typesetablissements`
--

INSERT INTO `typesetablissements` (`IDTypeEtablissement`, `libelle`) VALUES
(1, 'Restaurant'),
(2, 'Bar'),
(3, 'Coiffeur'),
(4, 'Boite de nuit'),
(5, 'Salon de thé'),
(6, 'Salle de sport');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
