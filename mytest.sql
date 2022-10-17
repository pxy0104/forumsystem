-- MySQL dump 10.13  Distrib 5.7.38, for Linux (x86_64)
--
-- Host: localhost    Database: xyqas
-- ------------------------------------------------------
-- Server version	5.7.38

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
-- Table structure for table `forum`
--

DROP TABLE IF EXISTS `forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forum` (
  `forum_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '版块id',
  `forum_name` varchar(50) NOT NULL DEFAULT 'default' COMMENT '版块名',
  `forum_isDeleted` int(2) NOT NULL DEFAULT '0' COMMENT '是否删除，0-否，1-逻辑删除',
  `forum_createTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `forum_modifyTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`forum_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='版块';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forum`
--

LOCK TABLES `forum` WRITE;
/*!40000 ALTER TABLE `forum` DISABLE KEYS */;
INSERT INTO `forum` VALUES (1,'默认',0,'2020-03-04 11:48:58','2020-03-04 11:53:13'),(2,'生活',0,'2020-03-04 11:48:58','2020-03-04 11:53:13'),(3,'学习区',0,'2022-09-01 10:04:34','2022-09-01 10:04:34');
/*!40000 ALTER TABLE `forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reply` (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '回复id',
  `user_id` int(11) NOT NULL DEFAULT '0' COMMENT '回复人id',
  `tip_id` int(11) NOT NULL DEFAULT '0' COMMENT '被回复贴id',
  `reply_content` text COLLATE utf8_bin NOT NULL COMMENT '回复内容',
  `reply_publishTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '回复发表时间',
  `reply_modifyTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '回复修改时间',
  `reply_isDeleted` int(2) NOT NULL DEFAULT '0' COMMENT '是否删除，0-否，1-逻辑删除',
  PRIMARY KEY (`reply_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='回复表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
INSERT INTO `reply` VALUES (23,1,12,'欢迎你','2022-09-01 10:15:03','2022-09-01 10:15:03',0),(24,1,11,'没问题','2022-09-01 10:15:13','2022-09-01 10:15:13',0),(25,1,13,'OK！','2022-09-01 10:15:23','2022-09-01 10:15:23',0),(26,7,14,'222333','2022-09-01 10:42:08','2022-09-01 10:42:08',0);
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tab`
--

DROP TABLE IF EXISTS `tab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tab` (
  `tab_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `tab_name` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT 'default' COMMENT '分类名',
  `forum_id` int(11) NOT NULL DEFAULT '1' COMMENT '版块id',
  `tab_isDeleted` int(2) NOT NULL DEFAULT '0' COMMENT '是否删除，0-否，1-逻辑删除',
  `tab_createTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tab_modifyTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`tab_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tab`
--

LOCK TABLES `tab` WRITE;
/*!40000 ALTER TABLE `tab` DISABLE KEYS */;
INSERT INTO `tab` VALUES (1,'Technology',1,0,'2022-08-30 11:49:43','2022-08-30 11:49:43'),(2,'其他',1,0,'2022-08-30 11:49:43','2022-08-30 11:49:43'),(3,'Life',2,0,'2022-08-30 11:49:43','2022-08-30 11:49:43'),(4,'美食',2,0,'2022-09-01 10:04:58','2022-09-01 10:04:58');
/*!40000 ALTER TABLE `tab` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tip`
--

DROP TABLE IF EXISTS `tip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tip` (
  `tip_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '贴子id',
  `user_id` int(11) NOT NULL COMMENT '楼主id',
  `tab_id` int(11) NOT NULL COMMENT '分类id',
  `tip_title` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '标题',
  `tip_content` text COLLATE utf8_bin COMMENT '内容',
  `tip_publishTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发表时间',
  `tip_modifyTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `tip_click` int(11) NOT NULL DEFAULT '0' COMMENT '贴子点击量',
  `tip_isDeleted` int(2) NOT NULL DEFAULT '0' COMMENT '是否逻辑删除，0否，1是',
  `tip_isKnot` int(2) NOT NULL DEFAULT '0' COMMENT '是否结贴，0否，1结贴',
  `tip_replies` int(11) NOT NULL DEFAULT '0' COMMENT '贴子回复数',
  `tip_isTop` int(2) NOT NULL DEFAULT '0' COMMENT '是否置顶，0-否，1-是',
  `tip_topTime` datetime DEFAULT NULL COMMENT '置顶时间',
  PRIMARY KEY (`tip_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='贴子';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tip`
--

LOCK TABLES `tip` WRITE;
/*!40000 ALTER TABLE `tip` DISABLE KEYS */;
INSERT INTO `tip` VALUES (1,1,1,'大学生交流文坛的第一个贴子','这是第一个贴子，测试发贴功能成功！','2022-08-30 11:49:43','2022-09-01 10:18:16',79,1,0,4,0,'2022-09-01 09:57:33'),(11,1,2,'测试正文为空',NULL,'2022-09-01 10:04:14','2022-09-01 10:15:13',2,0,0,1,0,NULL),(12,7,3,'新任管理员','我是wzx','2022-09-01 10:06:49','2022-09-01 10:15:03',4,0,0,1,0,NULL),(13,3,2,'我是新人','I\'m a new man!','2022-09-01 10:08:24','2022-09-01 10:15:23',3,0,0,1,0,NULL),(14,1,2,'1111','2222','2022-09-01 10:41:48','2022-09-01 10:42:08',3,0,0,1,0,NULL),(15,3,4,'USER的新帖','第一条帖子！！！','2022-09-04 15:24:38','2022-09-04 15:24:38',4,0,1,0,0,NULL);
/*!40000 ALTER TABLE `tip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `user_nick` varchar(50) DEFAULT NULL COMMENT '用户昵称',
  `user_password` varchar(20) NOT NULL DEFAULT '123456' COMMENT '密码',
  `user_status` int(2) NOT NULL DEFAULT '0' COMMENT '状态，0正常，1禁用，2锁定',
  `user_type` int(2) NOT NULL DEFAULT '2' COMMENT '用户类型，0超级管理员，1，管理员，2普通用户',
  `user_regTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `user_lastLoginTime` datetime DEFAULT NULL COMMENT '最近登录时间',
  `user_modifyTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'pxy','pxy','123456',0,0,NULL,'2022-09-04 15:55:36','2022-09-01 09:50:50'),(2,'admin','admin','123456',0,1,NULL,'2022-09-01 09:50:50','2022-09-01 09:50:50'),(3,'user','user','123456',0,2,NULL,'2022-09-04 15:24:17','2022-09-01 09:50:50'),(7,'wzx','wzx','123456',0,1,'2022-09-01 10:05:52','2022-09-04 15:23:13','2022-09-01 10:05:52');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-04 16:28:31
