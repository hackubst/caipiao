/*
Navicat MySQL Data Transfer

Source Server         : 47.75.222.46(hk_test)
Source Server Version : 50642
Source Host           : 47.75.222.46:3306
Source Database       : kdy28

Target Server Type    : MYSQL
Target Server Version : 50642
File Encoding         : 65001

Date: 2019-03-06 23:06:49
*/

SET FOREIGN_KEY_CHECKS=0;

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
INSERT INTO `game_catch_config` VALUES ('gamecqssc', '0', '00:00:00', '00:00:00', '重庆时时彩', '', '/alidata/server/php/bin/php crawler.php source=CQSSC');
INSERT INTO `game_catch_config` VALUES ('gamefast', '60', '00:00:00', '00:00:00', '急速类', '', '');
INSERT INTO `game_catch_config` VALUES ('gamehg', '90', '07:00:00', '04:58:30', '韩国快乐8', 'http://localhost:9921/crawler.php?source=Korea', '/alidata/server/php/bin/php crawler.php source=Korea');
INSERT INTO `game_catch_config` VALUES ('gamepk', '300', '09:07:00', '23:57:00', '北京pk拾', 'http://localhost:9921/crawler.php?source=Pk', '/alidata/server/php/bin/php crawler.php source=Pk');
INSERT INTO `game_catch_config` VALUES ('gametx', '60', '00:00:00', '00:00:00', '腾讯分分彩', '', '/alidata/server/php/bin/php crawler.php source=Tenxun');
INSERT INTO `game_catch_config` VALUES ('gamexync', '0', '00:00:00', '00:00:00', '幸运农场', '', '/alidata/server/php/bin/php crawler.php source=LuckFarm');
