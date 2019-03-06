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