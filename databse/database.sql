-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: music_quiz_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcement`
--

LOCK TABLES `announcement` WRITE;
/*!40000 ALTER TABLE `announcement` DISABLE KEYS */;
INSERT INTO `announcement` VALUES (3,'2025-08-03 12:06:52.843003','We\'ve resolved issues with quiz loading ? and fixed several login-related bugs ?. Thank you for your patience and support! ?','? Bug Fixes Released'),(5,'2025-08-03 13:50:49.757344','Our new forum feature is live! ? Share your music tips ?, ask questions ❓, and collaborate ? with other learners.','?? Join the Discussion!'),(9,'2025-08-28 17:12:50.211637','You can now track your quiz progress!','? New Feature'),(11,'2025-09-09 14:14:13.057218','unit testing','unit testing');
/*!40000 ALTER TABLE `announcement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_categories`
--

DROP TABLE IF EXISTS `forum_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` text,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_categories`
--

LOCK TABLES `forum_categories` WRITE;
/*!40000 ALTER TABLE `forum_categories` DISABLE KEYS */;
INSERT INTO `forum_categories` VALUES (1,'2025-08-15 13:02:42.842374','Discuss quiz concepts and music theory','Quiz Discussions'),(2,'2025-08-15 13:02:42.869311','General music composition discussions','General Chat');
/*!40000 ALTER TABLE `forum_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_posts`
--

DROP TABLE IF EXISTS `forum_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `content` text,
  `created_at` datetime(6) DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_posts`
--

LOCK TABLES `forum_posts` WRITE;
/*!40000 ALTER TABLE `forum_posts` DISABLE KEYS */;
INSERT INTO `forum_posts` VALUES (1,1,'I\'m struggling with understanding ii-V-I progressions. Can anyone help explain how they work in jazz?','2025-08-15 13:26:32.053116','Help with chord progressions','2025-08-15 13:26:32.053116',15),(2,2,'Let\'s share our composition journey and learn together.','2025-08-15 15:08:15.710345','Welcome to Music Composition Learning!','2025-08-15 15:08:15.710345',15),(3,2,'I am so confused that how to generate a good melody, anyone can help?','2025-08-17 17:32:58.840287','Music Composition','2025-08-17 17:32:58.840791',15),(4,1,'I\'ve been trying to incorporate modal interchange into my compositions, but I\'m not quite sure how to use it effectively. Any tips or examples would be appreciated!','2025-08-28 17:18:36.173551','Confused about modal interchange','2025-08-28 17:18:36.173551',15),(5,2,'unit testing','2025-09-09 14:26:04.708000','unit testing','2025-09-09 14:26:04.708000',15),(6,1,'Unit testing','2025-09-09 16:59:43.247186','Unit testing','2025-09-09 16:59:43.247186',24);
/*!40000 ALTER TABLE `forum_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forum_replies`
--

DROP TABLE IF EXISTS `forum_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `forum_replies` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `content` text,
  `created_at` datetime(6) DEFAULT NULL,
  `post_id` bigint NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum_replies`
--

LOCK TABLES `forum_replies` WRITE;
/*!40000 ALTER TABLE `forum_replies` DISABLE KEYS */;
INSERT INTO `forum_replies` VALUES (1,'Great post! I agree with your points about music composition techniques.','2025-08-15 13:29:32.476472',1,'2025-08-15 13:29:32.476472',15),(2,'haloooo','2025-08-15 15:28:32.215791',2,'2025-08-15 15:28:32.215791',15),(3,'yessss','2025-08-15 15:29:17.034334',1,'2025-08-15 15:29:17.035345',15),(4,'yes I would like to hear about the tips also!','2025-08-28 17:19:05.217867',4,'2025-08-28 17:19:05.217867',15),(5,'testing for sending reply','2025-09-09 11:42:18.620826',1,'2025-09-09 11:42:18.620826',15),(6,'unit testing','2025-09-09 13:49:57.625866',2,'2025-09-09 13:49:57.625866',15),(7,'Unit testing','2025-09-09 17:00:02.172927',6,'2025-09-09 17:00:02.172927',24);
/*!40000 ALTER TABLE `forum_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_options`
--

DROP TABLE IF EXISTS `question_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_options` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_correct` bit(1) DEFAULT NULL,
  `option_text` varchar(255) NOT NULL,
  `question_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKsb9v00wdrgc9qojtjkv7e1gkp` (`question_id`),
  CONSTRAINT `FKsb9v00wdrgc9qojtjkv7e1gkp` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_options`
--

LOCK TABLES `question_options` WRITE;
/*!40000 ALTER TABLE `question_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `audio_url` varchar(500) DEFAULT NULL,
  `correct_answer` varchar(255) NOT NULL,
  `points` int DEFAULT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('AUDIO_IDENTIFICATION','MULTIPLE_CHOICE','TRUE_FALSE') DEFAULT NULL,
  `quiz_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKn3gvco4b0kewxc0bywf1igfms` (`quiz_id`),
  CONSTRAINT `FKn3gvco4b0kewxc0bywf1igfms` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_attempts`
--

DROP TABLE IF EXISTS `quiz_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_attempts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `quiz_id` bigint NOT NULL,
  `score` int NOT NULL,
  `user_answer` varchar(255) DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_quiz_id` (`quiz_id`),
  KEY `idx_user_quiz` (`user_id`,`quiz_id`)
) ENGINE=InnoDB AUTO_INCREMENT=369 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_attempts`
--

LOCK TABLES `quiz_attempts` WRITE;
/*!40000 ALTER TABLE `quiz_attempts` DISABLE KEYS */;
INSERT INTO `quiz_attempts` VALUES (1,15,17,0,'Option A','2025-08-12 10:11:21'),(2,15,17,1,'A','2025-08-12 10:11:50'),(3,15,17,1,'A','2025-08-13 03:44:29'),(4,15,19,0,'Piano','2025-08-13 04:01:34'),(5,15,17,0,'Three-note chord','2025-08-13 04:01:38'),(6,15,17,0,'Three-note chord','2025-08-13 04:01:48'),(7,15,19,1,'Organ','2025-08-13 04:01:53'),(8,15,17,0,'Three-note chord','2025-08-13 04:02:16'),(9,15,17,0,'Three-note chord','2025-08-13 04:02:19'),(10,15,19,1,'Organ','2025-08-13 04:02:38'),(11,15,17,0,'Three-note chord','2025-08-13 04:02:41'),(12,15,19,0,'Piano','2025-08-13 04:02:46'),(13,15,17,0,'Scale','2025-08-13 04:02:49'),(14,15,19,1,'Organ','2025-08-13 04:02:53'),(15,15,17,0,'Four-note chord','2025-08-13 04:02:56'),(16,15,19,0,'Violin','2025-08-13 04:03:01'),(17,15,17,0,'Single note','2025-08-13 04:03:04'),(18,15,20,1,'Three-note chord','2025-08-13 04:22:34'),(19,15,17,0,'Three-note chord','2025-08-13 04:22:56'),(20,15,19,1,'Organ','2025-08-13 04:23:01'),(21,15,20,1,'Three-note chord','2025-08-13 04:23:04'),(22,15,17,0,'Three-note chord','2025-08-13 04:23:57'),(23,15,17,0,'Three-note chord','2025-08-13 04:24:01'),(24,15,17,0,'Three-note chord','2025-08-13 04:24:05'),(25,15,17,0,'Three-note chord','2025-08-13 04:27:38'),(26,15,19,1,'Organ','2025-08-13 04:27:56'),(27,15,19,1,'Organ','2025-08-13 04:28:11'),(28,15,19,1,'Organ','2025-08-13 04:50:04'),(29,15,20,1,'Three-note chord','2025-08-13 04:50:10'),(30,15,17,0,'Three-note chord','2025-08-13 04:50:12'),(31,15,17,0,'Three-note chord','2025-08-13 04:50:29'),(32,15,17,0,'Three-note chord','2025-08-13 04:50:32'),(33,15,17,0,'Three-note chord','2025-08-13 04:52:12'),(34,15,17,0,'Three-note chord','2025-08-13 04:52:18'),(35,15,17,0,'Three-note chord','2025-08-13 06:45:08'),(36,15,17,0,'Three-note chord','2025-08-13 06:45:14'),(37,15,17,0,'Three-note chord','2025-08-13 06:45:39'),(38,15,20,1,'Three-note chord','2025-08-13 06:45:43'),(39,15,19,1,'Organ','2025-08-13 06:45:46'),(40,15,20,1,'Three-note chord','2025-08-13 07:23:58'),(41,15,17,0,'Three-note chord','2025-08-13 07:24:01'),(42,15,19,1,'Organ','2025-08-13 07:24:48'),(43,15,23,1,'A minor','2025-08-14 05:47:45'),(44,15,20,1,'Three-note chord','2025-08-14 06:02:19'),(45,15,17,0,'Three-note chord','2025-08-14 06:02:23'),(46,15,28,0,'A major','2025-08-14 06:02:32'),(47,15,38,0,'Through-composed','2025-08-14 06:02:39'),(48,15,26,0,'GâCâD','2025-08-14 06:03:28'),(49,15,39,1,'G-C-D','2025-08-14 06:09:12'),(50,15,17,0,'Three-note chord','2025-08-14 06:31:48'),(51,15,23,0,'G minor','2025-08-14 06:31:55'),(52,15,28,0,'A major','2025-08-14 06:32:00'),(53,15,27,0,'2','2025-08-14 06:32:22'),(54,15,22,1,'C','2025-08-14 06:32:28'),(55,15,45,1,'A minor','2025-08-14 07:10:23'),(56,15,45,0,'g minor','2025-08-14 07:10:36'),(57,15,53,0,'To change time signature','2025-08-14 07:11:59'),(58,15,49,0,'C major','2025-08-14 07:12:06'),(59,15,46,0,'Minor 3rd','2025-08-14 07:12:56'),(60,15,49,0,'D major','2025-08-14 07:17:21'),(61,15,46,0,'Minor 3rd','2025-08-14 07:18:59'),(62,15,51,0,'Major scale','2025-08-14 07:19:10'),(63,15,60,0,'G-D-C','2025-08-14 07:19:22'),(64,15,61,0,'C minor 7','2025-08-14 07:20:43'),(65,15,45,1,'A minor','2025-08-14 07:26:45'),(66,15,46,0,'Perfect 4th','2025-08-14 07:26:56'),(67,15,45,0,'E minor','2025-08-14 07:31:05'),(68,15,45,0,'D minor','2025-08-14 07:31:15'),(69,15,45,1,'A minor','2025-08-14 07:31:21'),(70,15,45,1,'A minor','2025-08-14 07:37:33'),(71,15,46,0,'Minor 3rd','2025-08-14 07:37:45'),(72,15,46,0,'Minor 3rd','2025-08-14 07:39:25'),(73,15,46,0,'Minor 3rd','2025-08-14 07:40:49'),(74,15,46,1,'Major 3rd','2025-08-14 07:41:07'),(75,15,46,0,'Minor 3rd','2025-08-14 07:41:19'),(76,15,49,1,'G major','2025-08-14 07:41:33'),(77,15,45,0,'E minor','2025-08-14 07:41:38'),(78,15,59,1,'ABABCB (verse-chorus-verse-chorus-bridge-chorus)','2025-08-14 07:41:54'),(79,15,58,1,'Two or more rhythms occur simultaneously but with different beat divisions','2025-08-14 07:42:08'),(80,15,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-14 07:42:16'),(81,15,56,0,'Augmented chord','2025-08-14 07:42:21'),(82,15,57,0,'Repeating a single tonal center','2025-08-14 07:42:25'),(83,15,59,1,'ABABCB (verse-chorus-verse-chorus-bridge-chorus)','2025-08-14 08:01:29'),(84,15,61,0,'C major','2025-08-15 07:30:01'),(85,15,62,0,'D-C-G','2025-08-15 07:30:08'),(86,15,50,0,'D7','2025-08-15 07:30:13'),(87,15,57,0,'Using only whole-tone scales','2025-08-15 07:30:18'),(88,15,46,1,'Major 3rd','2025-08-15 07:30:22'),(89,15,53,1,'To temporarily tonicize a chord other than the tonic','2025-08-15 09:55:47'),(90,15,50,0,'D7','2025-08-15 09:55:53'),(91,15,51,0,'Chromatic scale','2025-08-15 09:55:59'),(92,15,49,0,'A major','2025-08-15 09:56:06'),(93,15,55,0,'Borrowing chords from the relative minor','2025-08-15 09:56:11'),(94,15,50,0,'D7','2025-08-15 10:12:17'),(95,15,59,0,'ABACAD','2025-08-15 10:12:20'),(96,15,46,0,'Minor 3rd','2025-08-15 10:12:25'),(97,15,51,1,'Mixolydian scale','2025-08-15 10:12:28'),(98,15,55,0,'Borrowing chords from the relative minor','2025-08-15 10:12:31'),(99,15,46,1,'Major 3rd','2025-08-15 10:13:22'),(100,15,46,1,'Major 3rd','2025-08-15 10:17:55'),(101,15,48,1,'3','2025-08-17 04:25:59'),(102,15,48,1,'3','2025-08-17 04:26:10'),(103,15,48,0,'4','2025-08-17 04:26:16'),(104,15,48,1,'3','2025-08-17 04:26:54'),(105,15,48,1,'3','2025-08-17 04:34:57'),(106,15,53,0,'To change time signature','2025-08-17 04:35:07'),(107,15,51,0,'Chromatic scale','2025-08-17 04:35:11'),(108,15,61,1,'C major 7','2025-08-17 04:35:14'),(109,15,50,0,'D7','2025-08-17 04:35:18'),(110,15,54,0,'3rds','2025-08-17 04:35:21'),(111,15,51,0,'Major scale','2025-08-17 04:35:30'),(112,15,50,0,'F7','2025-08-17 04:35:33'),(113,15,62,0,'C-G-D','2025-08-17 04:35:38'),(114,15,54,0,'6ths','2025-08-17 04:35:46'),(115,15,55,0,'Borrowing chords from the dominant key','2025-08-17 04:35:52'),(116,15,57,1,'Organizing all 12 chromatic notes into a tone row','2025-08-17 05:02:56'),(117,15,56,0,'Augmented chord','2025-08-17 05:03:00'),(118,15,58,1,'Two or more rhythms occur simultaneously but with different beat divisions','2025-08-17 05:03:03'),(119,15,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-17 05:03:06'),(120,15,53,0,'To create dissonance without resolution','2025-08-17 05:03:09'),(121,6,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-17 05:17:26'),(122,6,50,1,'G7','2025-08-17 05:17:29'),(123,6,56,1,'Diminished chord','2025-08-17 05:17:32'),(124,6,49,1,'G major','2025-08-17 05:17:37'),(125,6,61,0,'C major','2025-08-17 05:17:44'),(126,15,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-17 05:59:40'),(127,15,58,1,'Two or more rhythms occur simultaneously but with different beat divisions','2025-08-17 05:59:45'),(128,15,56,1,'Diminished chord','2025-08-17 06:01:52'),(129,15,59,0,'AAAA','2025-08-17 06:01:55'),(130,15,46,0,'Perfect 5th','2025-08-17 09:46:00'),(131,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-21 10:50:23'),(132,15,46,0,'Perfect 5th','2025-08-21 10:50:43'),(133,15,73,1,'Create music that is simultaneously consonant and dissonant through polytonality and metric displacement','2025-08-21 10:52:10'),(134,15,46,1,'Major 3rd','2025-08-21 10:55:56'),(135,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-21 10:56:16'),(136,15,69,1,'Vary rhythm, dynamics, articulation, and melodic direction with each repetition','2025-08-21 10:57:43'),(137,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-23 13:18:12'),(138,15,49,1,'G major','2025-08-23 13:18:18'),(139,15,65,1,'Combine minor keys with strong, angular rhythmic patterns','2025-08-23 13:18:32'),(140,15,62,1,'G-C-D','2025-08-23 13:18:43'),(141,15,64,1,'Gradually increasing dynamics with low, rumbling sounds','2025-08-23 13:19:03'),(142,15,66,1,'Add swing rhythm, extended chords, and improvisation sections','2025-08-23 13:19:11'),(143,15,48,1,'3','2025-08-23 13:19:19'),(144,15,46,1,'Major 3rd','2025-08-23 13:19:34'),(145,15,46,1,'Major 3rd','2025-08-23 13:21:08'),(146,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-24 11:09:37'),(147,15,65,1,'Combine minor keys with strong, angular rhythmic patterns','2025-08-24 11:09:51'),(148,15,49,1,'G major','2025-08-24 11:09:57'),(149,15,66,1,'Add swing rhythm, extended chords, and improvisation sections','2025-08-24 11:10:03'),(150,15,62,1,'G-C-D','2025-08-24 11:10:13'),(151,15,46,0,'Perfect 5th','2025-08-24 11:10:25'),(152,15,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-24 11:12:26'),(153,15,55,0,'Borrowing chords from a distant modulation','2025-08-24 11:14:27'),(154,15,48,1,'3','2025-08-24 11:15:31'),(155,15,55,0,'Borrowing chords from the parallel key (e.g., C major â C minor)','2025-08-24 11:16:58'),(156,15,55,0,'Borrowing chords from the relative minor','2025-08-24 11:17:23'),(157,15,73,1,'Create music that is simultaneously consonant and dissonant through polytonality and metric displacement','2025-08-24 11:18:56'),(158,15,46,0,'Minor 3rd','2025-08-24 11:21:57'),(159,15,46,1,'Major 3rd','2025-08-24 11:22:42'),(160,15,46,1,'Major 3rd','2025-08-24 11:24:21'),(161,15,46,1,'Major 3rd','2025-08-24 11:26:31'),(162,15,46,1,'Major 3rd','2025-08-25 02:51:52'),(163,15,46,1,'Major 3rd','2025-08-25 02:53:57'),(164,15,46,1,'Major 3rd','2025-08-25 02:57:00'),(165,15,69,1,'Vary rhythm, dynamics, articulation, and melodic direction with each repetition','2025-08-25 03:00:27'),(166,15,46,1,'Major 3rd','2025-08-25 03:01:59'),(167,15,46,1,'Major 3rd','2025-08-25 03:06:58'),(168,15,46,1,'Major 3rd','2025-08-25 03:10:30'),(169,15,48,1,'3','2025-08-25 03:10:41'),(170,15,62,1,'G-C-D','2025-08-25 03:13:15'),(171,15,46,1,'Major 3rd','2025-08-25 03:13:23'),(172,15,46,1,'Major 3rd','2025-08-25 03:14:59'),(173,15,49,1,'g major','2025-08-25 03:26:06'),(174,15,46,1,'Major 3rd','2025-08-25 03:29:20'),(175,15,49,1,'G major','2025-08-25 03:29:25'),(176,15,48,1,'3','2025-08-25 03:29:28'),(177,15,64,1,'Gradually increasing dynamics with low, rumbling sounds','2025-08-25 03:29:34'),(178,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-25 03:29:39'),(179,15,46,1,'Major 3rd','2025-08-25 03:31:12'),(180,15,49,1,'g major','2025-08-25 03:35:12'),(181,15,46,1,'Major 3rd','2025-08-25 03:35:27'),(182,15,48,1,'3','2025-08-25 03:35:38'),(183,15,46,1,'Major 3rd','2025-08-25 03:41:33'),(184,15,46,1,'Major 3rd','2025-08-25 03:45:28'),(185,15,46,1,'Major 3rd','2025-08-25 03:46:43'),(186,15,46,1,'Major 3rd','2025-08-25 03:46:51'),(187,15,46,1,'Major 3rd','2025-08-25 03:49:11'),(188,15,46,1,'Major 3rd','2025-08-25 03:50:13'),(189,15,46,1,'Major 3rd','2025-08-25 03:51:03'),(190,15,46,1,'Major 3rd','2025-08-25 03:52:02'),(191,15,46,1,'Major 3rd','2025-08-25 03:53:40'),(192,15,46,1,'Major 3rd','2025-08-25 03:56:09'),(193,15,46,1,'Major 3rd','2025-08-25 03:59:13'),(194,15,48,1,'3','2025-08-25 03:59:54'),(195,15,63,1,'Slow tempo, soft dynamics, simple repetitive melody','2025-08-28 06:55:20'),(196,15,61,0,'C major','2025-08-28 06:55:26'),(197,15,67,1,'Begin in minor key with slow tempo, gradually move to major key with brighter dynamics','2025-08-28 06:55:38'),(198,15,81,0,'G-C-D','2025-08-28 07:43:11'),(199,15,48,0,'A','2025-08-28 08:02:44'),(200,15,48,0,'a','2025-08-28 08:02:57'),(201,15,81,0,'G-C-D','2025-08-28 08:03:55'),(202,15,64,0,'A','2025-08-28 08:13:45'),(203,15,46,0,'A','2025-08-28 08:14:23'),(204,15,48,0,'a','2025-08-28 08:14:49'),(205,15,49,0,'B','2025-08-28 08:15:18'),(206,15,48,0,'a','2025-08-28 08:21:39'),(207,15,48,1,'b','2025-08-28 08:22:04'),(208,15,72,1,'B','2025-08-28 08:22:30'),(209,15,74,1,'B','2025-08-28 08:22:40'),(210,15,71,1,'B','2025-08-28 08:22:55'),(211,15,61,1,'C','2025-08-28 08:23:05'),(212,15,58,1,'B','2025-08-28 08:23:12'),(213,15,63,1,'B','2025-08-28 08:23:23'),(214,15,81,1,'A','2025-08-28 08:23:33'),(215,15,66,1,'B','2025-08-28 08:23:42'),(216,15,65,1,'B','2025-08-28 08:23:53'),(217,15,46,1,'A','2025-08-28 08:24:00'),(218,15,46,1,'A','2025-08-28 08:30:42'),(219,15,63,1,'B','2025-08-28 08:33:11'),(220,15,71,1,'B','2025-08-28 08:33:32'),(221,15,61,1,'C','2025-08-28 08:33:38'),(222,15,53,1,'B','2025-08-28 08:33:45'),(223,15,54,0,'B','2025-08-28 08:33:51'),(224,15,75,1,'B','2025-08-28 09:15:02'),(225,15,50,0,'A','2025-08-28 09:15:26'),(226,15,71,1,'B','2025-08-28 09:15:40'),(227,15,68,1,'B','2025-08-28 09:15:43'),(228,15,59,1,'A','2025-08-28 09:15:47'),(229,15,46,1,'A','2025-08-28 09:17:28'),(230,15,53,1,'B','2025-09-01 08:26:41'),(231,15,77,1,'B','2025-09-01 08:26:48'),(232,15,73,1,'B','2025-09-01 08:26:57'),(233,15,65,1,'B','2025-09-01 08:27:03'),(234,15,51,1,'C','2025-09-01 08:27:10'),(235,15,55,1,'A','2025-09-04 07:48:37'),(236,15,76,1,'B','2025-09-04 07:48:41'),(237,15,46,1,'A','2025-09-04 07:48:47'),(238,15,73,1,'B','2025-09-04 07:48:50'),(239,15,56,1,'C','2025-09-04 07:48:57'),(240,15,70,1,'B','2025-09-06 15:52:54'),(241,15,83,1,'A','2025-09-06 15:53:04'),(242,15,58,1,'B','2025-09-06 15:53:08'),(243,15,56,0,'D','2025-09-06 15:53:14'),(244,15,73,1,'B','2025-09-06 15:53:19'),(245,17,46,1,'A','2025-09-07 04:59:38'),(246,17,66,1,'B','2025-09-07 04:59:46'),(247,17,48,0,'D','2025-09-07 04:59:52'),(248,17,83,1,'A','2025-09-07 04:59:59'),(249,17,63,1,'B','2025-09-07 05:00:03'),(250,17,64,1,'A','2025-09-07 05:07:01'),(251,18,70,1,'B','2025-09-07 05:43:25'),(252,18,61,1,'C','2025-09-07 05:43:52'),(253,18,53,1,'B','2025-09-07 05:43:58'),(254,18,51,1,'C','2025-09-07 05:44:06'),(255,18,71,1,'B','2025-09-07 05:44:13'),(256,19,57,1,'B','2025-09-07 06:27:33'),(257,19,55,1,'A','2025-09-07 06:27:39'),(258,19,72,1,'B','2025-09-07 06:27:44'),(259,19,74,1,'B','2025-09-07 06:27:50'),(260,19,73,1,'B','2025-09-07 06:27:56'),(261,19,74,1,'B','2025-09-07 06:31:51'),(262,19,72,1,'B','2025-09-07 06:32:02'),(263,19,55,1,'A','2025-09-07 06:32:08'),(264,19,76,1,'B','2025-09-07 06:32:13'),(265,19,57,1,'B','2025-09-07 06:32:20'),(266,15,58,1,'B','2025-09-07 09:28:09'),(267,20,46,0,'C','2025-09-07 10:39:23'),(268,20,65,0,'D','2025-09-07 10:39:28'),(269,20,49,0,'D','2025-09-07 10:39:31'),(270,20,63,0,'D','2025-09-07 10:39:34'),(271,20,66,0,'D','2025-09-07 10:39:37'),(272,20,83,1,'A','2025-09-07 10:49:10'),(273,20,65,1,'B','2025-09-07 10:49:15'),(274,20,63,0,'A','2025-09-07 10:49:18'),(275,20,48,0,'C','2025-09-07 10:49:24'),(276,20,66,0,'A','2025-09-07 10:49:27'),(277,20,65,1,'B','2025-09-07 10:49:34'),(278,20,64,0,'C','2025-09-07 10:49:39'),(279,20,49,1,'B','2025-09-07 10:49:43'),(280,20,76,1,'B','2025-09-07 12:27:45'),(281,20,74,1,'B','2025-09-07 12:27:49'),(282,20,68,1,'B','2025-09-07 12:27:52'),(283,20,72,1,'B','2025-09-07 12:27:55'),(284,20,66,1,'B','2025-09-07 12:27:58'),(285,20,61,1,'C','2025-09-07 12:28:03'),(286,20,76,1,'B','2025-09-07 12:28:07'),(287,20,68,1,'B','2025-09-07 12:28:10'),(288,20,46,1,'A','2025-09-07 12:28:15'),(289,20,67,1,'B','2025-09-07 12:28:21'),(290,20,77,1,'B','2025-09-07 12:28:25'),(291,20,50,0,'A','2025-09-07 12:28:30'),(292,20,74,1,'B','2025-09-07 12:28:34'),(293,20,71,1,'B','2025-09-07 12:28:36'),(294,20,68,1,'B','2025-09-07 12:28:39'),(295,20,67,1,'B','2025-09-07 12:28:44'),(296,20,72,1,'B','2025-09-07 12:28:48'),(297,20,70,1,'B','2025-09-07 12:28:53'),(298,20,59,1,'A','2025-09-07 12:28:57'),(299,20,51,0,'A','2025-09-07 12:29:00'),(300,20,51,1,'C','2025-09-07 12:29:04'),(301,20,57,1,'B','2025-09-07 12:29:07'),(302,20,46,1,'A','2025-09-07 12:29:11'),(303,20,53,1,'B','2025-09-07 12:29:15'),(304,20,55,1,'A','2025-09-07 12:29:18'),(305,15,64,1,'A','2025-09-09 03:12:46'),(306,15,58,1,'B','2025-09-09 03:12:50'),(307,15,68,1,'B','2025-09-09 03:12:53'),(308,15,48,1,'B','2025-09-09 03:12:56'),(309,15,75,1,'B','2025-09-09 03:13:00'),(310,15,49,1,'B','2025-09-09 03:36:11'),(311,15,56,0,'D','2025-09-09 03:36:48'),(312,15,83,1,'A','2025-09-09 05:48:12'),(313,15,70,1,'B','2025-09-09 05:48:50'),(314,15,46,1,'A','2025-09-09 06:26:47'),(315,15,57,1,'B','2025-09-09 06:41:12'),(316,15,46,0,'C','2025-09-09 06:41:57'),(317,15,64,1,'A','2025-09-09 06:42:51'),(318,15,48,1,'B','2025-09-09 06:43:41'),(319,15,63,1,'B','2025-09-09 06:43:52'),(320,15,57,1,'B','2025-09-09 06:43:55'),(321,15,83,1,'A','2025-09-09 06:43:59'),(322,15,46,1,'A','2025-09-09 06:44:03'),(323,15,50,0,'B','2025-09-09 06:44:09'),(324,15,69,1,'B','2025-09-09 06:44:12'),(325,15,70,1,'B','2025-09-09 06:44:15'),(326,15,67,1,'B','2025-09-09 06:44:18'),(327,15,51,1,'C','2025-09-09 06:44:23'),(328,15,65,1,'B','2025-09-09 06:44:39'),(329,15,63,1,'B','2025-09-09 06:44:43'),(330,15,48,1,'B','2025-09-09 06:44:48'),(331,15,66,1,'B','2025-09-09 06:44:52'),(332,15,46,1,'A','2025-09-09 06:44:56'),(333,15,64,1,'A','2025-09-09 06:45:01'),(334,15,49,1,'B','2025-09-09 06:45:04'),(335,15,83,1,'A','2025-09-09 06:45:08'),(336,15,66,1,'B','2025-09-09 06:48:55'),(337,15,83,1,'A','2025-09-09 06:49:02'),(338,15,46,1,'A','2025-09-09 06:49:07'),(339,15,65,1,'B','2025-09-09 06:49:12'),(340,15,48,1,'B','2025-09-09 06:49:17'),(341,15,48,1,'B','2025-09-09 06:52:37'),(342,15,65,1,'B','2025-09-09 06:52:43'),(343,15,64,1,'A','2025-09-09 06:52:50'),(344,15,63,1,'B','2025-09-09 06:53:00'),(345,15,83,1,'A','2025-09-09 06:53:06'),(346,15,46,1,'A','2025-09-09 06:53:19'),(347,15,70,1,'B','2025-09-09 06:53:30'),(348,15,68,1,'B','2025-09-09 06:53:39'),(349,15,51,1,'C','2025-09-09 06:55:09'),(350,15,67,1,'B','2025-09-09 06:55:18'),(351,15,68,1,'B','2025-09-09 06:55:23'),(352,15,61,1,'C','2025-09-09 06:55:30'),(353,15,70,1,'B','2025-09-09 06:55:38'),(354,15,70,1,'B','2025-09-09 07:00:03'),(355,15,46,1,'A','2025-09-09 07:00:09'),(356,15,61,1,'C','2025-09-09 07:00:16'),(357,15,68,1,'B','2025-09-09 07:00:21'),(358,15,50,0,'A','2025-09-09 07:00:33'),(359,22,49,1,'B','2025-09-09 08:46:10'),(360,22,65,1,'B','2025-09-09 08:46:15'),(361,22,46,1,'A','2025-09-09 08:46:19'),(362,22,66,1,'B','2025-09-09 08:46:24'),(363,22,83,0,'D','2025-09-09 08:46:29'),(364,24,83,1,'A','2025-09-09 08:57:43'),(365,24,46,1,'A','2025-09-09 08:57:47'),(366,24,66,1,'B','2025-09-09 08:57:52'),(367,24,65,0,'A','2025-09-09 08:57:55'),(368,24,64,0,'B','2025-09-09 08:58:00');
/*!40000 ALTER TABLE `quiz_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quizzes`
--

DROP TABLE IF EXISTS `quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quizzes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `correct_answer` varchar(255) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `optiona` varchar(255) DEFAULT NULL,
  `optionb` varchar(255) DEFAULT NULL,
  `optionc` varchar(255) DEFAULT NULL,
  `optiond` varchar(255) DEFAULT NULL,
  `question` varchar(255) DEFAULT NULL,
  `topic` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `feedback` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quizzes`
--

LOCK TABLES `quizzes` WRITE;
/*!40000 ALTER TABLE `quizzes` DISABLE KEYS */;
INSERT INTO `quizzes` VALUES (46,'A','Beginner','Major 3rd','Minor 3rd','Perfect 4th','Perfect 5th','What is the interval between C and E?','Intervals','2025-08-14 06:53:24','From C to E is four semitones, which defines a major third interval.'),(48,'B','Beginner','2','3','4','6','In 4/4 time, how many beats does a dotted half note get?','Rhythm','2025-08-14 06:53:24','A half note gets 2 beats. The dot adds half of its value (1 beat), so together it equals 3 beats.'),(49,'B','Beginner','C major','G major','D major','A major','Which key signature has one sharp (#)?','Key Signatures','2025-08-14 06:53:24','G major has one sharp, which is F#. C major has none, D major has two, and A major has three.'),(50,'C','Intermediate','C7','D7','G7','F7','Which chord is the dominant seventh chord in C major?','Harmony','2025-08-14 06:53:24','The dominant (V) chord in C major is G. Adding a minor seventh creates the G7 chord, the dominant seventh.'),(51,'C','Intermediate','Major scale','Pentatonic scale','Mixolydian scale','Chromatic scale','Which of the following scales is most commonly used for jazz improvisation?','Scales','2025-08-14 06:53:24','The Mixolydian scale is widely used in jazz because of its dominant seventh sound, ideal for improvising.'),(53,'B','Intermediate','To change time signature','To temporarily tonicize a chord other than the tonic','To create dissonance without resolution','To modulate to another key','What is the purpose of secondary dominants in composition?','Harmony','2025-08-14 06:53:24','Secondary dominants temporarily make another chord sound like a temporary tonic by preceding it with its V chord.'),(55,'A','Expert','Borrowing chords from the parallel key (e.g., C major → C minor)','Borrowing chords from the relative minor','Borrowing chords from the dominant key','Borrowing chords from a distant modulation','Which of the following best describes modal interchange (borrowed chords)?','Harmony','2025-08-14 06:53:24','Modal interchange means borrowing chords from the parallel mode, like using iv from C minor while in C major.'),(56,'C','Expert','Major triad','Minor triad','Diminished chord','Augmented chord','In film scoring, which chord is often used to create a sense of suspense or mystery?','Composition Techniques','2025-08-14 06:53:24','Diminished chords have tense, unstable sounds that create suspense and are common in film scoring.'),(57,'B','Expert','Using the circle of fifths strictly','Organizing all 12 chromatic notes into a tone row','Using only whole-tone scales','Repeating a single tonal center','Which technique is used in 12-tone (serial) composition?','Modern Composition','2025-08-14 06:53:24','12-tone technique uses all 12 chromatic pitches in a fixed sequence (tone row), avoiding traditional tonal hierarchy.'),(58,'B','Expert','Two or more melodies are harmonized','Two or more rhythms occur simultaneously but with different beat divisions','The tempo changes suddenly','The meter changes between sections','A polyrhythm occurs when:','Rhythm','2025-08-14 06:53:24','Polyrhythm is when contrasting rhythms (like 3 against 2) happen together, creating rhythmic complexity.'),(59,'A','Expert','ABABCB (verse-chorus-verse-chorus-bridge-chorus)','AAAA','ABACAD','Through-composed','In modern pop composition, what is the most common song structure?','Songwriting','2025-08-14 06:53:24','Most modern pop songs use ABABCB: verse, chorus, verse, chorus, bridge, chorus — balancing repetition and contrast.'),(61,'C','Intermediate','C major','C minor 7','C major 7','G7','If a melody outlines the notes C-E-G-B, which chord does it imply?','Chords','2025-08-14 07:18:47','The notes C-E-G form a C major triad. Adding B makes it a major seventh chord (Cmaj7).'),(63,'B','Beginner','Fast tempo, major key, complex rhythms','Slow tempo, soft dynamics, simple repetitive melody','Moderate tempo, minor key, syncopated beats','Variable tempo, dissonant harmonies, wide melodic leaps','You\'re composing a lullaby for a restless child. Which musical elements would BEST create a calming atmosphere?','Creative Composition','2025-08-21 10:48:25','Lullabies use gentle, predictable elements to soothe. This teaches how musical choices create specific emotional responses.'),(64,'A','Beginner','Gradually increasing dynamics with low, rumbling sounds','Soft, high-pitched melodies in major keys','Steady, unchanging rhythm throughout','Simple, repetitive chord progression','If you wanted to musically represent \'a thunderstorm approaching\', which creative technique would be most effective?','Musical Storytelling','2025-08-21 10:48:25','Building dynamics and using low tones mimics natural thunder sounds, showing how music can paint vivid pictures.'),(65,'B','Beginner','Use only major chords and bright timbres','Combine minor keys with strong, angular rhythmic patterns','Write only in high registers with soft dynamics','Use random notes with no clear structure','You\'re creating a villain\'s theme song. To make it sound menacing yet memorable, you would:','Character Themes','2025-08-21 10:48:25','Villains often get dark tonalities and aggressive rhythms. This shows how musical choices can define character personalities.'),(66,'B','Beginner','Keep everything exactly the same as the original','Add swing rhythm, extended chords, and improvisation sections','Remove all harmony and play only the melody','Play it at exactly the same tempo as usual','If you were arranging \'Happy Birthday\' for a jazz band, which element would you change to make it more creative?','Creative Arrangement','2025-08-21 10:48:25','Jazz arrangements transform familiar songs through rhythmic feel, harmony, and personal expression - showing how creativity builds on existing material.'),(67,'B','Intermediate','Start and end in exactly the same style','Begin in minor key with slow tempo, gradually move to major key with brighter dynamics','Use only fast, energetic music throughout','Keep the same mood from beginning to end','You want to compose a piece that expresses \'hope after sadness\'. Which musical journey would best convey this emotional arc?','Emotional Architecture','2025-08-21 10:48:25','Musical transformation mirrors emotional journeys. This teaches how composers create narratives through strategic musical changes.'),(68,'B','Intermediate','Keep both genres completely separate with no interaction','Blend orchestral instruments with hip-hop beats, creating hybrid rhythmic-harmonic structures','Use only classical instruments and ignore hip-hop elements','Use only electronic sounds throughout','When creating a fusion piece combining classical and hip-hop, which approach would be most creatively successful?','Genre Fusion','2025-08-21 10:48:25','Successful fusion creates new possibilities by thoughtfully combining elements from different traditions, not just placing them side by side.'),(69,'B','Intermediate','Play the same melody every time','Vary rhythm, dynamics, articulation, and melodic direction with each repetition','Use only quarter notes throughout','Never change anything about your approach','You\'re improvising over a simple C-F-G-C progression. To create maximum expressive variety, you should:','Creative Improvisation','2025-08-21 10:48:25','Improvisation thrives on variation within structure. Each musical element can be a tool for personal expression and creativity.'),(70,'B','Intermediate','Slow tempo, relaxed rhythm, soft dynamics','Accelerating tempo, irregular accents, building dynamics, shortened phrase lengths','Constant tempo with no changes','Very soft dynamics throughout','If you were composing music for a scene where \'time is running out\', which combination would create the most effective musical tension?','Musical Tension','2025-08-21 10:48:25','Urgency is created through multiple accelerating elements working together. This shows how composers use time manipulation for dramatic effect.'),(71,'B','Intermediate','Use only abstract musical patterns with no connection to place','Incorporate local musical traditions, natural soundscapes, and personal memories into original musical structures','Copy existing songs exactly without changes','Avoid any reference to your actual experiences','You\'re writing a piece inspired by your hometown. Which compositional approach would best capture personal meaning while engaging listeners?','Personal Expression','2025-08-21 10:48:25','Meaningful composition draws from authentic experience while crafting it into universally communicative art. Personal + universal = powerful creativity.'),(72,'B','Expert','Repeat it exactly the same way every time','Transform it through inversion, augmentation, fragmentation, and tonal displacement while maintaining recognizability','Use it only once and never again','Change it so completely that it becomes unrecognizable','When developing a musical motif throughout a composition, which approach demonstrates the most sophisticated creative thinking?','Motivic Development','2025-08-21 10:48:25','Master composers create unity through infinite variation. A simple idea becomes a rich world through creative transformation techniques.'),(73,'B','Expert','Write in a single key throughout','Create music that is simultaneously consonant and dissonant through polytonality and metric displacement','Use only traditional chord progressions','Avoid any complexity or contradiction','You\'re creating a piece that explores the concept of \'musical paradox\'. Which technique would best embody this philosophical challenge?','Conceptual Composition','2025-08-21 10:48:25','Advanced creativity explores contradictions and paradoxes, pushing boundaries of what music can express and how listeners perceive sound.'),(74,'B','Expert','Ignore the theme completely','Develop musical structures that mirror environmental processes: growth, decay, cycles, and disruption','Use only pre-existing classical pieces','Focus solely on pleasant, conventional harmonies','When composing for a multimedia installation about climate change, which creative strategy would most effectively serve both artistic and communicative goals?','Programmatic Creativity','2025-08-21 10:48:25','Effective programmatic music finds musical equivalents for non-musical concepts, creating art that is both abstractly beautiful and meaningfully communicative.'),(75,'B','Expert','Copy other composers exactly without any personal input','Synthesize influences from multiple sources while developing distinctive personal expression and technical innovation','Reject all musical traditions and start completely from scratch','Use only the most popular current trends','In developing your personal compositional voice, which approach demonstrates the most mature creative thinking?','Artistic Identity','2025-08-21 10:48:25','Authentic artistic voice emerges from deep study of traditions combined with personal insight and innovative risk-taking. Creativity builds on knowledge.'),(76,'B','Expert','Give the audience complete random control with no musical structure','Create flexible frameworks where audience choices trigger meaningful musical variations within compositionally sound parameters','Let the audience only control volume','Ignore audience input completely','You\'re creating an interactive composition where the audience influences the music in real-time. Which design would maximize both musical coherence and creative participation?','Interactive Design','2025-08-21 10:48:25','Interactive creativity requires balancing freedom with structure, ensuring that participant choices lead to musically satisfying and artistically coherent results.'),(77,'B','Expert','Change everything and ignore the original culture','Research the cultural context deeply, then create arrangements that honor tradition while offering fresh interpretive perspectives','Copy it exactly without any changes','Use only the rhythm and completely change everything else','When reimagining a folk song for modern audiences while respecting its cultural origins, which approach shows the most creative and ethical thinking?','Cultural Creativity','2025-08-21 10:48:25','Ethical creativity respects sources while adding new value. Understanding tradition deeply enables more meaningful and respectful innovation.'),(83,'A','beginner','G-C-D','G-D-C','C-G-D','D-C-G','Which of the following chords is a I-IV-V progression in G major?','Chord Progressions','2025-08-28 09:12:18','In G major, the I chord is G, the IV is C, and the V is D - giving the classic G-C-D progression.');
/*!40000 ALTER TABLE `quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resource`
--

DROP TABLE IF EXISTS `resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resource` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(1000) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `upload_date` datetime(6) DEFAULT NULL,
  `uploaded_by` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `topic` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resource`
--

LOCK TABLES `resource` WRITE;
/*!40000 ALTER TABLE `resource` DISABLE KEYS */;
INSERT INTO `resource` VALUES (12,'Basic techniques for writing progressions.','How to Write Chord Progressions','2025-08-02 23:39:00.939369','admin3@example.com','https://blog.landr.com/chord-progressions/','? Music Composition'),(13,'A comprehensive guide to music theory concepts including scales, chords, and harmony.','Understanding Music Theory: The Complete Guide','2025-08-23 21:12:48.654519','admin3@example.com','https://www.iconcollective.edu/basic-music-theory','? Music Theory'),(14,'Tips and exercises to improve your melody writing skills for compositions.','Writing Better Melodies','2025-08-23 21:13:42.063276','admin3@example.com','https://www.masterclass.com/articles/how-to-write-a-melody','? Music Composition'),(15,'Step-by-step guide to arranging music for different instruments and ensembles.','How to Arrange Your Songs','2025-08-23 21:15:25.380684','admin3@example.com','https://www.artofcomposing.com/how-to-compose-music-101','? Music Composition'),(17,'Develop your ability to recognize intervals, chords, and progressions by ear.','Ear Training for Musicians','2025-08-28 17:13:39.621185','admin3@example.com','https://tonedear.com/','? Music Theory');
/*!40000 ALTER TABLE `resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKsb8bbouer5wak8vyiiy4pf2bx` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'test@example.com','123456',NULL,NULL,NULL,''),(2,'test2@example.com',NULL,NULL,NULL,NULL,''),(3,'test7@example.com','$2a$10$Jk8SpTZaS5gA0ZJjp0QbueIroxlVUGlay0MsbGN/eIDt1s1I5f7D2',NULL,NULL,NULL,''),(4,'test3@example.com','$2a$10$SRtApofTjqVdQIgt7mXQNOMsO4MX50Q2c5/s1aNc6VZP1WOP9U8vC',NULL,NULL,NULL,''),(5,'test4@example.com','$2a$10$hOs3iI.1NcrPrkb1258lh.WK7PmL20r2Zt2ye0pJjY1LFyp14ca42','2025-07-15 15:49:55.608462','USER',NULL,''),(6,'test9@example.com','$2a$10$EPg6B0exkPrVhJM0czwaFOHnTUpj1FkhI.8n33sSk9UZxxgE8zvuG','2025-07-22 22:48:26.932613','USER',NULL,''),(7,'admin@example.com','$2a$10$H5EUfp9DY7GkNJDDxJ/naus9fVYS6uMf6DQAE8Yk8H.AM1T0kbTKi','2025-07-27 14:01:32.048511','USER',NULL,''),(8,'admin1@example.com','$2a$10$/7RzAEVNY7JoXUZ69173MejAIPLDQnAIwO16di9vmck24xtvUNzY6','2025-07-27 14:06:06.778042','USER',NULL,''),(9,'admin2@example.com','$2a$10$f8aqMpP1ZyTmWWeVXSmUtu4B4k.kLMe1jYvJ3pR8QkhuHhm8R.J9y','2025-07-27 14:10:06.509204','ADMIN',NULL,''),(10,'test5@example.com','$2a$10$dSJbgFgg9B4/Y2j59OsU3eXuaRxf7dQtVRHMKMPeXvnB87M88D8n2','2025-07-27 14:12:33.306593','USER',NULL,''),(11,'admin3@example.com','$2a$10$bhbIbzh7OLVulmkb8ocNU.O/lMYxJcZJWtWBkFEsMMci3zCxHSAvy','2025-07-27 14:35:55.589524','ADMIN',NULL,''),(12,'test8@gmail.com','$2a$10$EHMDOKpO7S7exYwUnOcLQe30OSHa332Lq9CGj8GfLof5vfKyE0gua','2025-08-02 16:22:38.878092','USER',NULL,''),(13,'alice@example.com','$2a$10$c3EBl6Yd7Wn6/ICvwXLuS.KhO3iiwjZuircEQHbnwWOOzmhAxoGGW','2025-08-02 17:20:35.417929','USER',NULL,'Alice Tan'),(14,'lisa@example.com','$2a$10$IzazB9Xz4gJ5EEm1B8sLL.fLMH6G1YjK1DcOLODAqvtO9vQGKm/za','2025-08-02 17:24:52.029077','USER',NULL,'Lisa'),(15,'jennie@gmail.com','$2a$10$uIJyFBLhgRTumw1.ieFr5uzFmMg71dc22Dnf4uBdkcntGtExsLWD.','2025-08-02 17:33:54.320629','USER',NULL,'Jennie Kim'),(16,'lisa@gmail.com','$2a$10$7UBBzIj.ni9HFhGfQZUa0uman/OfsMRZAfR8ibmVHNMf2N1Cp9BES','2025-09-04 15:49:57.606114','USER',NULL,'Lisa'),(17,'rosie@example.com','$2a$10$F1bn9mAaM3.kkQ2bu.vw1u2kQguWWw2iFB0lGwE.BJL4w2/CaSu2G','2025-09-07 12:58:39.510082','USER',NULL,'Rosie'),(18,'baisheng@example.com','$2a$10$nB.bxq.ixlnOECvIPtD78uaPb91gIvB9lluAUTEAx2MfBuznrpigi','2025-09-07 13:40:58.017058','USER',NULL,'Bai Sheng'),(19,'sandy@example.com','$2a$10$5hHmDs1m35qzK3.DljGhnuf2JISVpuANWITLsNan.RE8le6YId9BK','2025-09-07 14:25:34.412913','USER',NULL,'Sandy'),(20,'lookmhe@gmail.com','$2a$10$NjfTwcFnIAdtg9baWYxpgOOEuNM8XGCWDtYGUEPmShz3tgj6.O9P.','2025-09-07 18:20:27.375235','USER',NULL,'lOOKMHE@123'),(21,'unittesting@example.com','$2a$10$UMs5PAi1lkWh5x2fLPr17O86w4UEWCLa0aoZoSRd9tO6QSvJXeVh2','2025-09-09 13:52:28.616884','USER',NULL,'unit testing'),(22,'testing@gmail.com','$2a$10$8HRNAiQHhkVo.n03xQfgZebEUiTwSbY/ITrc8cLMmZvUtcvIlsRwq','2025-09-09 16:40:05.668568','USER',NULL,'testing'),(23,'testing1@gmail.com','$2a$10$4OfF7LBJ0xHKKSa53lbQsOd0ZJ6oJ3rva77SNcAUsA/9p7uh2aUYO','2025-09-09 16:44:35.175743','USER',NULL,'Testing1'),(24,'testing3@gmail.com','$2a$10$7rVTPMMVMQ69Jc64HaPfbex1r1HO7rsGgRm208eqeUB3K8jalzgj.','2025-09-09 16:55:50.581843','USER',NULL,'Testing3');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_answers`
--

DROP TABLE IF EXISTS `user_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_answers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_correct` bit(1) DEFAULT NULL,
  `legacy_quiz_id` bigint DEFAULT NULL,
  `points_earned` int DEFAULT NULL,
  `selected_answer` varchar(255) DEFAULT NULL,
  `attempt_id` bigint NOT NULL,
  `question_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKk3y5lu72yypcj4m0d66e2yt3y` (`attempt_id`),
  KEY `FK6b46l4bb7a6wfxvmn6l7ig8vo` (`question_id`),
  CONSTRAINT `FK6b46l4bb7a6wfxvmn6l7ig8vo` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`),
  CONSTRAINT `FKk3y5lu72yypcj4m0d66e2yt3y` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_answers`
--

LOCK TABLES `user_answers` WRITE;
/*!40000 ALTER TABLE `user_answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_progress`
--

DROP TABLE IF EXISTS `user_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_progress` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `score` int NOT NULL,
  `level_name` varchar(255) DEFAULT NULL,
  `level_completed` int NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `best_score` int DEFAULT '0',
  `attempts_count` int DEFAULT '0',
  `last_attempt_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKdpcn9k9uoj0uh6eenim54gvng` (`user_id`),
  CONSTRAINT `FKdpcn9k9uoj0uh6eenim54gvng` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_progress`
--

LOCK TABLES `user_progress` WRITE;
/*!40000 ALTER TABLE `user_progress` DISABLE KEYS */;
INSERT INTO `user_progress` VALUES (2,'Jennie@gmail.com',219,'Beginner',1,15,1,195,'2025-09-09 07:00:09'),(3,NULL,0,'Advanced',0,15,0,1,'2025-08-14 06:02:39'),(4,NULL,32,'Intermediate',0,15,1,53,'2025-09-09 07:00:33'),(5,NULL,27,'Expert',0,15,1,45,'2025-09-09 06:43:55'),(6,NULL,1,'Expert',0,6,1,2,'2025-08-17 05:17:32'),(7,NULL,1,'Intermediate',0,6,1,2,'2025-08-17 05:17:44'),(8,NULL,1,'Beginner',0,6,1,1,'2025-08-17 05:17:37'),(9,NULL,5,'Beginner',0,17,1,6,'2025-09-07 05:07:02'),(10,NULL,5,'Intermediate',0,18,1,5,'2025-09-07 05:44:13'),(11,NULL,10,'Expert',0,19,1,10,'2025-09-07 06:32:20'),(12,NULL,7,'Beginner',0,20,1,16,'2025-09-07 12:29:11'),(13,NULL,10,'Expert',0,20,1,10,'2025-09-07 12:29:18'),(14,NULL,10,'Intermediate',0,20,1,12,'2025-09-07 12:29:15'),(15,NULL,4,'Beginner',0,22,1,5,'2025-09-09 08:46:29'),(16,NULL,3,'beginner',0,24,1,5,'2025-09-09 08:58:00');
/*!40000 ALTER TABLE `user_progress` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-14 22:18:32
