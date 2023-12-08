-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 08, 2023 at 01:34 AM
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

-- --------------------------------------------------------

--
-- Table structure for table `adherent`
--

CREATE TABLE `adherent` (
  `id_a` tinyint NOT NULL,
  `nom_a` varchar(30) NOT NULL,
  `prenom_a` varchar(30) NOT NULL,
  `telephone_a` varchar(10) NOT NULL,
  `email_a` varchar(50) NOT NULL,
  `cate_sociale` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `adherent`
--

INSERT INTO `adherent` (`id_a`, `nom_a`, `prenom_a`, `telephone_a`, `email_a`, `cate_sociale`) VALUES
(1, 'dupont', 'michel', '0612345678', 'michel.dupont@gmail.com', 1),
(2, 'marechal', 'thomas', '0687654321', 'thomas.marechal@utt.fr', 1),
(3, 'boccard', 'pierre-emeric', '0712121212', 'pem@gmail.com', 2),
(4, 'neveu', 'anouchka', '0623232323', 'ann.neveu@gmail.com', 3);

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
-- Table structure for table `certif_med`
--

CREATE TABLE `certif_med` (
  `id_cm` tinyint NOT NULL,
  `date_d_cm` date NOT NULL,
  `date_f_cm` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `certif_med`
--

INSERT INTO `certif_med` (`id_cm`, `date_d_cm`, `date_f_cm`) VALUES
(1, '2023-12-01', '2024-12-01');

-- --------------------------------------------------------

--
-- Table structure for table `compte-rendu`
--

CREATE TABLE `compte-rendu` (
  `id_cr` tinyint NOT NULL,
  `date_cr` date NOT NULL,
  `texte` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `compte-rendu`
--

INSERT INTO `compte-rendu` (`id_cr`, `date_cr`, `texte`) VALUES
(1, '2023-12-01', 'Création de l\'association des randonneurs aubois le 1er décembre 2023.');

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
  `tarif` int NOT NULL,
  `date_echeance` date NOT NULL,
  `date_paiement` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `paiement`
--

INSERT INTO `paiement` (`id_paiement`, `tarif`, `date_echeance`, `date_paiement`) VALUES
(1, 50, '2023-12-08', '2022-12-08');

-- --------------------------------------------------------

--
-- Table structure for table `photo`
--

CREATE TABLE `photo` (
  `id_photo` tinyint NOT NULL,
  `lieu_p` varchar(30) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `photo`
--

INSERT INTO `photo` (`id_photo`, `lieu_p`, `image`) VALUES
(1, 'Gorges du Verdon', 'https://photos.google.com/ara/123456.jpg');

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adherent`
--
ALTER TABLE `adherent`
  ADD PRIMARY KEY (`id_a`);

--
-- Indexes for table `adresse`
--
ALTER TABLE `adresse`
  ADD PRIMARY KEY (`id_adresse`);

--
-- Indexes for table `association`
--
ALTER TABLE `association`
  ADD PRIMARY KEY (`n_agrement`);

--
-- Indexes for table `certif_med`
--
ALTER TABLE `certif_med`
  ADD PRIMARY KEY (`id_cm`);

--
-- Indexes for table `compte-rendu`
--
ALTER TABLE `compte-rendu`
  ADD PRIMARY KEY (`id_cr`);

--
-- Indexes for table `formation`
--
ALTER TABLE `formation`
  ADD PRIMARY KEY (`id_f`);

--
-- Indexes for table `non-adherent`
--
ALTER TABLE `non-adherent`
  ADD PRIMARY KEY (`id_na`);

--
-- Indexes for table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id_paiement`);

--
-- Indexes for table `photo`
--
ALTER TABLE `photo`
  ADD PRIMARY KEY (`id_photo`);

--
-- Indexes for table `randonnee`
--
ALTER TABLE `randonnee`
  ADD PRIMARY KEY (`id_r`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adherent`
--
ALTER TABLE `adherent`
  MODIFY `id_a` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  MODIFY `id_paiement` tinyint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
