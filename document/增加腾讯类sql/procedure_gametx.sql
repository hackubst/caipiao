/*
Navicat MySQL Data Transfer

Source Server         : 47.75.222.46(hk_test)
Source Server Version : 50642
Source Host           : 47.75.222.46:3306
Source Database       : kdy28

Target Server Type    : MYSQL
Target Server Version : 50642
File Encoding         : 65001

Date: 2019-02-09 21:43:15
*/


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









    declare v_GameType int default 20;
    declare v_Points bigint;
    declare v_tz_num int default 0;
    declare v_i int;
    declare v_str_num_arr varchar(100) CHARACTER SET gbk;
    declare v_single_num varchar(50) CHARACTER SET gbk;
    declare v_single_point varchar(50) CHARACTER SET gbk;
    declare v_Check_sumPoint bigint default 0;
    declare v_curOdds varchar(1000) CHARACTER SET gbk;
    declare v_isKJ int;
    declare v_curTotalPressPoints bigint;
    declare v_HadPressPoint bigint;
    declare v_tzrNum int default 1;

    declare v_Press_min int;
    declare v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    declare v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
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









    declare v_GameType int default 19;
    declare v_Points bigint;
    declare v_tz_num int default 0;
    declare v_i int;
    declare v_str_num_arr varchar(100) CHARACTER SET gbk;
    declare v_single_num varchar(50) CHARACTER SET gbk;
    declare v_single_point varchar(50) CHARACTER SET gbk;
    declare v_Check_sumPoint bigint default 0;
    declare v_curOdds varchar(1000) CHARACTER SET gbk;
    declare v_isKJ int;
    declare v_curTotalPressPoints bigint;
    declare v_HadPressPoint bigint;
    declare v_tzrNum int default 1;

    declare v_Press_min int;
    declare v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    declare v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
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









    declare v_GameType int default 18;
    declare v_Points bigint;
    declare v_tz_num int default 0;
    declare v_i int;
    declare v_str_num_arr varchar(100) CHARACTER SET gbk;
    declare v_single_num varchar(50) CHARACTER SET gbk;
    declare v_single_point varchar(50) CHARACTER SET gbk;
    declare v_Check_sumPoint bigint default 0;
    declare v_curOdds varchar(1000) CHARACTER SET gbk;
    declare v_isKJ int;
    declare v_curTotalPressPoints bigint;
    declare v_HadPressPoint bigint;
    declare v_tzrNum int default 1;

    declare v_Press_min int;
    declare v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    declare v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
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









    declare v_GameType int default 21;
    declare v_Points bigint;
    declare v_tz_num int default 0;
    declare v_i int;
    declare v_str_num_arr varchar(100) CHARACTER SET gbk;
    declare v_single_num varchar(50) CHARACTER SET gbk;
    declare v_single_point varchar(50) CHARACTER SET gbk;
    declare v_Check_sumPoint bigint default 0;
    declare v_curOdds varchar(1000) CHARACTER SET gbk;
    declare v_isKJ int;
    declare v_curTotalPressPoints bigint;
    declare v_HadPressPoint bigint;
    declare v_tzrNum int default 1;

    declare v_Press_min int;
    declare v_Press_max int;

    DECLARE v_result INT DEFAULT 0;
    declare v_retmsg varchar(200) CHARACTER SET gbk default 'ok';
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