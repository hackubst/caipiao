/*
Navicat MySQL Data Transfer

Source Server         : 47.75.222.46(hk_test)
Source Server Version : 50642
Source Host           : 47.75.222.46:3306
Source Database       : kdy28

Target Server Type    : MYSQL
Target Server Version : 50642
File Encoding         : 65001

Date: 2019-03-06 23:09:29
*/

SET FOREIGN_KEY_CHECKS=0;

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
