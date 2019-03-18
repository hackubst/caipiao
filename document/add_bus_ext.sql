
use `kdy28`

/* 增加代理业绩统计标识 */
alter table user_score_changelog add column status bigint null default 0;

/* 代理业绩记录表 */
/*Table structure for table `agent_score_log` */
CREATE TABLE `agent_score_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `agentid` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '业绩类型(0自玩业绩，1一级代理业绩，2二级代理业绩，3三级代理业绩)',

  `ext_points` decimal(20,4) NOT NULL DEFAULT '0' COMMENT '业绩/千分',
  
  `extendid` int(11) NOT NULL DEFAULT '0' COMMENT '扩展提供业绩的下级代理ID',
  `thedate` datetime NOT NULL DEFAULT '0000-00-00' COMMENT '日期',
  `creates_time` datetime NOT NULL DEFAULT '0000-00-00' COMMENT '创建日期',

  PRIMARY KEY (`id`),
  KEY `agentid` (`agentid`) USING BTREE,
  KEY `thedate` (`thedate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理业绩记录表';
/*Data for the table `agent_score_log` */

/* 更新用户注册存储过程，去掉昵称重复验证 */
DROP PROCEDURE IF EXISTS `web_user_mobile_reg`;

/* Procedure structure for procedure `web_user_mobile_reg` */

DELIMITER $$
/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `web_user_mobile_reg`(
		p_RegType	INT, 							
		p_UserID	BIGINT, 						
		p_UserName	VARCHAR(50) CHARACTER SET gbk,	
		p_NickName	VARCHAR(50) CHARACTER SET gbk,	
		p_Password	VARCHAR(50) CHARACTER SET gbk,	
		p_RegIP		VARCHAR(15) CHARACTER SET gbk,	
		p_TJID		BIGINT,
		p_source	VARCHAR(250) CHARACTER SET gbk
    )
    SQL SECURITY INVOKER
