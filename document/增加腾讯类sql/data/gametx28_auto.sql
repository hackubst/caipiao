/*
Navicat MySQL Data Transfer

Source Server         : 47.75.222.46(hk_test)
Source Server Version : 50642
Source Host           : 47.75.222.46:3306
Source Database       : kdy28

Target Server Type    : MYSQL
Target Server Version : 50642
File Encoding         : 65001

Date: 2019-03-06 23:10:21
*/

SET FOREIGN_KEY_CHECKS=0;

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
