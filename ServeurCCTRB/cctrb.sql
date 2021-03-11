-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 11 mars 2021 à 15:08
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
  PRIMARY KEY (`IDClient`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `declarations`
--

DROP TABLE IF EXISTS `declarations`;
CREATE TABLE IF NOT EXISTS `declarations` (
  `IDClient` bigint(20) NOT NULL DEFAULT '0',
  `DateHeureDeclarationPositif` char(12) NOT NULL DEFAULT '000000000000',
  PRIMARY KEY (`IDClient`,`DateHeureDeclarationPositif`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `etablissements`
--

DROP TABLE IF EXISTS `etablissements`;
CREATE TABLE IF NOT EXISTS `etablissements` (
  `IDEtablissement` bigint(20) NOT NULL AUTO_INCREMENT,
  `RaisonSociale` varchar(255) NOT NULL DEFAULT '',
  `IDTypeEtablissement` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IDEtablissement`)
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
  `CasContact` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`IDClient`,`IDEtablissement`,`DateHeureEntree`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `typesetablissements`
--

DROP TABLE IF EXISTS `typesetablissements`;
CREATE TABLE IF NOT EXISTS `typesetablissements` (
  `IDTypeEtablissement` bigint(20) NOT NULL AUTO_INCREMENT,
  `libellle` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`IDTypeEtablissement`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `typesetablissements`
--

INSERT INTO `typesetablissements` (`IDTypeEtablissement`, `libellle`) VALUES
(1, 'Bar'),
(2, 'Restaurant'),
(3, 'Coiffeur'),
(4, 'Salon de thé');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
