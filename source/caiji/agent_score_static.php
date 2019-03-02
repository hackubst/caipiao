<?php

set_time_limit(0);
date_default_timezone_set('Asia/Shanghai');
error_reporting(E_ALL ^ E_NOTICE);
include_once(dirname( __FILE__ ) ."/Mysql.class.php");

$db = new db();

$win_radio = 9.9; // 输赢比例
$sys_radio = 5;   // 系统分成 百分之
$tme_radio = 0.5; // 自玩业绩 百分之
$one_radio = 0.7; // 一级分成 百分之
$two_radio = 0.5; // 二级分成 百分之
$thr_radio = 0.3; // 三级分成 百分之

$set_sql = "SELECT fldValue FROM sys_config WHERE fldVar='agent_extr_radio'";
$setres = $db->getOne($set_sql);

if ($setres != "") {    
    $radio01 = explode(",", $setres);
    $win_radio = floatval($radio01[0]);
    $sys_radio = floatval($radio01[1]);

    $radio02 = explode("|", $radio01[2]);
    $tme_radio = floatval($radio02[0]);
    $one_radio = floatval($radio02[1]);
    $two_radio = floatval($radio02[2]);
    $thr_radio = floatval($radio02[3]);    
}

$dat_sql = "SELECT DATE_SUB(NOW(),INTERVAL 1 DAY)";
$data_time = $db->getOne($dat_sql);

$score_sql = 
    "SELECT b.uid, b.pid, b.`level`, 
        SUM(CASE WHEN c.change_points>0 THEN 0 ELSE a.change_points END) AS DON_POINTS, 
        SUM(CASE WHEN c.change_points>0 THEN a.change_points ELSE 0 END) AS WIN_POINTS,
        SUM(c.change_points) AS WIN_SCORE
    FROM user_score_changelog a 
    LEFT JOIN users u ON (a.uid=u.id)
    LEFT JOIN agent b ON (b.uid=u.tjid)
    LEFT JOIN user_score_changelog c ON (a.gameno=c.gameno AND c.remark='开奖后')
    WHERE (a.remark LIKE '手动投注后%' OR a.remark LIKE '自动投注后%') 
        AND DATE_FORMAT(a.thetime,'%Y-%m-%d')=DATE_FORMAT({$data_time},'%Y-%m-%d')
        AND b.uid IS NOT NULL AND b.uid>0
    GROUP BY b.uid, b.pid, b.`level`;";
$logres = $db->getAll($score_sql);

foreach($logres as $item){

    $uid = $item['uid'];
    $pid = $item['pid'];
    $level = $item['level'];
    $win_scores = intval($item['WIN_SCORE']);
    $win_points = intval($item['WIN_POINTS']);
    $don_points = intval($item['DON_POINTS']);
    
    //系统分成
    $sys_points = (($win_points*9.99)-$win_points)*($sys_radio/100);
    //业绩分成计算基数
    $ext_points = $don_points+((($win_points*9.99)-$win_points)*((100-$sys_radio)/100));
        
    $tme_points = intval($ext_points*($tme_radio/100)); //代理自玩业绩
    $one_points = intval($ext_points*($one_radio/100)); //一级代理分成业绩    
    $tow_points = intval($ext_points*($two_radio/100)); //二级代理分成业绩    
    $thr_points = intval($ext_points*($thr_radio/100)); //三级代理分成业绩
    
    // 第一步记录业绩分成结果
    $into_sql = "INSERT INTO agent_score_static(agentid,`level`,agentpid,win_points,don_points,sys_points,tme_points,one_points,two_points,thr_points,thedate,creates_time)
     VALUES({$uid},{$level},{$pid},{$win_points},{$don_points},{$sys_points},{$tme_points},{$one_points},{$tow_points},{$thr_points},{$data_time},NOW());";
    $into_ret = $db->execute($into_sql);

    $db = new db();
    if($into_ret===FALSE) {
        $db->execute("rollback");
        continue;
    }

    // 第二步更新代理业绩余额，并记录代理业绩明细记录
    $scores = array($tme_points, $one_points, $tow_points, $thr_points);
    up_agent_score($uid, $scores);
}

/**
 * 更新代理业绩余额，并记录代理业绩明细记录 (支持递归更新数据，每个基本最高递归三次)
 * @param int $uid 代理用户ID
 * @param array $scores 代理业绩集合
 * @param int $level 代理级别 (默认为0，自玩业绩)
 */
function up_agent_score($uid, $scores, $level = 0, $cid = 0)
{
    if ($level<=3) 
    {
        try {
            $updb = new db();

            //更新业绩余额
            $upd_sql = "UPDATE agent SET score=score+".$scores[$level]." WHERE uid={$uid};";
            $upd_ret = $updb->execute($upd_sql);

            if($upd_ret===FALSE) {
                $updb->execute("rollback");
                return;
            } else {
                // 记录业绩记录
                $indb = new db();
                $into_sql = "INSERT INTO agent_score_log(agentid,`level`,ext_points,extendid,thedate,creates_time)
                 VALUES({$uid},{$level},{$scores[$level]},{$cid},{$data_time},NOW());";
                $into_ret = $indb->execute($into_sql);
                if($into_ret===FALSE) {
                    $indb->execute("rollback");
                    return;
                }
            }
        } catch(Exception $e) {
            echo (" {error_msg:".$e->getMessage()."} \r\n");
        }

        //获取是否有上级代理
        $sel_sql = "SELECT pid FROM agent WHERE uid=".$uid;
        $sel_pid = (new db())->getOne($sel_sql);
        
        if (!empty($sel_pid) && intval($sel_pid)>0) {
            //递归 更新上级代理业绩
            up_agent_score($sel_pid, $scores, ($level+1), $uid);
        }
    }
}

?>