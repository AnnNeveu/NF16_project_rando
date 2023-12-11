-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 11, 2023 at 03:03 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ara`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `detect_retardataires` ()   BEGIN

DROP VIEW IF EXISTS retardataires;
/*On crée une vue pour enregistrer les adhérents qui n'ont pas encore payé alors que la date d'échéance est dépassée*/
CREATE VIEW retardataires AS SELECT DISTINCT p.id_a
FROM paiement p
WHERE CURDATE() > p.date_echeance
AND p.date_paiement IS NULL;

DROP VIEW IF EXISTS bientot_retardataires;
/*On crée une vue pour enregistrer les adhérents dont la date d'échéance approche*/
CREATE VIEW bientot_retardataires AS SELECT DISTINCT p.id_a
FROM paiement p
WHERE DATEDIFF(p.date_echeance, CURDATE()) BETWEEN 1 AND 14
AND p.date_paiement IS NULL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `suppr_retardataires` ()   BEGIN
DECLARE done int DEFAULT FALSE;
DECLARE p_id_a tinyint;
/*On crée un curseur pour supprimer chaque adhérent qui n'a pas réglé le paiement 15 jours après la date d'échéance, soit plus de 2 semaines après la relance*/
DECLARE cursor1 CURSOR FOR SELECT DISTINCT p.id_a FROM paiement p WHERE CURDATE() > ADDDATE(p.date_echeance, 15) AND p.date_paiement IS NULL;
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
-- Table structure for table `adherent`
--

CREATE TABLE `adherent` (
  `id_a` tinyint NOT NULL,
  `n_agrement` int NOT NULL,
  `fonction` varchar(30) DEFAULT NULL,
  `nom_a` varchar(30) NOT NULL,
  `prenom_a` varchar(30) NOT NULL,
  `telephone_a` varchar(10) NOT NULL,
  `email_a` varchar(50) NOT NULL,
  `cate_sociale` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `adherent`
--

INSERT INTO `adherent` (`id_a`, `n_agrement`, `fonction`, `nom_a`, `prenom_a`, `telephone_a`, `email_a`, `cate_sociale`) VALUES
(1, 90001, 'comptable', 'dupont', 'michel', '0612345678', 'michel.dupont@gmail.com', 1),
(2, 90001, 'président', 'marechal', 'thomas', '0687654321', 'thomas.marechal@utt.fr', 1),
(3, 90001, NULL, 'boccard', 'pierre-emeric', '0712121212', 'pem@gmail.com', 2),
(4, 90001, NULL, 'neveu', 'anouchka', '0612121212', 'ann.neveu@gmail.com', 3);

-- --------------------------------------------------------

--
-- Table structure for table `adresse`
--

CREATE TABLE `adresse` (
  `id_adresse` tinyint NOT NULL,
  `ville` varchar(30) NOT NULL,
  `code_postal` int NOT NULL,
  `rue` varchar(50) NOT NULL,
  `n_rue` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `adresse`
--

INSERT INTO `adresse` (`id_adresse`, `ville`, `code_postal`, `rue`, `n_rue`) VALUES
(1, 'Troyes', 10000, 'Avenue Anatole France', 18),
(2, 'Reims', 51454, 'Rue du Général Sarrail', 30),
(3, 'Orléans', 45000, 'Rue du Pressoir-Tonneau', 12),
(4, 'Paris', 75001, 'Rue de Rivoli', 115),
(5, 'Troyes', 10000, 'Rue Marie Curie', 12);

-- --------------------------------------------------------

--
-- Table structure for table `ad_habite`
--

CREATE TABLE `ad_habite` (
  `id_a` tinyint NOT NULL,
  `id_adresse` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ad_habite`
--

