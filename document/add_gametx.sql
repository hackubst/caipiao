/*
Navicat MySQL Data Transfer

Source Server         : 47.75.222.46(hk_test)
Source Server Version : 50642
Source Host           : 47.75.222.46:3306
Source Database       : kdy28

Target Server Type    : MYSQL
Target Server Version : 50642
File Encoding         : 65001

Date: 2019-02-09 21:33:27
*/

USE `kdy28`;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for gametx11
-- ----------------------------
DROP TABLE IF EXISTS `gametx11`;
CREATE TABLE `gametx11` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(512) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注分',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢分',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯11投注统计';

-- ----------------------------
-- Table structure for gametx11_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx11_auto`;
CREATE TABLE `gametx11_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯11自动投注';

-- ----------------------------
-- Table structure for gametx11_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx11_auto_tz`;
CREATE TABLE `gametx11_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯11自动投注';

-- ----------------------------
-- Table structure for gametx11_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx11_kg_users_tz`;
CREATE TABLE `gametx11_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametx11_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametx11_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯11预投注';

-- ----------------------------
-- Table structure for gametx11_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx11_users_tz`;
CREATE TABLE `gametx11_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` decimal(10,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametx11_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯11投注记录';

-- ----------------------------
-- Table structure for gametx16
-- ----------------------------
DROP TABLE IF EXISTS `gametx16`;
CREATE TABLE `gametx16` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(512) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注分',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢分',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯16投注统计';

-- ----------------------------
-- Table structure for gametx16_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx16_auto`;
CREATE TABLE `gametx16_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯16自动投注';

-- ----------------------------
-- Table structure for gametx16_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx16_auto_tz`;
CREATE TABLE `gametx16_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯16自动投注';

-- ----------------------------
-- Table structure for gametx16_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx16_kg_users_tz`;
CREATE TABLE `gametx16_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametx16_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametx16_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯16预投注';

-- ----------------------------
-- Table structure for gametx16_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx16_users_tz`;
CREATE TABLE `gametx16_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` decimal(10,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametx16_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯16投注记录';

-- ----------------------------
-- Table structure for gametx28
-- ----------------------------
DROP TABLE IF EXISTS `gametx28`;
CREATE TABLE `gametx28` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(512) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注分',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢分',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28投注统计';

-- ----------------------------
-- Table structure for gametx28_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx28_auto`;
CREATE TABLE `gametx28_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28自动投注';

-- ----------------------------
-- Table structure for gametx28_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28_auto_tz`;
CREATE TABLE `gametx28_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28自动投注';

-- ----------------------------
-- Table structure for gametx28_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28_kg_users_tz`;
CREATE TABLE `gametx28_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametx28_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametx28_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28预投注';

-- ----------------------------
-- Table structure for gametx28_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28_users_tz`;
CREATE TABLE `gametx28_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` decimal(10,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametx28_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28投注记录';

-- ----------------------------
-- Table structure for gametx28gd
-- ----------------------------
DROP TABLE IF EXISTS `gametx28gd`;
CREATE TABLE `gametx28gd` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(512) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注分',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢分',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28固定投注统计';

-- ----------------------------
-- Table structure for gametx28gd_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx28gd_auto`;
CREATE TABLE `gametx28gd_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28固定自动投注';

-- ----------------------------
-- Table structure for gametx28gd_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28gd_auto_tz`;
CREATE TABLE `gametx28gd_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28固定自动投注';

-- ----------------------------
-- Table structure for gametx28gd_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28gd_kg_users_tz`;
CREATE TABLE `gametx28gd_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametx28gd_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametx28gd_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28固定预投注';

-- ----------------------------
-- Table structure for gametx28gd_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx28gd_users_tz`;
CREATE TABLE `gametx28gd_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` decimal(10,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametx28gd_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯28固定投注记录';

-- ----------------------------
-- Table structure for gametx36
-- ----------------------------
DROP TABLE IF EXISTS `gametx36`;
CREATE TABLE `gametx36` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(512) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注分',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢分',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯36投注统计';

-- ----------------------------
-- Table structure for gametx36_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx36_auto`;
CREATE TABLE `gametx36_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯36自动投注';

-- ----------------------------
-- Table structure for gametx36_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx36_auto_tz`;
CREATE TABLE `gametx36_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯36自动投注';

-- ----------------------------
-- Table structure for gametx36_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx36_kg_users_tz`;
CREATE TABLE `gametx36_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametx36_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametx36_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯36预投注';

-- ----------------------------
-- Table structure for gametx36_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametx36_users_tz`;
CREATE TABLE `gametx36_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` decimal(10,4) NOT NULL DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametx36_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯36投注记录';

-- ----------------------------
-- Table structure for gametxdw
-- ----------------------------
DROP TABLE IF EXISTS `gametxdw`;
CREATE TABLE `gametxdw` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `pre_kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '预开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(2000) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注总数',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢总数',
  `take_time_remark` varchar(250) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txdw投注统计';

-- ----------------------------
-- Table structure for gametxdw_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametxdw_auto`;
CREATE TABLE `gametxdw_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txdw自动投注';

-- ----------------------------
-- Table structure for gametxdw_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxdw_auto_tz`;
CREATE TABLE `gametxdw_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(2000) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(2000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txdw自动投注';

-- ----------------------------
-- Table structure for gametxdw_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxdw_kg_users_tz`;
CREATE TABLE `gametxdw_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametxdw_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametxdw_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txdw预投注';

-- ----------------------------
-- Table structure for gametxdw_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxdw_users_tz`;
CREATE TABLE `gametxdw_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` varchar(2000) DEFAULT '' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametxdw_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txdw投注记录';

-- ----------------------------
-- Table structure for gametxww
-- ----------------------------
DROP TABLE IF EXISTS `gametxww`;
CREATE TABLE `gametxww` (
  `id` int(11) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `pre_kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '预开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(2000) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` int(11) NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注总数',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢总数',
  `take_time_remark` varchar(250) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txww投注统计';

-- ----------------------------
-- Table structure for gametxww_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametxww_auto`;
CREATE TABLE `gametxww_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txww自动投注';

-- ----------------------------
-- Table structure for gametxww_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxww_auto_tz`;
CREATE TABLE `gametxww_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txww自动投注';

-- ----------------------------
-- Table structure for gametxww_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxww_kg_users_tz`;
CREATE TABLE `gametxww_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` int(11) NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametxww_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametxww_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txww预投注';

-- ----------------------------
-- Table structure for gametxww_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxww_users_tz`;
CREATE TABLE `gametxww_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) DEFAULT NULL COMMENT '期号',
  `tznum` varchar(2000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(2000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(2000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` varchar(2000) DEFAULT '' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametxww_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='txww投注记录';
DROP TRIGGER IF EXISTS `gametx11_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametx11_users_tz` BEFORE UPDATE ON `gametx11_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,20,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametx16_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametx16_users_tz` BEFORE UPDATE ON `gametx16_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,19,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametx28_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametx28_users_tz` BEFORE UPDATE ON `gametx28_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,18,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametx28gd_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametx28gd_users_tz` BEFORE UPDATE ON `gametx28gd_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,34,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametx36_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametx36_users_tz` BEFORE UPDATE ON `gametx36_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,21,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametxdw_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametxdw_users_tz` BEFORE UPDATE ON `gametxdw_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,31,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `gametxww_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametxww_users_tz` BEFORE UPDATE ON `gametxww_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,30,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Table structure for gametxffc
-- ----------------------------
DROP TABLE IF EXISTS `gametxffc`;
CREATE TABLE `gametxffc` (
  `id` bigint(20) unsigned NOT NULL COMMENT 'ID',
  `kgtime` datetime NOT NULL COMMENT '开奖时间',
  `kgjg` varchar(255) NOT NULL DEFAULT '' COMMENT '开奖结果',
  `kj` int(11) NOT NULL DEFAULT '0' COMMENT '已开奖？',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(11) NOT NULL DEFAULT '0' COMMENT '投注总额',
  `zjpl` varchar(2000) NOT NULL DEFAULT '' COMMENT '中奖赔率',
  `zjrnum` int(11) NOT NULL DEFAULT '0' COMMENT '中奖人数',
  `gfid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '官方期号',
  `kgNo` varchar(512) NOT NULL DEFAULT '' COMMENT '官方开奖号码',
  `kgsort` varchar(255) DEFAULT '' COMMENT '官方号码排序后结果',
  `zdtz` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注用户数',
  `zdtz_r` int(11) NOT NULL DEFAULT '0' COMMENT '自动投注机器数',
  `zdtz_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注用户总分',
  `zdtz_rpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '自动投注机器总分',
  `sdtz` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注人数',
  `sdtz_points` int(11) NOT NULL DEFAULT '0' COMMENT '手动投注总分',
  `game_tax` bigint(20) NOT NULL DEFAULT '0' COMMENT '邮箱抽税',
  `user_tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户投注总数',
  `user_winpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户输赢总数',
  `take_time_remark` varchar(150) NOT NULL DEFAULT '' COMMENT '耗时描述',
  PRIMARY KEY (`id`),
  KEY `kj` (`kj`) USING BTREE,
  KEY `zjpl` (`zjpl`(255)) USING BTREE,
  KEY `zjrnum` (`zjrnum`) USING BTREE,
  KEY `kgtime` (`kgtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯分分彩投注统计';

-- ----------------------------
-- Table structure for gametxffc_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametxffc_auto`;
CREATE TABLE `gametxffc_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯分分彩自动投注';

-- ----------------------------
-- Table structure for gametxffc_auto_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxffc_auto_tz`;
CREATE TABLE `gametxffc_auto_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `tzname` varchar(255) DEFAULT NULL COMMENT '投注名称',
  `tzunm` varchar(255) DEFAULT '' COMMENT '投注号与豆豆',
  `tzpoints` int(11) DEFAULT '0' COMMENT '投注额',
  `tznum` varchar(1000) DEFAULT '' COMMENT '投注数字与金额，格式：号码,金额|号码,金额',
  `tzid` int(11) DEFAULT NULL COMMENT '投注id',
  `winid` int(11) DEFAULT '0' COMMENT '赢ID',
  `lossid` int(11) DEFAULT '0' COMMENT '输ID',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯分分彩自动投注';

-- ----------------------------
-- Table structure for gametxffc_kg_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxffc_kg_users_tz`;
CREATE TABLE `gametxffc_kg_users_tz` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `NO` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '期号',
  `tznum` int(11) NOT NULL DEFAULT '0' COMMENT '投注号码',
  `tzpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '投注额',
  `time` datetime NOT NULL COMMENT '投注时间',
  `hdpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '获得数',
  `usertype` int(11) NOT NULL DEFAULT '0' COMMENT '用户类型，0-真人，1-机器',
  `zjpl` decimal(15,4) unsigned NOT NULL DEFAULT '0.0000' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_gametxffc_users_tz_uid_no_tznum` (`uid`,`NO`,`tznum`) USING BTREE,
  KEY `gametxffc_kg_users_tz_no` (`NO`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯分分彩预投注';

-- ----------------------------
-- Table structure for gametxffc_users_tz
-- ----------------------------
DROP TABLE IF EXISTS `gametxffc_users_tz`;
CREATE TABLE `gametxffc_users_tz` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `NO` int(11) unsigned DEFAULT NULL COMMENT '期号',
  `tznum` varchar(4000) DEFAULT NULL COMMENT '投注号码',
  `tzpoints` varchar(4000) DEFAULT NULL COMMENT '投注明细',
  `zjpoints` varchar(4000) DEFAULT NULL COMMENT '中奖明细',
  `time` datetime DEFAULT NULL COMMENT '投注时间',
  `points` bigint(20) DEFAULT '0' COMMENT '投入总豆',
  `hdpoints` bigint(20) DEFAULT '0' COMMENT '获得总豆',
  `zjpl` varchar(4000) DEFAULT '' COMMENT '中奖赔率',
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`NO`,`hdpoints`) USING BTREE,
  KEY `gametxffc_users_tz_no` (`NO`) USING BTREE,
  KEY `time` (`time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='腾讯分分彩投注记录';
DROP TRIGGER IF EXISTS `gametxffc_users_tz`;
DELIMITER ;;
CREATE TRIGGER `gametxffc_users_tz` BEFORE UPDATE ON `gametxffc_users_tz` FOR EACH ROW BEGIN
IF old.tznum!=new.tznum || old.tzpoints!=new.tzpoints THEN
INSERT update_tz (gid,tid,uid,NO,tznum,tzpoints,otznum,otzpoints,qf,tz_time,up_time) VALUES (old.id,49,old.uid,old.NO,new.tznum,new.tzpoints,old.tznum,old.tzpoints,2,old.time,NOW());
END IF;
END
;;
DELIMITER ;


-- ----------------------------
-- Table structure for game_config
-- ----------------------------
DROP TABLE IF EXISTS `game_config`;
CREATE TABLE `game_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `game_type` int(11) NOT NULL DEFAULT '0' COMMENT '游戏类型',
  `game_name` varchar(30) NOT NULL DEFAULT '' COMMENT '游戏名称',
  `game_table_prefix` varchar(100) NOT NULL DEFAULT '' COMMENT '游戏表前缀',
  `game_go_samples` int(11) NOT NULL DEFAULT '0' COMMENT '抽取投注万分比',
  `game_tz_exp` int(11) NOT NULL DEFAULT '0' COMMENT '奖励经验投注下限',
  `game_jl_exp` int(11) NOT NULL DEFAULT '0' COMMENT '奖励经验',
  `game_jl_maxexp` int(11) NOT NULL DEFAULT '0' COMMENT '奖励经验上限',
  `game_jl_exp_vip` int(11) NOT NULL DEFAULT '0' COMMENT 'vip奖励经验',
  `game_jl_maxexp_vip` int(11) NOT NULL DEFAULT '240' COMMENT 'vip奖励经验上限',
  `game_press_min` int(11) NOT NULL DEFAULT '10' COMMENT '最小投注',
  `game_press_max` int(11) NOT NULL DEFAULT '3000000' COMMENT '最大投注',
  `game_std_odds` varchar(2000) NOT NULL DEFAULT '' COMMENT '标准赔率，以|分隔',
  `game_std_press` varchar(2000) NOT NULL DEFAULT '' COMMENT '标准投注额，以|分隔',
  `game_kj_delay` int(11) NOT NULL DEFAULT '60' COMMENT '开奖延迟，秒',
  `game_tz_close` int(11) NOT NULL DEFAULT '80' COMMENT '投注截止，秒',
  `game_sys_win_min` int(11) NOT NULL DEFAULT '0' COMMENT '系统每天赢下限',
  `game_sys_win_max` int(11) NOT NULL DEFAULT '0' COMMENT '系统每天赢上限',
  `game_sys_win_odds` int(11) NOT NULL DEFAULT '60' COMMENT '系统赢概率，1-100',
  `game_open_flag` int(11) NOT NULL DEFAULT '0' COMMENT '是否开最小下注数字，0：否，1：是',
  `game_noopen_num` int(11) NOT NULL DEFAULT '6' COMMENT '不允许开奖下注最多的号码数',
  `game_model` varchar(2000) NOT NULL DEFAULT '' COMMENT '模式',
  `state` int(11) NOT NULL DEFAULT '1' COMMENT '状态，1：可用，0：不可用',
  `isstop` int(11) NOT NULL DEFAULT '0' COMMENT '是否停止，0：否，1：停止',
  `stop_msg` varchar(100) NOT NULL DEFAULT '' COMMENT '停止原因',
  `reward_num` int(11) NOT NULL DEFAULT '0' COMMENT '可下注号码个数',
  `ordernum` int(11) NOT NULL DEFAULT '0' COMMENT '排序，越大越靠前',
  PRIMARY KEY (`id`),
  KEY `game_config_type` (`game_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COMMENT='游戏配置表';

-- ----------------------------
-- Records of game_config
-- ----------------------------
INSERT INTO `game_config` VALUES ('1', '0', '幸运28', 'gamefast28', '120', '1000', '2', '2000', '3', '3000', '1000', '20000000', '1000.00|333.33|166.67|100.00|66.66|47.61|35.71|27.77|22.22|18.18|15.87|14.49|13.69|13.33|13.33|13.69|14.49|15.87|18.18|22.22|27.77|35.71|47.61|66.66|100.00|166.66|333.33|1000.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '5', '5', '90000000', '900000000', '10', '0', '18', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '28', '2');
INSERT INTO `game_config` VALUES ('2', '1', '幸运16', 'gamefast16', '120', '100', '2', '120', '4', '240', '1000', '20000000', '216.00|72.00|36.00|21.60|14.40|10.29|8.64|8.00|8.00|8.64|10.29|14.40|21.60|36.00|72.00|216.00', '1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1', '5', '5', '90000000', '900000000', '25', '0', '12', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '16', '3');
INSERT INTO `game_config` VALUES ('3', '2', '幸运11', 'gamefast11', '120', '100', '2', '120', '4', '240', '1000', '20000000', '36.00|18.00|12.00|9.00|7.20|6.00|7.20|9.00|12.00|18.00|36.00', '10,20,30,40,50,60,50,40,30,20,10', '5', '5', '90000000', '900000000', '20', '0', '9', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '11', '0');
INSERT INTO `game_config` VALUES ('4', '3', '蛋蛋28', 'game28', '120', '100', '2', '120', '4', '240', '1000', '50000000', '1000.00|333.33|166.67|100.00|66.66|47.61|35.71|27.77|22.22|18.18|15.87|14.49|13.69|13.33|13.33|13.69|14.49|15.87|18.18|22.22|27.77|35.71|47.61|66.66|100.00|166.66|333.33|1000.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '20', '40', '0', '0', '60', '1', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '28', '4');
INSERT INTO `game_config` VALUES ('5', '4', '北京28', 'gameself28', '120', '100', '2', '120', '4', '240', '1000', '50000000', '1000.00|333.33|166.67|100.00|66.66|47.61|35.71|27.77|22.22|18.18|15.87|14.49|13.69|13.33|13.33|13.69|14.49|15.87|18.18|22.22|27.77|35.71|47.61|66.66|100.00|166.66|333.33|1000.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '20', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '28', '6');
INSERT INTO `game_config` VALUES ('6', '5', '北京16', 'gamebj16', '120', '100', '2', '120', '4', '240', '1000', '50000000', '216.00|72.00|36.00|21.60|14.40|10.29|8.64|8.00|8.00|8.64|10.29|14.40|21.60|36.00|72.00|216.00', '1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1', '20', '40', '0', '0', '60', '1', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '16', '7');
INSERT INTO `game_config` VALUES ('7', '6', 'PK10', 'gamepk10', '120', '100', '2', '120', '4', '240', '1000', '50000000', '10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00', '10,10,10,10,10,10,10,10,10,10', '30', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '10', '13');
INSERT INTO `game_config` VALUES ('8', '7', 'PK冠军', 'gamegj10', '120', '100', '2', '120', '4', '240', '1000', '50000000', '10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00', '10,10,10,10,10,10,10,10,10,10', '30', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '10', '15');
INSERT INTO `game_config` VALUES ('9', '8', '加拿大28', 'gamecan28', '120', '100', '2', '120', '4', '240', '1000', '50000000', '1000.00|333.33|166.67|100.00|66.66|47.61|35.71|27.77|22.22|18.18|15.87|14.49|13.69|13.33|13.33|13.69|14.49|15.87|18.18|22.22|27.77|35.71|47.61|66.66|100.00|166.66|333.33|1000.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '15', '40', '0', '0', '60', '1', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '28', '9');
INSERT INTO `game_config` VALUES ('10', '9', '加拿大16', 'gamecan16', '120', '100', '2', '120', '4', '240', '1000', '50000000', '216.00|72.00|36.00|21.60|14.40|10.29|8.64|8.00|8.00|8.64|10.29|14.40|21.60|36.00|72.00|216.00', '1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1', '15', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '16', '10');
INSERT INTO `game_config` VALUES ('11', '10', '加拿大11', 'gamecan11', '120', '100', '2', '120', '4', '240', '1000', '50000000', '36.00|18.00|12.00|9.00|7.20|6.00|7.20|9.00|12.00|18.00|36.00', '10,20,30,40,50,60,50,40,30,20,10', '15', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '11', '11');
INSERT INTO `game_config` VALUES ('12', '11', '蛋蛋36', 'game36', '120', '100', '2', '120', '4', '240', '1000', '50000000', '100.00|3.70|16.67|2.78|3.33', '10,270,60,360,300', '20', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '5', '5');
INSERT INTO `game_config` VALUES ('13', '12', '北京36', 'gamebj36', '120', '100', '2', '120', '4', '240', '1000', '50000000', '100.00|3.70|16.67|2.78|3.33', '10,270,60,360,300', '20', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '5', '8');
INSERT INTO `game_config` VALUES ('14', '13', '加拿大36', 'gamecan36', '120', '100', '2', '120', '4', '240', '1000', '50000000', '100.00|3.70|16.67|2.78|3.33', '10,270,60,360,300', '15', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '5', '12');
INSERT INTO `game_config` VALUES ('15', '14', 'PK22', 'gamepk22', '120', '100', '2', '120', '4', '240', '1000', '50000000', '119.00|119.00|59.00|39.00|29.00|23.00|17.00|14.00|13.00|11.00|11.00|11.00|11.00|13.00|14.00|17.00|23.00|29.00|39.00|59.00|119.00|119.00', '10,10,20,30,40,50,70,80,90,100,100,100,100,90,80,70,50,40,30,20,10,10', '30', '40', '0', '0', '60', '1', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '22', '14');
INSERT INTO `game_config` VALUES ('16', '15', '幸运10', 'gamefast10', '120', '100', '2', '2000', '3', '3000', '1000', '20000000', '10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00', '10,10,10,10,10,10,10,10,10,10', '5', '5', '90000000', '900000000', '25', '0', '8', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '10', '1');
INSERT INTO `game_config` VALUES ('17', '16', 'PK龙虎', 'gamepklh', '120', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|2.00', '50,50', '30', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '2', '16');
INSERT INTO `game_config` VALUES ('18', '17', 'PK冠亚军', 'gamepkgyj', '120', '100', '2', '120', '4', '240', '1000', '50000000', '44.99|45.00|22.49|22.50|14.99|15.00|11.24|11.25|8.99|11.25|11.24|15.00|14.99|22.50|22.49|45.00|44.99', '2,2,4,4,6,6,8,8,10,8,8,6,6,4,4,2,2', '30', '40', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '17', '17');
INSERT INTO `game_config` VALUES ('19', '18', '腾讯28', 'gametx28', '120', '100', '2', '120', '4', '240', '1000', '50000000', '1000.00|333.33|166.67|100.00|66.66|47.61|35.71|27.77|22.22|18.18|15.87|14.49|13.69|13.33|13.33|13.69|14.49|15.87|18.18|22.22|27.77|35.71|47.61|66.66|100.00|166.66|333.33|1000.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '10', '5', '0', '0', '60', '1', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '28', '18');
INSERT INTO `game_config` VALUES ('20', '19', '腾讯16', 'gametx16', '120', '100', '2', '120', '4', '240', '1000', '50000000', '216.00|72.00|36.00|21.60|14.40|10.29|8.64|8.00|8.00|8.64|10.29|14.40|21.60|36.00|72.00|216.00', '1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1', '10', '5', '0', '0', '60', '0', '1', '', '1', '0', '游戏维护中', '16', '19');
INSERT INTO `game_config` VALUES ('21', '20', '腾讯11', 'gametx11', '120', '100', '2', '120', '4', '240', '1000', '50000000', '36.00|18.00|12.00|9.00|7.20|6.00|7.20|9.00|12.00|18.00|36.00', '10,20,30,40,50,60,50,40,30,20,10', '10', '5', '0', '0', '60', '1', '6', '', '1', '0', '游戏维护中', '11', '20');
INSERT INTO `game_config` VALUES ('22', '21', '腾讯36', 'gametx36', '120', '100', '2', '120', '4', '240', '1000', '50000000', '100.00|3.70|16.67|2.78|3.33', '10,270,60,360,300', '10', '5', '0', '0', '60', '1', '6', '', '1', '0', '游戏维护中', '5', '21');
INSERT INTO `game_config` VALUES ('23', '22', '幸运22', 'gamefast22', '120', '100', '2', '2000', '3', '3000', '1000', '20000000', '119.00|119.00|59.00|39.00|29.00|23.00|17.00|14.00|13.00|11.00|11.00|11.00|11.00|13.00|14.00|17.00|23.00|29.00|39.00|59.00|119.00|119.00', '10,10,20,30,40,50,70,80,90,100,100,100,100,90,80,70,50,40,30,20,10,10', '5', '5', '90000000', '900000000', '25', '0', '18', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '22', '0');
INSERT INTO `game_config` VALUES ('24', '23', '幸运36', 'gamefast36', '120', '100', '2', '2000', '4', '3000', '1000', '20000000', '100.00|3.70|16.67|2.78|3.33', '10,270,60,360,300', '5', '5', '90000000', '900000000', '5', '0', '4', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '5', '0');
INSERT INTO `game_config` VALUES ('25', '24', '幸运冠亚军', 'gamefastgyj', '120', '100', '2', '2000', '4', '3000', '1000', '20000000', '44.99|45.00|22.49|22.50|14.99|15.00|11.24|11.25|8.99|11.25|11.24|15.00|14.99|22.50|22.49|45.00|44.99', '2,2,4,4,6,6,8,8,10,8,8,6,6,4,4,2,2', '5', '5', '90000000', '900000000', '35', '0', '13', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '0', '游戏维护中', '17', '0');
INSERT INTO `game_config` VALUES ('26', '25', '蛋蛋外围', 'gameww', '0', '100', '2', '120', '4', '240', '1000', '50000000', '2.10|2.10|4.60|4.20|17.00|2.10|2.10|4.20|4.60|17.00|2.90|2.90|2.90', '476,476,215,235,58,476,476,235,215,58,344,344,344', '20', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,豹', '1', '0', '游戏维护中', '13', '0');
INSERT INTO `game_config` VALUES ('27', '26', '蛋蛋定位', 'gamedw', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|1.98|3.68|4.2|16|1.98|1.98|4.2|3.68|16|1.98|1.98|8|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9', '505,505,271,238,62,505,505,238,271,62,505,505,125,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101', '20', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9', '1', '0', '游戏维护中', '55', '0');
INSERT INTO `game_config` VALUES ('28', '27', '加拿大外围', 'gamecanww', '0', '100', '2', '120', '4', '240', '1000', '50000000', '2.10|2.10|4.60|4.20|17.00|2.10|2.10|4.20|4.60|17.00|2.90|2.90|2.90', '476,476,215,235,58,476,476,235,215,58,344,344,344', '15', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,豹', '1', '0', '游戏维护中', '13', '0');
INSERT INTO `game_config` VALUES ('29', '28', '加拿大定位', 'gamecandw', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|1.98|3.68|4.2|16|1.98|1.98|4.2|3.68|16|1.98|1.98|8|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9', '505,505,271,238,62,505,505,238,271,62,505,505,125,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101', '15', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9', '1', '0', '游戏维护中', '55', '0');
INSERT INTO `game_config` VALUES ('30', '29', 'PK赛车', 'gamepksc', '0', '100', '2', '120', '4', '240', '1000', '50000000', '40.00|40.00|20.00|20.00|13.00|13.00|10.00|10.00|9.00|10.00|10.00|13.00|13.00|20.00|20.00|40.00|40.00|2.186|1.786|1.786|2.186|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|9.85|1.97|1.97|1.97|1.97|1.97|1.97|1.97|1.97|1.97|1.97', '25,25,50,50,76,76,100,100,111,100,100,76,76,50,50,25,25,457,600,600,457,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,100,100,100,100,100,100,100,100,100,100,503,503,503,503,503,503,503,503,503,503', '30', '40', '0', '0', '60', '0', '6', '3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,大,小,单,双,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,大,小,单,双,1,2,3,4,5,6,7,8,9,10,龙,虎,龙,虎,龙,虎,龙,虎,龙,虎', '1', '0', '游戏维护中', '171', '0');
INSERT INTO `game_config` VALUES ('31', '30', '腾讯外围', 'gametxww', '0', '100', '2', '120', '4', '240', '1000', '50000000', '2.05|2.05|4.55|4.15|16.00|2.05|2.05|4.15|4.55|16.00|2.85|2.85|2.85', '476,476,215,235,58,476,476,235,215,58,350,350,350', '10', '5', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,豹', '1', '0', '游戏维护中', '13', '0');
INSERT INTO `game_config` VALUES ('32', '31', '腾讯定位', 'gametxdw', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|1.98|3.68|4.2|16|1.98|1.98|4.2|3.68|16|1.98|1.98|8|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9', '505,505,271,238,62,505,505,238,271,62,505,505,125,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101', '10', '5', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9', '1', '0', '游戏维护中', '55', '0');
INSERT INTO `game_config` VALUES ('33', '32', '蛋蛋28固定', 'game28gd', '0', '100', '2', '120', '4', '240', '1000', '50000000', '986.00|328.6633|164.3366|98.60|65.7267|46.9434|35.2100|27.3812|21.9089|17.9254|15.6478|14.2871|13.4983|13.1433|13.1433|13.4983|14.2871|15.6478|17.9254|21.9089|27.3812|35.2100|46.9434|65.7267|98.60|164.3366|328.6633|986.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '20', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '28', '0');
INSERT INTO `game_config` VALUES ('34', '33', '北京28固定', 'gamebj28gd', '0', '100', '2', '120', '4', '240', '1000', '50000000', '986.00|328.6633|164.3366|98.60|65.7267|46.9434|35.2100|27.3812|21.9089|17.9254|15.6478|14.2871|13.4983|13.1433|13.1433|13.4983|14.2871|15.6478|17.9254|21.9089|27.3812|35.2100|46.9434|65.7267|98.60|164.3366|328.6633|986.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '20', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '28', '0');
INSERT INTO `game_config` VALUES ('35', '34', '腾讯28固定', 'gametx28gd', '0', '100', '2', '120', '4', '240', '1000', '50000000', '986.00|328.6633|164.3366|98.60|65.7267|46.9434|35.2100|27.3812|21.9089|17.9254|15.6478|14.2871|13.4983|13.1433|13.1433|13.4983|14.2871|15.6478|17.9254|21.9089|27.3812|35.2100|46.9434|65.7267|98.60|164.3366|328.6633|986.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '10', '5', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '28', '0');
INSERT INTO `game_config` VALUES ('36', '35', '加拿大28固定', 'gamecan28gd', '0', '100', '2', '120', '4', '240', '1000', '50000000', '986.00|328.6633|164.3366|98.60|65.7267|46.9434|35.2100|27.3812|21.9089|17.9254|15.6478|14.2871|13.4983|13.1433|13.1433|13.4983|14.2871|15.6478|17.9254|21.9089|27.3812|35.2100|46.9434|65.7267|98.60|164.3366|328.6633|986.00', '1,3,6,10,15,21,28,36,45,55,63,69,73,75,75,73,69,63,55,45,36,28,21,15,10,6,3,1', '15', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '28', '0');
INSERT INTO `game_config` VALUES ('37', '36', '幸运农场', 'gamexync', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|1.98|1.98|1.98|1.98|1.98|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|19.8|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98|3.95|3.95|3.95|3.95|1.98|1.98|1.98|1.98|1.98|1.98|1.98|1.98', '10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10', '90', '50', '0', '0', '60', '0', '6', '大,小,单,双,尾大,尾小,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,大,双,尾大,合双,小,单,尾小,合单,东,南,西,北,龙,虎,龙,虎,龙,虎,龙,虎', '1', '1', '游戏维护中', '270', '0');
INSERT INTO `game_config` VALUES ('38', '37', '重庆时时彩', 'gamecqssc', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.97|1.97|1.97|1.97|1.97|1.97|9.1|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|69.0|2.8|13.0|2.0|2.3|69.0|2.8|13.0|2.0|2.3|69.0|2.8|13.0|2.0|2.3', '10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10', '40', '50', '0', '0', '60', '0', '6', '大,小,单,双,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,豹,对,顺,半,杂,豹,对,顺,半,杂,豹,对,顺,半,杂', '1', '1', '游戏维护中', '92', '0');
INSERT INTO `game_config` VALUES ('39', '38', '北京11', 'gamebj11', '120', '100', '2', '120', '4', '240', '1000', '50000000', '36.00|18.00|12.00|9.00|7.20|6.00|7.20|9.00|12.00|18.00|36.00', '10,20,30,40,50,60,50,40,30,20,10', '20', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '11', '0');
INSERT INTO `game_config` VALUES ('40', '39', '蛋蛋11', 'game11', '120', '100', '2', '120', '4', '240', '1000', '50000000', '36.00|18.00|12.00|9.00|7.20|6.00|7.20|9.00|12.00|18.00|36.00', '10,20,30,40,50,60,50,40,30,20,10', '20', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '11', '0');
INSERT INTO `game_config` VALUES ('41', '40', '蛋蛋16', 'game16', '120', '100', '2', '120', '4', '240', '1000', '50000000', '216.00|72.00|36.00|21.60|14.40|10.29|8.64|8.00|8.00|8.64|10.29|14.40|21.60|36.00|72.00|216.00', '1,3,6,10,15,21,25,27,27,25,21,15,10,6,3,1', '20', '40', '0', '0', '60', '0', '6', '', '1', '0', '游戏维护中', '16', '0');
INSERT INTO `game_config` VALUES ('42', '41', '北京外围', 'gamebjww', '0', '100', '2', '120', '4', '240', '1000', '50000000', '2.10|2.10|4.60|4.20|17.00|2.10|2.10|4.20|4.60|17.00|2.90|2.90|2.90', '476,476,215,235,58,476,476,235,215,58,344,344,344', '20', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,豹', '1', '0', '游戏维护中', '13', '0');
INSERT INTO `game_config` VALUES ('43', '42', '北京定位', 'gamebjdw', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.98|1.98|3.68|4.2|16|1.98|1.98|4.2|3.68|16|1.98|1.98|8|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|1.98|1.98|1.98|1.98|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9|9.9', '505,505,271,238,62,505,505,238,271,62,505,505,125,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101,505,505,505,505,101,101,101,101,101,101,101,101,101,101', '20', '40', '0', '0', '60', '0', '6', '单,大,小单,大单,极小,双,小,小双,大双,极大,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9', '1', '0', '游戏维护中', '55', '0');
INSERT INTO `game_config` VALUES ('44', '43', '飞艇10', 'gameairship10', '120', '100', '2', '120', '4', '240', '1000', '20000000', '10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00', '10,10,10,10,10,10,10,10,10,10', '30', '30', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '1', '游戏维护中', '10', '13');
INSERT INTO `game_config` VALUES ('45', '44', '飞艇22', 'gameairship22', '120', '100', '2', '120', '4', '240', '1000', '20000000', '119.00|119.00|59.00|39.00|29.00|23.00|17.00|14.00|13.00|11.00|11.00|11.00|11.00|13.00|14.00|17.00|23.00|29.00|39.00|59.00|119.00|119.00', '10,10,20,30,40,50,70,80,90,100,100,100,100,90,80,70,50,40,30,20,10,10', '30', '30', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '1', '游戏维护中', '22', '14');
INSERT INTO `game_config` VALUES ('46', '45', '飞艇冠亚军', 'gameairshipgyj', '120', '100', '2', '120', '4', '240', '1000', '20000000', '44.99|45.00|22.49|22.50|14.99|15.00|11.24|11.25|8.99|11.25|11.24|15.00|14.99|22.50|22.49|45.00|44.99', '2,2,4,4,6,6,8,8,10,8,8,6,6,4,4,2,2', '30', '30', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '1', '游戏维护中', '17', '17');
INSERT INTO `game_config` VALUES ('47', '46', '飞艇冠军', 'gameairshipgj10', '120', '100', '2', '120', '4', '240', '1000', '20000000', '10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00|10.00', '10,10,10,10,10,10,10,10,10,10', '30', '30', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '1', '游戏维护中', '10', '15');
INSERT INTO `game_config` VALUES ('48', '47', '飞艇龙虎', 'gameairshiplh', '120', '100', '2', '120', '4', '240', '1000', '20000000', '1.98|2.00', '50,50', '30', '30', '0', '0', '60', '0', '6', '-1,0|0,3|10000,3|100000,4|500000,7|1000000,10|2000000,12|5000000,15', '1', '1', '游戏维护中', '2', '16');
INSERT INTO `game_config` VALUES ('49', '48', '江苏骰宝', 'gamejs', '0', '0', '0', '0', '0', '240', '10', '3000000', '', '', '60', '80', '0', '0', '60', '0', '6', '', '0', '0', '', '0', '0');
INSERT INTO `game_config` VALUES ('50', '49', '腾讯分分彩', 'gametxffc', '0', '100', '2', '120', '4', '240', '1000', '50000000', '1.97|1.97|1.97|1.97|1.97|1.97|9.1|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|1.97|1.97|1.97|1.97|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|9.8|69.0|2.8|13.0|2.0|2.3|69.0|2.8|13.0|2.0|2.3|69.0|2.8|13.0|2.0|2.3', '10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10', '10', '5', '0', '0', '60', '0', '6', '大,小,单,双,龙,虎,和,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,大,小,单,双,0,1,2,3,4,5,6,7,8,9,豹,对,顺,半,杂,豹,对,顺,半,杂,豹,对,顺,半,杂', '1', '0', '游戏维护中', '92', '0');

-- ----------------------------
-- Table structure for game_catch_config
-- ----------------------------
DROP TABLE IF EXISTS `game_catch_config`;
CREATE TABLE `game_catch_config` (
  `gamekind` varchar(20) CHARACTER SET gbk NOT NULL DEFAULT '' COMMENT '游戏种类',
  `no_interval_second` int(11) NOT NULL DEFAULT '0' COMMENT '两期间隔，秒',
  `no_begin_time` time NOT NULL DEFAULT '00:00:00' COMMENT '每天开始时间',
  `no_end_time` time NOT NULL DEFAULT '00:00:00' COMMENT '每天结束时间',
  `remark` varchar(100) CHARACTER SET gbk NOT NULL DEFAULT '' COMMENT '备注',
  `catch_url` varchar(256) CHARACTER SET gbk NOT NULL DEFAULT '' COMMENT '采集地址',
  `open_url` varchar(256) CHARACTER SET gbk NOT NULL DEFAULT '' COMMENT '开奖地址',
  PRIMARY KEY (`gamekind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='游戏种类配置';

-- ----------------------------
-- Records of game_catch_config
-- ----------------------------
INSERT INTO `game_catch_config` VALUES ('gameairship', '300', '13:09:00', '04:04:00', '马耳他飞艇', '', '/alidata/server/php/bin/php crawler.php source=Airship');
INSERT INTO `game_catch_config` VALUES ('gamebj', '300', '09:05:00', '23:55:00', '北京快乐8', 'http://localhost:9921/crawler.php?source=Beijing', '/alidata/server/php/bin/php crawler.php source=Beijing');
INSERT INTO `game_catch_config` VALUES ('gamecan', '210', '20:08:00', '19:00:00', '加拿大快乐8', 'http://localhost:9921/crawler.php?source=Canada', '/alidata/server/php/bin/php crawler.php source=Canada');
INSERT INTO `game_catch_config` VALUES ('gamecqssc', '1200', '00:00:00', '00:00:00', '重庆时时彩', '', '/alidata/server/php/bin/php crawler.php source=CQSSC');
INSERT INTO `game_catch_config` VALUES ('gamefast', '60', '00:00:00', '00:00:00', '急速类', '', '');
INSERT INTO `game_catch_config` VALUES ('gamehg', '90', '07:00:00', '04:58:30', '韩国快乐8', 'http://localhost:9921/crawler.php?source=Korea', '/alidata/server/php/bin/php crawler.php source=Korea');
INSERT INTO `game_catch_config` VALUES ('gamepk', '1200', '09:07:00', '23:57:00', '北京pk拾', 'http://localhost:9921/crawler.php?source=Pk', '/alidata/server/php/bin/php crawler.php source=Pk');
INSERT INTO `game_catch_config` VALUES ('gametx', '60', '00:00:00', '00:00:00', '腾讯分分彩', '', '/alidata/server/php/bin/php crawler.php source=Tenxun');
INSERT INTO `game_catch_config` VALUES ('gamexync', '0', '00:00:00', '00:00:00', '幸运农场', '', '/alidata/server/php/bin/php crawler.php source=LuckFarm');


-- ----------------------------
-- Table structure for webtj
-- ----------------------------
DROP TABLE IF EXISTS `webtj`;
CREATE TABLE `webtj` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `regnum` bigint(20) NOT NULL DEFAULT '0' COMMENT '注册数',
  `forumnum` int(11) NOT NULL DEFAULT '0' COMMENT '论坛注册数',
  `onlinenum` int(11) NOT NULL DEFAULT '0' COMMENT '推广注册',
  `regpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '注册发放豆',
  `authenticationnum` int(11) NOT NULL DEFAULT '0' COMMENT '身份验证人数',
  `authenticationpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '身份验证发放豆',
  `jjpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '救济发放豆',
  `indexpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '首页设置发放豆',
  `adquestionspoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '问卷广告发放',
  `adcpapoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '互动广告发放',
  `adcpspoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '消费体验广告发放',
  `exchangepoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '兑换总量豆',
  `userspoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '用户账户总量豆',
  `time` date DEFAULT NULL COMMENT '时间',
  `rankingpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '排行榜奖励送豆',
  `boxpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '开宝箱送豆',
  `tgpoints` bigint(20) NOT NULL DEFAULT '0' COMMENT '推广送豆',
  `gamebj11` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京11赢取豆',
  `gamebj16` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京16赢取豆',
  `gameself28` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京28赢取豆',
  `gamebj28gd` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京28固定赢取豆',
  `gamebj36` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京36赢取豆',
  `gamebjww` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京外围赢取豆',
  `gamebjdw` bigint(20) NOT NULL DEFAULT '0' COMMENT '北京定位赢取豆',
  `game11` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋11赢取豆',
  `game16` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋16赢取豆',
  `game28` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋28赢取豆',
  `game28gd` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋28固定赢取豆',
  `game36` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋36赢取豆',
  `gameww` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋外围赢取豆',
  `gamedw` bigint(20) NOT NULL DEFAULT '0' COMMENT '蛋蛋定位赢取豆',
  `gamepkgyj` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK冠亚军赢取豆',
  `gamepklh` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK龙虎赢取豆',
  `gamepk10` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK10赢取豆',
  `gamepk22` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK22赢取豆',
  `gamegj10` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK冠军赢取豆',
  `gamepksc` bigint(20) NOT NULL DEFAULT '0' COMMENT 'PK赛车赢取豆',
  `gamecan28` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大28赢取豆',
  `gamecan28gd` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大28固定赢取豆',
  `gamecan16` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大16赢取豆',
  `gamecan11` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大11赢取豆',
  `gamecan36` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大36赢取豆',
  `gamecanww` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿大外围赢取豆',
  `gamecandw` bigint(20) NOT NULL DEFAULT '0' COMMENT '加拿定位围赢取豆',
  `gamefastgyj` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速冠亚军赢取豆',
  `gamefast36` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速23赢取豆',
  `gamefast28` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速28赢取豆',
  `gamefast22` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速22赢取豆',
  `gamefast16` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速16赢取豆',
  `gamefast11` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速11赢取豆',
  `gamefast10` bigint(20) NOT NULL DEFAULT '0' COMMENT '急速10赢取豆',
  `gametx28` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯28',
  `gametx28gd` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯28固定',
  `gametx16` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯16',
  `gametx11` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯11',
  `gametx36` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯36',
  `gametxww` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯外围赢取豆',
  `gametxdw` bigint(20) NOT NULL DEFAULT '0' COMMENT '腾讯定位赢取豆',
  `gametxffc` bigint(20) NOT NULL COMMENT '腾讯分分彩赢取豆',
  `gamexync` bigint(20) NOT NULL DEFAULT '0' COMMENT '幸运农场赢取豆',
  `gamecqssc` bigint(20) NOT NULL DEFAULT '0' COMMENT '重庆时时彩',
  `gameairship10` bigint(20) NOT NULL DEFAULT '0' COMMENT '飞艇10赢取豆',
  `gameairship22` bigint(20) NOT NULL DEFAULT '0' COMMENT '飞艇22赢取豆',
  `gameairshipgj10` bigint(20) NOT NULL DEFAULT '0' COMMENT '飞艇冠军赢取豆',
  `gameairshipgyj` bigint(20) NOT NULL DEFAULT '0' COMMENT '飞艇冠亚军赢取豆',
  `gameairshiplh` bigint(20) NOT NULL DEFAULT '0' COMMENT '飞艇龙虎',
  `card` bigint(20) NOT NULL DEFAULT '0' COMMENT '充卡总豆',
  `payonline` bigint(20) NOT NULL DEFAULT '0' COMMENT '在线充值总豆',
  `transtax` bigint(20) NOT NULL DEFAULT '0' COMMENT '转账抽税',
  `gametax` bigint(20) NOT NULL DEFAULT '0' COMMENT '游戏抽税',
  `pack` bigint(20) DEFAULT '0' COMMENT '红包',
  `cz` bigint(20) DEFAULT '0' COMMENT '在线冲值',
  `give_cz_point` bigint(20) DEFAULT '0' COMMENT '在线冲值积分',
  `rebate` bigint(20) DEFAULT '0' COMMENT '返利积分',
  `cashfee` decimal(12,2) unsigned NOT NULL DEFAULT '0.00' COMMENT '提现手续费',
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_webtj_time` (`time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101381 DEFAULT CHARSET=utf8 COMMENT='今日统计';

-- ----------------------------
-- Records of webtj
-- ----------------------------
INSERT INTO `webtj` VALUES ('101347', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-01', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101348', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-02', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101349', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-03', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101350', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-04', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101351', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-05', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101352', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-06', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101353', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-07', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101354', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-08', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101355', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-09', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101356', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-10', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101357', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-11', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101358', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-12', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101359', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-13', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101360', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-14', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101361', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-15', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101362', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-16', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101363', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-17', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101364', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-18', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101365', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-19', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101366', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-20', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101367', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-21', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101368', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-22', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101369', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-23', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101370', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-24', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101371', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-25', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101372', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-26', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101373', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-27', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101374', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-02-28', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101375', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-01', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101376', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-02', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101377', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-03', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101378', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-04', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101379', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-05', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');
INSERT INTO `webtj` VALUES ('101380', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '2019-03-06', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0.00');


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametx11` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametx11`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 20;
    DECLARE v_GameStep INT DEFAULT -1;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametx11 WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;
      IF v_gameSamples = 0 THEN
        SET v_kjPoints = v_tzPoints;
      ELSE
        SET v_kjPoints = FLOOR(v_tzPoints * (10000 - v_gameSamples) / 10000);
      END IF;

      SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
      FROM
        (
          SELECT odds FROM
            (
              SELECT num,0.00 AS odds
              FROM gameodds WHERE game_type = 'game11'
                                  AND num NOT IN(SELECT DISTINCT tznum FROM gametx11_kg_users_tz WHERE NO = p_No)
              UNION
              SELECT tznum AS num,TRUNCATE(v_kjPoints/SUM(tzpoints),4) AS odds
              FROM gametx11_kg_users_tz
              WHERE NO = p_No GROUP BY tznum
            ) b
          ORDER BY num
        ) a
      INTO v_ReardOdds_str;

      SET v_RewardNum = p_kjnum;
      SELECT Get_StrArrayStrOfIndex(v_ReardOdds_str,'|',v_RewardNum+v_GameStep) INTO v_Odds_str;
      IF v_Odds_str = '' THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '取中奖赔率错误';
        LEAVE LABEL_EXIT;
      END IF;
      SET v_RewardOdds = v_Odds_str * 1.00;


      UPDATE gametx11_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
      SET t.hdpoints = FLOOR(t.tzpoints * (v_RewardOdds*(10000 - u.kf) / 10000))
      WHERE t.`No` = p_No AND t.tznum = v_RewardNum;
      SET v_ChangeRewardCount = ROW_COUNT();

      UPDATE gametx11_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametx11_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametx11第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users AS a,
        (
          SELECT uid,hdpoints
          FROM gametx11_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,hdpoints
          FROM gametx11_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametx11_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametx11_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametx11_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,(v_RewardOdds*(10000 - u.kf) / 10000)
        FROM gametx11_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametx11_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametx11_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametx11_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum = v_RewardNum AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametx11 = gametx11 + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametx11,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametx11 SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,zjpl = v_ReardOdds_str,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametx11_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametx11_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametx11第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametx16` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametx16`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 19;
    DECLARE v_GameStep INT DEFAULT -2;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametx16 WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;
      IF v_gameSamples = 0 THEN
        SET v_kjPoints = v_tzPoints;
      ELSE
        SET v_kjPoints = FLOOR(v_tzPoints * (10000 - v_gameSamples) / 10000);
      END IF;

      SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
      FROM
        (
          SELECT odds FROM
            (
              SELECT num,0.00 AS odds
              FROM gameodds WHERE game_type = 'game16'
                                  AND num NOT IN(SELECT DISTINCT tznum FROM gametx16_kg_users_tz WHERE NO = p_No)
              UNION
              SELECT tznum AS num,TRUNCATE(v_kjPoints/SUM(tzpoints),4) AS odds
              FROM gametx16_kg_users_tz
              WHERE NO = p_No GROUP BY tznum
            ) b
          ORDER BY num
        ) a
      INTO v_ReardOdds_str;

      SET v_RewardNum = p_kjnum;
      SELECT Get_StrArrayStrOfIndex(v_ReardOdds_str,'|',v_RewardNum+v_GameStep) INTO v_Odds_str;
      IF v_Odds_str = '' THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '取中奖赔率错误';
        LEAVE LABEL_EXIT;
      END IF;
      SET v_RewardOdds = v_Odds_str * 1.00;


      UPDATE gametx16_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
      SET t.hdpoints = FLOOR(t.tzpoints * (v_RewardOdds*(10000 - u.kf) / 10000))
      WHERE t.`No` = p_No AND t.tznum = v_RewardNum;
      SET v_ChangeRewardCount = ROW_COUNT();

      UPDATE gametx16_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametx16_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametx16第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users AS a,
        (
          SELECT uid,hdpoints
          FROM gametx16_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,hdpoints
          FROM gametx16_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametx16_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametx16_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametx16_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,(v_RewardOdds*(10000 - u.kf) / 10000)
        FROM gametx16_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid 			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametx16_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametx16_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametx16_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum = v_RewardNum AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametx16 = gametx16 + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametx16,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametx16 SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,zjpl = v_ReardOdds_str,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametx16_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametx16_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametx16第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametx28` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametx28`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 18;
    DECLARE v_GameStep INT DEFAULT 1;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametx28 WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;
      IF v_gameSamples = 0 THEN
        SET v_kjPoints = v_tzPoints;
      ELSE
        SET v_kjPoints = FLOOR(v_tzPoints * (10000 - v_gameSamples) / 10000);
      END IF;

      SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
      FROM
        (
          SELECT odds FROM
            (
              SELECT num,0.00 AS odds
              FROM gameodds WHERE game_type = 'game28'
                                  AND num NOT IN(SELECT DISTINCT tznum FROM gametx28_kg_users_tz WHERE NO = p_No)
              UNION
              SELECT tznum AS num,TRUNCATE(v_kjPoints/SUM(tzpoints),4) AS odds
              FROM gametx28_kg_users_tz
              WHERE NO = p_No GROUP BY tznum
            ) b
          ORDER BY num
        ) a
      INTO v_ReardOdds_str;

      SET v_RewardNum = p_kjnum;
      SELECT Get_StrArrayStrOfIndex(v_ReardOdds_str,'|',v_RewardNum+v_GameStep) INTO v_Odds_str;
      IF v_Odds_str = '' THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '取中奖赔率错误';
        LEAVE LABEL_EXIT;
      END IF;
      SET v_RewardOdds = v_Odds_str * 1.00;


      UPDATE gametx28_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
      SET t.hdpoints = FLOOR(t.tzpoints * (v_RewardOdds*(10000 - u.kf) / 10000))
      WHERE t.`No` = p_No AND t.tznum = v_RewardNum;
      SET v_ChangeRewardCount = ROW_COUNT();

      UPDATE gametx28_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametx28_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametx28第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users AS a,
        (
          SELECT uid,hdpoints
          FROM gametx28_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,hdpoints
          FROM gametx28_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametx28_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametx28_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametx28_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,(v_RewardOdds*(10000 - u.kf) / 10000)
        FROM gametx28_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid 			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametx28_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametx28_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametx28_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum = v_RewardNum AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametx28 = gametx28 + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametx28,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametx28 SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,zjpl = v_ReardOdds_str,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametx28_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametx28_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametx28第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametx28gd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametx28gd`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 34;
    DECLARE v_GameStep INT DEFAULT 1;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametx28gd WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;
      IF v_gameSamples = 0 THEN
        SET v_kjPoints = v_tzPoints;
      ELSE
        SET v_kjPoints = FLOOR(v_tzPoints * (10000 - v_gameSamples) / 10000);
      END IF;

      SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
      FROM
        (
          SELECT odds FROM
            (
              SELECT num,odds AS odds
              FROM gameodds WHERE game_type = 'game28'
            ) b
          ORDER BY num
        ) a
      INTO v_ReardOdds_str;

      SELECT game_std_odds FROM game_config WHERE game_type = v_GameType INTO v_ReardOdds_str;

      SET v_RewardNum = p_kjnum;
      SELECT Get_StrArrayStrOfIndex(v_ReardOdds_str,'|',v_RewardNum+v_GameStep) INTO v_Odds_str;
      IF v_Odds_str = '' THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '取中奖赔率错误';
        LEAVE LABEL_EXIT;
      END IF;
      SET v_RewardOdds = v_Odds_str * 1.00;


      UPDATE gametx28gd_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
      SET t.hdpoints = FLOOR(t.tzpoints * (v_RewardOdds*(10000 - v_gameSamples) / 10000))
      WHERE t.`No` = p_No AND t.tznum = v_RewardNum;
      SET v_ChangeRewardCount = ROW_COUNT();

      UPDATE gametx28gd_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametx28gd_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametx28gd第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users AS a,
        (
          SELECT uid,hdpoints
          FROM gametx28gd_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,hdpoints
          FROM gametx28gd_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametx28gd_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametx28gd_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametx28gd_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,(v_RewardOdds*1)
        FROM gametx28gd_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid 			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametx28gd_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametx28gd_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;



      SELECT  IFNULL(CEIL(SUM(t.hdpoints * 0.01 / 10000)),0) FROM gametx28gd_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum = v_RewardNum AND t.usertype=0 INTO v_gameTax;

      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametx28gd = gametx28gd + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametx28gd,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametx28gd SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,zjpl = v_ReardOdds_str,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametx28gd_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametx28gd_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametx28gd第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametx36` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametx36`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 21;
    DECLARE v_GameStep INT DEFAULT 0;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametx36 WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;
      IF v_gameSamples = 0 THEN
        SET v_kjPoints = v_tzPoints;
      ELSE
        SET v_kjPoints = FLOOR(v_tzPoints * (10000 - v_gameSamples) / 10000);
      END IF;

      SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
      FROM
        (
          SELECT odds FROM
            (
              SELECT num,0.00 AS odds
              FROM gameodds WHERE game_type = 'game36'
                                  AND num NOT IN(SELECT DISTINCT tznum FROM gametx36_kg_users_tz WHERE NO = p_No)
              UNION
              SELECT tznum AS num,TRUNCATE(v_kjPoints/SUM(tzpoints),4) AS odds
              FROM gametx36_kg_users_tz
              WHERE NO = p_No GROUP BY tznum
            ) b
          ORDER BY num
        ) a
      INTO v_ReardOdds_str;

      SET v_RewardNum = p_kjnum;
      SELECT Get_StrArrayStrOfIndex(v_ReardOdds_str,'|',v_RewardNum+v_GameStep) INTO v_Odds_str;
      IF v_Odds_str = '' THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '取中奖赔率错误';
        LEAVE LABEL_EXIT;
      END IF;
      SET v_RewardOdds = v_Odds_str * 1.00;


      UPDATE gametx36_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
      SET t.hdpoints = FLOOR(t.tzpoints * (v_RewardOdds*(10000 - u.kf) / 10000))
      WHERE t.`No` = p_No AND t.tznum = v_RewardNum;
      SET v_ChangeRewardCount = ROW_COUNT();

      UPDATE gametx36_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametx36_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametx36第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users AS a,
        (
          SELECT uid,hdpoints
          FROM gametx36_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,hdpoints
          FROM gametx36_kg_users_tz WHERE `No` = p_No AND tznum = v_RewardNum AND usertype = 0
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametx36_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametx36_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametx36_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,(v_RewardOdds*(10000 - u.kf) / 10000)
        FROM gametx36_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid 			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametx36_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametx36_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametx36_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum = v_RewardNum AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametx36 = gametx36 + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametx36,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametx36 SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,zjpl = v_ReardOdds_str,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametx36_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametx36_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametx36第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametxdw` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametxdw`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk,

  p_kjnumCnt INT,
  p_kjnumStr VARCHAR(2000) CHARACTER SET gbk,
  p_kjnumOdd VARCHAR(2000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 31;
    DECLARE v_GameStep INT DEFAULT 1;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;

    DECLARE idx INT;
    DECLARE v_rowCnt INT;
    DECLARE v_kjnumCnt INT;
    DECLARE v_kjnumStr VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjnumOdd VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjNo INT;
    DECLARE v_kjOdd DECIMAL(20,4);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SET v_RewardNum = p_kjnum;
      SET v_kjnumCnt = p_kjnumCnt;
      SET v_kjnumStr = p_kjnumStr;
      SET v_kjnumOdd = p_kjnumOdd;
      SET idx=1;

      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametxdw WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;

      WHILE idx <= v_kjnumCnt
      DO
        SET v_kjNo = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumStr,',',idx),',',-1) * 1;
        SET v_kjOdd = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumOdd,',',idx),',',-1) * 1;

        UPDATE gametxdw_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
        SET t.hdpoints = FLOOR(t.tzpoints * (v_kjOdd*(10000 - v_gameSamples) / 10000)),
          t.zjpl = v_kjOdd*(10000 - v_gameSamples) / 10000
        WHERE t.`No` = p_No AND t.tznum = v_kjNo;

        SET v_rowCnt = ROW_COUNT();
        IF v_rowCnt > 0 THEN
          SET v_ChangeRewardCount = v_ChangeRewardCount + v_rowCnt;
        END IF;

        SET idx=idx+1;
      END WHILE;

      UPDATE gametxdw_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametxdw_kg_users_tz WHERE `No` = p_No
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametxdw第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;

      END IF;

      SELECT IFNULL(TRUNCATE(sum(hdpoints)/sum(tzpoints),4),0.0000) FROM gametxdw_kg_users_tz WHERE `No` = p_No AND usertype = 0 INTO  v_RewardOdds;

      UPDATE users AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxdw_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points +  b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;
      UPDATE game_static AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxdw_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametxdw_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametxdw_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametxdw_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,GROUP_CONCAT(t.zjpl ORDER BY t.id ASC SEPARATOR '|')
        FROM gametxdw_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid
        WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametxdw_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametxdw_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametxdw_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum in(v_kjnumStr) AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;
      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametxdw = gametxdw + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametxdw,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametxdw SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametxdw_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametxdw_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametxdw第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametxww` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametxww`(
  p_No	INT,
  p_numa	INT,
  p_numb	INT,
  p_numc	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk,

  p_kjnumCnt INT,
  p_kjnumStr VARCHAR(2000) CHARACTER SET gbk,
  p_kjnumOdd VARCHAR(2000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 30;
    DECLARE v_GameStep INT DEFAULT 1;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;

    DECLARE idx INT;
    DECLARE v_rowCnt INT;
    DECLARE v_kjnumCnt INT;
    DECLARE v_kjnumStr VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjnumOdd VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjNo INT;
    DECLARE v_kjOdd DECIMAL(20,4);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SET v_RewardNum = p_kjnum;
      SET v_kjnumCnt = p_kjnumCnt;
      SET v_kjnumStr = p_kjnumStr;
      SET v_kjnumOdd = p_kjnumOdd;
      SET idx=1;

      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametxww WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;


      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;

      WHILE idx <= v_kjnumCnt
      DO
        SET v_kjNo = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumStr,',',idx),',',-1) * 1;
        SET v_kjOdd = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumOdd,',',idx),',',-1) * 1;

        IF (v_RewardNum = 13 OR v_RewardNum = 14) AND (v_kjNo = 0 OR v_kjNo = 1 OR v_kjNo = 2 OR v_kjNo = 5 OR v_kjNo = 6 OR v_kjNo = 8) THEN
          UPDATE gametxww_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
          SET t.hdpoints = t.tzpoints,t.zjpl = 1.00
          WHERE t.`No` = p_No AND t.tznum = v_kjNo;
        ELSE
          UPDATE gametxww_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
          SET t.hdpoints = FLOOR(t.tzpoints * (v_kjOdd*(10000 - v_gameSamples) / 10000)),
            t.zjpl = v_kjOdd*(10000 - v_gameSamples) / 10000
          WHERE t.`No` = p_No AND t.tznum = v_kjNo;
        END IF;

        SET v_rowCnt = ROW_COUNT();
        IF v_rowCnt > 0 THEN
          SET v_ChangeRewardCount = v_ChangeRewardCount + v_rowCnt;
        END IF;

        SET idx=idx+1;
      END WHILE;

      UPDATE gametxww_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametxww_kg_users_tz WHERE `No` = p_No
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN
        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametxww第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;

      END IF;

      SELECT IFNULL(TRUNCATE(SUM(hdpoints)/SUM(tzpoints),4),0.0000) FROM gametxww_kg_users_tz WHERE `No` = p_No AND usertype = 0 INTO  v_RewardOdds;


      UPDATE users AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxww_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points +  b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;


      UPDATE game_static AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxww_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;

      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametxww_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;
      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametxww_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;
      INSERT INTO gametxww_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,GROUP_CONCAT(t.zjpl ORDER BY t.id ASC SEPARATOR '|')
        FROM gametxww_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid
        WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;

      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametxww_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;

      UPDATE users AS a,
        (
          SELECT uid FROM gametxww_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      IF v_RewardNum = 13 OR v_RewardNum = 14 THEN
        SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametxww_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum IN(v_kjnumStr) AND t.tznum IN(3,4,7,9,10,11,12) AND t.usertype=0 INTO v_gameTax;
      ELSE
        SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametxww_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum IN(v_kjnumStr) AND t.usertype=0 INTO v_gameTax;
      END IF;

      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;

      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametxww = gametxww + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametxww,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametxww SET kgjg = CONCAT(p_numa,'|',p_numb,'|',p_numc,'|',v_RewardNum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametxww_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametxww_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametx' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametxww第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_kj_gametxffc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_kj_gametxffc`(
  p_No	INT,
  p_kjnum	INT,
  p_gfNo	VARCHAR(500) CHARACTER SET gbk,
  p_kjnumCnt INT,
  p_kjnumStr VARCHAR(4000) CHARACTER SET gbk,
  p_kjnumOdd VARCHAR(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 49;
    DECLARE v_GameStep INT DEFAULT -2;
    DECLARE v_gameSamples INT;
    DECLARE v_gameTax BIGINT DEFAULT 0;
    DECLARE v_tzPoints BIGINT;
    DECLARE v_kjPoints BIGINT;
    DECLARE v_RewardsumPoints BIGINT;
    DECLARE v_RewardNum	INT;
    DECLARE v_RewardOdds DECIMAL(20,4);
    DECLARE v_Odds_str VARCHAR(20) CHARACTER SET gbk;
    DECLARE v_RewardrCount INT;
    DECLARE v_usrtzPoints	BIGINT;
    DECLARE v_UserWin	BIGINT;
    DECLARE v_ReardOdds_str VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_ingame_num BIGINT(40) unsigned DEFAULT 0;
    DECLARE v_ChangeRewardCount INT DEFAULT 0;

    DECLARE idx INT;
    DECLARE v_rowCnt INT;
    DECLARE v_kjnumCnt INT;
    DECLARE v_kjnumStr VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjnumOdd VARCHAR(2000) CHARACTER SET gbk;
    DECLARE v_kjNo INT;
    DECLARE v_kjOdd DECIMAL(20,4);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      SET v_RewardNum = p_kjnum;
      SET v_kjnumCnt = p_kjnumCnt;
      SET v_kjnumStr = p_kjnumStr;
      SET v_kjnumOdd = p_kjnumOdd;
      SET idx=1;

      SELECT tzpoints,DATE_FORMAT(kgtime,'%Y-%m-%d') FROM gametxffc WHERE id = p_No AND kj = 0
      INTO v_tzPoints,v_opentime;
      IF v_tzPoints IS NULL THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已开奖';
        LEAVE LABEL_EXIT;
      END IF;
      IF v_tzPoints = 0 AND EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") THEN
        SET v_result = 2;
        SET v_retmsg = '游戏已停止';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT game_go_samples FROM game_config WHERE game_type = v_GameType
      INTO v_gameSamples;

      WHILE idx <= v_kjnumCnt
      DO
        SET v_kjNo = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumStr,',',idx),',',-1) * 1;
        SET v_kjOdd = SUBSTRING_INDEX(SUBSTRING_INDEX(v_kjnumOdd,',',idx),',',-1) * 1;

        UPDATE gametxffc_kg_users_tz t LEFT JOIN users u ON u.id=t.uid
        SET t.hdpoints = FLOOR(t.tzpoints * (v_kjOdd*(10000 - v_gameSamples) / 10000)),
          t.zjpl = v_kjOdd*(10000 - v_gameSamples) / 10000
        WHERE t.`No` = p_No AND t.tznum = v_kjNo;

        SET v_rowCnt = ROW_COUNT();
        IF v_rowCnt > 0 THEN
          SET v_ChangeRewardCount = v_ChangeRewardCount + v_rowCnt;
        END IF;

        SET idx=idx+1;
      END WHILE;


      UPDATE gametxffc_kg_users_tz SET hdpoints=500000000 WHERE `No` = p_No AND hdpoints > 500000000;

      SELECT COUNT(uid),IFNULL(SUM(hdpoints),0) FROM gametxffc_kg_users_tz WHERE `No` = p_No
      INTO v_RewardrCount,v_RewardsumPoints;
      IF v_ChangeRewardCount > 0 AND v_RewardsumPoints = 0 THEN

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('全压无中奖',CONCAT('gametxffc第',p_No,'期,能更新中奖但更新后中奖为0'),NOW());

        UPDATE game_result SET isopen = 0 WHERE gametype='gametxffc' AND gameno = p_No;
        SELECT 4 INTO v_result;
        SET v_retmsg = '无法更新中奖，可能被锁表了';
        LEAVE LABEL_EXIT;

      END IF;



      SELECT IFNULL(TRUNCATE(SUM(hdpoints)/SUM(tzpoints),4),0.0000) FROM gametxffc_kg_users_tz WHERE `No` = p_No AND usertype = 0 INTO  v_RewardOdds;

      UPDATE users AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxffc_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.id = b.uid AND a.usertype = 0;



      UPDATE game_static AS a,
        (
          SELECT uid,SUM(hdpoints) AS hdpoints
          FROM gametxffc_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.hdpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;



      UPDATE game_day_static AS a,
        (
          SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints,uid
          FROM  gametxffc_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
        ) AS b
      SET a.points = a.points + b.sumhdpoints - b.sumtzpoints,a.tzpoints=a.tzpoints+b.sumtzpoints
      WHERE a.uid = b.uid AND a.`time`= v_opentime AND a.kindid=v_GameType;

      SELECT IFNULL(SUM(hdpoints),0) AS sumhdpoints,IFNULL(SUM(tzpoints),0) AS sumtzpoints
      FROM gametxffc_kg_users_tz
      WHERE `NO` = p_No AND usertype = 0
      INTO v_UserWin,v_usrtzPoints;


      INSERT INTO gametxffc_users_tz(uid,`NO`,tznum,tzpoints,zjpoints,`TIME`,points,hdpoints,zjpl)
        SELECT t.uid,t.`NO`,GROUP_CONCAT(t.tznum ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.tzpoints ORDER BY t.id ASC SEPARATOR '|'),
          GROUP_CONCAT(t.hdpoints ORDER BY t.id ASC SEPARATOR '|'),
          NOW(),SUM(t.tzpoints),SUM(t.hdpoints) ,GROUP_CONCAT(t.zjpl ORDER BY t.id ASC SEPARATOR '|')
        FROM gametxffc_kg_users_tz
             t LEFT JOIN users u ON u.id=t.uid 			WHERE t.`NO` = p_No AND t.usertype = 0 GROUP BY t.uid;
      SET v_ingame_num = POWER(2,v_GameType);


      UPDATE users AS a,
        (
          SELECT uid,SUM(tzpoints) AS points FROM gametxffc_kg_users_tz WHERE `NO` = p_No AND usertype = 0 GROUP BY uid
        ) b
      SET a.lock_points = a.lock_points - b.points ,a.ingame = (a.ingame ^ v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      UPDATE users AS a,
        (
          SELECT uid FROM gametxffc_kg_users_tz WHERE `NO` > p_NO AND usertype = 0 GROUP BY uid
        ) b
      SET a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      SELECT  IFNULL(CEIL(SUM(t.hdpoints * (u.kf+v_gameSamples) / 10000)),0) FROM gametxffc_kg_users_tz t LEFT JOIN users u ON u.id=t.uid WHERE t.`No` = p_No AND t.tznum IN(v_kjnumStr) AND t.usertype=0 INTO v_gameTax;


      IF v_gameTax > 0 THEN
        UPDATE centerbank SET score = score + v_gameTax WHERE bankIdx = 14;
      END IF;

      UPDATE centerbank SET score = score - (v_UserWin - v_usrtzPoints) - v_gameTax  WHERE bankIdx = 15;

      IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
        UPDATE webtj SET gametxffc = gametxffc + (v_UserWin - v_usrtzPoints),gametax = gametax + v_gameTax
        WHERE `time` = CURDATE();
      ELSE
        INSERT INTO webtj(`time`,gametxffc,gametax) VALUES(CURDATE(),v_UserWin - v_usrtzPoints,v_gameTax);
      END IF;
      UPDATE gametxffc SET kgjg = CONCAT(p_gfNo,'|',p_kjnum),take_time_remark = CONCAT(v_RewardOdds,'|',v_ChangeRewardCount,'|',v_RewardsumPoints),
        kj = 1,zjrnum = v_RewardrCount,kgNo = p_gfNo,game_tax = v_gameTax,user_tzpoints = v_usrtzPoints,user_winpoints = v_UserWin
      WHERE id = p_No;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.sumhdpoints,NOW(),'开奖后'
        FROM users a,
          (
            SELECT uid,SUM(hdpoints) AS sumhdpoints FROM gametxffc_kg_users_tz WHERE `No` = p_No AND usertype = 0 GROUP BY uid
          ) b
        WHERE a.id = b.uid AND a.usertype = 0;

      DELETE FROM gametxffc_kg_users_tz WHERE `No` = p_No;
    END LABEL_EXIT;
    IF err=1  THEN
      SET v_result = 99;
      SET v_retmsg = '数据库错误!';
    END IF;
    IF v_result = 0 THEN
      COMMIT;
    ELSE
      ROLLBACK;
      IF err = 1 THEN

        UPDATE game_result SET isopen = 0 WHERE gametype='gametxffc' AND gameno = p_No;

        INSERT INTO system_msg(msg_type,msg_content,msg_time)
        VALUES('开奖错误',CONCAT('gametxffc第',p_No,'期由于数据库错误回滚，自动重新开奖'),NOW());
      END IF;
    END IF;

    CALL web_gameno_addpatch('gametx',v_GameType,0,10);
    SELECT v_result AS result,v_retmsg AS msg;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx28_auto_new` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx28_auto_new`(
  p_preNo		INT,
  p_No		INT
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 18;

    DECLARE v_rmin_num INT;
    DECLARE v_rmax_num INT;
    DECLARE v_rcur_num INT;
    DECLARE v_isKJ INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_iszdtz INT DEFAULT 0;
    DECLARE v_sumpoints_user bigINT DEFAULT 0;
    DECLARE v_personcnt_user INT DEFAULT 0;
    DECLARE v_sumpoints_robot bigINT DEFAULT 0;
    DECLARE v_personcnt_robot INT DEFAULT 0;

    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_kgtime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;

    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx28;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_pressuser_gametx28(
      `uid` BIGINT(20),
      `tzpoints` BIGINT(20),
      `flag` INT(11)
    ) ENGINE = MEMORY;

    START TRANSACTION;

      LABEL_EXIT:BEGIN
      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),zdtz+zdtz_r,kgtime FROM gametx28 WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_iszdtz,v_kgtime;

      IF v_isKj = 1 OR v_iszdtz > 0 OR UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(v_kgtime) THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已经下过注或已开奖';
        LEAVE LABEL_EXIT;
      END IF;


      IF EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") OR
         EXISTS(SELECT 1 FROM game_config WHERE isstop = 1 AND game_type = v_GameType)
      THEN
        DELETE FROM gametx28_auto WHERE usertype = 0;
        SET v_result = 2;
        SET v_retmsg = '游戏已停止下注';
        LEAVE LABEL_EXIT;
      END IF;




      DELETE FROM gametx28_auto WHERE usertype = 0 AND endNO < p_No;

      DELETE FROM gametx28_auto
      WHERE id IN(
        SELECT id FROM
          (
            SELECT a.id
            FROM gametx28_auto a
              LEFT OUTER JOIN users b
                ON a.uid = b.id AND a.usertype = 0
            WHERE (a.maxG > 0 AND a.maxG <= b.points)
                  OR (a.minG >0 AND a.minG >= b.points)
          ) c
      );

      UPDATE gametx28_auto a
        LEFT JOIN gametx28_users_tz tz ON tz.uid=a.uid AND NO=p_preNo
        LEFT JOIN gametx28_auto_tz auto ON auto.`id`=a.`autoid` AND auto.`uid`=a.`uid`
      SET a.autoid=(CASE WHEN tz.`points` IS NULL THEN a.`start_auto_id` WHEN tz.`hdpoints`>=tz.`points` THEN auto.`winid` ELSE auto.`lossid` END)
      WHERE a.startNO<=p_No AND a.endNO>=p_No AND a.usertype=0;



      DELETE FROM gametx28_auto WHERE usertype = 0 AND uid IN(
        SELECT aa.id FROM users aa,
          (
            SELECT a.uid,a.tzpoints
            FROM gametx28_auto_tz a,gametx28_auto b
            WHERE a.uid = b.uid AND a.id = b.autoid AND b.usertype = 0
          ) bb
        WHERE aa.id = bb.uid AND aa.points < bb.tzpoints or aa.dj=1
      );


      INSERT INTO tmp_pressuser_gametx28(uid,tzpoints,flag)
        SELECT uid,0,0 FROM gametx28_auto WHERE usertype = 0 AND startno <= p_No;


      SELECT min_num,max_num FROM game_robot_config WHERE game_type = v_GameType
      INTO v_rmin_num,v_rmax_num;
      SET v_rcur_num = FLOOR(v_rmin_num + RAND() * (v_rmax_num - v_rmin_num + 1));

      INSERT INTO tmp_pressuser_gametx28(uid,tzpoints,flag)
        SELECT uid,0,1
        FROM gametx28_auto
        WHERE usertype = 1 AND STATUS = 1
        ORDER BY RAND() LIMIT v_rcur_num;


      INSERT INTO gametx28_kg_users_tz(uid,`NO`,tznum,tzpoints,`time`,usertype)
        SELECT a.uid,p_No,a.tznum,a.tzpoints,NOW(),b.usertype
        FROM gameall_auto_tz a,gametx28_auto b
        WHERE a.uid = b.uid AND a.gametype = v_GameType AND a.autoid = b.autoid
              AND a.uid IN( SELECT uid FROM tmp_pressuser_gametx28);

      INSERT INTO gameall_kg_users_tz_history(gametype,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype)
        SELECT v_GameType,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype
        FROM gametx28_kg_users_tz
        WHERE `NO` = p_No AND usertype = 0;

      INSERT INTO presslog(uid,`NO`,gametype,pressStr,totalscore)
        SELECT uid,p_No,v_GameType,GROUP_CONCAT(CONCAT(tznum,',',tzpoints) ORDER BY tznum ASC SEPARATOR '|'),SUM(tzpoints)
        FROM gametx28_kg_users_tz WHERE `NO` = p_No AND usertype = 0
                                        AND uid IN( SELECT uid FROM tmp_pressuser_gametx28)
        GROUP BY uid;


      UPDATE tmp_pressuser_gametx28 a,
        (
          SELECT uid,SUM(tzpoints) AS sumpoints FROM gametx28_kg_users_tz
          WHERE `NO` = p_No
          GROUP BY uid
        ) b
      SET a.tzpoints = b.sumpoints
      WHERE a.uid = b.uid;


      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users a,tmp_pressuser_gametx28 b
      SET a.points = a.points - b.tzpoints,a.lock_points = a.lock_points + b.tzpoints,a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;




      INSERT INTO game_static(uid,typeid,points)
        SELECT uid,v_GameType,0 FROM tmp_pressuser_gametx28
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_static WHERE typeid = v_GameType);

      UPDATE game_static a,tmp_pressuser_gametx28 b
      SET a.points = a.points - b.tzpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;


      INSERT INTO game_day_static(uid,`time`,usertype,points,kindid)
        SELECT uid,v_opentime,flag,0,v_GameType FROM tmp_pressuser_gametx28
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_day_static WHERE `time` = v_opentime AND kindid = v_GameType);

      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx28 WHERE flag = 0
      INTO v_personcnt_user,v_sumpoints_user;
      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx28 WHERE flag = 1
      INTO v_personcnt_robot,v_sumpoints_robot;

      UPDATE gametx28 SET tzpoints = tzpoints + v_sumpoints_user + v_sumpoints_robot,
        zdtz = zdtz + v_personcnt_user,zdtz_r = zdtz_r + v_personcnt_robot,
        zdtz_points = zdtz_points + v_sumpoints_user,zdtz_rpoints = zdtz_rpoints + v_sumpoints_robot
      WHERE id = p_No;


      SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx28_kg_users_tz WHERE NO = p_No
      INTO v_curTotalPressPoints;
      IF v_curTotalPressPoints > 0 THEN

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game28'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx28_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx28_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        UPDATE gametx28 SET zjpl = v_curOdds WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.tzpoints,NOW(),'自动投注后'
        FROM users a,tmp_pressuser_gametx28 b
        WHERE a.id = b.uid AND b.flag = 0;



    END LABEL_EXIT;


    IF err = 1 THEN
      ROLLBACK;
      SELECT 99 INTO v_result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;

    END IF;


    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx28;

    SELECT v_result AS result,v_retmsg AS msg;

  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx16_auto_new` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx16_auto_new`(
  p_preNo		INT,
  p_No		INT
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 19;

    DECLARE v_rmin_num INT;
    DECLARE v_rmax_num INT;
    DECLARE v_rcur_num INT;
    DECLARE v_isKJ INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_iszdtz INT DEFAULT 0;
    DECLARE v_sumpoints_user bigINT DEFAULT 0;
    DECLARE v_personcnt_user INT DEFAULT 0;
    DECLARE v_sumpoints_robot bigINT DEFAULT 0;
    DECLARE v_personcnt_robot INT DEFAULT 0;

    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_kgtime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;

    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx16;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_pressuser_gametx16(`uid` BIGINT(20),`tzpoints` BIGINT(20),`flag` INT(11))ENGINE = MEMORY;

    START TRANSACTION;

      LABEL_EXIT:BEGIN
      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),zdtz+zdtz_r,kgtime FROM gametx16 WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_iszdtz,v_kgtime;

      IF v_isKj = 1 OR v_iszdtz > 0 OR UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(v_kgtime) THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已经下过注或已开奖';
        LEAVE LABEL_EXIT;
      END IF;


      IF EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") OR
         EXISTS(SELECT 1 FROM game_config WHERE isstop = 1 AND game_type = v_GameType)
      THEN
        DELETE FROM gametx16_auto WHERE usertype = 0;
        SET v_result = 2;
        SET v_retmsg = '游戏已停止下注';
        LEAVE LABEL_EXIT;
      END IF;




      DELETE FROM gametx16_auto WHERE usertype = 0 AND endNO < p_No;

      DELETE FROM gametx16_auto
      WHERE id IN(
        SELECT id FROM
          (
            SELECT a.id
            FROM gametx16_auto a
              LEFT OUTER JOIN users b
                ON a.uid = b.id AND a.usertype = 0
            WHERE (a.maxG > 0 AND a.maxG <= b.points)
                  OR (a.minG >0 AND a.minG >= b.points)
          ) c
      );


      UPDATE gametx16_auto a
        LEFT JOIN gametx16_users_tz tz ON tz.uid=a.uid AND NO=p_preNo
        LEFT JOIN gametx16_auto_tz auto ON auto.`id`=a.`autoid` AND auto.`uid`=a.`uid`
      SET a.autoid=(CASE WHEN tz.`points` IS NULL THEN a.`start_auto_id` WHEN tz.`hdpoints`>=tz.`points` THEN auto.`winid` ELSE auto.`lossid` END)
      WHERE a.startNO<=p_No AND a.endNO>=p_No AND a.usertype=0;


      DELETE FROM gametx16_auto WHERE usertype = 0 AND uid IN(
        SELECT aa.id FROM users aa,
          (
            SELECT a.uid,a.tzpoints
            FROM gametx16_auto_tz a,gametx16_auto b
            WHERE a.uid = b.uid AND a.id = b.autoid AND b.usertype = 0
          ) bb
        WHERE aa.id = bb.uid AND aa.points < bb.tzpoints or aa.dj=1
      );


      INSERT INTO tmp_pressuser_gametx16(uid,tzpoints,flag)
        SELECT uid,0,0 FROM gametx16_auto WHERE usertype = 0 AND startno <= p_No;


      SELECT min_num,max_num FROM game_robot_config WHERE game_type = v_GameType
      INTO v_rmin_num,v_rmax_num;
      SET v_rcur_num = FLOOR(v_rmin_num + RAND() * (v_rmax_num - v_rmin_num + 1));

      INSERT INTO tmp_pressuser_gametx16(uid,tzpoints,flag)
        SELECT uid,0,1
        FROM gametx16_auto
        WHERE usertype = 1 AND STATUS = 1
        ORDER BY RAND() LIMIT v_rcur_num;


      INSERT INTO gametx16_kg_users_tz(uid,`NO`,tznum,tzpoints,`time`,usertype)
        SELECT a.uid,p_No,a.tznum,a.tzpoints,NOW(),b.usertype
        FROM gameall_auto_tz a,gametx16_auto b
        WHERE a.uid = b.uid AND a.gametype = v_GameType AND a.autoid = b.autoid
              AND a.uid IN( SELECT uid FROM tmp_pressuser_gametx16);

      INSERT INTO gameall_kg_users_tz_history(gametype,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype)
        SELECT v_GameType,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype
        FROM gametx16_kg_users_tz
        WHERE `NO` = p_No AND usertype = 0;

      INSERT INTO presslog(uid,`NO`,gametype,pressStr,totalscore)
        SELECT uid,p_No,v_GameType,GROUP_CONCAT(CONCAT(tznum,',',tzpoints) ORDER BY tznum ASC SEPARATOR '|'),SUM(tzpoints)
        FROM gametx16_kg_users_tz WHERE `NO` = p_No AND usertype = 0
                                        AND uid IN( SELECT uid FROM tmp_pressuser_gametx16)
        GROUP BY uid;


      UPDATE tmp_pressuser_gametx16 a,
        (
          SELECT uid,SUM(tzpoints) AS sumpoints FROM gametx16_kg_users_tz
          WHERE `NO` = p_No
          GROUP BY uid
        ) b
      SET a.tzpoints = b.sumpoints
      WHERE a.uid = b.uid;


      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users a,tmp_pressuser_gametx16 b
      SET a.points = a.points - b.tzpoints,a.lock_points = a.lock_points + b.tzpoints,a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;


      INSERT INTO game_static(uid,typeid,points)
        SELECT uid,v_GameType,0 FROM tmp_pressuser_gametx16
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_static WHERE typeid = v_GameType);

      UPDATE game_static a,tmp_pressuser_gametx16 b
      SET a.points = a.points - b.tzpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;


      INSERT INTO game_day_static(uid,`time`,usertype,points,kindid)
        SELECT uid,v_opentime,flag,0,v_GameType FROM tmp_pressuser_gametx16
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_day_static WHERE `time` = v_opentime AND kindid = v_GameType);

      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx16 WHERE flag = 0
      INTO v_personcnt_user,v_sumpoints_user;
      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx16 WHERE flag = 1
      INTO v_personcnt_robot,v_sumpoints_robot;

      UPDATE gametx16 SET tzpoints = tzpoints + v_sumpoints_user + v_sumpoints_robot,
        zdtz = zdtz + v_personcnt_user,zdtz_r = zdtz_r + v_personcnt_robot,
        zdtz_points = zdtz_points + v_sumpoints_user,zdtz_rpoints = zdtz_rpoints + v_sumpoints_robot
      WHERE id = p_No;


      SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx16_kg_users_tz WHERE NO = p_No
      INTO v_curTotalPressPoints;
      IF v_curTotalPressPoints > 0 THEN

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game16'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx16_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx16_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        UPDATE gametx16 SET zjpl = v_curOdds WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.tzpoints,NOW(),'自动投注后'
        FROM users a,tmp_pressuser_gametx16 b
        WHERE a.id = b.uid AND b.flag = 0;



    END LABEL_EXIT;

    IF err = 1 THEN
      ROLLBACK;
      SELECT 99 INTO v_result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;

    END IF;


    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx16;

    SELECT v_result AS result,v_retmsg AS msg;

  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx11_auto_new` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx11_auto_new`(
  p_preNo		INT,
  p_No		INT
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 20;

    DECLARE v_rmin_num INT;
    DECLARE v_rmax_num INT;
    DECLARE v_rcur_num INT;
    DECLARE v_isKJ INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_iszdtz INT DEFAULT 0;
    DECLARE v_sumpoints_user bigINT DEFAULT 0;
    DECLARE v_personcnt_user INT DEFAULT 0;
    DECLARE v_sumpoints_robot bigINT DEFAULT 0;
    DECLARE v_personcnt_robot INT DEFAULT 0;

    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_kgtime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;

    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx11;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_pressuser_gametx11(`uid` BIGINT(20),`tzpoints` BIGINT(20),`flag` INT(11))ENGINE = MEMORY;

    START TRANSACTION;

      LABEL_EXIT:BEGIN
      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),zdtz+zdtz_r,kgtime FROM gametx11 WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_iszdtz,v_kgtime;

      IF v_isKj = 1 OR v_iszdtz > 0 OR UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(v_kgtime) THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已经下过注或已开奖';
        LEAVE LABEL_EXIT;
      END IF;


      IF EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") OR
         EXISTS(SELECT 1 FROM game_config WHERE isstop = 1 AND game_type = v_GameType)
      THEN
        DELETE FROM gametx11_auto WHERE usertype = 0;
        SET v_result = 2;
        SET v_retmsg = '游戏已停止下注';
        LEAVE LABEL_EXIT;
      END IF;




      DELETE FROM gametx11_auto WHERE usertype = 0 AND endNO < p_No;

      DELETE FROM gametx11_auto
      WHERE id IN(
        SELECT id FROM
          (
            SELECT a.id
            FROM gametx11_auto a
              LEFT OUTER JOIN users b
                ON a.uid = b.id AND a.usertype = 0
            WHERE (a.maxG > 0 AND a.maxG <= b.points)
                  OR (a.minG >0 AND a.minG >= b.points)
          ) c
      );


      UPDATE gametx11_auto a
        LEFT JOIN gametx11_users_tz tz ON tz.uid=a.uid AND NO=p_preNo
        LEFT JOIN gametx11_auto_tz auto ON auto.`id`=a.`autoid` AND auto.`uid`=a.`uid`
      SET a.autoid=(CASE WHEN tz.`points` IS NULL THEN a.`start_auto_id` WHEN tz.`hdpoints`>=tz.`points` THEN auto.`winid` ELSE auto.`lossid` END)
      WHERE a.startNO<=p_No AND a.endNO>=p_No AND a.usertype=0;


      DELETE FROM gametx11_auto WHERE usertype = 0 AND uid IN(
        SELECT aa.id FROM users aa,
          (
            SELECT a.uid,a.tzpoints
            FROM gametx11_auto_tz a,gametx11_auto b
            WHERE a.uid = b.uid AND a.id = b.autoid AND b.usertype = 0
          ) bb
        WHERE aa.id = bb.uid AND aa.points < bb.tzpoints or aa.dj=1
      );


      INSERT INTO tmp_pressuser_gametx11(uid,tzpoints,flag)
        SELECT uid,0,0 FROM gametx11_auto WHERE usertype = 0 AND startno <= p_No;


      SELECT min_num,max_num FROM game_robot_config WHERE game_type = v_GameType
      INTO v_rmin_num,v_rmax_num;
      SET v_rcur_num = FLOOR(v_rmin_num + RAND() * (v_rmax_num - v_rmin_num + 1));

      INSERT INTO tmp_pressuser_gametx11(uid,tzpoints,flag)
        SELECT uid,0,1
        FROM gametx11_auto
        WHERE usertype = 1 AND STATUS = 1
        ORDER BY RAND() LIMIT v_rcur_num;


      INSERT INTO gametx11_kg_users_tz(uid,`NO`,tznum,tzpoints,`time`,usertype)
        SELECT a.uid,p_No,a.tznum,a.tzpoints,NOW(),b.usertype
        FROM gameall_auto_tz a,gametx11_auto b
        WHERE a.uid = b.uid AND a.gametype = v_GameType AND a.autoid = b.autoid
              AND a.uid IN( SELECT uid FROM tmp_pressuser_gametx11);

      INSERT INTO gameall_kg_users_tz_history(gametype,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype)
        SELECT v_GameType,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype
        FROM gametx11_kg_users_tz
        WHERE `NO` = p_No AND usertype = 0;

      INSERT INTO presslog(uid,`NO`,gametype,pressStr,totalscore)
        SELECT uid,p_No,v_GameType,GROUP_CONCAT(CONCAT(tznum,',',tzpoints) ORDER BY tznum ASC SEPARATOR '|'),SUM(tzpoints)
        FROM gametx11_kg_users_tz WHERE `NO` = p_No AND usertype = 0
                                        AND uid IN( SELECT uid FROM tmp_pressuser_gametx11)
        GROUP BY uid;


      UPDATE tmp_pressuser_gametx11 a,
        (
          SELECT uid,SUM(tzpoints) AS sumpoints FROM gametx11_kg_users_tz
          WHERE `NO` = p_No
          GROUP BY uid
        ) b
      SET a.tzpoints = b.sumpoints
      WHERE a.uid = b.uid;


      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users a,tmp_pressuser_gametx11 b
      SET a.points = a.points - b.tzpoints,a.lock_points = a.lock_points + b.tzpoints,a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;




      INSERT INTO game_static(uid,typeid,points)
        SELECT uid,v_GameType,0 FROM tmp_pressuser_gametx11
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_static WHERE typeid = v_GameType);

      UPDATE game_static a,tmp_pressuser_gametx11 b
      SET a.points = a.points - b.tzpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;


      INSERT INTO game_day_static(uid,`time`,usertype,points,kindid)
        SELECT uid,v_opentime,flag,0,v_GameType FROM tmp_pressuser_gametx11
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_day_static WHERE `time` = v_opentime AND kindid = v_GameType);

      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx11 WHERE flag = 0
      INTO v_personcnt_user,v_sumpoints_user;
      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx11 WHERE flag = 1
      INTO v_personcnt_robot,v_sumpoints_robot;

      UPDATE gametx11 SET tzpoints = tzpoints + v_sumpoints_user + v_sumpoints_robot,
        zdtz = zdtz + v_personcnt_user,zdtz_r = zdtz_r + v_personcnt_robot,
        zdtz_points = zdtz_points + v_sumpoints_user,zdtz_rpoints = zdtz_rpoints + v_sumpoints_robot
      WHERE id = p_No;


      SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx11_kg_users_tz WHERE NO = p_No
      INTO v_curTotalPressPoints;
      IF v_curTotalPressPoints > 0 THEN

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game11'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx11_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx11_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        UPDATE gametx11 SET zjpl = v_curOdds WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.tzpoints,NOW(),'自动投注后'
        FROM users a,tmp_pressuser_gametx11 b
        WHERE a.id = b.uid AND b.flag = 0;



    END LABEL_EXIT;


    IF err = 1 THEN
      ROLLBACK;
      SELECT 99 INTO v_result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;

    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx11;

    SELECT v_result AS result,v_retmsg AS msg;

  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx36_auto_new` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx36_auto_new`(
  p_preNo		INT,
  p_No		INT
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 21;

    DECLARE v_rmin_num INT;
    DECLARE v_rmax_num INT;
    DECLARE v_rcur_num INT;
    DECLARE v_isKJ INT DEFAULT 0;
    DECLARE v_opentime DATETIME;
    DECLARE v_iszdtz INT DEFAULT 0;
    DECLARE v_sumpoints_user bigINT DEFAULT 0;
    DECLARE v_personcnt_user INT DEFAULT 0;
    DECLARE v_sumpoints_robot bigINT DEFAULT 0;
    DECLARE v_personcnt_robot INT DEFAULT 0;

    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;
    DECLARE v_kgtime DATETIME;
    DECLARE v_ingame_num BIGINT(40) DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;

    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx36;
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_pressuser_gametx36(`uid` BIGINT(20),`tzpoints` BIGINT(20),`flag` INT(11))ENGINE = MEMORY;

    START TRANSACTION;

      LABEL_EXIT:BEGIN
      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),zdtz+zdtz_r,kgtime FROM gametx36 WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_iszdtz,v_kgtime;

      IF v_isKj = 1 OR v_iszdtz > 0 OR UNIX_TIMESTAMP(NOW()) > UNIX_TIMESTAMP(v_kgtime) THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '该期已经下过注或已开奖';
        LEAVE LABEL_EXIT;
      END IF;


      IF EXISTS(SELECT 1 FROM sys_config WHERE fldVar = 'game_open_flag' AND fldValue = "1") OR
         EXISTS(SELECT 1 FROM game_config WHERE isstop = 1 AND game_type = v_GameType)
      THEN
        DELETE FROM gametx36_auto WHERE usertype = 0;
        SET v_result = 2;
        SET v_retmsg = '游戏已停止下注';
        LEAVE LABEL_EXIT;
      END IF;




      DELETE FROM gametx36_auto WHERE usertype = 0 AND endNO < p_No;

      DELETE FROM gametx36_auto
      WHERE id IN(
        SELECT id FROM
          (
            SELECT a.id
            FROM gametx36_auto a
              LEFT OUTER JOIN users b
                ON a.uid = b.id AND a.usertype = 0
            WHERE (a.maxG > 0 AND a.maxG <= b.points)
                  OR (a.minG >0 AND a.minG >= b.points)
          ) c
      );


      UPDATE gametx36_auto a
        LEFT JOIN gametx36_users_tz tz ON tz.uid=a.uid AND NO=p_preNo
        LEFT JOIN gametx36_auto_tz auto ON auto.`id`=a.`autoid` AND auto.`uid`=a.`uid`
      SET a.autoid=(CASE WHEN tz.`points` IS NULL THEN a.`start_auto_id` WHEN tz.`hdpoints`>=tz.`points` THEN auto.`winid` ELSE auto.`lossid` END)
      WHERE a.startNO<=p_No AND a.endNO>=p_No AND a.usertype=0;


      DELETE FROM gametx36_auto WHERE usertype = 0 AND uid IN(
        SELECT aa.id FROM users aa,
          (
            SELECT a.uid,a.tzpoints
            FROM gametx36_auto_tz a,gametx36_auto b
            WHERE a.uid = b.uid AND a.id = b.autoid AND b.usertype = 0
          ) bb
        WHERE aa.id = bb.uid AND aa.points < bb.tzpoints or aa.dj=1
      );


      INSERT INTO tmp_pressuser_gametx36(uid,tzpoints,flag)
        SELECT uid,0,0 FROM gametx36_auto WHERE usertype = 0 AND startno <= p_No;


      SELECT min_num,max_num FROM game_robot_config WHERE game_type = v_GameType
      INTO v_rmin_num,v_rmax_num;
      SET v_rcur_num = FLOOR(v_rmin_num + RAND() * (v_rmax_num - v_rmin_num + 1));

      INSERT INTO tmp_pressuser_gametx36(uid,tzpoints,flag)
        SELECT uid,0,1
        FROM gametx36_auto
        WHERE usertype = 1 AND STATUS = 1
        ORDER BY RAND() LIMIT v_rcur_num;


      INSERT INTO gametx36_kg_users_tz(uid,`NO`,tznum,tzpoints,`time`,usertype)
        SELECT a.uid,p_No,a.tznum,a.tzpoints,NOW(),b.usertype
        FROM gameall_auto_tz a,gametx36_auto b
        WHERE a.uid = b.uid AND a.gametype = v_GameType AND a.autoid = b.autoid
              AND a.uid IN( SELECT uid FROM tmp_pressuser_gametx36);

      INSERT INTO gameall_kg_users_tz_history(gametype,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype)
        SELECT v_GameType,uid,`NO`,tznum,tzpoints,`time`,hdpoints,usertype
        FROM gametx36_kg_users_tz
        WHERE `NO` = p_No AND usertype = 0;


      INSERT INTO presslog(uid,`NO`,gametype,pressStr,totalscore)
        SELECT uid,p_No,v_GameType,GROUP_CONCAT(CONCAT(tznum,',',tzpoints) ORDER BY tznum ASC SEPARATOR '|'),SUM(tzpoints)
        FROM gametx36_kg_users_tz WHERE `NO` = p_No AND usertype = 0
                                        AND uid IN( SELECT uid FROM tmp_pressuser_gametx36)
        GROUP BY uid;

      UPDATE tmp_pressuser_gametx36 a,
        (
          SELECT uid,SUM(tzpoints) AS sumpoints FROM gametx36_kg_users_tz
          WHERE `NO` = p_No
          GROUP BY uid
        ) b
      SET a.tzpoints = b.sumpoints
      WHERE a.uid = b.uid;


      SET v_ingame_num = POWER(2,v_GameType);
      UPDATE users a,tmp_pressuser_gametx36 b
      SET a.points = a.points - b.tzpoints,a.lock_points = a.lock_points + b.tzpoints,a.ingame = (a.ingame | v_ingame_num)
      WHERE a.id = b.uid AND a.usertype = 0;




      INSERT INTO game_static(uid,typeid,points)
        SELECT uid,v_GameType,0 FROM tmp_pressuser_gametx36
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_static WHERE typeid = v_GameType);

      UPDATE game_static a,tmp_pressuser_gametx36 b
      SET a.points = a.points - b.tzpoints
      WHERE a.uid = b.uid AND a.typeid = v_GameType;


      INSERT INTO game_day_static(uid,`time`,usertype,points,kindid)
        SELECT uid,v_opentime,flag,0,v_GameType FROM tmp_pressuser_gametx36
        WHERE flag = 0 AND uid NOT IN(SELECT uid FROM game_day_static WHERE `time` = v_opentime AND kindid = v_GameType);

      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx36 WHERE flag = 0
      INTO v_personcnt_user,v_sumpoints_user;
      SELECT COUNT(uid),IFNULL(SUM(tzpoints),0) FROM tmp_pressuser_gametx36 WHERE flag = 1
      INTO v_personcnt_robot,v_sumpoints_robot;

      UPDATE gametx36 SET tzpoints = tzpoints + v_sumpoints_user + v_sumpoints_robot,
        zdtz = zdtz + v_personcnt_user,zdtz_r = zdtz_r + v_personcnt_robot,
        zdtz_points = zdtz_points + v_sumpoints_user,zdtz_rpoints = zdtz_rpoints + v_sumpoints_robot
      WHERE id = p_No;


      SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx36_kg_users_tz WHERE NO = p_No
      INTO v_curTotalPressPoints;
      IF v_curTotalPressPoints > 0 THEN

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game36'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx36_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx36_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        UPDATE gametx36 SET zjpl = v_curOdds WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,a.id,a.points,a.back,a.lock_points,a.experience,b.tzpoints,NOW(),'自动投注后'
        FROM users a,tmp_pressuser_gametx36 b
        WHERE a.id = b.uid AND b.flag = 0;

    END LABEL_EXIT;

    IF err = 1 THEN
      ROLLBACK;
      SELECT 99 INTO v_result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;

    END IF;


    DROP TEMPORARY TABLE IF EXISTS tmp_pressuser_gametx36;

    SELECT v_result AS result,v_retmsg AS msg;

  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx11` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx11`(
  p_uid		bigint,
  p_No		int,
  p_sumPoint	bigint,
  p_tz_type	int,
  p_tz_arr	varchar(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType int default 20;
    DECLARE v_Points bigint;
    DECLARE v_tz_num int default 0;
    DECLARE v_i int;
    DECLARE v_str_num_arr varchar(100) CHARACTER SET gbk;
    DECLARE v_single_num varchar(50) CHARACTER SET gbk;
    DECLARE v_single_point varchar(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint bigint default 0;
    DECLARE v_curOdds varchar(1000) CHARACTER SET gbk;
    DECLARE v_isKJ int;
    DECLARE v_curTotalPressPoints bigint;
    DECLARE v_HadPressPoint bigint;
    DECLARE v_tzrNum int default 1;

    DECLARE v_Press_min int;
    DECLARE v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      if p_sumPoint <= 0 then
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      end if;

      select kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) from gametx11 where id = p_No
      into v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      if v_isKj = 1 then
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      end if;

      select points from users where id = p_uid
      into v_Points
      for update;
      if v_Points < p_sumPoint then
        SELECT 2 INTO v_result;
        set v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      end if;


      SELECT game_press_min,game_press_max,game_tz_close from game_config where game_type = v_GameType
      into v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = concat('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      select ifnull(sum(tzpoints),0) from gametx11_kg_users_tz where No = p_No and uid = p_uid
      into v_HadPressPoint;
      if v_Press_max < v_HadPressPoint + p_sumPoint then
        SELECT 6 INTO v_result;
        SET v_retmsg = concat('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      end if;

      select Get_StrArrayLength(p_tz_arr,'|') into v_tz_num;
      set v_i = 1;
      while v_i <= v_tz_num do
        select Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) into v_str_num_arr;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',1) into v_single_num;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        if v_single_num <> '' and v_single_point <> '' then
          set v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          if exists(select 1 from gametx11_kg_users_tz where NO = p_No and uid = p_uid and tznum = v_single_num) then
            update gametx11_kg_users_tz set tzpoints = tzpoints + v_single_point
            where NO = p_No AND uid = p_uid AND tznum = v_single_num;
          else
            insert into gametx11_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            values(p_uid,p_No,v_single_num,v_single_point,now());
          end if;
        end if;
        set v_i = v_i + 1;
      end while;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      if v_Check_sumPoint <> p_sumPoint then
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      end if;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      if p_tz_type = 0 then

        SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx11_kg_users_tz WHERE NO = p_No
        INTO v_curTotalPressPoints;

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game11'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx11_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx11_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        update gametx11 set zjpl = v_curOdds,tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint where id = p_No;
      else
        UPDATE gametx11 SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      end if;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 as result;
      SET v_retmsg = '数据库错误';
    ELSE
      if v_result = 0 then
        COMMIT;

        select v_result as result,v_retmsg as msg,points,back from users where id = p_uid;
      else
        ROLLBACK;

        select v_result as result,v_retmsg AS msg;
      end if;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx16` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx16`(
  p_uid		bigint,
  p_No		int,
  p_sumPoint	bigint,
  p_tz_type	int,
  p_tz_arr	varchar(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType int default 19;
    DECLARE v_Points bigint;
    DECLARE v_tz_num int default 0;
    DECLARE v_i int;
    DECLARE v_str_num_arr varchar(100) CHARACTER SET gbk;
    DECLARE v_single_num varchar(50) CHARACTER SET gbk;
    DECLARE v_single_point varchar(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint bigint default 0;
    DECLARE v_curOdds varchar(1000) CHARACTER SET gbk;
    DECLARE v_isKJ int;
    DECLARE v_curTotalPressPoints bigint;
    DECLARE v_HadPressPoint bigint;
    DECLARE v_tzrNum int default 1;

    DECLARE v_Press_min int;
    DECLARE v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      if p_sumPoint <= 0 then
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      end if;

      select kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) from gametx16 where id = p_No
      into v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      if v_isKj = 1 then
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      end if;

      select points from users where id = p_uid
      into v_Points
      for update;
      if v_Points < p_sumPoint then
        SELECT 2 INTO v_result;
        set v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      end if;


      SELECT game_press_min,game_press_max,game_tz_close from game_config where game_type = v_GameType
      into v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = concat('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      select ifnull(sum(tzpoints),0) from gametx16_kg_users_tz where No = p_No and uid = p_uid
      into v_HadPressPoint;
      if v_Press_max < v_HadPressPoint + p_sumPoint then
        SELECT 6 INTO v_result;
        SET v_retmsg = concat('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      end if;

      select Get_StrArrayLength(p_tz_arr,'|') into v_tz_num;
      set v_i = 1;
      while v_i <= v_tz_num do
        select Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) into v_str_num_arr;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',1) into v_single_num;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        if v_single_num <> '' and v_single_point <> '' then
          set v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          if exists(select 1 from gametx16_kg_users_tz where NO = p_No and uid = p_uid and tznum = v_single_num) then
            update gametx16_kg_users_tz set tzpoints = tzpoints + v_single_point
            where NO = p_No AND uid = p_uid AND tznum = v_single_num;
          else
            insert into gametx16_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            values(p_uid,p_No,v_single_num,v_single_point,now());
          end if;
        end if;
        set v_i = v_i + 1;
      end while;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      if v_Check_sumPoint <> p_sumPoint then
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      end if;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      if p_tz_type = 0 then

        SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx16_kg_users_tz WHERE NO = p_No
        INTO v_curTotalPressPoints;

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game16'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx16_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx16_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        update gametx16 set zjpl = v_curOdds,tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint where id = p_No;
      else
        UPDATE gametx16 SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      end if;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 as result;
      SET v_retmsg = '数据库错误';
    ELSE
      if v_result = 0 then
        COMMIT;

        select v_result as result,v_retmsg as msg,points,back from users where id = p_uid;
      else
        ROLLBACK;

        select v_result as result,v_retmsg AS msg;
      end if;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx28` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx28`(
  p_uid		bigint,
  p_No		int,
  p_sumPoint	bigint,
  p_tz_type	int,
  p_tz_arr	varchar(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType int default 18;
    DECLARE v_Points bigint;
    DECLARE v_tz_num int default 0;
    DECLARE v_i int;
    DECLARE v_str_num_arr varchar(100) CHARACTER SET gbk;
    DECLARE v_single_num varchar(50) CHARACTER SET gbk;
    DECLARE v_single_point varchar(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint bigint default 0;
    DECLARE v_curOdds varchar(1000) CHARACTER SET gbk;
    DECLARE v_isKJ int;
    DECLARE v_curTotalPressPoints bigint;
    DECLARE v_HadPressPoint bigint;
    DECLARE v_tzrNum int default 1;

    DECLARE v_Press_min int;
    DECLARE v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      if p_sumPoint <= 0 then
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      end if;

      select kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) from gametx28 where id = p_No
      into v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      if v_isKj = 1 then
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      end if;

      select points from users where id = p_uid
      into v_Points
      for update;
      if v_Points < p_sumPoint then
        SELECT 2 INTO v_result;
        set v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      end if;


      SELECT game_press_min,game_press_max,game_tz_close from game_config where game_type = v_GameType
      into v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = concat('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      select ifnull(sum(tzpoints),0) from gametx28_kg_users_tz where No = p_No and uid = p_uid
      into v_HadPressPoint;
      if v_Press_max < v_HadPressPoint + p_sumPoint then
        SELECT 6 INTO v_result;
        SET v_retmsg = concat('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      end if;

      select Get_StrArrayLength(p_tz_arr,'|') into v_tz_num;
      set v_i = 1;
      while v_i <= v_tz_num do
        select Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) into v_str_num_arr;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',1) into v_single_num;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        if v_single_num <> '' and v_single_point <> '' then
          set v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          if exists(select 1 from gametx28_kg_users_tz where NO = p_No and uid = p_uid and tznum = v_single_num) then
            update gametx28_kg_users_tz set tzpoints = tzpoints + v_single_point
            where NO = p_No AND uid = p_uid AND tznum = v_single_num;
          else
            insert into gametx28_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            values(p_uid,p_No,v_single_num,v_single_point,now());
          end if;
        end if;
        set v_i = v_i + 1;
      end while;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      if v_Check_sumPoint <> p_sumPoint then
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      end if;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      if p_tz_type = 0 then

        SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx28_kg_users_tz WHERE NO = p_No
        INTO v_curTotalPressPoints;

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game28'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx28_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx28_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        update gametx28 set zjpl = v_curOdds,tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint where id = p_No;
      else
        UPDATE gametx28 SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      end if;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 as result;
      SET v_retmsg = '数据库错误';
    ELSE
      if v_result = 0 then
        COMMIT;

        select v_result as result,v_retmsg as msg,points,back from users where id = p_uid;
      else
        ROLLBACK;

        select v_result as result,v_retmsg AS msg;
      end if;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx28gd` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx28gd`(
  p_uid		BIGINT,
  p_No		INT,
  p_sumPoint	BIGINT,
  p_tz_type	INT,
  p_tz_arr	VARCHAR(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 34;
    DECLARE v_Points BIGINT;
    DECLARE v_tz_num INT DEFAULT 0;
    DECLARE v_i INT;
    DECLARE v_str_num_arr VARCHAR(100) CHARACTER SET gbk;
    DECLARE v_single_num VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_single_point VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint BIGINT DEFAULT 0;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;
    DECLARE v_isKJ INT;
    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_HadPressPoint BIGINT;
    DECLARE v_tzrNum INT DEFAULT 1;

    DECLARE v_Press_min INT;
    DECLARE v_Press_max INT;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      IF p_sumPoint <= 0 THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) FROM gametx28gd WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      IF v_isKj = 1 THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT points FROM users WHERE id = p_uid
      INTO v_Points
      FOR UPDATE;
      IF v_Points < p_sumPoint THEN
        SELECT 2 INTO v_result;
        SET v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      END IF;


      SELECT game_press_min,game_press_max,game_tz_close FROM game_config WHERE game_type = v_GameType
      INTO v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = CONCAT('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT IFNULL(SUM(tzpoints),0) FROM gametx28gd_kg_users_tz WHERE NO = p_No AND uid = p_uid
      INTO v_HadPressPoint;
      IF v_Press_max < v_HadPressPoint + p_sumPoint THEN
        SELECT 6 INTO v_result;
        SET v_retmsg = CONCAT('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      END IF;

      SELECT Get_StrArrayLength(p_tz_arr,'|') INTO v_tz_num;
      SET v_i = 1;
      WHILE v_i <= v_tz_num DO
        SELECT Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) INTO v_str_num_arr;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',1) INTO v_single_num;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        IF v_single_num <> '' AND v_single_point <> '' THEN
          SET v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          IF EXISTS(SELECT 1 FROM gametx28gd_kg_users_tz WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num) THEN
            UPDATE gametx28gd_kg_users_tz SET tzpoints = tzpoints + v_single_point
            WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num;
          ELSE
            INSERT INTO gametx28gd_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            VALUES(p_uid,p_No,v_single_num,v_single_point,NOW());
          END IF;
        END IF;
        SET v_i = v_i + 1;
      END WHILE;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      IF v_Check_sumPoint <> p_sumPoint THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      IF p_tz_type = 0 THEN

        SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx28gd_kg_users_tz WHERE NO = p_No
        INTO v_curTotalPressPoints;

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game28'
          ) a ORDER BY num
        INTO v_curOdds;

        UPDATE gametx28gd SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint WHERE id = p_No;
      ELSE
        UPDATE gametx28gd SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 AS result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;

        SELECT v_result AS result,v_retmsg AS msg,points,back FROM users WHERE id = p_uid;
      ELSE
        ROLLBACK;

        SELECT v_result AS result,v_retmsg AS msg;
      END IF;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametx36` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametx36`(
  p_uid		bigint,
  p_No		int,
  p_sumPoint	bigint,
  p_tz_type	int,
  p_tz_arr	varchar(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT default 21;
    DECLARE v_Points BIGINT;
    DECLARE v_tz_num INT default 0;
    DECLARE v_i INT;
    DECLARE v_str_num_arr varchar(100) CHARACTER SET gbk;
    DECLARE v_single_num varchar(50) CHARACTER SET gbk;
    DECLARE v_single_point varchar(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint BIGINT default 0;
    DECLARE v_curOdds varchar(1000) CHARACTER SET gbk;
    DECLARE v_isKJ INT;
    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_HadPressPoint BIGINT;
    DECLARE v_tzrNum INT default 1;

    DECLARE v_Press_min INT;
    DECLARE v_Press_max INT;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      if p_sumPoint <= 0 then
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      end if;

      select kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) from gametx36 where id = p_No
      into v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      if v_isKj = 1 then
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      end if;

      select points from users where id = p_uid
      into v_Points
      for update;
      if v_Points < p_sumPoint then
        SELECT 2 INTO v_result;
        set v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      end if;


      SELECT game_press_min,game_press_max,game_tz_close from game_config where game_type = v_GameType
      into v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = concat('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      select ifnull(sum(tzpoints),0) from gametx36_kg_users_tz where No = p_No and uid = p_uid
      into v_HadPressPoint;
      if v_Press_max < v_HadPressPoint + p_sumPoint then
        SELECT 6 INTO v_result;
        SET v_retmsg = concat('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      end if;

      select Get_StrArrayLength(p_tz_arr,'|') into v_tz_num;
      set v_i = 1;
      while v_i <= v_tz_num do
        select Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) into v_str_num_arr;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',1) into v_single_num;
        select Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        if v_single_num <> '' and v_single_point <> '' then
          set v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          if exists(select 1 from gametx36_kg_users_tz where NO = p_No and uid = p_uid and tznum = v_single_num) then
            update gametx36_kg_users_tz set tzpoints = tzpoints + v_single_point
            where NO = p_No AND uid = p_uid AND tznum = v_single_num;
          else
            insert into gametx36_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            values(p_uid,p_No,v_single_num,v_single_point,now());
          end if;
        end if;
        set v_i = v_i + 1;
      end while;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      if v_Check_sumPoint <> p_sumPoint then
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      end if;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      if p_tz_type = 0 then

        SELECT IFNULL(SUM(tzpoints),0) AS sumpoints FROM gametx36_kg_users_tz WHERE NO = p_No
        INTO v_curTotalPressPoints;

        SELECT GROUP_CONCAT(TRUNCATE(odds,4) SEPARATOR '|')
        FROM
          (
            SELECT num,odds
            FROM gameodds WHERE game_type = 'game36'
                                AND num NOT IN(SELECT DISTINCT tznum FROM gametx36_kg_users_tz WHERE NO = p_No)
            UNION
            SELECT tznum AS num,TRUNCATE(v_curTotalPressPoints/SUM(tzpoints),4) AS odds
            FROM gametx36_kg_users_tz
            WHERE NO = p_No GROUP BY tznum
          ) a ORDER BY num
        INTO v_curOdds;

        update gametx36 set zjpl = v_curOdds,tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint where id = p_No;
      else
        UPDATE gametx36 SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      end if;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 as result;
      SET v_retmsg = '数据库错误';
    ELSE
      if v_result = 0 then
        COMMIT;

        select v_result as result,v_retmsg as msg,points,back from users where id = p_uid;
      else
        ROLLBACK;

        select v_result as result,v_retmsg AS msg;
      end if;
    END IF;
  END ;;  
DELIMITER ;


/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametxdw` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametxdw`(
  p_uid		BIGINT,
  p_No		INT,
  p_sumPoint	BIGINT,
  p_tz_type	INT,
  p_tz_arr	VARCHAR(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 31;
    DECLARE v_Points BIGINT;
    DECLARE v_tz_num INT DEFAULT 0;
    DECLARE v_i INT;
    DECLARE v_str_num_arr VARCHAR(100) CHARACTER SET gbk;
    DECLARE v_single_num VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_single_point VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint BIGINT DEFAULT 0;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;
    DECLARE v_isKJ INT;
    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_HadPressPoint BIGINT;
    DECLARE v_tzrNum INT DEFAULT 1;

    DECLARE v_Press_min INT;
    DECLARE v_Press_max INT;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      IF p_sumPoint <= 0 THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) FROM gametxdw WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      IF v_isKj = 1 THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT points FROM users WHERE id = p_uid
      INTO v_Points
      FOR UPDATE;
      IF v_Points < p_sumPoint THEN
        SELECT 2 INTO v_result;
        SET v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      END IF;


      SELECT game_press_min,game_press_max,game_tz_close FROM game_config WHERE game_type = v_GameType
      INTO v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = CONCAT('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT IFNULL(SUM(tzpoints),0) FROM gametxdw_kg_users_tz WHERE NO = p_No AND uid = p_uid
      INTO v_HadPressPoint;
      IF v_Press_max < v_HadPressPoint + p_sumPoint THEN
        SELECT 6 INTO v_result;
        SET v_retmsg = CONCAT('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      END IF;

      SELECT Get_StrArrayLength(p_tz_arr,'|') INTO v_tz_num;
      SET v_i = 1;
      WHILE v_i <= v_tz_num DO
        SELECT Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) INTO v_str_num_arr;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',1) INTO v_single_num;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        IF v_single_num <> '' AND v_single_point <> '' THEN
          SET v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          IF EXISTS(SELECT 1 FROM gametxdw_kg_users_tz WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num) THEN
            UPDATE gametxdw_kg_users_tz SET tzpoints = tzpoints + v_single_point
            WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num;
          ELSE
            INSERT INTO gametxdw_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            VALUES(p_uid,p_No,v_single_num,v_single_point,NOW());
          END IF;
        END IF;
        SET v_i = v_i + 1;
      END WHILE;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      IF v_Check_sumPoint <> p_sumPoint THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      IF p_tz_type = 0 THEN
        UPDATE gametxdw SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint WHERE id = p_No;
      ELSE
        UPDATE gametxdw SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 AS result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;

        SELECT v_result AS result,v_retmsg AS msg,points,back FROM users WHERE id = p_uid;
      ELSE
        ROLLBACK;

        SELECT v_result AS result,v_retmsg AS msg;
      END IF;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametxww` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametxww`(
  p_uid		BIGINT,
  p_No		INT,
  p_sumPoint	BIGINT,
  p_tz_type	INT,
  p_tz_arr	VARCHAR(4000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 30;
    DECLARE v_Points BIGINT;
    DECLARE v_tz_num INT DEFAULT 0;
    DECLARE v_i INT;
    DECLARE v_str_num_arr VARCHAR(100) CHARACTER SET gbk;
    DECLARE v_single_num VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_single_point VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint BIGINT DEFAULT 0;
    DECLARE v_curOdds VARCHAR(1000) CHARACTER SET gbk;
    DECLARE v_isKJ INT;
    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_HadPressPoint BIGINT;
    DECLARE v_tzrNum INT DEFAULT 1;

    DECLARE v_Press_min INT;
    DECLARE v_Press_max INT;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      IF p_sumPoint <= 0 THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) FROM gametxww WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      IF v_isKj = 1 THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT points FROM users WHERE id = p_uid
      INTO v_Points
      FOR UPDATE;
      IF v_Points < p_sumPoint THEN
        SELECT 2 INTO v_result;
        SET v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      END IF;


      SELECT game_press_min,game_press_max,game_tz_close FROM game_config WHERE game_type = v_GameType
      INTO v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = CONCAT('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT IFNULL(SUM(tzpoints),0) FROM gametxww_kg_users_tz WHERE NO = p_No AND uid = p_uid
      INTO v_HadPressPoint;
      IF v_Press_max < v_HadPressPoint + p_sumPoint THEN
        SELECT 6 INTO v_result;
        SET v_retmsg = CONCAT('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      END IF;

      SELECT Get_StrArrayLength(p_tz_arr,'|') INTO v_tz_num;
      SET v_i = 1;
      WHILE v_i <= v_tz_num DO
        SELECT Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) INTO v_str_num_arr;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',1) INTO v_single_num;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        IF v_single_num <> '' AND v_single_point <> '' THEN
          SET v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          IF EXISTS(SELECT 1 FROM gametxww_kg_users_tz WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num) THEN
            UPDATE gametxww_kg_users_tz SET tzpoints = tzpoints + v_single_point
            WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num;
          ELSE
            INSERT INTO gametxww_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            VALUES(p_uid,p_No,v_single_num,v_single_point,NOW());
          END IF;
        END IF;
        SET v_i = v_i + 1;
      END WHILE;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      IF v_Check_sumPoint <> p_sumPoint THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      IF p_tz_type = 0 THEN
        UPDATE gametxww SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint WHERE id = p_No;
      ELSE
        UPDATE gametxww SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 AS result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;

        SELECT v_result AS result,v_retmsg AS msg,points,back FROM users WHERE id = p_uid;
      ELSE
        ROLLBACK;

        SELECT v_result AS result,v_retmsg AS msg;
      END IF;
    END IF;
  END ;;
DELIMITER ;


/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `web_tz_gametxffc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_tz_gametxffc`(
  p_uid		BIGINT,
  p_No		INT,
  p_sumPoint	BIGINT,
  p_tz_type	INT,
  p_tz_arr	VARCHAR(6000) CHARACTER SET gbk
)
  SQL SECURITY INVOKER
  BEGIN

    DECLARE v_GameType INT DEFAULT 49;
    DECLARE v_Points BIGINT;
    DECLARE v_tz_num INT DEFAULT 0;
    DECLARE v_i INT;
    DECLARE v_str_num_arr VARCHAR(4000) CHARACTER SET gbk;
    DECLARE v_single_num VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_single_point VARCHAR(50) CHARACTER SET gbk;
    DECLARE v_Check_sumPoint BIGINT DEFAULT 0;
    DECLARE v_curOdds VARCHAR(4000) CHARACTER SET gbk;
    DECLARE v_isKJ INT;
    DECLARE v_curTotalPressPoints BIGINT;
    DECLARE v_HadPressPoint BIGINT;
    DECLARE v_tzrNum INT DEFAULT 1;

    DECLARE v_Press_min INT;
    DECLARE v_Press_max INT;

    DECLARE v_result INT DEFAULT 0;
    DECLARE v_retmsg VARCHAR(200) CHARACTER SET gbk DEFAULT 'ok';
    DECLARE err INT DEFAULT 0;

    DECLARE v_opentime DATETIME;
    DECLARE v_opentime_sec BIGINT;
    DECLARE v_tz_close INT;
    DECLARE v_now_sec BIGINT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
    START TRANSACTION;
      LABEL_EXIT:BEGIN
      IF p_sumPoint <= 0 THEN
        SELECT 1 INTO v_result;
        SET v_retmsg = '投注总额必须大于0';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT kj,zjpl,DATE_FORMAT(kgtime,'%Y-%m-%d'),UNIX_TIMESTAMP(kgtime),UNIX_TIMESTAMP(NOW()) FROM gametxffc WHERE id = p_No
      INTO v_isKJ,v_curOdds,v_opentime,v_opentime_sec,v_now_sec;
      IF v_isKj = 1 THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期已经开奖过了';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT points FROM users WHERE id = p_uid
      INTO v_Points
      FOR UPDATE;
      IF v_Points < p_sumPoint THEN
        SELECT 2 INTO v_result;
        SET v_retmsg = '余额不足';
        LEAVE LABEL_EXIT;
      END IF;


      SELECT game_press_min,game_press_max,game_tz_close FROM game_config WHERE game_type = v_GameType
      INTO v_Press_min,v_Press_max,v_tz_close;
      IF v_Press_min > p_sumPoint THEN
        SELECT 5 INTO v_result;
        SET v_retmsg = CONCAT('投注额小于最小限制值',v_Press_min);
        LEAVE LABEL_EXIT;
      END IF;

      IF v_now_sec > v_opentime_sec - v_tz_close THEN
        SELECT 4 INTO v_result;
        SET v_retmsg = '本期投注已结束';
        LEAVE LABEL_EXIT;
      END IF;

      SELECT IFNULL(SUM(tzpoints),0) FROM gametxffc_kg_users_tz WHERE NO = p_No AND uid = p_uid
      INTO v_HadPressPoint;
      IF v_Press_max < v_HadPressPoint + p_sumPoint THEN
        SELECT 6 INTO v_result;
        SET v_retmsg = CONCAT('投注已满，最大限制值',v_Press_max);
        LEAVE LABEL_EXIT;
      END IF;

      SELECT Get_StrArrayLength(p_tz_arr,'|') INTO v_tz_num;
      SET v_i = 1;
      WHILE v_i <= v_tz_num DO
        SELECT Get_StrArrayStrOfIndex(p_tz_arr,'|',v_i) INTO v_str_num_arr;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',1) INTO v_single_num;
        SELECT Get_StrArrayStrOfIndex(v_str_num_arr,',',2) INTO v_single_point;

        IF v_single_num <> '' AND v_single_point <> '' THEN
          SET v_Check_sumPoint = v_Check_sumPoint + v_single_point;
          IF EXISTS(SELECT 1 FROM gametxffc_kg_users_tz WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num) THEN
            UPDATE gametxffc_kg_users_tz SET tzpoints = tzpoints + v_single_point
            WHERE NO = p_No AND uid = p_uid AND tznum = v_single_num;
          ELSE
            INSERT INTO gametxffc_kg_users_tz(uid,`No`,tznum,tzpoints,`time`)
            VALUES(p_uid,p_No,v_single_num,v_single_point,NOW());
          END IF;
        END IF;
        SET v_i = v_i + 1;
      END WHILE;

      INSERT INTO presslog(uid,`no`,gametype,pressStr,totalscore) values(p_uid,p_No,v_GameType,p_tz_arr,p_sumPoint);

      IF v_Check_sumPoint <> p_sumPoint THEN
        SELECT 3 INTO v_result;
        SET v_retmsg = '核对投注总豆失败';
        LEAVE LABEL_EXIT;
      END IF;


      UPDATE users SET points = points - p_sumPoint,
        lock_points = lock_points + p_sumPoint,ingame = (ingame | POWER(2,v_GameType))
      WHERE id = p_uid;


      IF EXISTS(SELECT 1 FROM game_static WHERE uid = p_uid AND typeid = v_GameType) THEN
        UPDATE game_static SET points = points - p_sumPoint WHERE uid = p_uid AND typeid = v_GameType;
      ELSE
        INSERT INTO game_static(uid,typeid,points) VALUES(p_uid,v_GameType,-p_sumPoint);
      END IF;


      IF NOT EXISTS (SELECT 1 FROM game_day_static WHERE uid=p_uid AND  `time`= v_opentime AND kindid=v_GameType ) THEN
        INSERT INTO game_day_static(`time`,uid,points,usertype,kindid) VALUES(v_opentime,p_uid,0,0,v_GameType);
      END IF;

      IF p_tz_type = 0 THEN
        UPDATE gametxffc SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,sdtz = sdtz + v_tzrNum,sdtz_points=sdtz_points+p_sumPoint WHERE id = p_No;
      ELSE
        UPDATE gametxffc SET tznum = tznum + v_tz_num,tzpoints = tzpoints + p_sumPoint,zdtz = zdtz + v_tzrNum WHERE id = p_No;
      END IF;

      INSERT INTO user_score_changelog(gametype,gameno,uid,points,back,lock_points,experience,change_points,thetime,remark)
        SELECT v_GameType,p_No,id,points,back,lock_points,experience,p_sumPoint,NOW(),'手动投注后'
        FROM users WHERE id = p_uid;

    END LABEL_EXIT;

    IF(err=1) THEN
      ROLLBACK;
      SELECT 99 AS result;
      SET v_retmsg = '数据库错误';
    ELSE
      IF v_result = 0 THEN
        COMMIT;

        SELECT v_result AS result,v_retmsg AS msg,points,back FROM users WHERE id = p_uid;
      ELSE
        ROLLBACK;

        SELECT v_result AS result,v_retmsg AS msg;
      END IF;
    END IF;
  END ;;
DELIMITER ;


/*!50003 DROP PROCEDURE IF EXISTS `web_gameno_addpatch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `web_gameno_addpatch`(
  p_gamekind 	VARCHAR(20),
  p_gametype 	INT,
  p_specifyno INT,
  p_reccount 	INT
)
  BEGIN
  
    DECLARE v_tablename VARCHAR(100);
    DECLARE v_table_users_tz VARCHAR(100);
    DECLARE v_no INT DEFAULT 0;
    DECLARE v_interval_second INT;
    DECLARE v_begin_time TIME;
    DECLARE v_end_time TIME;
    DECLARE v_no_time DATETIME;
    DECLARE v_hadno_count INT DEFAULT 0;
    DECLARE v_odds VARCHAR(1000) CHARACTER SET gbk;
    DECLARE v_overtime DATETIME;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_ret INT DEFAULT 0;
    DECLARE err INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
      LABEL_EXIT:BEGIN

      SELECT game_table_prefix FROM game_config WHERE game_type = p_gametype LIMIT 1
      INTO v_tablename;


      SET @s = CONCAT("SELECT count(*) FROM ",v_tablename," WHERE kj = 0 and kgtime > DATE_ADD(NOW(),INTERVAL -10 MINUTE )
								INTO @v_reccount");
      PREPARE stmt FROM @s;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET v_hadno_count = @v_reccount;
      IF v_hadno_count >= p_reccount THEN
        LEAVE LABEL_EXIT;
      END IF;


      IF HOUR(NOW()) = 9 THEN
        DELETE FROM game_result WHERE isopen = 1 AND opentime < DATE_ADD(NOW(),INTERVAL -1 DAY);
        SET v_table_users_tz = CONCAT(v_tablename,"_users_tz");
        SET v_overtime = DATE_FORMAT(DATE_ADD(NOW(),INTERVAL -15 DAY),"%Y-%m-%d");
        SET @s = CONCAT("delete from ",v_table_users_tz," where `time` < '",v_overtime,"'");
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @s = CONCAT("delete from ",v_tablename," where `kgtime` < '",v_overtime,"'");
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
      END IF;

      IF p_specifyno = 0 THEN
        SET @s = CONCAT("SELECT id,kgtime FROM ",v_tablename,"  ORDER BY id DESC LIMIT 1
								INTO @v_LastNo,@v_LastkgTime");
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET v_no = @v_LastNo;
        SET v_no_time = @v_LastkgTime;

        IF v_no IS NULL THEN
          SET v_ret = 1;
          LEAVE LABEL_EXIT;
        END IF;
      ELSE
        SET v_no = p_specifyno;
        SET @s = CONCAT("SELECT kgtime FROM ",v_tablename," WHERE id = ",v_no," LIMIT 1
								INTO @v_LastkgTime");
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        SET v_no_time = @v_LastkgTime;
      END IF;

      SELECT no_interval_second,no_begin_time,no_end_time FROM game_catch_config WHERE gamekind = p_gamekind
      INTO v_interval_second,v_begin_time,v_end_time;

      SELECT game_std_odds FROM game_config WHERE game_type = p_gametype
      INTO v_odds;

      WHILE v_i <= p_reccount DO
        SET v_no = v_no + 1;
        IF p_gamekind = "gamefast" THEN

          IF UNIX_TIMESTAMP(v_no_time) < UNIX_TIMESTAMP(NOW()) THEN
            SET v_no_time = DATE_FORMAT(DATE_ADD(NOW(),INTERVAL v_interval_second SECOND),'%Y-%m-%d %H:%i:00');
          ELSE
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND);
          END IF;
        ELSEIF p_gamekind = "gametx" THEN

          IF cast(SUBSTR(v_no,-4) as UNSIGNED INTEGER) >= 1441 THEN
            SET v_no = cast(CONCAT(DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'%y%m%d'),'0001') as UNSIGNED INTEGER);
          END IF;

          IF UNIX_TIMESTAMP(v_no_time) < UNIX_TIMESTAMP(NOW()) THEN
            SET v_no_time = DATE_FORMAT(DATE_ADD(NOW(),INTERVAL v_interval_second SECOND),'%Y-%m-%d %H:%i:00');
          ELSE
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND);
          END IF;
        ELSEIF p_gamekind = "gamepk" OR p_gamekind = "gamebj" THEN

          IF TIME(DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND)) < v_begin_time THEN
            SET v_no_time = DATE_FORMAT(DATE_ADD(v_no_time,INTERVAL v_begin_time HOUR_SECOND),"%Y-%m-%d 00:00:00");
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_begin_time HOUR_SECOND);
          ELSE
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND);
          END IF;
        ELSEIF p_gamekind = "gamecan" THEN

          IF TIME(DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND)) < "00:05:00" THEN
            SET v_no_time = DATE_FORMAT(DATE_ADD(v_no_time,INTERVAL v_begin_time HOUR_SECOND),"%Y-%m-%d 00:00:00");
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_begin_time HOUR_SECOND);
          ELSE
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND);
          END IF;
        ELSEIF p_gamekind = "gamehg" THEN

          IF TIME(DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND)) > v_end_time AND  TIME(DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND)) < v_begin_time THEN
            SET v_no_time = DATE_ADD(DATE_FORMAT(v_no_time,'%Y-%m-%d'),INTERVAL v_begin_time HOUR_SECOND);
          ELSE
            SET v_no_time = DATE_ADD(v_no_time,INTERVAL v_interval_second SECOND);
          END IF;
        END IF;

        SET @s = CONCAT("insert into ",v_tablename,"(id,kgtime,gfid,zjpl) values(?,?,?,?)");
        PREPARE stmt FROM @s;
        SET @a = v_no;
        SET @b = v_no_time;
        SET @c = v_no;
        SET @d = v_odds;
        EXECUTE stmt USING @a,@b,@c,@d;
        DEALLOCATE PREPARE stmt;

        SELECT @s AS stmt,@a,@b,@c,@d;

        SET v_i = v_i + 1;
      END WHILE;

    END LABEL_EXIT;

    IF err=1  THEN
      SET v_ret = 99;
    END IF;

    SELECT v_ret AS result ,v_hadno_count AS hadno_count,v_no AS NO,v_i;
  END ;;
DELIMITER ;


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for gametx11_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx11_auto`;
CREATE TABLE `gametx11_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=306 DEFAULT CHARSET=utf8 COMMENT='腾讯11自动投注';

-- ----------------------------
-- Records of gametx11_auto
-- ----------------------------
INSERT INTO `gametx11_auto` VALUES ('1', '0', '0', '0', '10000', '63', '1', '1', '367827', '0');
INSERT INTO `gametx11_auto` VALUES ('2', '0', '0', '0', '10000', '63', '1', '1', '367830', '0');
INSERT INTO `gametx11_auto` VALUES ('3', '0', '0', '0', '10000', '63', '1', '1', '367839', '0');
INSERT INTO `gametx11_auto` VALUES ('4', '0', '0', '0', '10000', '63', '1', '1', '367841', '0');
INSERT INTO `gametx11_auto` VALUES ('5', '0', '0', '0', '10000', '63', '1', '1', '367852', '0');
INSERT INTO `gametx11_auto` VALUES ('6', '0', '0', '0', '10000', '63', '1', '1', '367869', '0');
INSERT INTO `gametx11_auto` VALUES ('7', '0', '0', '0', '10000', '63', '1', '1', '367887', '0');
INSERT INTO `gametx11_auto` VALUES ('8', '0', '0', '0', '10000', '63', '1', '1', '367914', '0');
INSERT INTO `gametx11_auto` VALUES ('9', '0', '0', '0', '10000', '63', '1', '1', '367931', '0');
INSERT INTO `gametx11_auto` VALUES ('10', '0', '0', '0', '10000', '63', '1', '1', '367941', '0');
INSERT INTO `gametx11_auto` VALUES ('11', '0', '0', '0', '10000', '63', '1', '1', '367995', '0');
INSERT INTO `gametx11_auto` VALUES ('12', '0', '0', '0', '10000', '63', '1', '1', '367998', '0');
INSERT INTO `gametx11_auto` VALUES ('13', '0', '0', '0', '10000', '63', '1', '1', '368008', '0');
INSERT INTO `gametx11_auto` VALUES ('14', '0', '0', '0', '10000', '63', '1', '1', '368081', '0');
INSERT INTO `gametx11_auto` VALUES ('15', '0', '0', '0', '10000', '63', '1', '1', '368116', '0');
INSERT INTO `gametx11_auto` VALUES ('16', '0', '0', '0', '10000', '63', '1', '1', '368121', '0');
INSERT INTO `gametx11_auto` VALUES ('17', '0', '0', '0', '10000', '63', '1', '1', '368206', '0');
INSERT INTO `gametx11_auto` VALUES ('18', '0', '0', '0', '10000', '63', '1', '1', '368249', '0');
INSERT INTO `gametx11_auto` VALUES ('19', '0', '0', '0', '10000', '63', '1', '1', '368262', '0');
INSERT INTO `gametx11_auto` VALUES ('20', '0', '0', '0', '10000', '63', '1', '1', '368295', '0');
INSERT INTO `gametx11_auto` VALUES ('21', '0', '0', '0', '10000', '63', '1', '1', '368311', '0');
INSERT INTO `gametx11_auto` VALUES ('22', '0', '0', '0', '10000', '63', '1', '1', '368325', '0');
INSERT INTO `gametx11_auto` VALUES ('23', '0', '0', '0', '10000', '63', '1', '1', '368337', '0');
INSERT INTO `gametx11_auto` VALUES ('24', '0', '0', '0', '10000', '63', '1', '1', '368469', '0');
INSERT INTO `gametx11_auto` VALUES ('25', '0', '0', '0', '10000', '63', '1', '1', '368492', '0');
INSERT INTO `gametx11_auto` VALUES ('26', '0', '0', '0', '10000', '63', '1', '1', '368547', '0');
INSERT INTO `gametx11_auto` VALUES ('27', '0', '0', '0', '10000', '63', '1', '1', '368550', '0');
INSERT INTO `gametx11_auto` VALUES ('28', '0', '0', '0', '10000', '63', '1', '1', '368553', '0');
INSERT INTO `gametx11_auto` VALUES ('29', '0', '0', '0', '10000', '63', '1', '1', '368586', '0');
INSERT INTO `gametx11_auto` VALUES ('30', '0', '0', '0', '10000', '63', '1', '1', '368602', '0');
INSERT INTO `gametx11_auto` VALUES ('31', '0', '0', '0', '10000', '63', '1', '1', '368612', '0');
INSERT INTO `gametx11_auto` VALUES ('32', '0', '0', '0', '10000', '63', '1', '1', '368623', '0');
INSERT INTO `gametx11_auto` VALUES ('33', '0', '0', '0', '10000', '63', '1', '1', '368635', '0');
INSERT INTO `gametx11_auto` VALUES ('34', '0', '0', '0', '10000', '63', '1', '1', '368688', '0');
INSERT INTO `gametx11_auto` VALUES ('35', '0', '0', '0', '10000', '63', '1', '1', '368706', '0');
INSERT INTO `gametx11_auto` VALUES ('36', '0', '0', '0', '10000', '63', '1', '1', '368724', '0');
INSERT INTO `gametx11_auto` VALUES ('37', '0', '0', '0', '10000', '63', '1', '1', '368769', '0');
INSERT INTO `gametx11_auto` VALUES ('38', '0', '0', '0', '10000', '63', '1', '1', '368778', '0');
INSERT INTO `gametx11_auto` VALUES ('39', '0', '0', '0', '10000', '63', '1', '1', '368782', '0');
INSERT INTO `gametx11_auto` VALUES ('40', '0', '0', '0', '10000', '63', '1', '1', '368810', '0');
INSERT INTO `gametx11_auto` VALUES ('41', '0', '0', '0', '10000', '63', '1', '1', '368847', '0');
INSERT INTO `gametx11_auto` VALUES ('42', '0', '0', '0', '10000', '63', '1', '1', '368884', '0');
INSERT INTO `gametx11_auto` VALUES ('43', '0', '0', '0', '10000', '63', '1', '1', '368896', '0');
INSERT INTO `gametx11_auto` VALUES ('44', '0', '0', '0', '10000', '63', '1', '1', '368925', '0');
INSERT INTO `gametx11_auto` VALUES ('45', '0', '0', '0', '10000', '63', '1', '1', '368936', '0');
INSERT INTO `gametx11_auto` VALUES ('46', '0', '0', '0', '10000', '63', '1', '1', '368945', '0');
INSERT INTO `gametx11_auto` VALUES ('47', '0', '0', '0', '10000', '63', '1', '1', '368964', '0');
INSERT INTO `gametx11_auto` VALUES ('48', '0', '0', '0', '10000', '63', '1', '1', '368996', '0');
INSERT INTO `gametx11_auto` VALUES ('49', '0', '0', '0', '10000', '63', '1', '1', '369022', '0');
INSERT INTO `gametx11_auto` VALUES ('50', '0', '0', '0', '10000', '63', '1', '1', '369037', '0');
INSERT INTO `gametx11_auto` VALUES ('51', '0', '0', '0', '10000', '63', '1', '1', '369052', '0');
INSERT INTO `gametx11_auto` VALUES ('52', '0', '0', '0', '10000', '63', '1', '1', '369057', '0');
INSERT INTO `gametx11_auto` VALUES ('53', '0', '0', '0', '10000', '63', '1', '1', '369060', '0');
INSERT INTO `gametx11_auto` VALUES ('54', '0', '0', '0', '10000', '63', '1', '1', '369075', '0');
INSERT INTO `gametx11_auto` VALUES ('55', '0', '0', '0', '10000', '63', '1', '1', '369082', '0');
INSERT INTO `gametx11_auto` VALUES ('56', '0', '0', '0', '10000', '63', '1', '1', '369090', '0');
INSERT INTO `gametx11_auto` VALUES ('57', '0', '0', '0', '10000', '63', '1', '1', '369122', '0');
INSERT INTO `gametx11_auto` VALUES ('58', '0', '0', '0', '10000', '63', '1', '1', '369185', '0');
INSERT INTO `gametx11_auto` VALUES ('59', '0', '0', '0', '10000', '63', '1', '1', '369219', '0');
INSERT INTO `gametx11_auto` VALUES ('60', '0', '0', '0', '10000', '63', '1', '1', '369257', '0');
INSERT INTO `gametx11_auto` VALUES ('61', '0', '0', '0', '10000', '63', '1', '1', '369258', '0');
INSERT INTO `gametx11_auto` VALUES ('62', '0', '0', '0', '10000', '63', '1', '1', '369259', '0');
INSERT INTO `gametx11_auto` VALUES ('63', '0', '0', '0', '10000', '63', '1', '1', '369277', '0');
INSERT INTO `gametx11_auto` VALUES ('64', '0', '0', '0', '10000', '63', '1', '1', '369294', '0');
INSERT INTO `gametx11_auto` VALUES ('65', '0', '0', '0', '10000', '63', '1', '1', '369328', '0');
INSERT INTO `gametx11_auto` VALUES ('66', '0', '0', '0', '10000', '63', '1', '1', '369352', '0');
INSERT INTO `gametx11_auto` VALUES ('67', '0', '0', '0', '10000', '63', '1', '1', '369372', '0');
INSERT INTO `gametx11_auto` VALUES ('68', '0', '0', '0', '10000', '63', '1', '1', '369451', '0');
INSERT INTO `gametx11_auto` VALUES ('69', '0', '0', '0', '10000', '63', '1', '1', '369463', '0');
INSERT INTO `gametx11_auto` VALUES ('70', '0', '0', '0', '10000', '63', '1', '1', '369512', '0');
INSERT INTO `gametx11_auto` VALUES ('71', '0', '0', '0', '10000', '63', '1', '1', '369574', '0');
INSERT INTO `gametx11_auto` VALUES ('72', '0', '0', '0', '10000', '63', '1', '1', '369627', '0');
INSERT INTO `gametx11_auto` VALUES ('73', '0', '0', '0', '10000', '63', '1', '1', '369646', '0');
INSERT INTO `gametx11_auto` VALUES ('74', '0', '0', '0', '10000', '63', '1', '1', '369709', '0');
INSERT INTO `gametx11_auto` VALUES ('75', '0', '0', '0', '10000', '63', '1', '1', '369735', '0');
INSERT INTO `gametx11_auto` VALUES ('76', '0', '0', '0', '10000', '63', '1', '1', '369795', '0');
INSERT INTO `gametx11_auto` VALUES ('77', '0', '0', '0', '10000', '63', '1', '1', '369822', '0');
INSERT INTO `gametx11_auto` VALUES ('78', '0', '0', '0', '10000', '63', '1', '1', '369858', '0');
INSERT INTO `gametx11_auto` VALUES ('79', '0', '0', '0', '10000', '63', '1', '1', '369862', '0');
INSERT INTO `gametx11_auto` VALUES ('80', '0', '0', '0', '10000', '63', '1', '1', '369874', '0');
INSERT INTO `gametx11_auto` VALUES ('81', '0', '0', '0', '10000', '63', '1', '1', '369878', '0');
INSERT INTO `gametx11_auto` VALUES ('82', '0', '0', '0', '10000', '63', '1', '1', '369936', '0');
INSERT INTO `gametx11_auto` VALUES ('83', '0', '0', '0', '10000', '63', '1', '1', '369949', '0');
INSERT INTO `gametx11_auto` VALUES ('84', '0', '0', '0', '10000', '63', '1', '1', '369950', '0');
INSERT INTO `gametx11_auto` VALUES ('85', '0', '0', '0', '10000', '63', '1', '1', '369953', '0');
INSERT INTO `gametx11_auto` VALUES ('86', '0', '0', '0', '10000', '63', '1', '1', '370065', '0');
INSERT INTO `gametx11_auto` VALUES ('87', '0', '0', '0', '10000', '63', '1', '1', '370072', '0');
INSERT INTO `gametx11_auto` VALUES ('88', '0', '0', '0', '10000', '63', '1', '1', '370158', '0');
INSERT INTO `gametx11_auto` VALUES ('89', '0', '0', '0', '10000', '63', '1', '1', '370184', '0');
INSERT INTO `gametx11_auto` VALUES ('90', '0', '0', '0', '10000', '63', '1', '1', '370201', '0');
INSERT INTO `gametx11_auto` VALUES ('91', '0', '0', '0', '10000', '63', '1', '1', '370234', '0');
INSERT INTO `gametx11_auto` VALUES ('92', '0', '0', '0', '10000', '63', '1', '1', '370244', '0');
INSERT INTO `gametx11_auto` VALUES ('93', '0', '0', '0', '10000', '63', '1', '1', '370256', '0');
INSERT INTO `gametx11_auto` VALUES ('94', '0', '0', '0', '10000', '63', '1', '1', '370274', '0');
INSERT INTO `gametx11_auto` VALUES ('95', '0', '0', '0', '10000', '63', '1', '1', '370329', '0');
INSERT INTO `gametx11_auto` VALUES ('96', '0', '0', '0', '10000', '63', '1', '1', '370352', '0');
INSERT INTO `gametx11_auto` VALUES ('97', '0', '0', '0', '10000', '63', '1', '1', '370363', '0');
INSERT INTO `gametx11_auto` VALUES ('98', '0', '0', '0', '10000', '63', '1', '1', '370417', '0');
INSERT INTO `gametx11_auto` VALUES ('99', '0', '0', '0', '10000', '63', '1', '1', '370428', '0');
INSERT INTO `gametx11_auto` VALUES ('100', '0', '0', '0', '10000', '63', '1', '1', '370438', '0');
INSERT INTO `gametx11_auto` VALUES ('101', '0', '0', '0', '10000', '63', '1', '1', '370488', '0');
INSERT INTO `gametx11_auto` VALUES ('102', '0', '0', '0', '10000', '63', '1', '1', '370529', '0');
INSERT INTO `gametx11_auto` VALUES ('103', '0', '0', '0', '10000', '63', '1', '1', '370563', '0');
INSERT INTO `gametx11_auto` VALUES ('104', '0', '0', '0', '10000', '63', '1', '1', '370566', '0');
INSERT INTO `gametx11_auto` VALUES ('105', '0', '0', '0', '10000', '63', '1', '1', '370621', '0');
INSERT INTO `gametx11_auto` VALUES ('106', '0', '0', '0', '10000', '63', '1', '1', '370623', '0');
INSERT INTO `gametx11_auto` VALUES ('107', '0', '0', '0', '10000', '63', '1', '1', '370652', '0');
INSERT INTO `gametx11_auto` VALUES ('108', '0', '0', '0', '10000', '63', '1', '1', '370655', '0');
INSERT INTO `gametx11_auto` VALUES ('109', '0', '0', '0', '10000', '63', '1', '1', '370669', '0');
INSERT INTO `gametx11_auto` VALUES ('110', '0', '0', '0', '10000', '63', '1', '1', '370702', '0');
INSERT INTO `gametx11_auto` VALUES ('111', '0', '0', '0', '10000', '63', '1', '1', '370718', '0');
INSERT INTO `gametx11_auto` VALUES ('112', '0', '0', '0', '10000', '63', '1', '1', '370719', '0');
INSERT INTO `gametx11_auto` VALUES ('113', '0', '0', '0', '10000', '63', '1', '1', '370738', '0');
INSERT INTO `gametx11_auto` VALUES ('114', '0', '0', '0', '10000', '63', '1', '1', '370776', '0');
INSERT INTO `gametx11_auto` VALUES ('115', '0', '0', '0', '10000', '63', '1', '1', '370835', '0');
INSERT INTO `gametx11_auto` VALUES ('116', '0', '0', '0', '10000', '63', '1', '1', '370857', '0');
INSERT INTO `gametx11_auto` VALUES ('117', '0', '0', '0', '10000', '63', '1', '1', '370890', '0');
INSERT INTO `gametx11_auto` VALUES ('118', '0', '0', '0', '10000', '63', '1', '1', '370950', '0');
INSERT INTO `gametx11_auto` VALUES ('119', '0', '0', '0', '10000', '63', '1', '1', '370965', '0');
INSERT INTO `gametx11_auto` VALUES ('120', '0', '0', '0', '10000', '63', '1', '1', '371025', '0');
INSERT INTO `gametx11_auto` VALUES ('121', '0', '0', '0', '10000', '63', '1', '1', '371062', '0');
INSERT INTO `gametx11_auto` VALUES ('122', '0', '0', '0', '10000', '63', '1', '1', '371088', '0');
INSERT INTO `gametx11_auto` VALUES ('123', '0', '0', '0', '10000', '63', '1', '1', '371108', '0');
INSERT INTO `gametx11_auto` VALUES ('124', '0', '0', '0', '10000', '63', '1', '1', '371110', '0');
INSERT INTO `gametx11_auto` VALUES ('125', '0', '0', '0', '10000', '63', '1', '1', '371135', '0');
INSERT INTO `gametx11_auto` VALUES ('126', '0', '0', '0', '10000', '63', '1', '1', '371137', '0');
INSERT INTO `gametx11_auto` VALUES ('127', '0', '0', '0', '10000', '63', '1', '1', '371178', '0');
INSERT INTO `gametx11_auto` VALUES ('128', '0', '0', '0', '10000', '63', '1', '1', '371224', '0');
INSERT INTO `gametx11_auto` VALUES ('129', '0', '0', '0', '10000', '63', '1', '1', '371227', '0');
INSERT INTO `gametx11_auto` VALUES ('130', '0', '0', '0', '10000', '63', '1', '1', '371230', '0');
INSERT INTO `gametx11_auto` VALUES ('131', '0', '0', '0', '10000', '63', '1', '1', '371264', '0');
INSERT INTO `gametx11_auto` VALUES ('132', '0', '0', '0', '10000', '63', '1', '1', '371265', '0');
INSERT INTO `gametx11_auto` VALUES ('133', '0', '0', '0', '10000', '63', '1', '1', '371294', '0');
INSERT INTO `gametx11_auto` VALUES ('134', '0', '0', '0', '10000', '63', '1', '1', '371324', '0');
INSERT INTO `gametx11_auto` VALUES ('135', '0', '0', '0', '10000', '63', '1', '1', '371428', '0');
INSERT INTO `gametx11_auto` VALUES ('136', '0', '0', '0', '10000', '63', '1', '1', '371488', '0');
INSERT INTO `gametx11_auto` VALUES ('137', '0', '0', '0', '10000', '63', '1', '1', '371555', '0');
INSERT INTO `gametx11_auto` VALUES ('138', '0', '0', '0', '10000', '63', '1', '1', '371567', '0');
INSERT INTO `gametx11_auto` VALUES ('139', '0', '0', '0', '10000', '63', '1', '1', '371583', '0');
INSERT INTO `gametx11_auto` VALUES ('140', '0', '0', '0', '10000', '63', '1', '1', '371615', '0');
INSERT INTO `gametx11_auto` VALUES ('141', '0', '0', '0', '10000', '63', '1', '1', '371616', '0');
INSERT INTO `gametx11_auto` VALUES ('142', '0', '0', '0', '10000', '63', '1', '1', '371722', '0');
INSERT INTO `gametx11_auto` VALUES ('143', '0', '0', '0', '10000', '63', '1', '1', '371729', '0');
INSERT INTO `gametx11_auto` VALUES ('144', '0', '0', '0', '10000', '63', '1', '1', '371820', '0');
INSERT INTO `gametx11_auto` VALUES ('145', '0', '0', '0', '10000', '63', '1', '1', '371913', '0');
INSERT INTO `gametx11_auto` VALUES ('146', '0', '0', '0', '10000', '63', '1', '1', '371952', '0');
INSERT INTO `gametx11_auto` VALUES ('147', '0', '0', '0', '10000', '63', '1', '1', '371969', '0');
INSERT INTO `gametx11_auto` VALUES ('148', '0', '0', '0', '10000', '63', '1', '1', '372007', '0');
INSERT INTO `gametx11_auto` VALUES ('149', '0', '0', '0', '10000', '63', '1', '1', '372019', '0');
INSERT INTO `gametx11_auto` VALUES ('150', '0', '0', '0', '10000', '63', '1', '1', '372049', '0');
INSERT INTO `gametx11_auto` VALUES ('151', '0', '0', '0', '10000', '63', '1', '1', '372059', '0');
INSERT INTO `gametx11_auto` VALUES ('152', '0', '0', '0', '10000', '63', '1', '1', '372060', '0');
INSERT INTO `gametx11_auto` VALUES ('153', '0', '0', '0', '10000', '63', '1', '1', '372067', '0');
INSERT INTO `gametx11_auto` VALUES ('154', '0', '0', '0', '10000', '63', '1', '1', '372080', '0');
INSERT INTO `gametx11_auto` VALUES ('155', '0', '0', '0', '10000', '63', '1', '1', '372112', '0');
INSERT INTO `gametx11_auto` VALUES ('156', '0', '0', '0', '10000', '63', '1', '1', '372117', '0');
INSERT INTO `gametx11_auto` VALUES ('157', '0', '0', '0', '10000', '63', '1', '1', '372128', '0');
INSERT INTO `gametx11_auto` VALUES ('158', '0', '0', '0', '10000', '63', '1', '1', '372175', '0');
INSERT INTO `gametx11_auto` VALUES ('159', '0', '0', '0', '10000', '63', '1', '1', '372349', '0');
INSERT INTO `gametx11_auto` VALUES ('160', '0', '0', '0', '10000', '63', '1', '1', '372372', '0');
INSERT INTO `gametx11_auto` VALUES ('161', '0', '0', '0', '10000', '63', '1', '1', '372382', '0');
INSERT INTO `gametx11_auto` VALUES ('162', '0', '0', '0', '10000', '63', '1', '1', '372399', '0');
INSERT INTO `gametx11_auto` VALUES ('163', '0', '0', '0', '10000', '63', '1', '1', '372417', '0');
INSERT INTO `gametx11_auto` VALUES ('164', '0', '0', '0', '10000', '63', '1', '1', '372449', '0');
INSERT INTO `gametx11_auto` VALUES ('165', '0', '0', '0', '10000', '63', '1', '1', '372461', '0');
INSERT INTO `gametx11_auto` VALUES ('166', '0', '0', '0', '10000', '63', '1', '1', '372470', '0');
INSERT INTO `gametx11_auto` VALUES ('167', '0', '0', '0', '10000', '63', '1', '1', '372504', '0');
INSERT INTO `gametx11_auto` VALUES ('168', '0', '0', '0', '10000', '63', '1', '1', '372519', '0');
INSERT INTO `gametx11_auto` VALUES ('169', '0', '0', '0', '10000', '63', '1', '1', '372521', '0');
INSERT INTO `gametx11_auto` VALUES ('170', '0', '0', '0', '10000', '63', '1', '1', '372552', '0');
INSERT INTO `gametx11_auto` VALUES ('171', '0', '0', '0', '10000', '63', '1', '1', '372576', '0');
INSERT INTO `gametx11_auto` VALUES ('172', '0', '0', '0', '10000', '63', '1', '1', '372578', '0');
INSERT INTO `gametx11_auto` VALUES ('173', '0', '0', '0', '10000', '63', '1', '1', '372588', '0');
INSERT INTO `gametx11_auto` VALUES ('174', '0', '0', '0', '10000', '63', '1', '1', '372611', '0');
INSERT INTO `gametx11_auto` VALUES ('175', '0', '0', '0', '10000', '63', '1', '1', '372638', '0');
INSERT INTO `gametx11_auto` VALUES ('176', '0', '0', '0', '10000', '63', '1', '1', '372640', '0');
INSERT INTO `gametx11_auto` VALUES ('177', '0', '0', '0', '10000', '63', '1', '1', '372655', '0');
INSERT INTO `gametx11_auto` VALUES ('178', '0', '0', '0', '10000', '63', '1', '1', '372672', '0');
INSERT INTO `gametx11_auto` VALUES ('179', '0', '0', '0', '10000', '63', '1', '1', '372681', '0');
INSERT INTO `gametx11_auto` VALUES ('180', '0', '0', '0', '10000', '63', '1', '1', '372714', '0');
INSERT INTO `gametx11_auto` VALUES ('181', '0', '0', '0', '10000', '63', '1', '1', '372736', '0');
INSERT INTO `gametx11_auto` VALUES ('182', '0', '0', '0', '10000', '63', '1', '1', '372774', '0');
INSERT INTO `gametx11_auto` VALUES ('183', '0', '0', '0', '10000', '63', '1', '1', '372786', '0');
INSERT INTO `gametx11_auto` VALUES ('184', '0', '0', '0', '10000', '63', '1', '1', '372807', '0');
INSERT INTO `gametx11_auto` VALUES ('185', '0', '0', '0', '10000', '63', '1', '1', '372812', '0');
INSERT INTO `gametx11_auto` VALUES ('186', '0', '0', '0', '10000', '63', '1', '1', '372861', '0');
INSERT INTO `gametx11_auto` VALUES ('187', '0', '0', '0', '10000', '63', '1', '1', '372862', '0');
INSERT INTO `gametx11_auto` VALUES ('188', '0', '0', '0', '10000', '63', '1', '1', '372908', '0');
INSERT INTO `gametx11_auto` VALUES ('189', '0', '0', '0', '10000', '63', '1', '1', '372964', '0');
INSERT INTO `gametx11_auto` VALUES ('190', '0', '0', '0', '10000', '63', '1', '1', '372988', '0');
INSERT INTO `gametx11_auto` VALUES ('191', '0', '0', '0', '10000', '63', '1', '1', '373010', '0');
INSERT INTO `gametx11_auto` VALUES ('192', '0', '0', '0', '10000', '63', '1', '1', '373014', '0');
INSERT INTO `gametx11_auto` VALUES ('193', '0', '0', '0', '10000', '63', '1', '1', '373016', '0');
INSERT INTO `gametx11_auto` VALUES ('194', '0', '0', '0', '10000', '63', '1', '1', '373034', '0');
INSERT INTO `gametx11_auto` VALUES ('195', '0', '0', '0', '10000', '63', '1', '1', '373089', '0');
INSERT INTO `gametx11_auto` VALUES ('196', '0', '0', '0', '10000', '63', '1', '1', '373112', '0');
INSERT INTO `gametx11_auto` VALUES ('197', '0', '0', '0', '10000', '63', '1', '1', '373119', '0');
INSERT INTO `gametx11_auto` VALUES ('198', '0', '0', '0', '10000', '63', '1', '1', '373149', '0');
INSERT INTO `gametx11_auto` VALUES ('199', '0', '0', '0', '10000', '63', '1', '1', '373151', '0');
INSERT INTO `gametx11_auto` VALUES ('200', '0', '0', '0', '10000', '63', '1', '1', '373213', '0');
INSERT INTO `gametx11_auto` VALUES ('201', '0', '0', '0', '10000', '63', '1', '1', '373229', '0');
INSERT INTO `gametx11_auto` VALUES ('202', '0', '0', '0', '10000', '63', '1', '1', '373263', '0');
INSERT INTO `gametx11_auto` VALUES ('203', '0', '0', '0', '10000', '63', '1', '1', '373299', '0');
INSERT INTO `gametx11_auto` VALUES ('204', '0', '0', '0', '10000', '63', '1', '1', '373325', '0');
INSERT INTO `gametx11_auto` VALUES ('205', '0', '0', '0', '10000', '63', '1', '1', '373330', '0');
INSERT INTO `gametx11_auto` VALUES ('206', '0', '0', '0', '10000', '63', '1', '1', '373395', '0');
INSERT INTO `gametx11_auto` VALUES ('207', '0', '0', '0', '10000', '63', '1', '1', '373452', '0');
INSERT INTO `gametx11_auto` VALUES ('208', '0', '0', '0', '10000', '63', '1', '1', '373459', '0');
INSERT INTO `gametx11_auto` VALUES ('209', '0', '0', '0', '10000', '63', '1', '1', '373498', '0');
INSERT INTO `gametx11_auto` VALUES ('210', '0', '0', '0', '10000', '63', '1', '1', '373519', '0');
INSERT INTO `gametx11_auto` VALUES ('211', '0', '0', '0', '10000', '63', '1', '1', '373524', '0');
INSERT INTO `gametx11_auto` VALUES ('212', '0', '0', '0', '10000', '63', '1', '1', '373559', '0');
INSERT INTO `gametx11_auto` VALUES ('213', '0', '0', '0', '10000', '63', '1', '1', '373570', '0');
INSERT INTO `gametx11_auto` VALUES ('214', '0', '0', '0', '10000', '63', '1', '1', '373579', '0');
INSERT INTO `gametx11_auto` VALUES ('215', '0', '0', '0', '10000', '63', '1', '1', '373600', '0');
INSERT INTO `gametx11_auto` VALUES ('216', '0', '0', '0', '10000', '63', '1', '1', '373646', '0');
INSERT INTO `gametx11_auto` VALUES ('217', '0', '0', '0', '10000', '63', '1', '1', '373659', '0');
INSERT INTO `gametx11_auto` VALUES ('218', '0', '0', '0', '10000', '63', '1', '1', '373679', '0');
INSERT INTO `gametx11_auto` VALUES ('219', '0', '0', '0', '10000', '63', '1', '1', '373728', '0');
INSERT INTO `gametx11_auto` VALUES ('220', '0', '0', '0', '10000', '63', '1', '1', '373752', '0');
INSERT INTO `gametx11_auto` VALUES ('221', '0', '0', '0', '10000', '63', '1', '1', '373753', '0');
INSERT INTO `gametx11_auto` VALUES ('222', '0', '0', '0', '10000', '63', '1', '1', '373761', '0');
INSERT INTO `gametx11_auto` VALUES ('223', '0', '0', '0', '10000', '63', '1', '1', '373777', '0');
INSERT INTO `gametx11_auto` VALUES ('224', '0', '0', '0', '10000', '63', '1', '1', '373821', '0');
INSERT INTO `gametx11_auto` VALUES ('225', '0', '0', '0', '10000', '63', '1', '1', '373857', '0');
INSERT INTO `gametx11_auto` VALUES ('226', '0', '0', '0', '10000', '63', '1', '1', '373880', '0');
INSERT INTO `gametx11_auto` VALUES ('227', '0', '0', '0', '10000', '63', '1', '1', '373881', '0');
INSERT INTO `gametx11_auto` VALUES ('228', '0', '0', '0', '10000', '63', '1', '1', '373938', '0');
INSERT INTO `gametx11_auto` VALUES ('229', '0', '0', '0', '10000', '63', '1', '1', '373974', '0');
INSERT INTO `gametx11_auto` VALUES ('230', '0', '0', '0', '10000', '63', '1', '1', '373981', '0');
INSERT INTO `gametx11_auto` VALUES ('231', '0', '0', '0', '10000', '63', '1', '1', '374012', '0');
INSERT INTO `gametx11_auto` VALUES ('232', '0', '0', '0', '10000', '63', '1', '1', '374026', '0');
INSERT INTO `gametx11_auto` VALUES ('233', '0', '0', '0', '10000', '63', '1', '1', '374056', '0');
INSERT INTO `gametx11_auto` VALUES ('234', '0', '0', '0', '10000', '63', '1', '1', '374057', '0');
INSERT INTO `gametx11_auto` VALUES ('235', '0', '0', '0', '10000', '63', '1', '1', '374111', '0');
INSERT INTO `gametx11_auto` VALUES ('236', '0', '0', '0', '10000', '63', '1', '1', '374124', '0');
INSERT INTO `gametx11_auto` VALUES ('237', '0', '0', '0', '10000', '63', '1', '1', '374126', '0');
INSERT INTO `gametx11_auto` VALUES ('238', '0', '0', '0', '10000', '63', '1', '1', '374142', '0');
INSERT INTO `gametx11_auto` VALUES ('239', '0', '0', '0', '10000', '63', '1', '1', '374214', '0');
INSERT INTO `gametx11_auto` VALUES ('240', '0', '0', '0', '10000', '63', '1', '1', '374226', '0');
INSERT INTO `gametx11_auto` VALUES ('241', '0', '0', '0', '10000', '63', '1', '1', '374250', '0');
INSERT INTO `gametx11_auto` VALUES ('242', '0', '0', '0', '10000', '63', '1', '1', '374278', '0');
INSERT INTO `gametx11_auto` VALUES ('243', '0', '0', '0', '10000', '63', '1', '1', '374332', '0');
INSERT INTO `gametx11_auto` VALUES ('244', '0', '0', '0', '10000', '63', '1', '1', '374366', '0');
INSERT INTO `gametx11_auto` VALUES ('245', '0', '0', '0', '10000', '63', '1', '1', '374368', '0');
INSERT INTO `gametx11_auto` VALUES ('246', '0', '0', '0', '10000', '63', '1', '1', '374383', '0');
INSERT INTO `gametx11_auto` VALUES ('247', '0', '0', '0', '10000', '63', '1', '1', '374453', '0');
INSERT INTO `gametx11_auto` VALUES ('248', '0', '0', '0', '10000', '63', '1', '1', '374457', '0');
INSERT INTO `gametx11_auto` VALUES ('249', '0', '0', '0', '10000', '63', '1', '1', '374527', '0');
INSERT INTO `gametx11_auto` VALUES ('250', '0', '0', '0', '10000', '63', '1', '1', '374530', '0');
INSERT INTO `gametx11_auto` VALUES ('256', '0', '0', '0', '10000', '64', '1', '1', '248699', '0');
INSERT INTO `gametx11_auto` VALUES ('257', '0', '0', '0', '10000', '64', '1', '1', '248715', '0');
INSERT INTO `gametx11_auto` VALUES ('258', '0', '0', '0', '10000', '64', '1', '1', '248727', '0');
INSERT INTO `gametx11_auto` VALUES ('259', '0', '0', '0', '10000', '64', '1', '1', '248750', '0');
INSERT INTO `gametx11_auto` VALUES ('260', '0', '0', '0', '10000', '64', '1', '1', '248781', '0');
INSERT INTO `gametx11_auto` VALUES ('261', '0', '0', '0', '10000', '64', '1', '1', '248796', '0');
INSERT INTO `gametx11_auto` VALUES ('262', '0', '0', '0', '10000', '64', '1', '1', '248817', '0');
INSERT INTO `gametx11_auto` VALUES ('263', '0', '0', '0', '10000', '64', '1', '1', '248839', '0');
INSERT INTO `gametx11_auto` VALUES ('264', '0', '0', '0', '10000', '64', '1', '1', '248883', '0');
INSERT INTO `gametx11_auto` VALUES ('265', '0', '0', '0', '10000', '64', '1', '1', '248896', '0');
INSERT INTO `gametx11_auto` VALUES ('266', '0', '0', '0', '10000', '64', '1', '1', '248901', '0');
INSERT INTO `gametx11_auto` VALUES ('267', '0', '0', '0', '10000', '64', '1', '1', '248904', '0');
INSERT INTO `gametx11_auto` VALUES ('268', '0', '0', '0', '10000', '64', '1', '1', '248942', '0');
INSERT INTO `gametx11_auto` VALUES ('269', '0', '0', '0', '10000', '64', '1', '1', '248964', '0');
INSERT INTO `gametx11_auto` VALUES ('270', '0', '0', '0', '10000', '64', '1', '1', '249001', '0');
INSERT INTO `gametx11_auto` VALUES ('271', '0', '0', '0', '10000', '64', '1', '1', '249071', '0');
INSERT INTO `gametx11_auto` VALUES ('272', '0', '0', '0', '10000', '64', '1', '1', '249077', '0');
INSERT INTO `gametx11_auto` VALUES ('273', '0', '0', '0', '10000', '64', '1', '1', '249095', '0');
INSERT INTO `gametx11_auto` VALUES ('274', '0', '0', '0', '10000', '64', '1', '1', '249108', '0');
INSERT INTO `gametx11_auto` VALUES ('275', '0', '0', '0', '10000', '64', '1', '1', '249113', '0');
INSERT INTO `gametx11_auto` VALUES ('276', '0', '0', '0', '10000', '64', '1', '1', '249127', '0');
INSERT INTO `gametx11_auto` VALUES ('277', '0', '0', '0', '10000', '64', '1', '1', '249153', '0');
INSERT INTO `gametx11_auto` VALUES ('278', '0', '0', '0', '10000', '64', '1', '1', '249203', '0');
INSERT INTO `gametx11_auto` VALUES ('279', '0', '0', '0', '10000', '64', '1', '1', '249214', '0');
INSERT INTO `gametx11_auto` VALUES ('280', '0', '0', '0', '10000', '64', '1', '1', '249283', '0');
INSERT INTO `gametx11_auto` VALUES ('281', '0', '0', '0', '10000', '64', '1', '1', '249339', '0');
INSERT INTO `gametx11_auto` VALUES ('282', '0', '0', '0', '10000', '64', '1', '1', '249347', '0');
INSERT INTO `gametx11_auto` VALUES ('283', '0', '0', '0', '10000', '64', '1', '1', '249374', '0');
INSERT INTO `gametx11_auto` VALUES ('284', '0', '0', '0', '10000', '64', '1', '1', '249387', '0');
INSERT INTO `gametx11_auto` VALUES ('285', '0', '0', '0', '10000', '64', '1', '1', '249415', '0');
INSERT INTO `gametx11_auto` VALUES ('286', '0', '0', '0', '10000', '64', '1', '1', '249432', '0');
INSERT INTO `gametx11_auto` VALUES ('287', '0', '0', '0', '10000', '64', '1', '1', '249442', '0');
INSERT INTO `gametx11_auto` VALUES ('288', '0', '0', '0', '10000', '64', '1', '1', '249487', '0');
INSERT INTO `gametx11_auto` VALUES ('289', '0', '0', '0', '10000', '64', '1', '1', '249503', '0');
INSERT INTO `gametx11_auto` VALUES ('290', '0', '0', '0', '10000', '64', '1', '1', '249509', '0');
INSERT INTO `gametx11_auto` VALUES ('291', '0', '0', '0', '10000', '64', '1', '1', '249516', '0');
INSERT INTO `gametx11_auto` VALUES ('292', '0', '0', '0', '10000', '64', '1', '1', '249520', '0');
INSERT INTO `gametx11_auto` VALUES ('293', '0', '0', '0', '10000', '64', '1', '1', '249529', '0');
INSERT INTO `gametx11_auto` VALUES ('294', '0', '0', '0', '10000', '64', '1', '1', '249540', '0');
INSERT INTO `gametx11_auto` VALUES ('295', '0', '0', '0', '10000', '64', '1', '1', '249562', '0');
INSERT INTO `gametx11_auto` VALUES ('296', '0', '0', '0', '10000', '64', '1', '1', '249570', '0');
INSERT INTO `gametx11_auto` VALUES ('297', '0', '0', '0', '10000', '64', '1', '1', '249630', '0');
INSERT INTO `gametx11_auto` VALUES ('298', '0', '0', '0', '10000', '64', '1', '1', '249657', '0');
INSERT INTO `gametx11_auto` VALUES ('299', '0', '0', '0', '10000', '64', '1', '1', '249663', '0');
INSERT INTO `gametx11_auto` VALUES ('300', '0', '0', '0', '10000', '64', '1', '1', '249704', '0');
INSERT INTO `gametx11_auto` VALUES ('301', '0', '0', '0', '10000', '64', '1', '1', '249714', '0');
INSERT INTO `gametx11_auto` VALUES ('302', '0', '0', '0', '10000', '64', '1', '1', '249717', '0');
INSERT INTO `gametx11_auto` VALUES ('303', '0', '0', '0', '10000', '64', '1', '1', '249797', '0');
INSERT INTO `gametx11_auto` VALUES ('304', '0', '0', '0', '10000', '64', '1', '1', '249824', '0');
INSERT INTO `gametx11_auto` VALUES ('305', '0', '0', '0', '10000', '64', '1', '1', '249845', '0');


-- ----------------------------
-- Table structure for gametx16_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx16_auto`;
CREATE TABLE `gametx16_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=419 DEFAULT CHARSET=utf8 COMMENT='腾讯16自动投注';

-- ----------------------------
-- Records of gametx16_auto
-- ----------------------------
INSERT INTO `gametx16_auto` VALUES ('1', '0', '0', '0', '10000', '65', '1', '1', '249863', '0');
INSERT INTO `gametx16_auto` VALUES ('2', '0', '0', '0', '10000', '65', '1', '1', '249885', '0');
INSERT INTO `gametx16_auto` VALUES ('3', '0', '0', '0', '10000', '65', '1', '1', '249951', '0');
INSERT INTO `gametx16_auto` VALUES ('4', '0', '0', '0', '10000', '65', '1', '1', '249974', '0');
INSERT INTO `gametx16_auto` VALUES ('5', '0', '0', '0', '10000', '65', '1', '1', '250047', '0');
INSERT INTO `gametx16_auto` VALUES ('6', '0', '0', '0', '10000', '65', '1', '1', '250108', '0');
INSERT INTO `gametx16_auto` VALUES ('7', '0', '0', '0', '10000', '65', '1', '1', '250160', '0');
INSERT INTO `gametx16_auto` VALUES ('8', '0', '0', '0', '10000', '65', '1', '1', '250173', '0');
INSERT INTO `gametx16_auto` VALUES ('9', '0', '0', '0', '10000', '65', '1', '1', '250195', '0');
INSERT INTO `gametx16_auto` VALUES ('10', '0', '0', '0', '10000', '65', '1', '1', '250228', '0');
INSERT INTO `gametx16_auto` VALUES ('11', '0', '0', '0', '10000', '65', '1', '1', '250246', '0');
INSERT INTO `gametx16_auto` VALUES ('12', '0', '0', '0', '10000', '65', '1', '1', '250248', '0');
INSERT INTO `gametx16_auto` VALUES ('13', '0', '0', '0', '10000', '65', '1', '1', '250251', '0');
INSERT INTO `gametx16_auto` VALUES ('14', '0', '0', '0', '10000', '65', '1', '1', '250291', '0');
INSERT INTO `gametx16_auto` VALUES ('15', '0', '0', '0', '10000', '65', '1', '1', '250316', '0');
INSERT INTO `gametx16_auto` VALUES ('16', '0', '0', '0', '10000', '65', '1', '1', '250350', '0');
INSERT INTO `gametx16_auto` VALUES ('17', '0', '0', '0', '10000', '65', '1', '1', '250381', '0');
INSERT INTO `gametx16_auto` VALUES ('18', '0', '0', '0', '10000', '65', '1', '1', '250418', '0');
INSERT INTO `gametx16_auto` VALUES ('19', '0', '0', '0', '10000', '65', '1', '1', '250457', '0');
INSERT INTO `gametx16_auto` VALUES ('20', '0', '0', '0', '10000', '65', '1', '1', '250486', '0');
INSERT INTO `gametx16_auto` VALUES ('21', '0', '0', '0', '10000', '65', '1', '1', '250498', '0');
INSERT INTO `gametx16_auto` VALUES ('22', '0', '0', '0', '10000', '65', '1', '1', '250544', '0');
INSERT INTO `gametx16_auto` VALUES ('23', '0', '0', '0', '10000', '65', '1', '1', '250552', '0');
INSERT INTO `gametx16_auto` VALUES ('24', '0', '0', '0', '10000', '65', '1', '1', '250581', '0');
INSERT INTO `gametx16_auto` VALUES ('25', '0', '0', '0', '10000', '65', '1', '1', '250601', '0');
INSERT INTO `gametx16_auto` VALUES ('26', '0', '0', '0', '10000', '65', '1', '1', '250651', '0');
INSERT INTO `gametx16_auto` VALUES ('27', '0', '0', '0', '10000', '65', '1', '1', '250656', '0');
INSERT INTO `gametx16_auto` VALUES ('28', '0', '0', '0', '10000', '65', '1', '1', '250666', '0');
INSERT INTO `gametx16_auto` VALUES ('29', '0', '0', '0', '10000', '65', '1', '1', '250697', '0');
INSERT INTO `gametx16_auto` VALUES ('30', '0', '0', '0', '10000', '65', '1', '1', '250723', '0');
INSERT INTO `gametx16_auto` VALUES ('31', '0', '0', '0', '10000', '65', '1', '1', '250748', '0');
INSERT INTO `gametx16_auto` VALUES ('32', '0', '0', '0', '10000', '65', '1', '1', '250761', '0');
INSERT INTO `gametx16_auto` VALUES ('33', '0', '0', '0', '10000', '65', '1', '1', '250778', '0');
INSERT INTO `gametx16_auto` VALUES ('34', '0', '0', '0', '10000', '65', '1', '1', '250841', '0');
INSERT INTO `gametx16_auto` VALUES ('35', '0', '0', '0', '10000', '65', '1', '1', '250867', '0');
INSERT INTO `gametx16_auto` VALUES ('36', '0', '0', '0', '10000', '65', '1', '1', '250876', '0');
INSERT INTO `gametx16_auto` VALUES ('37', '0', '0', '0', '10000', '65', '1', '1', '250890', '0');
INSERT INTO `gametx16_auto` VALUES ('38', '0', '0', '0', '10000', '65', '1', '1', '250917', '0');
INSERT INTO `gametx16_auto` VALUES ('39', '0', '0', '0', '10000', '65', '1', '1', '250933', '0');
INSERT INTO `gametx16_auto` VALUES ('40', '0', '0', '0', '10000', '65', '1', '1', '250942', '0');
INSERT INTO `gametx16_auto` VALUES ('41', '0', '0', '0', '10000', '65', '1', '1', '250955', '0');
INSERT INTO `gametx16_auto` VALUES ('42', '0', '0', '0', '10000', '65', '1', '1', '250969', '0');
INSERT INTO `gametx16_auto` VALUES ('43', '0', '0', '0', '10000', '65', '1', '1', '250987', '0');
INSERT INTO `gametx16_auto` VALUES ('44', '0', '0', '0', '10000', '65', '1', '1', '250990', '0');
INSERT INTO `gametx16_auto` VALUES ('45', '0', '0', '0', '10000', '65', '1', '1', '251006', '0');
INSERT INTO `gametx16_auto` VALUES ('46', '0', '0', '0', '10000', '65', '1', '1', '251020', '0');
INSERT INTO `gametx16_auto` VALUES ('47', '0', '0', '0', '10000', '65', '1', '1', '251022', '0');
INSERT INTO `gametx16_auto` VALUES ('48', '0', '0', '0', '10000', '65', '1', '1', '251024', '0');
INSERT INTO `gametx16_auto` VALUES ('49', '0', '0', '0', '10000', '65', '1', '1', '251030', '0');
INSERT INTO `gametx16_auto` VALUES ('50', '0', '0', '0', '10000', '65', '1', '1', '251042', '0');
INSERT INTO `gametx16_auto` VALUES ('51', '0', '0', '0', '10000', '65', '1', '1', '251073', '0');
INSERT INTO `gametx16_auto` VALUES ('52', '0', '0', '0', '10000', '65', '1', '1', '251080', '0');
INSERT INTO `gametx16_auto` VALUES ('53', '0', '0', '0', '10000', '65', '1', '1', '251090', '0');
INSERT INTO `gametx16_auto` VALUES ('54', '0', '0', '0', '10000', '65', '1', '1', '251124', '0');
INSERT INTO `gametx16_auto` VALUES ('55', '0', '0', '0', '10000', '65', '1', '1', '251127', '0');
INSERT INTO `gametx16_auto` VALUES ('56', '0', '0', '0', '10000', '65', '1', '1', '251144', '0');
INSERT INTO `gametx16_auto` VALUES ('57', '0', '0', '0', '10000', '65', '1', '1', '251155', '0');
INSERT INTO `gametx16_auto` VALUES ('58', '0', '0', '0', '10000', '65', '1', '1', '251172', '0');
INSERT INTO `gametx16_auto` VALUES ('59', '0', '0', '0', '10000', '65', '1', '1', '251195', '0');
INSERT INTO `gametx16_auto` VALUES ('60', '0', '0', '0', '10000', '65', '1', '1', '251205', '0');
INSERT INTO `gametx16_auto` VALUES ('61', '0', '0', '0', '10000', '65', '1', '1', '251223', '0');
INSERT INTO `gametx16_auto` VALUES ('62', '0', '0', '0', '10000', '65', '1', '1', '251263', '0');
INSERT INTO `gametx16_auto` VALUES ('63', '0', '0', '0', '10000', '65', '1', '1', '251265', '0');
INSERT INTO `gametx16_auto` VALUES ('64', '0', '0', '0', '10000', '65', '1', '1', '251288', '0');
INSERT INTO `gametx16_auto` VALUES ('65', '0', '0', '0', '10000', '65', '1', '1', '251293', '0');
INSERT INTO `gametx16_auto` VALUES ('66', '0', '0', '0', '10000', '65', '1', '1', '251295', '0');
INSERT INTO `gametx16_auto` VALUES ('67', '0', '0', '0', '10000', '65', '1', '1', '251333', '0');
INSERT INTO `gametx16_auto` VALUES ('68', '0', '0', '0', '10000', '65', '1', '1', '251338', '0');
INSERT INTO `gametx16_auto` VALUES ('69', '0', '0', '0', '10000', '65', '1', '1', '251351', '0');
INSERT INTO `gametx16_auto` VALUES ('70', '0', '0', '0', '10000', '65', '1', '1', '251373', '0');
INSERT INTO `gametx16_auto` VALUES ('71', '0', '0', '0', '10000', '65', '1', '1', '251381', '0');
INSERT INTO `gametx16_auto` VALUES ('72', '0', '0', '0', '10000', '65', '1', '1', '251437', '0');
INSERT INTO `gametx16_auto` VALUES ('73', '0', '0', '0', '10000', '65', '1', '1', '251462', '0');
INSERT INTO `gametx16_auto` VALUES ('74', '0', '0', '0', '10000', '65', '1', '1', '251463', '0');
INSERT INTO `gametx16_auto` VALUES ('75', '0', '0', '0', '10000', '65', '1', '1', '251492', '0');
INSERT INTO `gametx16_auto` VALUES ('76', '0', '0', '0', '10000', '65', '1', '1', '251527', '0');
INSERT INTO `gametx16_auto` VALUES ('77', '0', '0', '0', '10000', '65', '1', '1', '251533', '0');
INSERT INTO `gametx16_auto` VALUES ('78', '0', '0', '0', '10000', '65', '1', '1', '251589', '0');
INSERT INTO `gametx16_auto` VALUES ('79', '0', '0', '0', '10000', '65', '1', '1', '251609', '0');
INSERT INTO `gametx16_auto` VALUES ('80', '0', '0', '0', '10000', '65', '1', '1', '251615', '0');
INSERT INTO `gametx16_auto` VALUES ('81', '0', '0', '0', '10000', '65', '1', '1', '251628', '0');
INSERT INTO `gametx16_auto` VALUES ('82', '0', '0', '0', '10000', '65', '1', '1', '251636', '0');
INSERT INTO `gametx16_auto` VALUES ('83', '0', '0', '0', '10000', '65', '1', '1', '251672', '0');
INSERT INTO `gametx16_auto` VALUES ('84', '0', '0', '0', '10000', '65', '1', '1', '251729', '0');
INSERT INTO `gametx16_auto` VALUES ('85', '0', '0', '0', '10000', '65', '1', '1', '251746', '0');
INSERT INTO `gametx16_auto` VALUES ('86', '0', '0', '0', '10000', '65', '1', '1', '251750', '0');
INSERT INTO `gametx16_auto` VALUES ('87', '0', '0', '0', '10000', '65', '1', '1', '251768', '0');
INSERT INTO `gametx16_auto` VALUES ('88', '0', '0', '0', '10000', '65', '1', '1', '251774', '0');
INSERT INTO `gametx16_auto` VALUES ('89', '0', '0', '0', '10000', '65', '1', '1', '251829', '0');
INSERT INTO `gametx16_auto` VALUES ('90', '0', '0', '0', '10000', '65', '1', '1', '251845', '0');
INSERT INTO `gametx16_auto` VALUES ('91', '0', '0', '0', '10000', '65', '1', '1', '251856', '0');
INSERT INTO `gametx16_auto` VALUES ('92', '0', '0', '0', '10000', '65', '1', '1', '251879', '0');
INSERT INTO `gametx16_auto` VALUES ('93', '0', '0', '0', '10000', '65', '1', '1', '251899', '0');
INSERT INTO `gametx16_auto` VALUES ('94', '0', '0', '0', '10000', '65', '1', '1', '251917', '0');
INSERT INTO `gametx16_auto` VALUES ('95', '0', '0', '0', '10000', '65', '1', '1', '251934', '0');
INSERT INTO `gametx16_auto` VALUES ('96', '0', '0', '0', '10000', '65', '1', '1', '252001', '0');
INSERT INTO `gametx16_auto` VALUES ('97', '0', '0', '0', '10000', '65', '1', '1', '252025', '0');
INSERT INTO `gametx16_auto` VALUES ('98', '0', '0', '0', '10000', '65', '1', '1', '252034', '0');
INSERT INTO `gametx16_auto` VALUES ('99', '0', '0', '0', '10000', '65', '1', '1', '252094', '0');
INSERT INTO `gametx16_auto` VALUES ('100', '0', '0', '0', '10000', '65', '1', '1', '252128', '0');
INSERT INTO `gametx16_auto` VALUES ('101', '0', '0', '0', '10000', '65', '1', '1', '252201', '0');
INSERT INTO `gametx16_auto` VALUES ('102', '0', '0', '0', '10000', '65', '1', '1', '252213', '0');
INSERT INTO `gametx16_auto` VALUES ('103', '0', '0', '0', '10000', '65', '1', '1', '252248', '0');
INSERT INTO `gametx16_auto` VALUES ('104', '0', '0', '0', '10000', '65', '1', '1', '252280', '0');
INSERT INTO `gametx16_auto` VALUES ('105', '0', '0', '0', '10000', '65', '1', '1', '252281', '0');
INSERT INTO `gametx16_auto` VALUES ('106', '0', '0', '0', '10000', '65', '1', '1', '252387', '0');
INSERT INTO `gametx16_auto` VALUES ('107', '0', '0', '0', '10000', '65', '1', '1', '252436', '0');
INSERT INTO `gametx16_auto` VALUES ('108', '0', '0', '0', '10000', '65', '1', '1', '252490', '0');
INSERT INTO `gametx16_auto` VALUES ('109', '0', '0', '0', '10000', '65', '1', '1', '252498', '0');
INSERT INTO `gametx16_auto` VALUES ('110', '0', '0', '0', '10000', '65', '1', '1', '252535', '0');
INSERT INTO `gametx16_auto` VALUES ('111', '0', '0', '0', '10000', '65', '1', '1', '252615', '0');
INSERT INTO `gametx16_auto` VALUES ('112', '0', '0', '0', '10000', '65', '1', '1', '252633', '0');
INSERT INTO `gametx16_auto` VALUES ('113', '0', '0', '0', '10000', '65', '1', '1', '252635', '0');
INSERT INTO `gametx16_auto` VALUES ('114', '0', '0', '0', '10000', '65', '1', '1', '252768', '0');
INSERT INTO `gametx16_auto` VALUES ('115', '0', '0', '0', '10000', '65', '1', '1', '252787', '0');
INSERT INTO `gametx16_auto` VALUES ('116', '0', '0', '0', '10000', '65', '1', '1', '252808', '0');
INSERT INTO `gametx16_auto` VALUES ('117', '0', '0', '0', '10000', '65', '1', '1', '252818', '0');
INSERT INTO `gametx16_auto` VALUES ('118', '0', '0', '0', '10000', '65', '1', '1', '252829', '0');
INSERT INTO `gametx16_auto` VALUES ('119', '0', '0', '0', '10000', '65', '1', '1', '252859', '0');
INSERT INTO `gametx16_auto` VALUES ('120', '0', '0', '0', '10000', '65', '1', '1', '252873', '0');
INSERT INTO `gametx16_auto` VALUES ('121', '0', '0', '0', '10000', '65', '1', '1', '252933', '0');
INSERT INTO `gametx16_auto` VALUES ('122', '0', '0', '0', '10000', '65', '1', '1', '252962', '0');
INSERT INTO `gametx16_auto` VALUES ('123', '0', '0', '0', '10000', '65', '1', '1', '252975', '0');
INSERT INTO `gametx16_auto` VALUES ('124', '0', '0', '0', '10000', '65', '1', '1', '252995', '0');
INSERT INTO `gametx16_auto` VALUES ('125', '0', '0', '0', '10000', '65', '1', '1', '253002', '0');
INSERT INTO `gametx16_auto` VALUES ('126', '0', '0', '0', '10000', '65', '1', '1', '253022', '0');
INSERT INTO `gametx16_auto` VALUES ('127', '0', '0', '0', '10000', '65', '1', '1', '253024', '0');
INSERT INTO `gametx16_auto` VALUES ('128', '0', '0', '0', '10000', '65', '1', '1', '253064', '0');
INSERT INTO `gametx16_auto` VALUES ('129', '0', '0', '0', '10000', '65', '1', '1', '253094', '0');
INSERT INTO `gametx16_auto` VALUES ('130', '0', '0', '0', '10000', '65', '1', '1', '253100', '0');
INSERT INTO `gametx16_auto` VALUES ('131', '0', '0', '0', '10000', '65', '1', '1', '253107', '0');
INSERT INTO `gametx16_auto` VALUES ('132', '0', '0', '0', '10000', '65', '1', '1', '253124', '0');
INSERT INTO `gametx16_auto` VALUES ('133', '0', '0', '0', '10000', '65', '1', '1', '253128', '0');
INSERT INTO `gametx16_auto` VALUES ('134', '0', '0', '0', '10000', '65', '1', '1', '253142', '0');
INSERT INTO `gametx16_auto` VALUES ('135', '0', '0', '0', '10000', '65', '1', '1', '253156', '0');
INSERT INTO `gametx16_auto` VALUES ('136', '0', '0', '0', '10000', '65', '1', '1', '253292', '0');
INSERT INTO `gametx16_auto` VALUES ('137', '0', '0', '0', '10000', '65', '1', '1', '253304', '0');
INSERT INTO `gametx16_auto` VALUES ('138', '0', '0', '0', '10000', '65', '1', '1', '253325', '0');
INSERT INTO `gametx16_auto` VALUES ('139', '0', '0', '0', '10000', '65', '1', '1', '253382', '0');
INSERT INTO `gametx16_auto` VALUES ('140', '0', '0', '0', '10000', '65', '1', '1', '253389', '0');
INSERT INTO `gametx16_auto` VALUES ('141', '0', '0', '0', '10000', '65', '1', '1', '253402', '0');
INSERT INTO `gametx16_auto` VALUES ('142', '0', '0', '0', '10000', '65', '1', '1', '253424', '0');
INSERT INTO `gametx16_auto` VALUES ('143', '0', '0', '0', '10000', '65', '1', '1', '253450', '0');
INSERT INTO `gametx16_auto` VALUES ('144', '0', '0', '0', '10000', '65', '1', '1', '253454', '0');
INSERT INTO `gametx16_auto` VALUES ('145', '0', '0', '0', '10000', '65', '1', '1', '253514', '0');
INSERT INTO `gametx16_auto` VALUES ('146', '0', '0', '0', '10000', '65', '1', '1', '253537', '0');
INSERT INTO `gametx16_auto` VALUES ('147', '0', '0', '0', '10000', '65', '1', '1', '253545', '0');
INSERT INTO `gametx16_auto` VALUES ('148', '0', '0', '0', '10000', '65', '1', '1', '253553', '0');
INSERT INTO `gametx16_auto` VALUES ('149', '0', '0', '0', '10000', '65', '1', '1', '253560', '0');
INSERT INTO `gametx16_auto` VALUES ('150', '0', '0', '0', '10000', '65', '1', '1', '253601', '0');
INSERT INTO `gametx16_auto` VALUES ('256', '0', '0', '0', '10000', '62', '1', '1', '253611', '0');
INSERT INTO `gametx16_auto` VALUES ('257', '0', '0', '0', '10000', '62', '1', '1', '253618', '0');
INSERT INTO `gametx16_auto` VALUES ('258', '0', '0', '0', '10000', '62', '1', '1', '253623', '0');
INSERT INTO `gametx16_auto` VALUES ('259', '0', '0', '0', '10000', '62', '1', '1', '253628', '0');
INSERT INTO `gametx16_auto` VALUES ('260', '0', '0', '0', '10000', '62', '1', '1', '253647', '0');
INSERT INTO `gametx16_auto` VALUES ('261', '0', '0', '0', '10000', '62', '1', '1', '253655', '0');
INSERT INTO `gametx16_auto` VALUES ('262', '0', '0', '0', '10000', '62', '1', '1', '253748', '0');
INSERT INTO `gametx16_auto` VALUES ('263', '0', '0', '0', '10000', '62', '1', '1', '253811', '0');
INSERT INTO `gametx16_auto` VALUES ('264', '0', '0', '0', '10000', '62', '1', '1', '253837', '0');
INSERT INTO `gametx16_auto` VALUES ('265', '0', '0', '0', '10000', '62', '1', '1', '253887', '0');
INSERT INTO `gametx16_auto` VALUES ('266', '0', '0', '0', '10000', '62', '1', '1', '253906', '0');
INSERT INTO `gametx16_auto` VALUES ('267', '0', '0', '0', '10000', '62', '1', '1', '253947', '0');
INSERT INTO `gametx16_auto` VALUES ('268', '0', '0', '0', '10000', '62', '1', '1', '253953', '0');
INSERT INTO `gametx16_auto` VALUES ('269', '0', '0', '0', '10000', '62', '1', '1', '253975', '0');
INSERT INTO `gametx16_auto` VALUES ('270', '0', '0', '0', '10000', '62', '1', '1', '253977', '0');
INSERT INTO `gametx16_auto` VALUES ('271', '0', '0', '0', '10000', '62', '1', '1', '254003', '0');
INSERT INTO `gametx16_auto` VALUES ('272', '0', '0', '0', '10000', '62', '1', '1', '254052', '0');
INSERT INTO `gametx16_auto` VALUES ('273', '0', '0', '0', '10000', '62', '1', '1', '254060', '0');
INSERT INTO `gametx16_auto` VALUES ('274', '0', '0', '0', '10000', '62', '1', '1', '254074', '0');
INSERT INTO `gametx16_auto` VALUES ('275', '0', '0', '0', '10000', '62', '1', '1', '254075', '0');
INSERT INTO `gametx16_auto` VALUES ('276', '0', '0', '0', '10000', '62', '1', '1', '254082', '0');
INSERT INTO `gametx16_auto` VALUES ('277', '0', '0', '0', '10000', '62', '1', '1', '254085', '0');
INSERT INTO `gametx16_auto` VALUES ('278', '0', '0', '0', '10000', '62', '1', '1', '254105', '0');
INSERT INTO `gametx16_auto` VALUES ('279', '0', '0', '0', '10000', '62', '1', '1', '254138', '0');
INSERT INTO `gametx16_auto` VALUES ('280', '0', '0', '0', '10000', '62', '1', '1', '254157', '0');
INSERT INTO `gametx16_auto` VALUES ('281', '0', '0', '0', '10000', '62', '1', '1', '254162', '0');
INSERT INTO `gametx16_auto` VALUES ('282', '0', '0', '0', '10000', '62', '1', '1', '254173', '0');
INSERT INTO `gametx16_auto` VALUES ('283', '0', '0', '0', '10000', '62', '1', '1', '254179', '0');
INSERT INTO `gametx16_auto` VALUES ('284', '0', '0', '0', '10000', '62', '1', '1', '254193', '0');
INSERT INTO `gametx16_auto` VALUES ('285', '0', '0', '0', '10000', '62', '1', '1', '254215', '0');
INSERT INTO `gametx16_auto` VALUES ('286', '0', '0', '0', '10000', '62', '1', '1', '254264', '0');
INSERT INTO `gametx16_auto` VALUES ('287', '0', '0', '0', '10000', '62', '1', '1', '254281', '0');
INSERT INTO `gametx16_auto` VALUES ('288', '0', '0', '0', '10000', '62', '1', '1', '254310', '0');
INSERT INTO `gametx16_auto` VALUES ('289', '0', '0', '0', '10000', '62', '1', '1', '254317', '0');
INSERT INTO `gametx16_auto` VALUES ('290', '0', '0', '0', '10000', '62', '1', '1', '254332', '0');
INSERT INTO `gametx16_auto` VALUES ('291', '0', '0', '0', '10000', '62', '1', '1', '254358', '0');
INSERT INTO `gametx16_auto` VALUES ('292', '0', '0', '0', '10000', '62', '1', '1', '254361', '0');
INSERT INTO `gametx16_auto` VALUES ('293', '0', '0', '0', '10000', '62', '1', '1', '254380', '0');
INSERT INTO `gametx16_auto` VALUES ('294', '0', '0', '0', '10000', '62', '1', '1', '254386', '0');
INSERT INTO `gametx16_auto` VALUES ('295', '0', '0', '0', '10000', '62', '1', '1', '254394', '0');
INSERT INTO `gametx16_auto` VALUES ('296', '0', '0', '0', '10000', '62', '1', '1', '254395', '0');
INSERT INTO `gametx16_auto` VALUES ('297', '0', '0', '0', '10000', '62', '1', '1', '254417', '0');
INSERT INTO `gametx16_auto` VALUES ('298', '0', '0', '0', '10000', '62', '1', '1', '254424', '0');
INSERT INTO `gametx16_auto` VALUES ('299', '0', '0', '0', '10000', '62', '1', '1', '254475', '0');
INSERT INTO `gametx16_auto` VALUES ('300', '0', '0', '0', '10000', '62', '1', '1', '254485', '0');
INSERT INTO `gametx16_auto` VALUES ('301', '0', '0', '0', '10000', '62', '1', '1', '254533', '0');
INSERT INTO `gametx16_auto` VALUES ('302', '0', '0', '0', '10000', '62', '1', '1', '254632', '0');
INSERT INTO `gametx16_auto` VALUES ('303', '0', '0', '0', '10000', '62', '1', '1', '254661', '0');
INSERT INTO `gametx16_auto` VALUES ('304', '0', '0', '0', '10000', '62', '1', '1', '254672', '0');
INSERT INTO `gametx16_auto` VALUES ('305', '0', '0', '0', '10000', '62', '1', '1', '254674', '0');
INSERT INTO `gametx16_auto` VALUES ('319', '0', '0', '0', '10000', '65', '1', '1', '270697', '0');
INSERT INTO `gametx16_auto` VALUES ('320', '0', '0', '0', '10000', '65', '1', '1', '270719', '0');
INSERT INTO `gametx16_auto` VALUES ('321', '0', '0', '0', '10000', '65', '1', '1', '270742', '0');
INSERT INTO `gametx16_auto` VALUES ('322', '0', '0', '0', '10000', '65', '1', '1', '270743', '0');
INSERT INTO `gametx16_auto` VALUES ('323', '0', '0', '0', '10000', '65', '1', '1', '270776', '0');
INSERT INTO `gametx16_auto` VALUES ('324', '0', '0', '0', '10000', '65', '1', '1', '270794', '0');
INSERT INTO `gametx16_auto` VALUES ('325', '0', '0', '0', '10000', '65', '1', '1', '270799', '0');
INSERT INTO `gametx16_auto` VALUES ('326', '0', '0', '0', '10000', '65', '1', '1', '270868', '0');
INSERT INTO `gametx16_auto` VALUES ('327', '0', '0', '0', '10000', '65', '1', '1', '270894', '0');
INSERT INTO `gametx16_auto` VALUES ('328', '0', '0', '0', '10000', '65', '1', '1', '270935', '0');
INSERT INTO `gametx16_auto` VALUES ('329', '0', '0', '0', '10000', '65', '1', '1', '270960', '0');
INSERT INTO `gametx16_auto` VALUES ('330', '0', '0', '0', '10000', '65', '1', '1', '270990', '0');
INSERT INTO `gametx16_auto` VALUES ('331', '0', '0', '0', '10000', '65', '1', '1', '271028', '0');
INSERT INTO `gametx16_auto` VALUES ('332', '0', '0', '0', '10000', '65', '1', '1', '271038', '0');
INSERT INTO `gametx16_auto` VALUES ('333', '0', '0', '0', '10000', '65', '1', '1', '271048', '0');
INSERT INTO `gametx16_auto` VALUES ('334', '0', '0', '0', '10000', '65', '1', '1', '271054', '0');
INSERT INTO `gametx16_auto` VALUES ('335', '0', '0', '0', '10000', '65', '1', '1', '271061', '0');
INSERT INTO `gametx16_auto` VALUES ('336', '0', '0', '0', '10000', '65', '1', '1', '271095', '0');
INSERT INTO `gametx16_auto` VALUES ('337', '0', '0', '0', '10000', '65', '1', '1', '271138', '0');
INSERT INTO `gametx16_auto` VALUES ('338', '0', '0', '0', '10000', '65', '1', '1', '271145', '0');
INSERT INTO `gametx16_auto` VALUES ('339', '0', '0', '0', '10000', '65', '1', '1', '271146', '0');
INSERT INTO `gametx16_auto` VALUES ('340', '0', '0', '0', '10000', '65', '1', '1', '271174', '0');
INSERT INTO `gametx16_auto` VALUES ('341', '0', '0', '0', '10000', '65', '1', '1', '271180', '0');
INSERT INTO `gametx16_auto` VALUES ('342', '0', '0', '0', '10000', '65', '1', '1', '271265', '0');
INSERT INTO `gametx16_auto` VALUES ('343', '0', '0', '0', '10000', '65', '1', '1', '271269', '0');
INSERT INTO `gametx16_auto` VALUES ('344', '0', '0', '0', '10000', '65', '1', '1', '271289', '0');
INSERT INTO `gametx16_auto` VALUES ('345', '0', '0', '0', '10000', '65', '1', '1', '271309', '0');
INSERT INTO `gametx16_auto` VALUES ('346', '0', '0', '0', '10000', '65', '1', '1', '271332', '0');
INSERT INTO `gametx16_auto` VALUES ('347', '0', '0', '0', '10000', '65', '1', '1', '271336', '0');
INSERT INTO `gametx16_auto` VALUES ('348', '0', '0', '0', '10000', '65', '1', '1', '271349', '0');
INSERT INTO `gametx16_auto` VALUES ('349', '0', '0', '0', '10000', '65', '1', '1', '271356', '0');
INSERT INTO `gametx16_auto` VALUES ('350', '0', '0', '0', '10000', '65', '1', '1', '271391', '0');
INSERT INTO `gametx16_auto` VALUES ('351', '0', '0', '0', '10000', '65', '1', '1', '271408', '0');
INSERT INTO `gametx16_auto` VALUES ('352', '0', '0', '0', '10000', '65', '1', '1', '271409', '0');
INSERT INTO `gametx16_auto` VALUES ('353', '0', '0', '0', '10000', '65', '1', '1', '271454', '0');
INSERT INTO `gametx16_auto` VALUES ('354', '0', '0', '0', '10000', '65', '1', '1', '271473', '0');
INSERT INTO `gametx16_auto` VALUES ('355', '0', '0', '0', '10000', '65', '1', '1', '271475', '0');
INSERT INTO `gametx16_auto` VALUES ('356', '0', '0', '0', '10000', '65', '1', '1', '271517', '0');
INSERT INTO `gametx16_auto` VALUES ('357', '0', '0', '0', '10000', '65', '1', '1', '271571', '0');
INSERT INTO `gametx16_auto` VALUES ('358', '0', '0', '0', '10000', '65', '1', '1', '271579', '0');
INSERT INTO `gametx16_auto` VALUES ('359', '0', '0', '0', '10000', '65', '1', '1', '271628', '0');
INSERT INTO `gametx16_auto` VALUES ('360', '0', '0', '0', '10000', '65', '1', '1', '271641', '0');
INSERT INTO `gametx16_auto` VALUES ('361', '0', '0', '0', '10000', '65', '1', '1', '271648', '0');
INSERT INTO `gametx16_auto` VALUES ('362', '0', '0', '0', '10000', '65', '1', '1', '271649', '0');
INSERT INTO `gametx16_auto` VALUES ('363', '0', '0', '0', '10000', '65', '1', '1', '271666', '0');
INSERT INTO `gametx16_auto` VALUES ('364', '0', '0', '0', '10000', '65', '1', '1', '271720', '0');
INSERT INTO `gametx16_auto` VALUES ('365', '0', '0', '0', '10000', '65', '1', '1', '271730', '0');
INSERT INTO `gametx16_auto` VALUES ('366', '0', '0', '0', '10000', '65', '1', '1', '271793', '0');
INSERT INTO `gametx16_auto` VALUES ('367', '0', '0', '0', '10000', '65', '1', '1', '271799', '0');
INSERT INTO `gametx16_auto` VALUES ('368', '0', '0', '0', '10000', '65', '1', '1', '271807', '0');
INSERT INTO `gametx16_auto` VALUES ('369', '0', '0', '0', '10000', '65', '1', '1', '271895', '0');
INSERT INTO `gametx16_auto` VALUES ('370', '0', '0', '0', '10000', '65', '1', '1', '271908', '0');
INSERT INTO `gametx16_auto` VALUES ('371', '0', '0', '0', '10000', '65', '1', '1', '271910', '0');
INSERT INTO `gametx16_auto` VALUES ('372', '0', '0', '0', '10000', '65', '1', '1', '271917', '0');
INSERT INTO `gametx16_auto` VALUES ('373', '0', '0', '0', '10000', '65', '1', '1', '271935', '0');
INSERT INTO `gametx16_auto` VALUES ('374', '0', '0', '0', '10000', '65', '1', '1', '271938', '0');
INSERT INTO `gametx16_auto` VALUES ('375', '0', '0', '0', '10000', '65', '1', '1', '271951', '0');
INSERT INTO `gametx16_auto` VALUES ('376', '0', '0', '0', '10000', '65', '1', '1', '271978', '0');
INSERT INTO `gametx16_auto` VALUES ('377', '0', '0', '0', '10000', '65', '1', '1', '271993', '0');
INSERT INTO `gametx16_auto` VALUES ('378', '0', '0', '0', '10000', '65', '1', '1', '272007', '0');
INSERT INTO `gametx16_auto` VALUES ('379', '0', '0', '0', '10000', '65', '1', '1', '272021', '0');
INSERT INTO `gametx16_auto` VALUES ('380', '0', '0', '0', '10000', '65', '1', '1', '272037', '0');
INSERT INTO `gametx16_auto` VALUES ('381', '0', '0', '0', '10000', '65', '1', '1', '272066', '0');
INSERT INTO `gametx16_auto` VALUES ('382', '0', '0', '0', '10000', '65', '1', '1', '272124', '0');
INSERT INTO `gametx16_auto` VALUES ('383', '0', '0', '0', '10000', '65', '1', '1', '272187', '0');
INSERT INTO `gametx16_auto` VALUES ('384', '0', '0', '0', '10000', '65', '1', '1', '272200', '0');
INSERT INTO `gametx16_auto` VALUES ('385', '0', '0', '0', '10000', '65', '1', '1', '272207', '0');
INSERT INTO `gametx16_auto` VALUES ('386', '0', '0', '0', '10000', '65', '1', '1', '272236', '0');
INSERT INTO `gametx16_auto` VALUES ('387', '0', '0', '0', '10000', '65', '1', '1', '272245', '0');
INSERT INTO `gametx16_auto` VALUES ('388', '0', '0', '0', '10000', '65', '1', '1', '272263', '0');
INSERT INTO `gametx16_auto` VALUES ('389', '0', '0', '0', '10000', '65', '1', '1', '272314', '0');
INSERT INTO `gametx16_auto` VALUES ('390', '0', '0', '0', '10000', '65', '1', '1', '272345', '0');
INSERT INTO `gametx16_auto` VALUES ('391', '0', '0', '0', '10000', '65', '1', '1', '272348', '0');
INSERT INTO `gametx16_auto` VALUES ('392', '0', '0', '0', '10000', '65', '1', '1', '272362', '0');
INSERT INTO `gametx16_auto` VALUES ('393', '0', '0', '0', '10000', '65', '1', '1', '272406', '0');
INSERT INTO `gametx16_auto` VALUES ('394', '0', '0', '0', '10000', '65', '1', '1', '272421', '0');
INSERT INTO `gametx16_auto` VALUES ('395', '0', '0', '0', '10000', '65', '1', '1', '272434', '0');
INSERT INTO `gametx16_auto` VALUES ('396', '0', '0', '0', '10000', '65', '1', '1', '272443', '0');
INSERT INTO `gametx16_auto` VALUES ('397', '0', '0', '0', '10000', '65', '1', '1', '272444', '0');
INSERT INTO `gametx16_auto` VALUES ('398', '0', '0', '0', '10000', '65', '1', '1', '272480', '0');
INSERT INTO `gametx16_auto` VALUES ('399', '0', '0', '0', '10000', '65', '1', '1', '272484', '0');
INSERT INTO `gametx16_auto` VALUES ('400', '0', '0', '0', '10000', '65', '1', '1', '272525', '0');
INSERT INTO `gametx16_auto` VALUES ('401', '0', '0', '0', '10000', '65', '1', '1', '272538', '0');
INSERT INTO `gametx16_auto` VALUES ('402', '0', '0', '0', '10000', '65', '1', '1', '272539', '0');
INSERT INTO `gametx16_auto` VALUES ('403', '0', '0', '0', '10000', '65', '1', '1', '272546', '0');
INSERT INTO `gametx16_auto` VALUES ('404', '0', '0', '0', '10000', '65', '1', '1', '272602', '0');
INSERT INTO `gametx16_auto` VALUES ('405', '0', '0', '0', '10000', '65', '1', '1', '272631', '0');
INSERT INTO `gametx16_auto` VALUES ('406', '0', '0', '0', '10000', '65', '1', '1', '272696', '0');
INSERT INTO `gametx16_auto` VALUES ('407', '0', '0', '0', '10000', '65', '1', '1', '272713', '0');
INSERT INTO `gametx16_auto` VALUES ('408', '0', '0', '0', '10000', '65', '1', '1', '272715', '0');
INSERT INTO `gametx16_auto` VALUES ('409', '0', '0', '0', '10000', '65', '1', '1', '272747', '0');
INSERT INTO `gametx16_auto` VALUES ('410', '0', '0', '0', '10000', '65', '1', '1', '272758', '0');
INSERT INTO `gametx16_auto` VALUES ('411', '0', '0', '0', '10000', '65', '1', '1', '272761', '0');
INSERT INTO `gametx16_auto` VALUES ('412', '0', '0', '0', '10000', '65', '1', '1', '272771', '0');
INSERT INTO `gametx16_auto` VALUES ('413', '0', '0', '0', '10000', '65', '1', '1', '272773', '0');
INSERT INTO `gametx16_auto` VALUES ('414', '0', '0', '0', '10000', '65', '1', '1', '272824', '0');
INSERT INTO `gametx16_auto` VALUES ('415', '0', '0', '0', '10000', '65', '1', '1', '272853', '0');
INSERT INTO `gametx16_auto` VALUES ('416', '0', '0', '0', '10000', '65', '1', '1', '272854', '0');
INSERT INTO `gametx16_auto` VALUES ('417', '0', '0', '0', '10000', '65', '1', '1', '272891', '0');
INSERT INTO `gametx16_auto` VALUES ('418', '0', '0', '0', '10000', '65', '1', '1', '272897', '0');


-- ----------------------------
-- Table structure for gametx28_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx28_auto`;
CREATE TABLE `gametx28_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1326 DEFAULT CHARSET=utf8 COMMENT='腾讯28自动投注';

-- ----------------------------
-- Records of gametx28_auto
-- ----------------------------
INSERT INTO `gametx28_auto` VALUES ('1', '0', '0', '0', '10000', '59', '1', '1', '367827', '0');
INSERT INTO `gametx28_auto` VALUES ('2', '0', '0', '0', '10000', '59', '1', '1', '367830', '0');
INSERT INTO `gametx28_auto` VALUES ('3', '0', '0', '0', '10000', '59', '1', '1', '367839', '0');
INSERT INTO `gametx28_auto` VALUES ('4', '0', '0', '0', '10000', '59', '1', '1', '367841', '0');
INSERT INTO `gametx28_auto` VALUES ('5', '0', '0', '0', '10000', '59', '1', '1', '367852', '0');
INSERT INTO `gametx28_auto` VALUES ('6', '0', '0', '0', '10000', '59', '1', '1', '367869', '0');
INSERT INTO `gametx28_auto` VALUES ('7', '0', '0', '0', '10000', '59', '1', '1', '367887', '0');
INSERT INTO `gametx28_auto` VALUES ('8', '0', '0', '0', '10000', '59', '1', '1', '367914', '0');
INSERT INTO `gametx28_auto` VALUES ('9', '0', '0', '0', '10000', '59', '1', '1', '367931', '0');
INSERT INTO `gametx28_auto` VALUES ('10', '0', '0', '0', '10000', '59', '1', '1', '367941', '0');
INSERT INTO `gametx28_auto` VALUES ('11', '0', '0', '0', '10000', '59', '1', '1', '367995', '0');
INSERT INTO `gametx28_auto` VALUES ('12', '0', '0', '0', '10000', '59', '1', '1', '367998', '0');
INSERT INTO `gametx28_auto` VALUES ('13', '0', '0', '0', '10000', '59', '1', '1', '368008', '0');
INSERT INTO `gametx28_auto` VALUES ('14', '0', '0', '0', '10000', '59', '1', '1', '368081', '0');
INSERT INTO `gametx28_auto` VALUES ('15', '0', '0', '0', '10000', '59', '1', '1', '368116', '0');
INSERT INTO `gametx28_auto` VALUES ('16', '0', '0', '0', '10000', '59', '1', '1', '368121', '0');
INSERT INTO `gametx28_auto` VALUES ('17', '0', '0', '0', '10000', '59', '1', '1', '368206', '0');
INSERT INTO `gametx28_auto` VALUES ('18', '0', '0', '0', '10000', '59', '1', '1', '368249', '0');
INSERT INTO `gametx28_auto` VALUES ('19', '0', '0', '0', '10000', '59', '1', '1', '368262', '0');
INSERT INTO `gametx28_auto` VALUES ('20', '0', '0', '0', '10000', '59', '1', '1', '368295', '0');
INSERT INTO `gametx28_auto` VALUES ('21', '0', '0', '0', '10000', '59', '1', '1', '368311', '0');
INSERT INTO `gametx28_auto` VALUES ('22', '0', '0', '0', '10000', '59', '1', '1', '368325', '0');
INSERT INTO `gametx28_auto` VALUES ('23', '0', '0', '0', '10000', '59', '1', '1', '368337', '0');
INSERT INTO `gametx28_auto` VALUES ('24', '0', '0', '0', '10000', '59', '1', '1', '368469', '0');
INSERT INTO `gametx28_auto` VALUES ('25', '0', '0', '0', '10000', '59', '1', '1', '368492', '0');
INSERT INTO `gametx28_auto` VALUES ('26', '0', '0', '0', '10000', '59', '1', '1', '368547', '0');
INSERT INTO `gametx28_auto` VALUES ('27', '0', '0', '0', '10000', '59', '1', '1', '368550', '0');
INSERT INTO `gametx28_auto` VALUES ('28', '0', '0', '0', '10000', '59', '1', '1', '368553', '0');
INSERT INTO `gametx28_auto` VALUES ('29', '0', '0', '0', '10000', '59', '1', '1', '368586', '0');
INSERT INTO `gametx28_auto` VALUES ('30', '0', '0', '0', '10000', '59', '1', '1', '368602', '0');
INSERT INTO `gametx28_auto` VALUES ('31', '0', '0', '0', '10000', '59', '1', '1', '368612', '0');
INSERT INTO `gametx28_auto` VALUES ('32', '0', '0', '0', '10000', '59', '1', '1', '368623', '0');
INSERT INTO `gametx28_auto` VALUES ('33', '0', '0', '0', '10000', '59', '1', '1', '368635', '0');
INSERT INTO `gametx28_auto` VALUES ('34', '0', '0', '0', '10000', '59', '1', '1', '368688', '0');
INSERT INTO `gametx28_auto` VALUES ('35', '0', '0', '0', '10000', '59', '1', '1', '368706', '0');
INSERT INTO `gametx28_auto` VALUES ('36', '0', '0', '0', '10000', '59', '1', '1', '368724', '0');
INSERT INTO `gametx28_auto` VALUES ('37', '0', '0', '0', '10000', '59', '1', '1', '368769', '0');
INSERT INTO `gametx28_auto` VALUES ('38', '0', '0', '0', '10000', '59', '1', '1', '368778', '0');
INSERT INTO `gametx28_auto` VALUES ('39', '0', '0', '0', '10000', '59', '1', '1', '368782', '0');
INSERT INTO `gametx28_auto` VALUES ('40', '0', '0', '0', '10000', '59', '1', '1', '368810', '0');
INSERT INTO `gametx28_auto` VALUES ('41', '0', '0', '0', '10000', '59', '1', '1', '368847', '0');
INSERT INTO `gametx28_auto` VALUES ('42', '0', '0', '0', '10000', '59', '1', '1', '368884', '0');
INSERT INTO `gametx28_auto` VALUES ('43', '0', '0', '0', '10000', '59', '1', '1', '368896', '0');
INSERT INTO `gametx28_auto` VALUES ('44', '0', '0', '0', '10000', '59', '1', '1', '368925', '0');
INSERT INTO `gametx28_auto` VALUES ('45', '0', '0', '0', '10000', '59', '1', '1', '368936', '0');
INSERT INTO `gametx28_auto` VALUES ('46', '0', '0', '0', '10000', '59', '1', '1', '368945', '0');
INSERT INTO `gametx28_auto` VALUES ('47', '0', '0', '0', '10000', '59', '1', '1', '368964', '0');
INSERT INTO `gametx28_auto` VALUES ('48', '0', '0', '0', '10000', '59', '1', '1', '368996', '0');
INSERT INTO `gametx28_auto` VALUES ('49', '0', '0', '0', '10000', '59', '1', '1', '369022', '0');
INSERT INTO `gametx28_auto` VALUES ('50', '0', '0', '0', '10000', '59', '1', '1', '369037', '0');
INSERT INTO `gametx28_auto` VALUES ('51', '0', '0', '0', '10000', '59', '1', '1', '369052', '0');
INSERT INTO `gametx28_auto` VALUES ('52', '0', '0', '0', '10000', '59', '1', '1', '369057', '0');
INSERT INTO `gametx28_auto` VALUES ('53', '0', '0', '0', '10000', '59', '1', '1', '369060', '0');
INSERT INTO `gametx28_auto` VALUES ('54', '0', '0', '0', '10000', '59', '1', '1', '369075', '0');
INSERT INTO `gametx28_auto` VALUES ('55', '0', '0', '0', '10000', '59', '1', '1', '369082', '0');
INSERT INTO `gametx28_auto` VALUES ('56', '0', '0', '0', '10000', '59', '1', '1', '369090', '0');
INSERT INTO `gametx28_auto` VALUES ('57', '0', '0', '0', '10000', '59', '1', '1', '369122', '0');
INSERT INTO `gametx28_auto` VALUES ('58', '0', '0', '0', '10000', '59', '1', '1', '369185', '0');
INSERT INTO `gametx28_auto` VALUES ('59', '0', '0', '0', '10000', '59', '1', '1', '369219', '0');
INSERT INTO `gametx28_auto` VALUES ('60', '0', '0', '0', '10000', '59', '1', '1', '369257', '0');
INSERT INTO `gametx28_auto` VALUES ('61', '0', '0', '0', '10000', '59', '1', '1', '369258', '0');
INSERT INTO `gametx28_auto` VALUES ('62', '0', '0', '0', '10000', '59', '1', '1', '369259', '0');
INSERT INTO `gametx28_auto` VALUES ('63', '0', '0', '0', '10000', '59', '1', '1', '369277', '0');
INSERT INTO `gametx28_auto` VALUES ('64', '0', '0', '0', '10000', '59', '1', '1', '369294', '0');
INSERT INTO `gametx28_auto` VALUES ('65', '0', '0', '0', '10000', '59', '1', '1', '369328', '0');
INSERT INTO `gametx28_auto` VALUES ('66', '0', '0', '0', '10000', '59', '1', '1', '369352', '0');
INSERT INTO `gametx28_auto` VALUES ('67', '0', '0', '0', '10000', '59', '1', '1', '369372', '0');
INSERT INTO `gametx28_auto` VALUES ('68', '0', '0', '0', '10000', '59', '1', '1', '369451', '0');
INSERT INTO `gametx28_auto` VALUES ('69', '0', '0', '0', '10000', '59', '1', '1', '369463', '0');
INSERT INTO `gametx28_auto` VALUES ('70', '0', '0', '0', '10000', '59', '1', '1', '369512', '0');
INSERT INTO `gametx28_auto` VALUES ('71', '0', '0', '0', '10000', '59', '1', '1', '369574', '0');
INSERT INTO `gametx28_auto` VALUES ('72', '0', '0', '0', '10000', '59', '1', '1', '369627', '0');
INSERT INTO `gametx28_auto` VALUES ('73', '0', '0', '0', '10000', '59', '1', '1', '369646', '0');
INSERT INTO `gametx28_auto` VALUES ('74', '0', '0', '0', '10000', '59', '1', '1', '369709', '0');
INSERT INTO `gametx28_auto` VALUES ('75', '0', '0', '0', '10000', '59', '1', '1', '369735', '0');
INSERT INTO `gametx28_auto` VALUES ('76', '0', '0', '0', '10000', '59', '1', '1', '369795', '0');
INSERT INTO `gametx28_auto` VALUES ('77', '0', '0', '0', '10000', '59', '1', '1', '369822', '0');
INSERT INTO `gametx28_auto` VALUES ('78', '0', '0', '0', '10000', '59', '1', '1', '369858', '0');
INSERT INTO `gametx28_auto` VALUES ('79', '0', '0', '0', '10000', '59', '1', '1', '369862', '0');
INSERT INTO `gametx28_auto` VALUES ('80', '0', '0', '0', '10000', '59', '1', '1', '369874', '0');
INSERT INTO `gametx28_auto` VALUES ('81', '0', '0', '0', '10000', '59', '1', '1', '369878', '0');
INSERT INTO `gametx28_auto` VALUES ('82', '0', '0', '0', '10000', '59', '1', '1', '369936', '0');
INSERT INTO `gametx28_auto` VALUES ('83', '0', '0', '0', '10000', '59', '1', '1', '369949', '0');
INSERT INTO `gametx28_auto` VALUES ('84', '0', '0', '0', '10000', '59', '1', '1', '369950', '0');
INSERT INTO `gametx28_auto` VALUES ('85', '0', '0', '0', '10000', '59', '1', '1', '369953', '0');
INSERT INTO `gametx28_auto` VALUES ('86', '0', '0', '0', '10000', '59', '1', '1', '370065', '0');
INSERT INTO `gametx28_auto` VALUES ('87', '0', '0', '0', '10000', '59', '1', '1', '370072', '0');
INSERT INTO `gametx28_auto` VALUES ('88', '0', '0', '0', '10000', '59', '1', '1', '370158', '0');
INSERT INTO `gametx28_auto` VALUES ('89', '0', '0', '0', '10000', '59', '1', '1', '370184', '0');
INSERT INTO `gametx28_auto` VALUES ('90', '0', '0', '0', '10000', '59', '1', '1', '370201', '0');
INSERT INTO `gametx28_auto` VALUES ('91', '0', '0', '0', '10000', '59', '1', '1', '370234', '0');
INSERT INTO `gametx28_auto` VALUES ('92', '0', '0', '0', '10000', '59', '1', '1', '370244', '0');
INSERT INTO `gametx28_auto` VALUES ('93', '0', '0', '0', '10000', '59', '1', '1', '370256', '0');
INSERT INTO `gametx28_auto` VALUES ('94', '0', '0', '0', '10000', '59', '1', '1', '370274', '0');
INSERT INTO `gametx28_auto` VALUES ('95', '0', '0', '0', '10000', '59', '1', '1', '370329', '0');
INSERT INTO `gametx28_auto` VALUES ('96', '0', '0', '0', '10000', '59', '1', '1', '370352', '0');
INSERT INTO `gametx28_auto` VALUES ('97', '0', '0', '0', '10000', '59', '1', '1', '370363', '0');
INSERT INTO `gametx28_auto` VALUES ('98', '0', '0', '0', '10000', '59', '1', '1', '370417', '0');
INSERT INTO `gametx28_auto` VALUES ('99', '0', '0', '0', '10000', '59', '1', '1', '370428', '0');
INSERT INTO `gametx28_auto` VALUES ('100', '0', '0', '0', '10000', '59', '1', '1', '370438', '0');
INSERT INTO `gametx28_auto` VALUES ('101', '0', '0', '0', '10000', '59', '1', '1', '370488', '0');
INSERT INTO `gametx28_auto` VALUES ('102', '0', '0', '0', '10000', '59', '1', '1', '370529', '0');
INSERT INTO `gametx28_auto` VALUES ('103', '0', '0', '0', '10000', '59', '1', '1', '370563', '0');
INSERT INTO `gametx28_auto` VALUES ('104', '0', '0', '0', '10000', '59', '1', '1', '370566', '0');
INSERT INTO `gametx28_auto` VALUES ('105', '0', '0', '0', '10000', '59', '1', '1', '370621', '0');
INSERT INTO `gametx28_auto` VALUES ('106', '0', '0', '0', '10000', '59', '1', '1', '370623', '0');
INSERT INTO `gametx28_auto` VALUES ('107', '0', '0', '0', '10000', '59', '1', '1', '370652', '0');
INSERT INTO `gametx28_auto` VALUES ('108', '0', '0', '0', '10000', '59', '1', '1', '370655', '0');
INSERT INTO `gametx28_auto` VALUES ('109', '0', '0', '0', '10000', '59', '1', '1', '370669', '0');
INSERT INTO `gametx28_auto` VALUES ('110', '0', '0', '0', '10000', '59', '1', '1', '370702', '0');
INSERT INTO `gametx28_auto` VALUES ('111', '0', '0', '0', '10000', '59', '1', '1', '370718', '0');
INSERT INTO `gametx28_auto` VALUES ('112', '0', '0', '0', '10000', '59', '1', '1', '370719', '0');
INSERT INTO `gametx28_auto` VALUES ('113', '0', '0', '0', '10000', '59', '1', '1', '370738', '0');
INSERT INTO `gametx28_auto` VALUES ('114', '0', '0', '0', '10000', '59', '1', '1', '370776', '0');
INSERT INTO `gametx28_auto` VALUES ('115', '0', '0', '0', '10000', '59', '1', '1', '370835', '0');
INSERT INTO `gametx28_auto` VALUES ('116', '0', '0', '0', '10000', '59', '1', '1', '370857', '0');
INSERT INTO `gametx28_auto` VALUES ('117', '0', '0', '0', '10000', '59', '1', '1', '370890', '0');
INSERT INTO `gametx28_auto` VALUES ('118', '0', '0', '0', '10000', '59', '1', '1', '370950', '0');
INSERT INTO `gametx28_auto` VALUES ('119', '0', '0', '0', '10000', '59', '1', '1', '370965', '0');
INSERT INTO `gametx28_auto` VALUES ('120', '0', '0', '0', '10000', '59', '1', '1', '371025', '0');
INSERT INTO `gametx28_auto` VALUES ('121', '0', '0', '0', '10000', '59', '1', '1', '371062', '0');
INSERT INTO `gametx28_auto` VALUES ('122', '0', '0', '0', '10000', '59', '1', '1', '371088', '0');
INSERT INTO `gametx28_auto` VALUES ('123', '0', '0', '0', '10000', '59', '1', '1', '371108', '0');
INSERT INTO `gametx28_auto` VALUES ('124', '0', '0', '0', '10000', '59', '1', '1', '371110', '0');
INSERT INTO `gametx28_auto` VALUES ('125', '0', '0', '0', '10000', '59', '1', '1', '371135', '0');
INSERT INTO `gametx28_auto` VALUES ('126', '0', '0', '0', '10000', '59', '1', '1', '371137', '0');
INSERT INTO `gametx28_auto` VALUES ('127', '0', '0', '0', '10000', '59', '1', '1', '371178', '0');
INSERT INTO `gametx28_auto` VALUES ('128', '0', '0', '0', '10000', '59', '1', '1', '371224', '0');
INSERT INTO `gametx28_auto` VALUES ('129', '0', '0', '0', '10000', '59', '1', '1', '371227', '0');
INSERT INTO `gametx28_auto` VALUES ('130', '0', '0', '0', '10000', '59', '1', '1', '371230', '0');
INSERT INTO `gametx28_auto` VALUES ('131', '0', '0', '0', '10000', '59', '1', '1', '371264', '0');
INSERT INTO `gametx28_auto` VALUES ('132', '0', '0', '0', '10000', '59', '1', '1', '371265', '0');
INSERT INTO `gametx28_auto` VALUES ('133', '0', '0', '0', '10000', '59', '1', '1', '371294', '0');
INSERT INTO `gametx28_auto` VALUES ('134', '0', '0', '0', '10000', '59', '1', '1', '371324', '0');
INSERT INTO `gametx28_auto` VALUES ('135', '0', '0', '0', '10000', '59', '1', '1', '371428', '0');
INSERT INTO `gametx28_auto` VALUES ('136', '0', '0', '0', '10000', '59', '1', '1', '371488', '0');
INSERT INTO `gametx28_auto` VALUES ('137', '0', '0', '0', '10000', '59', '1', '1', '371555', '0');
INSERT INTO `gametx28_auto` VALUES ('138', '0', '0', '0', '10000', '59', '1', '1', '371567', '0');
INSERT INTO `gametx28_auto` VALUES ('139', '0', '0', '0', '10000', '59', '1', '1', '371583', '0');
INSERT INTO `gametx28_auto` VALUES ('140', '0', '0', '0', '10000', '59', '1', '1', '371615', '0');
INSERT INTO `gametx28_auto` VALUES ('141', '0', '0', '0', '10000', '59', '1', '1', '371616', '0');
INSERT INTO `gametx28_auto` VALUES ('142', '0', '0', '0', '10000', '59', '1', '1', '371722', '0');
INSERT INTO `gametx28_auto` VALUES ('143', '0', '0', '0', '10000', '59', '1', '1', '371729', '0');
INSERT INTO `gametx28_auto` VALUES ('144', '0', '0', '0', '10000', '59', '1', '1', '371820', '0');
INSERT INTO `gametx28_auto` VALUES ('145', '0', '0', '0', '10000', '59', '1', '1', '371913', '0');
INSERT INTO `gametx28_auto` VALUES ('146', '0', '0', '0', '10000', '59', '1', '1', '371952', '0');
INSERT INTO `gametx28_auto` VALUES ('147', '0', '0', '0', '10000', '59', '1', '1', '371969', '0');
INSERT INTO `gametx28_auto` VALUES ('148', '0', '0', '0', '10000', '59', '1', '1', '372007', '0');
INSERT INTO `gametx28_auto` VALUES ('149', '0', '0', '0', '10000', '59', '1', '1', '372019', '0');
INSERT INTO `gametx28_auto` VALUES ('150', '0', '0', '0', '10000', '59', '1', '1', '372049', '0');
INSERT INTO `gametx28_auto` VALUES ('151', '0', '0', '0', '10000', '59', '1', '1', '372059', '0');
INSERT INTO `gametx28_auto` VALUES ('152', '0', '0', '0', '10000', '59', '1', '1', '372060', '0');
INSERT INTO `gametx28_auto` VALUES ('153', '0', '0', '0', '10000', '59', '1', '1', '372067', '0');
INSERT INTO `gametx28_auto` VALUES ('154', '0', '0', '0', '10000', '59', '1', '1', '372080', '0');
INSERT INTO `gametx28_auto` VALUES ('155', '0', '0', '0', '10000', '59', '1', '1', '372112', '0');
INSERT INTO `gametx28_auto` VALUES ('156', '0', '0', '0', '10000', '59', '1', '1', '372117', '0');
INSERT INTO `gametx28_auto` VALUES ('157', '0', '0', '0', '10000', '59', '1', '1', '372128', '0');
INSERT INTO `gametx28_auto` VALUES ('158', '0', '0', '0', '10000', '59', '1', '1', '372175', '0');
INSERT INTO `gametx28_auto` VALUES ('159', '0', '0', '0', '10000', '59', '1', '1', '372349', '0');
INSERT INTO `gametx28_auto` VALUES ('160', '0', '0', '0', '10000', '59', '1', '1', '372372', '0');
INSERT INTO `gametx28_auto` VALUES ('161', '0', '0', '0', '10000', '59', '1', '1', '372382', '0');
INSERT INTO `gametx28_auto` VALUES ('162', '0', '0', '0', '10000', '59', '1', '1', '372399', '0');
INSERT INTO `gametx28_auto` VALUES ('163', '0', '0', '0', '10000', '59', '1', '1', '372417', '0');
INSERT INTO `gametx28_auto` VALUES ('164', '0', '0', '0', '10000', '59', '1', '1', '372449', '0');
INSERT INTO `gametx28_auto` VALUES ('165', '0', '0', '0', '10000', '59', '1', '1', '372461', '0');
INSERT INTO `gametx28_auto` VALUES ('166', '0', '0', '0', '10000', '59', '1', '1', '372470', '0');
INSERT INTO `gametx28_auto` VALUES ('167', '0', '0', '0', '10000', '59', '1', '1', '372504', '0');
INSERT INTO `gametx28_auto` VALUES ('168', '0', '0', '0', '10000', '59', '1', '1', '372519', '0');
INSERT INTO `gametx28_auto` VALUES ('169', '0', '0', '0', '10000', '59', '1', '1', '372521', '0');
INSERT INTO `gametx28_auto` VALUES ('170', '0', '0', '0', '10000', '59', '1', '1', '372552', '0');
INSERT INTO `gametx28_auto` VALUES ('171', '0', '0', '0', '10000', '59', '1', '1', '372576', '0');
INSERT INTO `gametx28_auto` VALUES ('172', '0', '0', '0', '10000', '59', '1', '1', '372578', '0');
INSERT INTO `gametx28_auto` VALUES ('173', '0', '0', '0', '10000', '59', '1', '1', '372588', '0');
INSERT INTO `gametx28_auto` VALUES ('174', '0', '0', '0', '10000', '59', '1', '1', '372611', '0');
INSERT INTO `gametx28_auto` VALUES ('175', '0', '0', '0', '10000', '59', '1', '1', '372638', '0');
INSERT INTO `gametx28_auto` VALUES ('176', '0', '0', '0', '10000', '59', '1', '1', '372640', '0');
INSERT INTO `gametx28_auto` VALUES ('177', '0', '0', '0', '10000', '59', '1', '1', '372655', '0');
INSERT INTO `gametx28_auto` VALUES ('178', '0', '0', '0', '10000', '59', '1', '1', '372672', '0');
INSERT INTO `gametx28_auto` VALUES ('179', '0', '0', '0', '10000', '59', '1', '1', '372681', '0');
INSERT INTO `gametx28_auto` VALUES ('180', '0', '0', '0', '10000', '59', '1', '1', '372714', '0');
INSERT INTO `gametx28_auto` VALUES ('181', '0', '0', '0', '10000', '59', '1', '1', '372736', '0');
INSERT INTO `gametx28_auto` VALUES ('182', '0', '0', '0', '10000', '59', '1', '1', '372774', '0');
INSERT INTO `gametx28_auto` VALUES ('183', '0', '0', '0', '10000', '59', '1', '1', '372786', '0');
INSERT INTO `gametx28_auto` VALUES ('184', '0', '0', '0', '10000', '59', '1', '1', '372807', '0');
INSERT INTO `gametx28_auto` VALUES ('185', '0', '0', '0', '10000', '59', '1', '1', '372812', '0');
INSERT INTO `gametx28_auto` VALUES ('186', '0', '0', '0', '10000', '59', '1', '1', '372861', '0');
INSERT INTO `gametx28_auto` VALUES ('187', '0', '0', '0', '10000', '59', '1', '1', '372862', '0');
INSERT INTO `gametx28_auto` VALUES ('188', '0', '0', '0', '10000', '59', '1', '1', '372908', '0');
INSERT INTO `gametx28_auto` VALUES ('189', '0', '0', '0', '10000', '59', '1', '1', '372964', '0');
INSERT INTO `gametx28_auto` VALUES ('190', '0', '0', '0', '10000', '59', '1', '1', '372988', '0');
INSERT INTO `gametx28_auto` VALUES ('191', '0', '0', '0', '10000', '59', '1', '1', '373010', '0');
INSERT INTO `gametx28_auto` VALUES ('192', '0', '0', '0', '10000', '59', '1', '1', '373014', '0');
INSERT INTO `gametx28_auto` VALUES ('193', '0', '0', '0', '10000', '59', '1', '1', '373016', '0');
INSERT INTO `gametx28_auto` VALUES ('194', '0', '0', '0', '10000', '59', '1', '1', '373034', '0');
INSERT INTO `gametx28_auto` VALUES ('195', '0', '0', '0', '10000', '59', '1', '1', '373089', '0');
INSERT INTO `gametx28_auto` VALUES ('196', '0', '0', '0', '10000', '59', '1', '1', '373112', '0');
INSERT INTO `gametx28_auto` VALUES ('197', '0', '0', '0', '10000', '59', '1', '1', '373119', '0');
INSERT INTO `gametx28_auto` VALUES ('198', '0', '0', '0', '10000', '59', '1', '1', '373149', '0');
INSERT INTO `gametx28_auto` VALUES ('199', '0', '0', '0', '10000', '59', '1', '1', '373151', '0');
INSERT INTO `gametx28_auto` VALUES ('200', '0', '0', '0', '10000', '59', '1', '1', '373213', '0');
INSERT INTO `gametx28_auto` VALUES ('201', '0', '0', '0', '10000', '59', '1', '1', '373229', '0');
INSERT INTO `gametx28_auto` VALUES ('202', '0', '0', '0', '10000', '59', '1', '1', '373263', '0');
INSERT INTO `gametx28_auto` VALUES ('203', '0', '0', '0', '10000', '59', '1', '1', '373299', '0');
INSERT INTO `gametx28_auto` VALUES ('204', '0', '0', '0', '10000', '59', '1', '1', '373325', '0');
INSERT INTO `gametx28_auto` VALUES ('205', '0', '0', '0', '10000', '59', '1', '1', '373330', '0');
INSERT INTO `gametx28_auto` VALUES ('206', '0', '0', '0', '10000', '59', '1', '1', '373395', '0');
INSERT INTO `gametx28_auto` VALUES ('207', '0', '0', '0', '10000', '59', '1', '1', '373452', '0');
INSERT INTO `gametx28_auto` VALUES ('208', '0', '0', '0', '10000', '59', '1', '1', '373459', '0');
INSERT INTO `gametx28_auto` VALUES ('209', '0', '0', '0', '10000', '59', '1', '1', '373498', '0');
INSERT INTO `gametx28_auto` VALUES ('210', '0', '0', '0', '10000', '59', '1', '1', '373519', '0');
INSERT INTO `gametx28_auto` VALUES ('211', '0', '0', '0', '10000', '59', '1', '1', '373524', '0');
INSERT INTO `gametx28_auto` VALUES ('212', '0', '0', '0', '10000', '59', '1', '1', '373559', '0');
INSERT INTO `gametx28_auto` VALUES ('213', '0', '0', '0', '10000', '59', '1', '1', '373570', '0');
INSERT INTO `gametx28_auto` VALUES ('214', '0', '0', '0', '10000', '59', '1', '1', '373579', '0');
INSERT INTO `gametx28_auto` VALUES ('215', '0', '0', '0', '10000', '59', '1', '1', '373600', '0');
INSERT INTO `gametx28_auto` VALUES ('216', '0', '0', '0', '10000', '59', '1', '1', '373646', '0');
INSERT INTO `gametx28_auto` VALUES ('217', '0', '0', '0', '10000', '59', '1', '1', '373659', '0');
INSERT INTO `gametx28_auto` VALUES ('218', '0', '0', '0', '10000', '59', '1', '1', '373679', '0');
INSERT INTO `gametx28_auto` VALUES ('219', '0', '0', '0', '10000', '59', '1', '1', '373728', '0');
INSERT INTO `gametx28_auto` VALUES ('220', '0', '0', '0', '10000', '59', '1', '1', '373752', '0');
INSERT INTO `gametx28_auto` VALUES ('221', '0', '0', '0', '10000', '59', '1', '1', '373753', '0');
INSERT INTO `gametx28_auto` VALUES ('222', '0', '0', '0', '10000', '59', '1', '1', '373761', '0');
INSERT INTO `gametx28_auto` VALUES ('223', '0', '0', '0', '10000', '59', '1', '1', '373777', '0');
INSERT INTO `gametx28_auto` VALUES ('224', '0', '0', '0', '10000', '59', '1', '1', '373821', '0');
INSERT INTO `gametx28_auto` VALUES ('225', '0', '0', '0', '10000', '59', '1', '1', '373857', '0');
INSERT INTO `gametx28_auto` VALUES ('226', '0', '0', '0', '10000', '59', '1', '1', '373880', '0');
INSERT INTO `gametx28_auto` VALUES ('227', '0', '0', '0', '10000', '59', '1', '1', '373881', '0');
INSERT INTO `gametx28_auto` VALUES ('228', '0', '0', '0', '10000', '59', '1', '1', '373938', '0');
INSERT INTO `gametx28_auto` VALUES ('229', '0', '0', '0', '10000', '59', '1', '1', '373974', '0');
INSERT INTO `gametx28_auto` VALUES ('230', '0', '0', '0', '10000', '59', '1', '1', '373981', '0');
INSERT INTO `gametx28_auto` VALUES ('231', '0', '0', '0', '10000', '59', '1', '1', '374012', '0');
INSERT INTO `gametx28_auto` VALUES ('232', '0', '0', '0', '10000', '59', '1', '1', '374026', '0');
INSERT INTO `gametx28_auto` VALUES ('233', '0', '0', '0', '10000', '59', '1', '1', '374056', '0');
INSERT INTO `gametx28_auto` VALUES ('234', '0', '0', '0', '10000', '59', '1', '1', '374057', '0');
INSERT INTO `gametx28_auto` VALUES ('235', '0', '0', '0', '10000', '59', '1', '1', '374111', '0');
INSERT INTO `gametx28_auto` VALUES ('236', '0', '0', '0', '10000', '59', '1', '1', '374124', '0');
INSERT INTO `gametx28_auto` VALUES ('237', '0', '0', '0', '10000', '59', '1', '1', '374126', '0');
INSERT INTO `gametx28_auto` VALUES ('238', '0', '0', '0', '10000', '59', '1', '1', '374142', '0');
INSERT INTO `gametx28_auto` VALUES ('239', '0', '0', '0', '10000', '59', '1', '1', '374214', '0');
INSERT INTO `gametx28_auto` VALUES ('240', '0', '0', '0', '10000', '59', '1', '1', '374226', '0');
INSERT INTO `gametx28_auto` VALUES ('241', '0', '0', '0', '10000', '59', '1', '1', '374250', '0');
INSERT INTO `gametx28_auto` VALUES ('242', '0', '0', '0', '10000', '59', '1', '1', '374278', '0');
INSERT INTO `gametx28_auto` VALUES ('243', '0', '0', '0', '10000', '59', '1', '1', '374332', '0');
INSERT INTO `gametx28_auto` VALUES ('244', '0', '0', '0', '10000', '59', '1', '1', '374366', '0');
INSERT INTO `gametx28_auto` VALUES ('245', '0', '0', '0', '10000', '59', '1', '1', '374368', '0');
INSERT INTO `gametx28_auto` VALUES ('246', '0', '0', '0', '10000', '59', '1', '1', '374383', '0');
INSERT INTO `gametx28_auto` VALUES ('247', '0', '0', '0', '10000', '59', '1', '1', '374453', '0');
INSERT INTO `gametx28_auto` VALUES ('248', '0', '0', '0', '10000', '59', '1', '1', '374457', '0');
INSERT INTO `gametx28_auto` VALUES ('249', '0', '0', '0', '10000', '59', '1', '1', '374527', '0');
INSERT INTO `gametx28_auto` VALUES ('250', '0', '0', '0', '10000', '59', '1', '1', '374530', '0');
INSERT INTO `gametx28_auto` VALUES ('1276', '0', '0', '0', '10000', '60', '1', '1', '259631', '0');
INSERT INTO `gametx28_auto` VALUES ('1277', '0', '0', '0', '10000', '60', '1', '1', '259635', '0');
INSERT INTO `gametx28_auto` VALUES ('1278', '0', '0', '0', '10000', '60', '1', '1', '259713', '0');
INSERT INTO `gametx28_auto` VALUES ('1279', '0', '0', '0', '10000', '60', '1', '1', '259728', '0');
INSERT INTO `gametx28_auto` VALUES ('1280', '0', '0', '0', '10000', '60', '1', '1', '259743', '0');
INSERT INTO `gametx28_auto` VALUES ('1281', '0', '0', '0', '10000', '60', '1', '1', '259870', '0');
INSERT INTO `gametx28_auto` VALUES ('1282', '0', '0', '0', '10000', '60', '1', '1', '259876', '0');
INSERT INTO `gametx28_auto` VALUES ('1283', '0', '0', '0', '10000', '60', '1', '1', '260367', '0');
INSERT INTO `gametx28_auto` VALUES ('1284', '0', '0', '0', '10000', '60', '1', '1', '260875', '0');
INSERT INTO `gametx28_auto` VALUES ('1285', '0', '0', '0', '10000', '60', '1', '1', '264197', '0');
INSERT INTO `gametx28_auto` VALUES ('1286', '0', '0', '0', '10000', '60', '1', '1', '266551', '0');
INSERT INTO `gametx28_auto` VALUES ('1287', '0', '0', '0', '10000', '60', '1', '1', '268472', '0');
INSERT INTO `gametx28_auto` VALUES ('1288', '0', '0', '0', '10000', '60', '1', '1', '268475', '0');
INSERT INTO `gametx28_auto` VALUES ('1289', '0', '0', '0', '10000', '60', '1', '1', '268507', '0');
INSERT INTO `gametx28_auto` VALUES ('1290', '0', '0', '0', '10000', '60', '1', '1', '268521', '0');
INSERT INTO `gametx28_auto` VALUES ('1291', '0', '0', '0', '10000', '60', '1', '1', '268552', '0');
INSERT INTO `gametx28_auto` VALUES ('1292', '0', '0', '0', '10000', '60', '1', '1', '268589', '0');
INSERT INTO `gametx28_auto` VALUES ('1293', '0', '0', '0', '10000', '60', '1', '1', '268594', '0');
INSERT INTO `gametx28_auto` VALUES ('1294', '0', '0', '0', '10000', '60', '1', '1', '268668', '0');
INSERT INTO `gametx28_auto` VALUES ('1295', '0', '0', '0', '10000', '60', '1', '1', '268716', '0');
INSERT INTO `gametx28_auto` VALUES ('1296', '0', '0', '0', '10000', '60', '1', '1', '268737', '0');
INSERT INTO `gametx28_auto` VALUES ('1297', '0', '0', '0', '10000', '60', '1', '1', '268748', '0');
INSERT INTO `gametx28_auto` VALUES ('1298', '0', '0', '0', '10000', '60', '1', '1', '268754', '0');
INSERT INTO `gametx28_auto` VALUES ('1299', '0', '0', '0', '10000', '60', '1', '1', '268773', '0');
INSERT INTO `gametx28_auto` VALUES ('1300', '0', '0', '0', '10000', '60', '1', '1', '268788', '0');
INSERT INTO `gametx28_auto` VALUES ('1301', '0', '0', '0', '10000', '60', '1', '1', '268857', '0');
INSERT INTO `gametx28_auto` VALUES ('1302', '0', '0', '0', '10000', '60', '1', '1', '268864', '0');
INSERT INTO `gametx28_auto` VALUES ('1303', '0', '0', '0', '10000', '60', '1', '1', '268893', '0');
INSERT INTO `gametx28_auto` VALUES ('1304', '0', '0', '0', '10000', '60', '1', '1', '268898', '0');
INSERT INTO `gametx28_auto` VALUES ('1305', '0', '0', '0', '10000', '60', '1', '1', '268981', '0');
INSERT INTO `gametx28_auto` VALUES ('1306', '0', '0', '0', '10000', '60', '1', '1', '269013', '0');
INSERT INTO `gametx28_auto` VALUES ('1307', '0', '0', '0', '10000', '60', '1', '1', '269031', '0');
INSERT INTO `gametx28_auto` VALUES ('1308', '0', '0', '0', '10000', '60', '1', '1', '269052', '0');
INSERT INTO `gametx28_auto` VALUES ('1309', '0', '0', '0', '10000', '60', '1', '1', '269058', '0');
INSERT INTO `gametx28_auto` VALUES ('1310', '0', '0', '0', '10000', '60', '1', '1', '269066', '0');
INSERT INTO `gametx28_auto` VALUES ('1311', '0', '0', '0', '10000', '60', '1', '1', '269091', '0');
INSERT INTO `gametx28_auto` VALUES ('1312', '0', '0', '0', '10000', '60', '1', '1', '269107', '0');
INSERT INTO `gametx28_auto` VALUES ('1313', '0', '0', '0', '10000', '60', '1', '1', '269126', '0');
INSERT INTO `gametx28_auto` VALUES ('1314', '0', '0', '0', '10000', '60', '1', '1', '269150', '0');
INSERT INTO `gametx28_auto` VALUES ('1315', '0', '0', '0', '10000', '60', '1', '1', '269160', '0');
INSERT INTO `gametx28_auto` VALUES ('1316', '0', '0', '0', '10000', '60', '1', '1', '269201', '0');
INSERT INTO `gametx28_auto` VALUES ('1317', '0', '0', '0', '10000', '60', '1', '1', '269257', '0');
INSERT INTO `gametx28_auto` VALUES ('1318', '0', '0', '0', '10000', '60', '1', '1', '269313', '0');
INSERT INTO `gametx28_auto` VALUES ('1319', '0', '0', '0', '10000', '60', '1', '1', '269344', '0');
INSERT INTO `gametx28_auto` VALUES ('1320', '0', '0', '0', '10000', '60', '1', '1', '269361', '0');
INSERT INTO `gametx28_auto` VALUES ('1321', '0', '0', '0', '10000', '60', '1', '1', '269379', '0');
INSERT INTO `gametx28_auto` VALUES ('1322', '0', '0', '0', '10000', '60', '1', '1', '269401', '0');
INSERT INTO `gametx28_auto` VALUES ('1323', '0', '0', '0', '10000', '60', '1', '1', '269427', '0');
INSERT INTO `gametx28_auto` VALUES ('1324', '0', '0', '0', '10000', '60', '1', '1', '269429', '0');
INSERT INTO `gametx28_auto` VALUES ('1325', '0', '0', '0', '10000', '60', '1', '1', '269432', '0');


-- ----------------------------
-- Table structure for gametx36_auto
-- ----------------------------
DROP TABLE IF EXISTS `gametx36_auto`;
CREATE TABLE `gametx36_auto` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `startNO` int(11) DEFAULT '0' COMMENT '开始期号',
  `endNO` int(11) DEFAULT '0' COMMENT '结束期号',
  `minG` int(11) DEFAULT '0' COMMENT '账户最小值（小于次数时自动停止）',
  `maxG` int(11) DEFAULT '0' COMMENT '账户最大值（大于次数时自动停止）',
  `autoid` int(11) DEFAULT '0' COMMENT '自动模式ID',
  `usertype` int(11) DEFAULT '0' COMMENT '用户类型，0：用户，1：机器人',
  `status` int(11) DEFAULT '1' COMMENT '状态，只对机器人起作用',
  `uid` int(11) DEFAULT NULL COMMENT '用户ID',
  `start_auto_id` int(11) DEFAULT '0' COMMENT '默认投注名称id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uid` (`uid`) USING BTREE,
  KEY `startNO` (`startNO`,`endNO`,`autoid`,`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=utf8 COMMENT='腾讯36自动投注';

-- ----------------------------
-- Records of gametx36_auto
-- ----------------------------
INSERT INTO `gametx36_auto` VALUES ('1', '0', '0', '0', '10000', '54', '1', '1', '367827', '0');
INSERT INTO `gametx36_auto` VALUES ('2', '0', '0', '0', '10000', '54', '1', '1', '367830', '0');
INSERT INTO `gametx36_auto` VALUES ('3', '0', '0', '0', '10000', '54', '1', '1', '367839', '0');
INSERT INTO `gametx36_auto` VALUES ('4', '0', '0', '0', '10000', '54', '1', '1', '367841', '0');
INSERT INTO `gametx36_auto` VALUES ('5', '0', '0', '0', '10000', '54', '1', '1', '367852', '0');
INSERT INTO `gametx36_auto` VALUES ('6', '0', '0', '0', '10000', '54', '1', '1', '367869', '0');
INSERT INTO `gametx36_auto` VALUES ('7', '0', '0', '0', '10000', '54', '1', '1', '367887', '0');
INSERT INTO `gametx36_auto` VALUES ('8', '0', '0', '0', '10000', '54', '1', '1', '367914', '0');
INSERT INTO `gametx36_auto` VALUES ('9', '0', '0', '0', '10000', '54', '1', '1', '367931', '0');
INSERT INTO `gametx36_auto` VALUES ('10', '0', '0', '0', '10000', '54', '1', '1', '367941', '0');
INSERT INTO `gametx36_auto` VALUES ('11', '0', '0', '0', '10000', '54', '1', '1', '367995', '0');
INSERT INTO `gametx36_auto` VALUES ('12', '0', '0', '0', '10000', '54', '1', '1', '367998', '0');
INSERT INTO `gametx36_auto` VALUES ('13', '0', '0', '0', '10000', '54', '1', '1', '368008', '0');
INSERT INTO `gametx36_auto` VALUES ('14', '0', '0', '0', '10000', '54', '1', '1', '368081', '0');
INSERT INTO `gametx36_auto` VALUES ('15', '0', '0', '0', '10000', '54', '1', '1', '368116', '0');
INSERT INTO `gametx36_auto` VALUES ('16', '0', '0', '0', '10000', '54', '1', '1', '368121', '0');
INSERT INTO `gametx36_auto` VALUES ('17', '0', '0', '0', '10000', '54', '1', '1', '368206', '0');
INSERT INTO `gametx36_auto` VALUES ('18', '0', '0', '0', '10000', '54', '1', '1', '368249', '0');
INSERT INTO `gametx36_auto` VALUES ('19', '0', '0', '0', '10000', '54', '1', '1', '368262', '0');
INSERT INTO `gametx36_auto` VALUES ('20', '0', '0', '0', '10000', '54', '1', '1', '368295', '0');
INSERT INTO `gametx36_auto` VALUES ('21', '0', '0', '0', '10000', '54', '1', '1', '368311', '0');
INSERT INTO `gametx36_auto` VALUES ('22', '0', '0', '0', '10000', '54', '1', '1', '368325', '0');
INSERT INTO `gametx36_auto` VALUES ('23', '0', '0', '0', '10000', '54', '1', '1', '368337', '0');
INSERT INTO `gametx36_auto` VALUES ('24', '0', '0', '0', '10000', '54', '1', '1', '368469', '0');
INSERT INTO `gametx36_auto` VALUES ('25', '0', '0', '0', '10000', '54', '1', '1', '368492', '0');
INSERT INTO `gametx36_auto` VALUES ('26', '0', '0', '0', '10000', '54', '1', '1', '368547', '0');
INSERT INTO `gametx36_auto` VALUES ('27', '0', '0', '0', '10000', '54', '1', '1', '368550', '0');
INSERT INTO `gametx36_auto` VALUES ('28', '0', '0', '0', '10000', '54', '1', '1', '368553', '0');
INSERT INTO `gametx36_auto` VALUES ('29', '0', '0', '0', '10000', '54', '1', '1', '368586', '0');
INSERT INTO `gametx36_auto` VALUES ('30', '0', '0', '0', '10000', '54', '1', '1', '368602', '0');
INSERT INTO `gametx36_auto` VALUES ('31', '0', '0', '0', '10000', '54', '1', '1', '368612', '0');
INSERT INTO `gametx36_auto` VALUES ('32', '0', '0', '0', '10000', '54', '1', '1', '368623', '0');
INSERT INTO `gametx36_auto` VALUES ('33', '0', '0', '0', '10000', '54', '1', '1', '368635', '0');
INSERT INTO `gametx36_auto` VALUES ('34', '0', '0', '0', '10000', '54', '1', '1', '368688', '0');
INSERT INTO `gametx36_auto` VALUES ('35', '0', '0', '0', '10000', '54', '1', '1', '368706', '0');
INSERT INTO `gametx36_auto` VALUES ('36', '0', '0', '0', '10000', '54', '1', '1', '368724', '0');
INSERT INTO `gametx36_auto` VALUES ('37', '0', '0', '0', '10000', '54', '1', '1', '368769', '0');
INSERT INTO `gametx36_auto` VALUES ('38', '0', '0', '0', '10000', '54', '1', '1', '368778', '0');
INSERT INTO `gametx36_auto` VALUES ('39', '0', '0', '0', '10000', '54', '1', '1', '368782', '0');
INSERT INTO `gametx36_auto` VALUES ('40', '0', '0', '0', '10000', '54', '1', '1', '368810', '0');
INSERT INTO `gametx36_auto` VALUES ('41', '0', '0', '0', '10000', '54', '1', '1', '368847', '0');
INSERT INTO `gametx36_auto` VALUES ('42', '0', '0', '0', '10000', '54', '1', '1', '368884', '0');
INSERT INTO `gametx36_auto` VALUES ('43', '0', '0', '0', '10000', '54', '1', '1', '368896', '0');
INSERT INTO `gametx36_auto` VALUES ('44', '0', '0', '0', '10000', '54', '1', '1', '368925', '0');
INSERT INTO `gametx36_auto` VALUES ('45', '0', '0', '0', '10000', '54', '1', '1', '368936', '0');
INSERT INTO `gametx36_auto` VALUES ('46', '0', '0', '0', '10000', '54', '1', '1', '368945', '0');
INSERT INTO `gametx36_auto` VALUES ('47', '0', '0', '0', '10000', '54', '1', '1', '368964', '0');
INSERT INTO `gametx36_auto` VALUES ('48', '0', '0', '0', '10000', '54', '1', '1', '368996', '0');
INSERT INTO `gametx36_auto` VALUES ('49', '0', '0', '0', '10000', '54', '1', '1', '369022', '0');
INSERT INTO `gametx36_auto` VALUES ('50', '0', '0', '0', '10000', '54', '1', '1', '369037', '0');
INSERT INTO `gametx36_auto` VALUES ('51', '0', '0', '0', '10000', '54', '1', '1', '369052', '0');
INSERT INTO `gametx36_auto` VALUES ('52', '0', '0', '0', '10000', '54', '1', '1', '369057', '0');
INSERT INTO `gametx36_auto` VALUES ('53', '0', '0', '0', '10000', '54', '1', '1', '369060', '0');
INSERT INTO `gametx36_auto` VALUES ('54', '0', '0', '0', '10000', '54', '1', '1', '369075', '0');
INSERT INTO `gametx36_auto` VALUES ('55', '0', '0', '0', '10000', '54', '1', '1', '369082', '0');
INSERT INTO `gametx36_auto` VALUES ('56', '0', '0', '0', '10000', '54', '1', '1', '369090', '0');
INSERT INTO `gametx36_auto` VALUES ('57', '0', '0', '0', '10000', '54', '1', '1', '369122', '0');
INSERT INTO `gametx36_auto` VALUES ('58', '0', '0', '0', '10000', '54', '1', '1', '369185', '0');
INSERT INTO `gametx36_auto` VALUES ('59', '0', '0', '0', '10000', '54', '1', '1', '369219', '0');
INSERT INTO `gametx36_auto` VALUES ('60', '0', '0', '0', '10000', '54', '1', '1', '369257', '0');
INSERT INTO `gametx36_auto` VALUES ('61', '0', '0', '0', '10000', '54', '1', '1', '369258', '0');
INSERT INTO `gametx36_auto` VALUES ('62', '0', '0', '0', '10000', '54', '1', '1', '369259', '0');
INSERT INTO `gametx36_auto` VALUES ('63', '0', '0', '0', '10000', '54', '1', '1', '369277', '0');
INSERT INTO `gametx36_auto` VALUES ('64', '0', '0', '0', '10000', '54', '1', '1', '369294', '0');
INSERT INTO `gametx36_auto` VALUES ('65', '0', '0', '0', '10000', '54', '1', '1', '369328', '0');
INSERT INTO `gametx36_auto` VALUES ('66', '0', '0', '0', '10000', '54', '1', '1', '369352', '0');
INSERT INTO `gametx36_auto` VALUES ('67', '0', '0', '0', '10000', '54', '1', '1', '369372', '0');
INSERT INTO `gametx36_auto` VALUES ('68', '0', '0', '0', '10000', '54', '1', '1', '369451', '0');
INSERT INTO `gametx36_auto` VALUES ('69', '0', '0', '0', '10000', '54', '1', '1', '369463', '0');
INSERT INTO `gametx36_auto` VALUES ('70', '0', '0', '0', '10000', '54', '1', '1', '369512', '0');
INSERT INTO `gametx36_auto` VALUES ('71', '0', '0', '0', '10000', '54', '1', '1', '369574', '0');
INSERT INTO `gametx36_auto` VALUES ('72', '0', '0', '0', '10000', '54', '1', '1', '369627', '0');
INSERT INTO `gametx36_auto` VALUES ('73', '0', '0', '0', '10000', '54', '1', '1', '369646', '0');
INSERT INTO `gametx36_auto` VALUES ('74', '0', '0', '0', '10000', '54', '1', '1', '369709', '0');
INSERT INTO `gametx36_auto` VALUES ('75', '0', '0', '0', '10000', '54', '1', '1', '369735', '0');
INSERT INTO `gametx36_auto` VALUES ('76', '0', '0', '0', '10000', '54', '1', '1', '369795', '0');
INSERT INTO `gametx36_auto` VALUES ('77', '0', '0', '0', '10000', '54', '1', '1', '369822', '0');
INSERT INTO `gametx36_auto` VALUES ('78', '0', '0', '0', '10000', '54', '1', '1', '369858', '0');
INSERT INTO `gametx36_auto` VALUES ('79', '0', '0', '0', '10000', '54', '1', '1', '369862', '0');
INSERT INTO `gametx36_auto` VALUES ('80', '0', '0', '0', '10000', '54', '1', '1', '369874', '0');
INSERT INTO `gametx36_auto` VALUES ('81', '0', '0', '0', '10000', '54', '1', '1', '369878', '0');
INSERT INTO `gametx36_auto` VALUES ('82', '0', '0', '0', '10000', '54', '1', '1', '369936', '0');
INSERT INTO `gametx36_auto` VALUES ('83', '0', '0', '0', '10000', '54', '1', '1', '369949', '0');
INSERT INTO `gametx36_auto` VALUES ('84', '0', '0', '0', '10000', '54', '1', '1', '369950', '0');
INSERT INTO `gametx36_auto` VALUES ('85', '0', '0', '0', '10000', '54', '1', '1', '369953', '0');
INSERT INTO `gametx36_auto` VALUES ('86', '0', '0', '0', '10000', '54', '1', '1', '370065', '0');
INSERT INTO `gametx36_auto` VALUES ('87', '0', '0', '0', '10000', '54', '1', '1', '370072', '0');
INSERT INTO `gametx36_auto` VALUES ('88', '0', '0', '0', '10000', '54', '1', '1', '370158', '0');
INSERT INTO `gametx36_auto` VALUES ('89', '0', '0', '0', '10000', '54', '1', '1', '370184', '0');
INSERT INTO `gametx36_auto` VALUES ('90', '0', '0', '0', '10000', '54', '1', '1', '370201', '0');
INSERT INTO `gametx36_auto` VALUES ('91', '0', '0', '0', '10000', '54', '1', '1', '370234', '0');
INSERT INTO `gametx36_auto` VALUES ('92', '0', '0', '0', '10000', '54', '1', '1', '370244', '0');
INSERT INTO `gametx36_auto` VALUES ('93', '0', '0', '0', '10000', '54', '1', '1', '370256', '0');
INSERT INTO `gametx36_auto` VALUES ('94', '0', '0', '0', '10000', '54', '1', '1', '370274', '0');
INSERT INTO `gametx36_auto` VALUES ('95', '0', '0', '0', '10000', '54', '1', '1', '370329', '0');
INSERT INTO `gametx36_auto` VALUES ('96', '0', '0', '0', '10000', '54', '1', '1', '370352', '0');
INSERT INTO `gametx36_auto` VALUES ('97', '0', '0', '0', '10000', '54', '1', '1', '370363', '0');
INSERT INTO `gametx36_auto` VALUES ('98', '0', '0', '0', '10000', '54', '1', '1', '370417', '0');
INSERT INTO `gametx36_auto` VALUES ('99', '0', '0', '0', '10000', '54', '1', '1', '370428', '0');
INSERT INTO `gametx36_auto` VALUES ('100', '0', '0', '0', '10000', '54', '1', '1', '370438', '0');
INSERT INTO `gametx36_auto` VALUES ('101', '0', '0', '0', '10000', '54', '1', '1', '370488', '0');
INSERT INTO `gametx36_auto` VALUES ('102', '0', '0', '0', '10000', '54', '1', '1', '370529', '0');
INSERT INTO `gametx36_auto` VALUES ('103', '0', '0', '0', '10000', '54', '1', '1', '370563', '0');
INSERT INTO `gametx36_auto` VALUES ('104', '0', '0', '0', '10000', '54', '1', '1', '370566', '0');
INSERT INTO `gametx36_auto` VALUES ('105', '0', '0', '0', '10000', '54', '1', '1', '370621', '0');
INSERT INTO `gametx36_auto` VALUES ('106', '0', '0', '0', '10000', '54', '1', '1', '370623', '0');
INSERT INTO `gametx36_auto` VALUES ('107', '0', '0', '0', '10000', '54', '1', '1', '370652', '0');
INSERT INTO `gametx36_auto` VALUES ('108', '0', '0', '0', '10000', '54', '1', '1', '370655', '0');
INSERT INTO `gametx36_auto` VALUES ('109', '0', '0', '0', '10000', '54', '1', '1', '370669', '0');
INSERT INTO `gametx36_auto` VALUES ('110', '0', '0', '0', '10000', '54', '1', '1', '370702', '0');
INSERT INTO `gametx36_auto` VALUES ('111', '0', '0', '0', '10000', '54', '1', '1', '370718', '0');
INSERT INTO `gametx36_auto` VALUES ('112', '0', '0', '0', '10000', '54', '1', '1', '370719', '0');
INSERT INTO `gametx36_auto` VALUES ('113', '0', '0', '0', '10000', '54', '1', '1', '370738', '0');
INSERT INTO `gametx36_auto` VALUES ('114', '0', '0', '0', '10000', '54', '1', '1', '370776', '0');
INSERT INTO `gametx36_auto` VALUES ('115', '0', '0', '0', '10000', '54', '1', '1', '370835', '0');
INSERT INTO `gametx36_auto` VALUES ('116', '0', '0', '0', '10000', '54', '1', '1', '370857', '0');
INSERT INTO `gametx36_auto` VALUES ('117', '0', '0', '0', '10000', '54', '1', '1', '370890', '0');
INSERT INTO `gametx36_auto` VALUES ('118', '0', '0', '0', '10000', '54', '1', '1', '370950', '0');
INSERT INTO `gametx36_auto` VALUES ('119', '0', '0', '0', '10000', '54', '1', '1', '370965', '0');
INSERT INTO `gametx36_auto` VALUES ('120', '0', '0', '0', '10000', '54', '1', '1', '371025', '0');
INSERT INTO `gametx36_auto` VALUES ('121', '0', '0', '0', '10000', '54', '1', '1', '371062', '0');
INSERT INTO `gametx36_auto` VALUES ('122', '0', '0', '0', '10000', '54', '1', '1', '371088', '0');
INSERT INTO `gametx36_auto` VALUES ('123', '0', '0', '0', '10000', '54', '1', '1', '371108', '0');
INSERT INTO `gametx36_auto` VALUES ('124', '0', '0', '0', '10000', '54', '1', '1', '371110', '0');
INSERT INTO `gametx36_auto` VALUES ('125', '0', '0', '0', '10000', '54', '1', '1', '371135', '0');
INSERT INTO `gametx36_auto` VALUES ('126', '0', '0', '0', '10000', '54', '1', '1', '371137', '0');
INSERT INTO `gametx36_auto` VALUES ('127', '0', '0', '0', '10000', '54', '1', '1', '371178', '0');
INSERT INTO `gametx36_auto` VALUES ('128', '0', '0', '0', '10000', '54', '1', '1', '371224', '0');
INSERT INTO `gametx36_auto` VALUES ('129', '0', '0', '0', '10000', '54', '1', '1', '371227', '0');
INSERT INTO `gametx36_auto` VALUES ('130', '0', '0', '0', '10000', '54', '1', '1', '371230', '0');
INSERT INTO `gametx36_auto` VALUES ('131', '0', '0', '0', '10000', '54', '1', '1', '371264', '0');
INSERT INTO `gametx36_auto` VALUES ('132', '0', '0', '0', '10000', '54', '1', '1', '371265', '0');
INSERT INTO `gametx36_auto` VALUES ('133', '0', '0', '0', '10000', '54', '1', '1', '371294', '0');
INSERT INTO `gametx36_auto` VALUES ('134', '0', '0', '0', '10000', '54', '1', '1', '371324', '0');
INSERT INTO `gametx36_auto` VALUES ('135', '0', '0', '0', '10000', '54', '1', '1', '371428', '0');
INSERT INTO `gametx36_auto` VALUES ('136', '0', '0', '0', '10000', '54', '1', '1', '371488', '0');
INSERT INTO `gametx36_auto` VALUES ('137', '0', '0', '0', '10000', '54', '1', '1', '371555', '0');
INSERT INTO `gametx36_auto` VALUES ('138', '0', '0', '0', '10000', '54', '1', '1', '371567', '0');
INSERT INTO `gametx36_auto` VALUES ('139', '0', '0', '0', '10000', '54', '1', '1', '371583', '0');
INSERT INTO `gametx36_auto` VALUES ('140', '0', '0', '0', '10000', '54', '1', '1', '371615', '0');
INSERT INTO `gametx36_auto` VALUES ('141', '0', '0', '0', '10000', '54', '1', '1', '371616', '0');
INSERT INTO `gametx36_auto` VALUES ('142', '0', '0', '0', '10000', '54', '1', '1', '371722', '0');
INSERT INTO `gametx36_auto` VALUES ('143', '0', '0', '0', '10000', '54', '1', '1', '371729', '0');
INSERT INTO `gametx36_auto` VALUES ('144', '0', '0', '0', '10000', '54', '1', '1', '371820', '0');
INSERT INTO `gametx36_auto` VALUES ('145', '0', '0', '0', '10000', '54', '1', '1', '371913', '0');
INSERT INTO `gametx36_auto` VALUES ('146', '0', '0', '0', '10000', '54', '1', '1', '371952', '0');
INSERT INTO `gametx36_auto` VALUES ('147', '0', '0', '0', '10000', '54', '1', '1', '371969', '0');
INSERT INTO `gametx36_auto` VALUES ('148', '0', '0', '0', '10000', '54', '1', '1', '372007', '0');
INSERT INTO `gametx36_auto` VALUES ('149', '0', '0', '0', '10000', '54', '1', '1', '372019', '0');
INSERT INTO `gametx36_auto` VALUES ('150', '0', '0', '0', '10000', '54', '1', '1', '372049', '0');
INSERT INTO `gametx36_auto` VALUES ('151', '0', '0', '0', '10000', '54', '1', '1', '372059', '0');
INSERT INTO `gametx36_auto` VALUES ('152', '0', '0', '0', '10000', '54', '1', '1', '372060', '0');
INSERT INTO `gametx36_auto` VALUES ('153', '0', '0', '0', '10000', '54', '1', '1', '372067', '0');
INSERT INTO `gametx36_auto` VALUES ('154', '0', '0', '0', '10000', '54', '1', '1', '372080', '0');
INSERT INTO `gametx36_auto` VALUES ('155', '0', '0', '0', '10000', '54', '1', '1', '372112', '0');
INSERT INTO `gametx36_auto` VALUES ('156', '0', '0', '0', '10000', '54', '1', '1', '372117', '0');
INSERT INTO `gametx36_auto` VALUES ('157', '0', '0', '0', '10000', '54', '1', '1', '372128', '0');
INSERT INTO `gametx36_auto` VALUES ('158', '0', '0', '0', '10000', '54', '1', '1', '372175', '0');
INSERT INTO `gametx36_auto` VALUES ('159', '0', '0', '0', '10000', '54', '1', '1', '372349', '0');
INSERT INTO `gametx36_auto` VALUES ('160', '0', '0', '0', '10000', '54', '1', '1', '372372', '0');
INSERT INTO `gametx36_auto` VALUES ('161', '0', '0', '0', '10000', '54', '1', '1', '372382', '0');
INSERT INTO `gametx36_auto` VALUES ('162', '0', '0', '0', '10000', '54', '1', '1', '372399', '0');
INSERT INTO `gametx36_auto` VALUES ('163', '0', '0', '0', '10000', '54', '1', '1', '372417', '0');
INSERT INTO `gametx36_auto` VALUES ('164', '0', '0', '0', '10000', '54', '1', '1', '372449', '0');
INSERT INTO `gametx36_auto` VALUES ('165', '0', '0', '0', '10000', '54', '1', '1', '372461', '0');
INSERT INTO `gametx36_auto` VALUES ('166', '0', '0', '0', '10000', '54', '1', '1', '372470', '0');
INSERT INTO `gametx36_auto` VALUES ('167', '0', '0', '0', '10000', '54', '1', '1', '372504', '0');
INSERT INTO `gametx36_auto` VALUES ('168', '0', '0', '0', '10000', '54', '1', '1', '372519', '0');
INSERT INTO `gametx36_auto` VALUES ('169', '0', '0', '0', '10000', '54', '1', '1', '372521', '0');
INSERT INTO `gametx36_auto` VALUES ('170', '0', '0', '0', '10000', '54', '1', '1', '372552', '0');
INSERT INTO `gametx36_auto` VALUES ('171', '0', '0', '0', '10000', '54', '1', '1', '372576', '0');
INSERT INTO `gametx36_auto` VALUES ('172', '0', '0', '0', '10000', '54', '1', '1', '372578', '0');
INSERT INTO `gametx36_auto` VALUES ('173', '0', '0', '0', '10000', '54', '1', '1', '372588', '0');
INSERT INTO `gametx36_auto` VALUES ('174', '0', '0', '0', '10000', '54', '1', '1', '372611', '0');
INSERT INTO `gametx36_auto` VALUES ('175', '0', '0', '0', '10000', '54', '1', '1', '372638', '0');
INSERT INTO `gametx36_auto` VALUES ('176', '0', '0', '0', '10000', '54', '1', '1', '372640', '0');
INSERT INTO `gametx36_auto` VALUES ('177', '0', '0', '0', '10000', '54', '1', '1', '372655', '0');
INSERT INTO `gametx36_auto` VALUES ('178', '0', '0', '0', '10000', '54', '1', '1', '372672', '0');
INSERT INTO `gametx36_auto` VALUES ('179', '0', '0', '0', '10000', '54', '1', '1', '372681', '0');
INSERT INTO `gametx36_auto` VALUES ('180', '0', '0', '0', '10000', '54', '1', '1', '372714', '0');
INSERT INTO `gametx36_auto` VALUES ('181', '0', '0', '0', '10000', '54', '1', '1', '372736', '0');
INSERT INTO `gametx36_auto` VALUES ('182', '0', '0', '0', '10000', '54', '1', '1', '372774', '0');
INSERT INTO `gametx36_auto` VALUES ('183', '0', '0', '0', '10000', '54', '1', '1', '372786', '0');
INSERT INTO `gametx36_auto` VALUES ('184', '0', '0', '0', '10000', '54', '1', '1', '372807', '0');
INSERT INTO `gametx36_auto` VALUES ('185', '0', '0', '0', '10000', '54', '1', '1', '372812', '0');
INSERT INTO `gametx36_auto` VALUES ('186', '0', '0', '0', '10000', '54', '1', '1', '372861', '0');
INSERT INTO `gametx36_auto` VALUES ('187', '0', '0', '0', '10000', '54', '1', '1', '372862', '0');
INSERT INTO `gametx36_auto` VALUES ('188', '0', '0', '0', '10000', '54', '1', '1', '372908', '0');
INSERT INTO `gametx36_auto` VALUES ('189', '0', '0', '0', '10000', '54', '1', '1', '372964', '0');
INSERT INTO `gametx36_auto` VALUES ('190', '0', '0', '0', '10000', '54', '1', '1', '372988', '0');
INSERT INTO `gametx36_auto` VALUES ('191', '0', '0', '0', '10000', '54', '1', '1', '373010', '0');
INSERT INTO `gametx36_auto` VALUES ('192', '0', '0', '0', '10000', '54', '1', '1', '373014', '0');
INSERT INTO `gametx36_auto` VALUES ('193', '0', '0', '0', '10000', '54', '1', '1', '373016', '0');
INSERT INTO `gametx36_auto` VALUES ('194', '0', '0', '0', '10000', '54', '1', '1', '373034', '0');
INSERT INTO `gametx36_auto` VALUES ('195', '0', '0', '0', '10000', '54', '1', '1', '373089', '0');
INSERT INTO `gametx36_auto` VALUES ('196', '0', '0', '0', '10000', '54', '1', '1', '373112', '0');
INSERT INTO `gametx36_auto` VALUES ('197', '0', '0', '0', '10000', '54', '1', '1', '373119', '0');
INSERT INTO `gametx36_auto` VALUES ('198', '0', '0', '0', '10000', '54', '1', '1', '373149', '0');
INSERT INTO `gametx36_auto` VALUES ('199', '0', '0', '0', '10000', '54', '1', '1', '373151', '0');
INSERT INTO `gametx36_auto` VALUES ('200', '0', '0', '0', '10000', '54', '1', '1', '373213', '0');
INSERT INTO `gametx36_auto` VALUES ('201', '0', '0', '0', '10000', '54', '1', '1', '373229', '0');
INSERT INTO `gametx36_auto` VALUES ('202', '0', '0', '0', '10000', '54', '1', '1', '373263', '0');
INSERT INTO `gametx36_auto` VALUES ('203', '0', '0', '0', '10000', '54', '1', '1', '373299', '0');
INSERT INTO `gametx36_auto` VALUES ('204', '0', '0', '0', '10000', '54', '1', '1', '373325', '0');
INSERT INTO `gametx36_auto` VALUES ('205', '0', '0', '0', '10000', '54', '1', '1', '373330', '0');
INSERT INTO `gametx36_auto` VALUES ('206', '0', '0', '0', '10000', '54', '1', '1', '373395', '0');
INSERT INTO `gametx36_auto` VALUES ('207', '0', '0', '0', '10000', '54', '1', '1', '373452', '0');
INSERT INTO `gametx36_auto` VALUES ('208', '0', '0', '0', '10000', '54', '1', '1', '373459', '0');
INSERT INTO `gametx36_auto` VALUES ('209', '0', '0', '0', '10000', '54', '1', '1', '373498', '0');
INSERT INTO `gametx36_auto` VALUES ('210', '0', '0', '0', '10000', '54', '1', '1', '373519', '0');
INSERT INTO `gametx36_auto` VALUES ('211', '0', '0', '0', '10000', '54', '1', '1', '373524', '0');
INSERT INTO `gametx36_auto` VALUES ('212', '0', '0', '0', '10000', '54', '1', '1', '373559', '0');
INSERT INTO `gametx36_auto` VALUES ('213', '0', '0', '0', '10000', '54', '1', '1', '373570', '0');
INSERT INTO `gametx36_auto` VALUES ('214', '0', '0', '0', '10000', '54', '1', '1', '373579', '0');
INSERT INTO `gametx36_auto` VALUES ('215', '0', '0', '0', '10000', '54', '1', '1', '373600', '0');
INSERT INTO `gametx36_auto` VALUES ('216', '0', '0', '0', '10000', '54', '1', '1', '373646', '0');
INSERT INTO `gametx36_auto` VALUES ('217', '0', '0', '0', '10000', '54', '1', '1', '373659', '0');
INSERT INTO `gametx36_auto` VALUES ('218', '0', '0', '0', '10000', '54', '1', '1', '373679', '0');
INSERT INTO `gametx36_auto` VALUES ('219', '0', '0', '0', '10000', '54', '1', '1', '373728', '0');
INSERT INTO `gametx36_auto` VALUES ('220', '0', '0', '0', '10000', '54', '1', '1', '373752', '0');
INSERT INTO `gametx36_auto` VALUES ('221', '0', '0', '0', '10000', '54', '1', '1', '373753', '0');
INSERT INTO `gametx36_auto` VALUES ('222', '0', '0', '0', '10000', '54', '1', '1', '373761', '0');
INSERT INTO `gametx36_auto` VALUES ('223', '0', '0', '0', '10000', '54', '1', '1', '373777', '0');
INSERT INTO `gametx36_auto` VALUES ('224', '0', '0', '0', '10000', '54', '1', '1', '373821', '0');
INSERT INTO `gametx36_auto` VALUES ('225', '0', '0', '0', '10000', '54', '1', '1', '373857', '0');
INSERT INTO `gametx36_auto` VALUES ('226', '0', '0', '0', '10000', '54', '1', '1', '373880', '0');
INSERT INTO `gametx36_auto` VALUES ('227', '0', '0', '0', '10000', '54', '1', '1', '373881', '0');
INSERT INTO `gametx36_auto` VALUES ('228', '0', '0', '0', '10000', '54', '1', '1', '373938', '0');
INSERT INTO `gametx36_auto` VALUES ('229', '0', '0', '0', '10000', '54', '1', '1', '373974', '0');
INSERT INTO `gametx36_auto` VALUES ('230', '0', '0', '0', '10000', '54', '1', '1', '373981', '0');
INSERT INTO `gametx36_auto` VALUES ('231', '0', '0', '0', '10000', '54', '1', '1', '374012', '0');
INSERT INTO `gametx36_auto` VALUES ('232', '0', '0', '0', '10000', '54', '1', '1', '374026', '0');
INSERT INTO `gametx36_auto` VALUES ('233', '0', '0', '0', '10000', '54', '1', '1', '374056', '0');
INSERT INTO `gametx36_auto` VALUES ('234', '0', '0', '0', '10000', '54', '1', '1', '374057', '0');
INSERT INTO `gametx36_auto` VALUES ('235', '0', '0', '0', '10000', '54', '1', '1', '374111', '0');
INSERT INTO `gametx36_auto` VALUES ('236', '0', '0', '0', '10000', '54', '1', '1', '374124', '0');
INSERT INTO `gametx36_auto` VALUES ('237', '0', '0', '0', '10000', '54', '1', '1', '374126', '0');
INSERT INTO `gametx36_auto` VALUES ('238', '0', '0', '0', '10000', '54', '1', '1', '374142', '0');
INSERT INTO `gametx36_auto` VALUES ('239', '0', '0', '0', '10000', '54', '1', '1', '374214', '0');
INSERT INTO `gametx36_auto` VALUES ('240', '0', '0', '0', '10000', '54', '1', '1', '374226', '0');
INSERT INTO `gametx36_auto` VALUES ('241', '0', '0', '0', '10000', '54', '1', '1', '374250', '0');
INSERT INTO `gametx36_auto` VALUES ('242', '0', '0', '0', '10000', '54', '1', '1', '374278', '0');
INSERT INTO `gametx36_auto` VALUES ('243', '0', '0', '0', '10000', '54', '1', '1', '374332', '0');
INSERT INTO `gametx36_auto` VALUES ('244', '0', '0', '0', '10000', '54', '1', '1', '374366', '0');
INSERT INTO `gametx36_auto` VALUES ('245', '0', '0', '0', '10000', '54', '1', '1', '374368', '0');
INSERT INTO `gametx36_auto` VALUES ('246', '0', '0', '0', '10000', '54', '1', '1', '374383', '0');
INSERT INTO `gametx36_auto` VALUES ('247', '0', '0', '0', '10000', '54', '1', '1', '374453', '0');
INSERT INTO `gametx36_auto` VALUES ('248', '0', '0', '0', '10000', '54', '1', '1', '374457', '0');
INSERT INTO `gametx36_auto` VALUES ('249', '0', '0', '0', '10000', '54', '1', '1', '374527', '0');
INSERT INTO `gametx36_auto` VALUES ('250', '0', '0', '0', '10000', '54', '1', '1', '374530', '0');
INSERT INTO `gametx36_auto` VALUES ('256', '0', '0', '0', '10000', '55', '1', '1', '264477', '0');
INSERT INTO `gametx36_auto` VALUES ('257', '0', '0', '0', '10000', '55', '1', '1', '264540', '0');
INSERT INTO `gametx36_auto` VALUES ('258', '0', '0', '0', '10000', '55', '1', '1', '264543', '0');
INSERT INTO `gametx36_auto` VALUES ('259', '0', '0', '0', '10000', '55', '1', '1', '264562', '0');
INSERT INTO `gametx36_auto` VALUES ('260', '0', '0', '0', '10000', '55', '1', '1', '264596', '0');
INSERT INTO `gametx36_auto` VALUES ('261', '0', '0', '0', '10000', '55', '1', '1', '264637', '0');
INSERT INTO `gametx36_auto` VALUES ('262', '0', '0', '0', '10000', '55', '1', '1', '264655', '0');
INSERT INTO `gametx36_auto` VALUES ('263', '0', '0', '0', '10000', '55', '1', '1', '264679', '0');
INSERT INTO `gametx36_auto` VALUES ('264', '0', '0', '0', '10000', '55', '1', '1', '264686', '0');
INSERT INTO `gametx36_auto` VALUES ('265', '0', '0', '0', '10000', '55', '1', '1', '264692', '0');
INSERT INTO `gametx36_auto` VALUES ('266', '0', '0', '0', '10000', '55', '1', '1', '264733', '0');
INSERT INTO `gametx36_auto` VALUES ('267', '0', '0', '0', '10000', '55', '1', '1', '264737', '0');
INSERT INTO `gametx36_auto` VALUES ('268', '0', '0', '0', '10000', '55', '1', '1', '264776', '0');
INSERT INTO `gametx36_auto` VALUES ('269', '0', '0', '0', '10000', '55', '1', '1', '264803', '0');
INSERT INTO `gametx36_auto` VALUES ('270', '0', '0', '0', '10000', '55', '1', '1', '264827', '0');
INSERT INTO `gametx36_auto` VALUES ('271', '0', '0', '0', '10000', '55', '1', '1', '264832', '0');
INSERT INTO `gametx36_auto` VALUES ('272', '0', '0', '0', '10000', '55', '1', '1', '264840', '0');
INSERT INTO `gametx36_auto` VALUES ('273', '0', '0', '0', '10000', '55', '1', '1', '264860', '0');
INSERT INTO `gametx36_auto` VALUES ('274', '0', '0', '0', '10000', '55', '1', '1', '264979', '0');
INSERT INTO `gametx36_auto` VALUES ('275', '0', '0', '0', '10000', '55', '1', '1', '264991', '0');
INSERT INTO `gametx36_auto` VALUES ('276', '0', '0', '0', '10000', '55', '1', '1', '265053', '0');
INSERT INTO `gametx36_auto` VALUES ('277', '0', '0', '0', '10000', '55', '1', '1', '265055', '0');
INSERT INTO `gametx36_auto` VALUES ('278', '0', '0', '0', '10000', '55', '1', '1', '265070', '0');
INSERT INTO `gametx36_auto` VALUES ('279', '0', '0', '0', '10000', '55', '1', '1', '265105', '0');
INSERT INTO `gametx36_auto` VALUES ('280', '0', '0', '0', '10000', '55', '1', '1', '265110', '0');
INSERT INTO `gametx36_auto` VALUES ('281', '0', '0', '0', '10000', '55', '1', '1', '265141', '0');
INSERT INTO `gametx36_auto` VALUES ('282', '0', '0', '0', '10000', '55', '1', '1', '265148', '0');
INSERT INTO `gametx36_auto` VALUES ('283', '0', '0', '0', '10000', '55', '1', '1', '265295', '0');
INSERT INTO `gametx36_auto` VALUES ('284', '0', '0', '0', '10000', '55', '1', '1', '265299', '0');
INSERT INTO `gametx36_auto` VALUES ('285', '0', '0', '0', '10000', '55', '1', '1', '265396', '0');
INSERT INTO `gametx36_auto` VALUES ('287', '0', '0', '0', '10000', '70', '1', '1', '265403', '0');
INSERT INTO `gametx36_auto` VALUES ('288', '0', '0', '0', '10000', '70', '1', '1', '265405', '0');
INSERT INTO `gametx36_auto` VALUES ('289', '0', '0', '0', '10000', '70', '1', '1', '265424', '0');
INSERT INTO `gametx36_auto` VALUES ('290', '0', '0', '0', '10000', '70', '1', '1', '265469', '0');
INSERT INTO `gametx36_auto` VALUES ('291', '0', '0', '0', '10000', '70', '1', '1', '265550', '0');
INSERT INTO `gametx36_auto` VALUES ('292', '0', '0', '0', '10000', '70', '1', '1', '265585', '0');
INSERT INTO `gametx36_auto` VALUES ('293', '0', '0', '0', '10000', '70', '1', '1', '265604', '0');
INSERT INTO `gametx36_auto` VALUES ('294', '0', '0', '0', '10000', '70', '1', '1', '265613', '0');
INSERT INTO `gametx36_auto` VALUES ('295', '0', '0', '0', '10000', '70', '1', '1', '265634', '0');
INSERT INTO `gametx36_auto` VALUES ('296', '0', '0', '0', '10000', '70', '1', '1', '265665', '0');
INSERT INTO `gametx36_auto` VALUES ('297', '0', '0', '0', '10000', '70', '1', '1', '265694', '0');
INSERT INTO `gametx36_auto` VALUES ('298', '0', '0', '0', '10000', '70', '1', '1', '265730', '0');
INSERT INTO `gametx36_auto` VALUES ('299', '0', '0', '0', '10000', '70', '1', '1', '265733', '0');
INSERT INTO `gametx36_auto` VALUES ('300', '0', '0', '0', '10000', '70', '1', '1', '265736', '0');
INSERT INTO `gametx36_auto` VALUES ('301', '0', '0', '0', '10000', '70', '1', '1', '265763', '0');
INSERT INTO `gametx36_auto` VALUES ('302', '0', '0', '0', '10000', '70', '1', '1', '265773', '0');
INSERT INTO `gametx36_auto` VALUES ('303', '0', '0', '0', '10000', '70', '1', '1', '265777', '0');
INSERT INTO `gametx36_auto` VALUES ('304', '0', '0', '0', '10000', '70', '1', '1', '265782', '0');
INSERT INTO `gametx36_auto` VALUES ('305', '0', '0', '0', '10000', '70', '1', '1', '265789', '0');
INSERT INTO `gametx36_auto` VALUES ('306', '0', '0', '0', '10000', '70', '1', '1', '265799', '0');

