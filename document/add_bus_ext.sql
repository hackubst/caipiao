-- 13410101012
-- e10adc3949ba59abbe56e057f20f883e

/* 平台配置表增加 代理业绩分成配置*/
insert into sys_config(fldIdx,fldName,fldValue,fldVar,fldType,fldCaptioni)
values(7,'代理业绩分成','9.99,5,0.7|0.5|0.3','agent_extr_radio',0,'分成按千分之计算');


/* 增加代理级别与上级用户ID */
alter table agent add column score bigint null default 0 after state;
alter table agent add column pid bigint null default 0 after score;
alter table agent add column `level` int null default 1 after pid;


/* 增加代理业绩统计标识 */
alter table user_score_changelog add column state bigint null default 0;


/* 更新代理用户添加存储过程，增加代理级别与上级用户ID */
DROP PROCEDURE IF EXISTS `web_agent_add`;
CREATE DEFINER = `root`@`localhost` PROCEDURE `web_agent_add`(
	p_UserPID		bigint,
	p_UserID		bigint,
	p_AgentName		VARCHAR(256) CHARACTER SET gbk,
	p_dbMoney		bigint,
	p_bcRate		float(10,2),
	p_rcRate		FLOAT(10,2),
	p_rcpfRate		FLOAT(10,2),
	p_CanRecCard	int,
	p_IsRecommend	INT,
	p_State			INT)
    SQL SECURITY INVOKER
BEGIN
	
	DECLARE v_level INT DEFAULT 0;
	DECLARE v_err INT DEFAULT 0; 
	DECLARE v_result INT DEFAULT 0; 
	declare v_temp	int;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET v_err=1;
	
	LABEL_EXIT:BEGIN
		if EXISTS(select 1 from agent where uid = p_UserID) then
			set v_result = 1; 
			leave LABEL_EXIT;
		end if;
		
		if not EXISTS(select 1 from users where id = p_UserID) then
			SET v_result = 2; 
			LEAVE LABEL_EXIT;
		end if;
		
		if not EXISTS(select 1 from agent where uid = p_UserPID) then
			SET v_result = 3; 
			LEAVE LABEL_EXIT;
		end if;
				
		select `level`+1 from agent where uid=p_UserPID into v_level;
		
		CALL KickUserAutoPress(p_UserID);
		
		insert into agent(pid,uid,agent_name,buycard_rate,reccard_rate,reccard_profit_rate,distribute_money,can_reccard,is_recommend,`state`,add_time,`level`)
			values(p_UserPID,p_UserID,p_AgentName,p_bcRate,p_rcRate,p_rcpfRate,p_dbMoney,p_CanRecCard,p_IsRecommend,p_State,now(),v_level);
		
		update users set isagent = 1 where id = p_UserID;
		
	END LABEL_EXIT;
	
	IF(v_err=1) THEN
		SET v_result = 99;
	END IF;
	
	SELECT v_result AS result;
		
END;

/* 代理业绩记录表 */
/*Table structure for table `agent_score_log` */
CREATE TABLE `agent_score_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `agentid` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '业绩类型(0自玩业绩，1一级代理业绩，2二级代理业绩，3三级代理业绩)',

  `ext_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '业绩/千分',
  
  `thedate` datetime NOT NULL DEFAULT 'NOW()' COMMENT '日期',

  PRIMARY KEY (`id`),
  KEY `agentid` (`agentid`) USING BTREE,
  KEY `thedate` (`thedate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理业绩记录表';
/*Data for the table `agent_score_log` */

/* 代理业绩日统计表 */
/*Table structure for table `agent_score_static` */
CREATE TABLE `agent_score_static` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `agentid` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `level` int(11) NOT NULL DEFAULT '0' COMMENT '代理层级',
  `agentpid` int(11) NOT NULL DEFAULT '0' COMMENT '上级代理ID',

  `win_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '赢分/千分',
  `don_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '输分/千分',
	
  `sys_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '系统分/千分',
  `tme_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '自玩分/千分',
  `one_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '1级分/千分',
  `two_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '2级分/千分',
  `thr_points` bigint(20) NOT NULL DEFAULT '0' COMMENT '3级分/千分',
  
  `thedate` datetime NOT NULL COMMENT '日期',

  PRIMARY KEY (`id`),
  KEY `agentid` (`agentid`) USING BTREE,
  KEY `thedate` (`thedate`) USING BTREE,
  KEY `agentpid` (`agentpid`) USING BTREE,
  KEY `level` (`level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理业绩日统计表';
/*Data for the table `agent_score_static` */