BEGIN
	
	DECLARE v_RegPoint INT;
	DECLARE v_loginExp INT;
	DECLARE v_result INT DEFAULT 0;
	DECLARE v_UserID BIGINT;
	DECLARE v_UserName VARCHAR(50) CHARACTER SET gbk;
	DECLARE v_NickName VARCHAR(50) CHARACTER SET gbk;
	DECLARE err INT DEFAULT 0;
	DECLARE	v_forumnum INT;
	DECLARE	v_onlinenum INT;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET err=1;
	START TRANSACTION;
	LABEL_EXIT:BEGIN
		
		IF p_RegType = 0 THEN 
			IF EXISTS(SELECT 1 FROM users WHERE username = p_UserName) THEN
				SELECT 1 INTO v_result; 
				LEAVE LABEL_EXIT;
			END IF;
			
			IF(EXISTS(SELECT 1 FROM deny_words WHERE deny_type = 'f' AND p_NickName LIKE CONCAT_WS('','%',keyword,'%'))
				OR EXISTS(SELECT 1 FROM deny_words WHERE deny_type = 'b' AND p_NickName LIKE CONCAT_WS('',keyword,'%'))
			) THEN
				SELECT 2 INTO v_result; 
				LEAVE LABEL_EXIT;
			END IF;
		END IF;
		
		IF p_UserID <> 0 THEN
			SET v_UserID = p_UserID;
			IF EXISTS(SELECT 1 FROM users WHERE id = p_UserID) THEN
				SELECT 3 INTO v_result; 
				LEAVE LABEL_EXIT;
			END IF;
		ELSE 
			SET v_UserID = 0;
			WHILE (v_UserID = 0) DO 
				SELECT FLOOR(100000 + RAND()*900000)
					INTO v_UserID;
				
				IF EXISTS(SELECT 1 FROM users WHERE id = v_UserID) THEN 
					SET v_UserID = 0;
				END IF;
			END WHILE;
		END IF;
		
		IF p_RegType = 0 THEN 
			SET v_UserName = p_UserName;
			SET v_NickName = P_NickName;
		ELSE
			SET v_UserName = CONCAT_WS('',"ru__",v_UserID);
				
			SELECT nickname FROM robot_nickname 
			WHERE isused = 0 AND nickname NOT IN(SELECT nickname FROM users)
			ORDER BY RAND() LIMIT 1
				INTO v_NickName;
				
			IF v_NickName IS NULL THEN
				SET v_NickName = v_UserID;
			ELSE
				UPDATE robot_nickname SET isused = 1 WHERE nickname = v_NickName;
			END IF;
		END IF;
		
		SELECT reg_points,web_loginperience FROM web_config WHERE id = 1
			INTO v_RegPoint,v_loginExp;
		IF v_RegPoint IS NULL THEN
			SET v_RegPoint = 0;
			SET v_loginExp = 0;
		END IF;
		
		INSERT INTO users(`id`,`username`,`nickname`,`password`,`is_check_mobile`,`mobile`,`bankpwd`,`points`,experience,maxexperience,`time`,`regip`,`tjid`,`usertype`,`loginip`,logintime,`source`)
			VALUES(v_UserID,v_UserName,v_NickName,p_Password,1,v_UserName,p_Password,v_RegPoint,v_loginExp,v_loginExp,NOW(),p_RegIP,p_TJID,p_RegType,p_RegIP,NOW(),p_source);		
		
		INSERT INTO game_static(uid,typeid,points) 
			VALUES(v_UserID,120,v_RegPoint);
			
		
		IF v_RegPoint > 0 THEN
			UPDATE centerbank SET score = score - v_RegPoint WHERE bankIdx = 6;
		END IF;
		
		
		IF p_TJID=908639 THEN
		  SET v_forumnum = 1;
		 ELSE 
		  SET v_forumnum = 0;
		 END IF;
		 IF p_TJID=826423 THEN
		  SET v_onlinenum = 1;
		 ELSE 
		  SET v_onlinenum = 0;
		 END IF;
		IF EXISTS(SELECT 1 FROM webtj WHERE `time` = CURDATE()) THEN
			UPDATE webtj SET regnum = regnum + 1,regpoints = regpoints + v_RegPoint 
				WHERE `time` = CURDATE();
			IF p_TJID=908639 THEN
			UPDATE webtj SET forumnum = forumnum + 1
				WHERE `time` = CURDATE();
			END IF;
			IF p_TJID=826423 THEN
			UPDATE webtj SET onlinenum = onlinenum + 1
				WHERE `time` = CURDATE();
			END IF;
		ELSE
			INSERT INTO webtj(`time`,regnum,forumnum,onlinenum,regpoints) VALUES(CURDATE(),1,v_forumnum,v_onlinenum,v_RegPoint);
		END IF;
		
		
		IF v_loginExp > 0 THEN
			INSERT INTO userslog(usersid,`time`,experience,logtype,`log`)
				VALUES(v_UserID,NOW(),v_loginExp,4,CONCAT('登录奖励',v_loginExp,'经验值'));
		END IF;
		
		IF p_RegType = 0 THEN
			INSERT INTO login_success(uid,username,nickname,`point`,bankpoint,`exp`,loginip,login_time)
				VALUES(v_UserID,v_UserName,v_NickName,v_RegPoint,0,v_loginExp,p_RegIP,NOW());
		END IF;
		
		
		IF(p_TJID>0 ) THEN 
		
			UPDATE users SET tj_level1_count=tj_level1_count+1 WHERE id=p_TJID;
			
			UPDATE users SET tj_level2_count=tj_level2_count+1 
			WHERE id IN(
				SELECT * FROM (
					SELECT tjid FROM users WHERE id=p_TJID
				) t
			);
			
			UPDATE users SET tj_level3_count=tj_level3_count+1 
			WHERE id IN(
				SELECT * FROM (
					SELECT tjid FROM users WHERE id IN(
						SELECT tjid FROM users WHERE id=p_TJID
					)
				) t
			);
			
		END IF;
		
	END LABEL_EXIT;
	
	IF(err=1) THEN
		ROLLBACK;
		SELECT 99 INTO v_result;
	ELSE
		COMMIT;
	END IF;
	
	IF p_RegType = 0 THEN
		IF v_result = 0 THEN
			SELECT v_result AS result,v_UserID AS userid,v_UserName AS username,v_NickName AS nickname,v_RegPoint AS points,v_loginExp AS experience;
		ELSE
			SELECT v_result AS result;
		END IF;
	END IF;
END  */$$
DELIMITER ;