INSERT INTO `ad_habite` (`id_a`, `id_adresse`) VALUES
(1, 2),
(2, 3),
(3, 1),
(4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `ad_participe`
--

CREATE TABLE `ad_participe` (
  `id_a` tinyint NOT NULL,
  `id_r` tinyint NOT NULL,
  `role` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `ad_participe`
--

INSERT INTO `ad_participe` (`id_a`, `id_r`, `role`) VALUES
(1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `association`
--

CREATE TABLE `association` (
  `n_agrement` int NOT NULL,
  `date_crea` date NOT NULL,
  `telephone_ass` varchar(10) NOT NULL,
  `email_ass` varchar(50) NOT NULL,
  `revenus_annee` int NOT NULL,
  `tarif_base` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `association`
--

INSERT INTO `association` (`n_agrement`, `date_crea`, `telephone_ass`, `email_ass`, `revenus_annee`, `tarif_base`) VALUES
(90001, '2023-12-01', '0301020304', 'randonneurs.aubois@gmail.com', 0, 50);

-- --------------------------------------------------------

--
-- Table structure for table `as_habite`
--

CREATE TABLE `as_habite` (
  `n_agrement` int NOT NULL,
  `id_adresse` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `as_habite`
--

INSERT INTO `as_habite` (`n_agrement`, `id_adresse`) VALUES
(90001, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `bientot_retardataires`
-- (See below for the actual view)
--
CREATE TABLE `bientot_retardataires` (
`id_a` tinyint
);

-- --------------------------------------------------------

--
-- Table structure for table `certif_med`
--

CREATE TABLE `certif_med` (
  `id_cm` tinyint NOT NULL,
  `id_a` tinyint NOT NULL,
  `date_d_cm` date NOT NULL,
  `date_f_cm` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `certif_med`
--

INSERT INTO `certif_med` (`id_cm`, `id_a`, `date_d_cm`, `date_f_cm`) VALUES
(1, 1, '2023-12-01', '2024-12-01');

-- --------------------------------------------------------

--
-- Table structure for table `compte-rendu`
--

CREATE TABLE `compte-rendu` (
  `id_cr` tinyint NOT NULL,
  `n_agrement` int NOT NULL,
  `date_cr` date NOT NULL,
  `texte` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `compte-rendu`
--

INSERT INTO `compte-rendu` (`id_cr`, `n_agrement`, `date_cr`, `texte`) VALUES
(1, 90001, '2023-12-01', 'Création de l\'association des randonneurs aubois le 1er décembre 2023.');

-- --------------------------------------------------------

--
-- Table structure for table `formation`
--

CREATE TABLE `formation` (
  `id_f` tinyint NOT NULL,
  `nom` varchar(50) NOT NULL,
  `date_d_f` date NOT NULL,
  `date_f_f` date NOT NULL,
  `date_f_validite` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `formation`
--

INSERT INTO `formation` (`id_f`, `nom`, `date_d_f`, `date_f_f`, `date_f_validite`) VALUES
(1, 'Formation de secourisme', '2023-12-03', '2023-12-05', '2026-12-03');

-- --------------------------------------------------------

--
-- Table structure for table `nad_participe`
--

CREATE TABLE `nad_participe` (
  `id_na` tinyint NOT NULL,
  `id_r` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `nad_participe`
--

INSERT INTO `nad_participe` (`id_na`, `id_r`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `non-adherent`
--

CREATE TABLE `non-adherent` (
  `id_na` tinyint NOT NULL,
  `nom_na` varchar(30) NOT NULL,
  `prenom_na` varchar(30) NOT NULL,
  `email_na` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `non-adherent`
--

INSERT INTO `non-adherent` (`id_na`, `nom_na`, `prenom_na`, `email_na`) VALUES
(1, 'landre', 'noe', 'noe.landre@laposte.net'),
(2, 'roncin', 'teddy', 'troncin@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `paiement`
--

CREATE TABLE `paiement` (
  `id_paiement` tinyint NOT NULL,
  `id_a` tinyint NOT NULL,
  `tarif` double NOT NULL,
  `date_echeance` date NOT NULL,
  `date_paiement` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `paiement`
--

INSERT INTO `paiement` (`id_paiement`, `id_a`, `tarif`, `date_echeance`, `date_paiement`) VALUES
(1, 1, 12.5, '2023-12-13', NULL),
(2, 2, 12.5, '2023-12-26', NULL),
(3, 3, 25, '2023-12-09', '2023-12-11'),
(4, 4, 50, '2023-12-09', NULL),
(5, 3, 25, '2024-12-11', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `photo`
--

CREATE TABLE `photo` (
  `id_photo` tinyint NOT NULL,
  `id_r` tinyint NOT NULL,
  `lieu_p` varchar(30) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `photo`
--

INSERT INTO `photo` (`id_photo`, `id_r`, `lieu_p`, `image`) VALUES
(1, 1, 'Gorges du Verdon', 'https://photos.google.com/ara/123456.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `randonnee`
--

CREATE TABLE `randonnee` (
  `id_r` tinyint NOT NULL,
  `date_r` date NOT NULL,
  `lieu_d` varchar(50) NOT NULL,
  `difficulte` tinyint(1) NOT NULL,
  `n_km` int NOT NULL,
  `cout` int NOT NULL,
  `valide` tinyint(1) NOT NULL,
  `titre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `randonnee`
--

INSERT INTO `randonnee` (`id_r`, `date_r`, `lieu_d`, `difficulte`, `n_km`, `cout`, `valide`, `titre`) VALUES
(1, '2023-12-04', 'Gorges du Verdon', 1, 30, 150, 1, 'Randonnée dans les Gorges');

-- --------------------------------------------------------

--
-- Stand-in structure for view `retardataires`
-- (See below for the actual view)
--
CREATE TABLE `retardataires` (
`id_a` tinyint
);

-- --------------------------------------------------------

--
-- Table structure for table `suit`
--

CREATE TABLE `suit` (
  `id_a` tinyint NOT NULL,
  `id_f` tinyint NOT NULL,
  `reussite` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `suit`
--

INSERT INTO `suit` (`id_a`, `id_f`, `reussite`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Structure for view `bientot_retardataires`
--
DROP TABLE IF EXISTS `bientot_retardataires`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bientot_retardataires`  AS SELECT DISTINCT `p`.`id_a` AS `id_a` FROM `paiement` AS `p` WHERE (((to_days(`p`.`date_echeance`) - to_days(curdate())) between 1 and 14) AND (`p`.`date_paiement` is null))  ;

-- --------------------------------------------------------

--
-- Structure for view `retardataires`
--
DROP TABLE IF EXISTS `retardataires`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `retardataires`  AS SELECT DISTINCT `p`.`id_a` AS `id_a` FROM `paiement` AS `p` WHERE ((curdate() > `p`.`date_echeance`) AND (`p`.`date_paiement` is null))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adherent`
--
ALTER TABLE `adherent`
  ADD PRIMARY KEY (`id_a`),
  ADD KEY `n_agrement` (`n_agrement`);

--
-- Indexes for table `adresse`
--
ALTER TABLE `adresse`
  ADD PRIMARY KEY (`id_adresse`);

--
-- Indexes for table `ad_habite`
--
ALTER TABLE `ad_habite`
  ADD PRIMARY KEY (`id_a`,`id_adresse`),
  ADD KEY `id_a` (`id_a`),
  ADD KEY `id_adresse` (`id_adresse`);

--
-- Indexes for table `ad_participe`
--
ALTER TABLE `ad_participe`
  ADD PRIMARY KEY (`id_a`,`id_r`),
  ADD KEY `id_a` (`id_a`),
  ADD KEY `id_r` (`id_r`);

--
-- Indexes for table `association`
--
ALTER TABLE `association`
  ADD PRIMARY KEY (`n_agrement`);

--
-- Indexes for table `as_habite`
--
ALTER TABLE `as_habite`
  ADD PRIMARY KEY (`id_adresse`,`n_agrement`),
  ADD KEY `n_agrement` (`n_agrement`),
  ADD KEY `id_adresse` (`id_adresse`);

--
-- Indexes for table `certif_med`
--
ALTER TABLE `certif_med`
  ADD PRIMARY KEY (`id_cm`),
  ADD KEY `id_a` (`id_a`);

--
-- Indexes for table `compte-rendu`
--
ALTER TABLE `compte-rendu`
  ADD PRIMARY KEY (`id_cr`),
  ADD KEY `n_agrement` (`n_agrement`);

--
-- Indexes for table `formation`
--
ALTER TABLE `formation`
  ADD PRIMARY KEY (`id_f`);

--
-- Indexes for table `nad_participe`
--
ALTER TABLE `nad_participe`
  ADD PRIMARY KEY (`id_na`,`id_r`) USING BTREE,
  ADD KEY `id_na` (`id_na`),
  ADD KEY `id_r` (`id_r`);

--
-- Indexes for table `non-adherent`
--
ALTER TABLE `non-adherent`
  ADD PRIMARY KEY (`id_na`);

--
-- Indexes for table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id_paiement`),
  ADD KEY `id_a` (`id_a`);

--
-- Indexes for table `photo`
--
ALTER TABLE `photo`
  ADD PRIMARY KEY (`id_photo`),
  ADD KEY `id_r` (`id_r`);

--
-- Indexes for table `randonnee`
--
ALTER TABLE `randonnee`
  ADD PRIMARY KEY (`id_r`);

--
-- Indexes for table `suit`
--
ALTER TABLE `suit`
  ADD PRIMARY KEY (`id_a`,`id_f`),
  ADD KEY `id_a` (`id_a`),
  ADD KEY `id_f` (`id_f`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adherent`
--
ALTER TABLE `adherent`
  MODIFY `id_a` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `adresse`
--
ALTER TABLE `adresse`
  MODIFY `id_adresse` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `certif_med`
--
ALTER TABLE `certif_med`
  MODIFY `id_cm` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `compte-rendu`
--
ALTER TABLE `compte-rendu`
  MODIFY `id_cr` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `formation`
--
ALTER TABLE `formation`
  MODIFY `id_f` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `non-adherent`
--
ALTER TABLE `non-adherent`
  MODIFY `id_na` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `paiement`
--
ALTER TABLE `paiement`
  MODIFY `id_paiement` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `photo`
--
ALTER TABLE `photo`
  MODIFY `id_photo` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `randonnee`
--
ALTER TABLE `randonnee`
  MODIFY `id_r` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `adherent`
--
ALTER TABLE `adherent`
  ADD CONSTRAINT `adherent_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ad_habite`
--
ALTER TABLE `ad_habite`
  ADD CONSTRAINT `ad_habite_ibfk_1` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ad_habite_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ad_participe`
--
ALTER TABLE `ad_participe`
  ADD CONSTRAINT `ad_participe_ibfk_1` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ad_participe_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `as_habite`
--
ALTER TABLE `as_habite`
  ADD CONSTRAINT `as_habite_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `as_habite_ibfk_2` FOREIGN KEY (`id_adresse`) REFERENCES `adresse` (`id_adresse`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `certif_med`
--
ALTER TABLE `certif_med`
  ADD CONSTRAINT `certif_med_ibfk_1` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `compte-rendu`
--
ALTER TABLE `compte-rendu`
  ADD CONSTRAINT `compte-rendu_ibfk_1` FOREIGN KEY (`n_agrement`) REFERENCES `association` (`n_agrement`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `nad_participe`
--
ALTER TABLE `nad_participe`
  ADD CONSTRAINT `nad_participe_ibfk_1` FOREIGN KEY (`id_na`) REFERENCES `non-adherent` (`id_na`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `nad_participe_ibfk_2` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `paiement_ibfk_1` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `photo`
--
ALTER TABLE `photo`
  ADD CONSTRAINT `photo_ibfk_1` FOREIGN KEY (`id_r`) REFERENCES `randonnee` (`id_r`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `suit`
--
ALTER TABLE `suit`
  ADD CONSTRAINT `suit_ibfk_1` FOREIGN KEY (`id_f`) REFERENCES `formation` (`id_f`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `suit_ibfk_2` FOREIGN KEY (`id_a`) REFERENCES `adherent` (`id_a`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `detection_mensuelle` ON SCHEDULE EVERY 1 MONTH STARTS '2023-12-10 15:24:00' ENDS '2024-01-13 14:40:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL detect_retardataires()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
