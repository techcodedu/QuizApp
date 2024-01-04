-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 04, 2024 at 01:51 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quizgamedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `fruits`
--

CREATE TABLE `fruits` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fruits`
--

INSERT INTO `fruits` (`id`, `name`, `image_url`) VALUES
(1, 'Apple', 'images/apple.jpg'),
(2, 'Banana', 'images/banana.jpg'),
(3, 'Cherry', 'images/cherry.jpg'),
(4, 'Date', 'images/date.jpg'),
(5, 'Elderberry', 'images/elderberry.jpg'),
(6, 'Fig', 'images/fig.jpg'),
(7, 'Grape', 'images/grape.jpg'),
(8, 'Honeydew', 'images/honeydew.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `highscore`
--

CREATE TABLE `highscore` (
  `id` int(11) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `highscore`
--

INSERT INTO `highscore` (`id`, `player_id`, `score`, `time`) VALUES
(1, 1, 4, NULL),
(2, 2, 1, 9),
(3, 3, 0, 6);

-- --------------------------------------------------------

--
-- Table structure for table `player`
--

CREATE TABLE `player` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `duration_of_play` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `player`
--

INSERT INTO `player` (`id`, `name`, `start_time`, `end_time`, `score`, `duration_of_play`) VALUES
(1, 'adf', '2024-01-04 00:19:06', '2024-01-04 00:19:14', 4, 8),
(2, 'john', '2024-01-04 00:21:55', '2024-01-04 00:22:03', 1, 9),
(3, 'john', '2024-01-04 00:45:56', '2024-01-04 00:46:01', 0, 6);

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE `question` (
  `id` int(11) NOT NULL,
  `fruit_id` int(11) DEFAULT NULL,
  `choice_1_id` int(11) DEFAULT NULL,
  `choice_2_id` int(11) DEFAULT NULL,
  `choice_3_id` int(11) DEFAULT NULL,
  `choice_4_id` int(11) DEFAULT NULL,
  `correct_choice_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`id`, `fruit_id`, `choice_1_id`, `choice_2_id`, `choice_3_id`, `choice_4_id`, `correct_choice_id`) VALUES
(1, 1, 1, 2, 3, 4, 1),
(2, 2, 1, 2, 3, 5, 2),
(3, 3, 2, 3, 4, 6, 3),
(4, 4, 3, 4, 5, 7, 4),
(5, 5, 4, 5, 6, 8, 5),
(6, 6, 5, 6, 7, 1, 6),
(7, 7, 6, 7, 8, 2, 7),
(8, 8, 7, 8, 1, 3, 8),
(9, 1, 8, 1, 2, 4, 1),
(10, 2, 1, 3, 5, 2, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `fruits`
--
ALTER TABLE `fruits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `highscore`
--
ALTER TABLE `highscore`
  ADD PRIMARY KEY (`id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fruit_id` (`fruit_id`),
  ADD KEY `choice_1_id` (`choice_1_id`),
  ADD KEY `choice_2_id` (`choice_2_id`),
  ADD KEY `choice_3_id` (`choice_3_id`),
  ADD KEY `choice_4_id` (`choice_4_id`),
  ADD KEY `correct_choice_id` (`correct_choice_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `fruits`
--
ALTER TABLE `fruits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `highscore`
--
ALTER TABLE `highscore`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `question`
--
ALTER TABLE `question`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `highscore`
--
ALTER TABLE `highscore`
  ADD CONSTRAINT `highscore_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`);

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`fruit_id`) REFERENCES `fruits` (`id`),
  ADD CONSTRAINT `question_ibfk_2` FOREIGN KEY (`choice_1_id`) REFERENCES `fruits` (`id`),
  ADD CONSTRAINT `question_ibfk_3` FOREIGN KEY (`choice_2_id`) REFERENCES `fruits` (`id`),
  ADD CONSTRAINT `question_ibfk_4` FOREIGN KEY (`choice_3_id`) REFERENCES `fruits` (`id`),
  ADD CONSTRAINT `question_ibfk_5` FOREIGN KEY (`choice_4_id`) REFERENCES `fruits` (`id`),
  ADD CONSTRAINT `question_ibfk_6` FOREIGN KEY (`correct_choice_id`) REFERENCES `fruits` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
