<?php
set_time_limit(0);
date_default_timezone_set('Asia/Shanghai');
error_reporting(E_ALL ^ E_NOTICE);

include_once(dirname( __FILE__ ) ."/Mysql.class.php");

$file = dirname( __FILE__ ) ."/".date("Ymd")."_userscorechangelog_.log";


$db = new db();

$sql = "select id,uid,change_points,thetime,remark from user_score_changelog where status=0 and remark in ('手动投注后','自动投注后','开奖后')";
$logres = $db->getAll($sql);
foreach($logres as $log){

    $sql = "select username from users where id={$log['uid']}";
    $username = $db->getOne($sql);
    $ip = '';
    $key = '';
    $money = $log['change_points']/10;
    if (in_array($log['remark'],['手动投注后','自动投注后'])) {
        $money *= -1;
    }
    $sign = strtoupper(md5($username . $money . $ip . $key));
    $data = ['account'=>$username,'money'=>$money,'ip'=>$ip,'sign'=>$sign];
    $url = 'http://192.168.0.120:13201/lottery/fundflow';
    $result = curl_post($url,$data);
    $datas = json_decode($result);
    if (0==$datas->errcode) {

        $sql = "update user_score_changelog set status=1 where id={$log['id']}";
        $ret = $db->execute($sql);
        if($ret===FALSE){
            $db->execute("rollback");
            continue;
        }
        $content = date("Y-m-d H:i:s") . ":" . $sql . "\n";
        @file_put_contents($file, $content,FILE_APPEND);
    }
	
}


/**
 * curl请求
 * @param $url
 * @param array $data
 * @return mixed
 */
function curl_post($url, $data = [])
{
    //初始化
    $curl = curl_init();
    //设置抓取的url
    curl_setopt($curl, CURLOPT_URL, $url);
    //设置头文件的信息作为数据流输出
    curl_setopt($curl, CURLOPT_HEADER, 0);
    //设置获取的信息以文件流的形式返回，而不是直接输出
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    //设置post方式提交
    curl_setopt($curl, CURLOPT_POST, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
    //执行命令
    $result = curl_exec($curl);
    //关闭url请求
    curl_close($curl);
    return $result;
}
