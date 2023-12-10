-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : dim. 10 déc. 2023 à 14:28
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ara`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `detect_retardataires`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `detect_retardataires` ()   BEGIN
DROP VIEW IF EXISTS retardataires;
/*On créer une vue pour enregistrer les adhérents qui n'ont pas encore payé alors que la date d'échéance est dépassée*/
CREATE VIEW retardataires AS SELECT DISTINCT p.id_a FROM paiement p WHERE CURDATE() > p.date_echeance AND p.date_paiement = '0000-00-00';
END$$

DROP PROCEDURE IF EXISTS `suppr_retardataires`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `suppr_retardataires` ()   BEGIN
DECLARE done int DEFAULT FALSE;
DECLARE p_id_a tinyint;
/*On créer un curseur pour supprimer chaque adhérent qui n'a pas réglé le paiement 15 jours après la date d'échéance, soit plus de 2 semaines après la relance*/
DECLARE cursor1 CURSOR FOR SELECT DISTINCT p.id_a FROM paiement p WHERE CURDATE() > ADDDATE(p.date_echeance, 15) AND p.date_paiement = '0000-00-00';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
OPEN cursor1;
read_loop :LOOP
	FETCH cursor1 into p_id_a;
		If done THEN
        	LEAVE read_loop;
        END IF;
    	DELETE FROM adherent WHERE id_a = p_id_a;
END LOOP;
CLOSE cursor1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `adherent`
--

DROP TABLE IF EXISTS `adherent`;
CREATE TABLE IF NOT EXISTS `adherent` (
  `id_a` tinyint NOT NULL AUTO_INCREMENT,
  `n_agrement` int NOT NULL,
  `fonction` varchar(30) DEFAULT NULL,
  `nom_a` varchar(30) NOT NULL,
  `prenom_a` varchar(30) NOT NULL,
  `telephone_a` varchar(10) NOT NULL,
  `email_a` varchar(50) NOT NULL,
  `cate_sociale` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_a`),
  KEY `n_agrement` (`n_agrement`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adherent`
--

INSERT INTO `adherent` (`id_a`, `n_agrement`, `fonction`, `nom_a`, `prenom_a`, `telephone_a`, `email_a`, `cate_sociale`) VALUES
(1, 90001, 'comptable', 'dupont', 'michel', '0612345678', 'michel.dupont@gmail.com', 1),
(2, 90001, 'président', 'marechal', 'thomas', '0687654321', 'thomas.marechal@utt.fr', 1),
(3, 90001, NULL, 'boccard', 'pierre-emeric', '0712121212', 'pem@gmail.com', 2),
(4, 90001, NULL, 'neveu', 'anouchka', '0623232323', 'ann.neveu@gmail.com', 3);

-- --------------------------------------------------------

--
-- Structure de la table `adresse`
--

DROP TABLE IF EXISTS `adresse`;
CREATE TABLE IF NOT EXISTS `adresse` (
  `id_adresse` tinyint NOT NULL AUTO_INCREMENT,
  `ville` varchar(30) NOT NULL,
  `code_postal` int NOT NULL,
  `rue` varchar(50) NOT NULL,
  `n_rue` tinyint NOT NULL,
  PRIMARY KEY (`id_adresse`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `adresse`
--

INSERT INTO `adresse` (`id_adresse`, `ville`, `code_postal`, `rue`, `n_rue`) VALUES
(1, 'Troyes', 10000, 'Avenue Anatole France', 18),
(2, 'Reims', 51454, 'Rue du Général Sarrail', 30),
(3, 'Orléans', 45000, 'Rue du Pressoir-Tonneau', 12),
(4, 'Paris', 75001, 'Rue de Rivoli', 115),
(5, 'Troyes', 10000, 'Rue Marie Curie', 12);

-- --------------------------------------------------------

--
-- Structure de la table `ad_habite`
--

DROP TABLE IF EXISTS `ad_habite`;
CREATE TABLE IF NOT EXISTS `ad_habite` (
  `id_a` tinyint NOT NULL,
  `id_adresse` tinyint NOT NULL,
  PRIMARY KEY (`id_a`,`id_adresse`),
  KEY `id_a` (`id_a`),
  KEY `id_adresse` (`id_adresse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ad_habite`
--

INSERT INTO `ad_habite` (`id_a`, `id_adresse`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Structure de la table `ad_participe`
--

DROP TABLE IF EXISTS `ad_participe`;
CREATE TABLE IF NOT EXISTS `ad_participe` (
  `id_a` tinyint NOT NULL,
  `id_r` tinyint NOT NULL,
  `role` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_a`,`id_r`),
  KEY `id_a` (`id_a`),
  KEY `id_r` (`id_r`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `ad_participe`
--

INSERT INTO `ad_participe` (`id_a`, `id_r`, `role`) VALUES
(1, 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `association`
--

DROP TABLE IF EXISTS `association`;
CREATE TABLE IF NOT EXISTS `association` (
  `n_agrement` int NOT NULL,
  `date_crea` date NOT NULL,
  `telephone_ass` varchar(10) NOT NULL,
  `email_ass` varchar(50) NOT NULL,
  `revenus_annee` int NOT NULL,
  `tarif_base` int NOT NULL,
  PRIMARY KEY (`n_agrement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `association`
--

INSERT INTO `association` (`n_agrement`, `date_crea`, `telephone_ass`, `email_ass`, `revenus_annee`, `tarif_base`) VALUES
(90001, '2023-12-01', '0301020304', 'randonneurs.aubois@gmail.com', 0, 50);

-- --------------------------------------------------------

--
-- Structure de la table `as_habite`
--

DROP TABLE IF EXISTS `as_habite`;
CREATE TABLE IF NOT EXISTS `as_habite` (
  `n_agrement` int NOT NULL,
  `id_adresse` tinyint NOT NULL,
  PRIMARY KEY (`id_adresse`,`n_agrement`),
  KEY `n_agrement` (`n_agrement`),
  KEY `id_adresse` (`id_adresse`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `as_habite`
--

INSERT INTO `as_habite` (`n_agrement`, `id_adresse`) VALUES
(90001, 1);

-- --------------------------------------------------------

--
-- Structure de la table `certif_med`
--

DROP TABLE IF EXISTS `certif_med`;
CREATE TABLE IF NOT EXISTS `certif_med` (
  `id_cm` tinyint NOT NULL AUTO_INCREMENT,
  `id_a` tinyint NOT NULL,
  `date_d_cm` date NOT NULL,
  `date_f_cm` date NOT NULL,
  PRIMARY KEY (`id_cm`),
  KEY `id_a` (`id_a`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `certif_med`
--

INSERT INTO `certif_med` (`id_cm`, `id_a`, `date_d_cm`, `date_f_cm`) VALUES
(1, 1, '2023-12-01', '2024-12-01');

-- --------------------------------------------------------

--
-- Structure de la table `compte-rendu`
--

DROP TABLE IF EXISTS `compte-rendu`;
CREATE TABLE IF NOT EXISTS `compte-rendu` (
  `id_cr` tinyint NOT NULL AUTO_INCREMENT,
  `n_agrement` int NOT NULL,
  `date_cr` date NOT NULL,
  `texte` text NOT NULL,
  PRIMARY KEY (`id_cr`),
  KEY `n_agrement` (`n_agrement`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `compte-rendu`
--

INSERT INTO `compte-rendu` (`id_cr`, `n_agrement`, `date_cr`, `texte`) VALUES
(1, 90001, '2023-12-01', 'Création de l\'association des randonneurs aubois le 1er décembre 2023.');

-- --------------------------------------------------------

--
-- Structure de la table `formation`
--

DROP TABLE IF EXISTS `formation`;
CREATE TABLE IF NOT EXISTS `formation` (
  `id_f` tinyint NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  `date_d_f` date NOT NULL,
  `date_f_f` date NOT NULL,
  `date_f_validite` date NOT NULL,
  PRIMARY KEY (`id_f`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `formation`
--

INSERT INTO `formation` (`id_f`, `nom`, `date_d_f`, `date_f_f`, `date_f_validite`) VALUES
(1, 'Formation de secourisme', '2023-12-03', '2023-12-05', '2026-12-03');

-- --------------------------------------------------------

--
-- Structure de la table `nad_participe`
--

DROP TABLE IF EXISTS `nad_participe`;
CREATE TABLE IF NOT EXISTS `nad_participe` (
  `id_na` tinyint NOT NULL,
  `id_r` tinyint NOT NULL,
  PRIMARY KEY (`id_na`,`id_r`) USING BTREE,
  KEY `id_na` (`id_na`),
  KEY `id_r` (`id_r`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `nad_participe`
--

INSERT INTO `nad_participe` (`id_na`, `id_r`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Structure de la table `non-adherent`
--

DROP TABLE IF EXISTS `non-adherent`;
CREATE TABLE IF NOT EXISTS `non-adherent` (
  `id_na` tinyint NOT NULL AUTO_INCREMENT,
  `nom_na` varchar(30) NOT NULL,
  `prenom_na` varchar(30) NOT NULL,
  `email_na` varchar(50) NOT NULL,
  PRIMARY KEY (`id_na`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `non-adherent`
--

INSERT INTO `non-adherent` (`id_na`, `nom_na`, `prenom_na`, `email_na`) VALUES
(1, 'landre', 'noe', 'noe.landre@laposte.net'),
(2, 'roncin', 'teddy', 'troncin@gmail.com');

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

DROP TABLE IF EXISTS `paiement`;
CREATE TABLE IF NOT EXISTS `paiement` (
  `id_paiement` tinyint NOT NULL AUTO_INCREMENT,
  `id_a` tinyint NOT NULL,
  `tarif` double NOT NULL,
  `date_echeance` date NOT NULL,
  `date_paiement` date DEFAULT NULL,
  PRIMARY KEY (`id_paiement`),
  KEY `id_a` (`id_a`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `paiement`
--

INSERT INTO `paiement` (`id_paiement`, `id_a`, `tarif`, `date_echeance`, `date_paiement`) VALUES
(1, 1, 12.5, '2023-12-08', '0000-00-00'),
(2, 2, 12.5, '2023-11-21', '0000-00-00'),
(3, 3, 25, '2024-01-16', '0000-00-00'),
(4, 4, 50, '2023-12-06', '2023-12-09'),
(5, 4, 50, '2024-01-06', '0000-00-00');

-- --------------------------------------------------------

--
-- Structure de la table `photo`
--

DROP TABLE IF EXISTS `photo`;
CREATE TABLE IF NOT EXISTS `photo` (
  `id_photo` tinyint NOT NULL AUTO_INCREMENT,
  `id_r` tinyint NOT NULL,
  `lieu_p` varchar(30) NOT NULL,
  `image` text NOT NULL,
  PRIMARY KEY (`id_photo`),
  KEY `id_r` (`id_r`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `photo`
--

INSERT INTO `photo` (`id_photo`, `id_r`, `lieu_p`, `image`) VALUES
(1, 1, 'Gorges du Verdon', 'https://photos.google.com/ara/123456.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `randonnee`
--

DROP TABLE IF EXISTS `randonnee`;
CREATE TABLE IF NOT EXISTS `randonnee` (
  `id_r` tinyint NOT NULL AUTO_INCREMENT,
  `date_r` date NOT NULL,
  `lieu_d` varchar(50) NOT NULL,
  `difficulte` tinyint(1) NOT NULL,
  `n_km` int NOT NULL,
  `cout` int NOT NULL,
  `valide` tinyint(1) NOT NULL,
  `titre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_r`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `randonnee`
--

INSERT INTO `randonnee` (`id_r`, `date_r`, `lieu_d`, `difficulte`, `n_km`, `cout`, `valide`, `titre`) VALUES
(1, '2023-12-04', 'Gorges du Verdon', 1, 30, 150, 1, 'Randonnée dans les Gorges');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `retardataires`
-- (Voir ci-dessous la vue réelle)
--
DROP VIEW IF EXISTS `retardataires`;
CREATE TABLE IF NOT EXISTS `retardataires` (
`id_a` tinyint
);

-- --------------------------------------------------------

--
-- Structure de la table `suit`
--

DROP TABLE IF EXISTS `suit`;
CREATE TABLE IF NOT EXISTS `suit` (
  `id_a` tinyint NOT NULL,
  `id_f` tinyint NOT NULL,
  `reussite` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_a`,`id_f`),
  KEY `id_a` (`id_a`),
  KEY `id_f` (`id_f`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `suit`
--

INSERT INTO `suit` (`id_a`, `id_f`, `reussite`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Structure de la vue `retardataires`
--
DROP TABLE IF EXISTS `retardataires`;

DROP VIEW IF EXISTS `retardataires`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `retardataires`  AS SELECT DISTINCT `p`.`id_a` AS `id_a` FROM `paiement` AS `p` WHERE ((curdate() > `p`.`date_echeance`) AND (`p`.`date_paiement` = '0000-00-00'))  ;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `adherent`
--
ALTER TABLE `adherent`
  ADD CONSTRAINT `adherent_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ad_habite`
--
ALTER TABLE `ad_habite`
  ADD CONSTRAINT `ad_habite_ibfk_1` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ad_habite_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `ad_participe`
--
ALTER TABLE `ad_participe`
  ADD CONSTRAINT `ad_participe_ibfk_1` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ad_participe_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `as_habite`
--
ALTER TABLE `as_habite`
  ADD CONSTRAINT `as_habite_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `as_habite_ibfk_2` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `certif_med`
--
ALTER TABLE `certif_med`
  ADD CONSTRAINT `certif_med_ibfk_1` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `compte-rendu`
--
ALTER TABLE `compte-rendu`
  ADD CONSTRAINT `compte-rendu_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `nad_participe`
--
ALTER TABLE `nad_participe`
  ADD CONSTRAINT `nad_participe_ibfk_1` FOREIGN KEY (`id_na`) REFERENCES `non-adherent` (`id_na`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nad_participe_ibfk_2` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `paiement_ibfk_1` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `photo`
--
ALTER TABLE `photo`
  ADD CONSTRAINT `photo_ibfk_1` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `suit`
--
ALTER TABLE `suit`
  ADD CONSTRAINT `suit_ibfk_1` FOREIGN KEY (`id_f`) REFERENCES `formation` (`id_f`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `suit_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Évènements
--
DROP EVENT IF EXISTS `detection_mensuelle`$$
CREATE DEFINER=`root`@`localhost` EVENT `detection_mensuelle` ON SCHEDULE EVERY 1 MONTH STARTS '2023-12-10 15:24:00' ENDS '2024-01-13 14:40:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL detect_retardataires()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
