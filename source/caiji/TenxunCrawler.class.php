<?php
include_once(dirname( __FILE__ ) ."/BaseCrawler.class.php");

class TenxunCrawler extends BaseCrawler
{
	
	public function __construct(){
		parent::__construct();
		$this->sleepSec = 2;
		$this->stopBegin = "00:00:00";
		$this->stopEnd = "00:00:00";
		$this->gameType = "gametx";
		$this->gameTypes = [18,19,20,21,30,31,34,49];
		$this->crawlerUrls = array(
			0=>array('url'=>'https://mma.qq.com/cgi-bin/im/online','method'=>'_api','useproxy'=>0,'referurl'=>''),
		);
	}

    private function _api($contents){
        $opentime = mktime(date("H"),date("i"),0);
        $n = ($opentime - mktime(0,0,0))/60;
        $no = date("ymd").str_pad($n+1,4,'0',STR_PAD_LEFT);
        $item = json_decode(substr($contents,strpos($contents,'(')+1,-1));
        $result = array();
        $result[$no]['no'] = $no;
        $result[$no]['time'] = date('Y-m-d H:i:s',$opentime);
        $result[$no]['data'] = implode("|",str_split($item->c));

        if(empty($result)) $this->Logger("Parse Error.");

        return $result;
    }
	
	protected function getUnOpenGameNos(){
		$ret = array();
		$sql = "SELECT id FROM gametx28 
					WHERE kj = 0 AND kgtime < NOW()
					AND kgtime > DATE_ADD(NOW(),INTERVAL -60 MINUTE)
					AND id NOT IN(select gameno FROM game_result WHERE gametype = '{$this->gameType}') 
					ORDER BY id DESC";
		$result = $this->db->getAll($sql);
		if(!empty($result)){
			foreach($result as $res){
				$ret[$res['id']] = $res['id'];
			}
		}
		
		
		if(count($result) >= 4){
			$this->switchGame(1);
		}else{
			;//$this->switchGame(0);
		}
		
		
		return $ret;
	}
	
	public function crawler(){
		$count = 0;
		$result = array();
		$rets = $this->getUnOpenGameNos();
		if(count($rets) > 0){
			foreach($this->crawlerUrls as $idx=>$source){
                sleep(1);
				$contents = $this->httpGet($source['url'] , $source['useproxy'] , $source['referurl']);
				$result = $this->$source['method']($contents);
				if(count($result) > 0){
					$hasnewdata = 0;
					foreach($rets as $k=>$v){
						if(!empty($result[$k])){
							$hasnewdata = 1;
						}
						break;
					}
					
					if($hasnewdata)
					break;
				}
			}
			
			//print_r($result);exit;
			
			foreach($rets as $k=>$v){
				if(!empty($result[$k])){
					$this->saveCrawlerData($k , $result[$k]['data']);
					$count++;
				}
			}
		}
		
		if(empty($count)){
			sleep($this->sleepSec);
		}
		
		return $count;
	}
	
	public function open($No=0){
		$isToAuto = true;
		
		if($No == 0){
			$sql = "select gameno from game_result where gametype = '{$this->gameType}' and isopen = 0 order by gameno desc limit 1";//AND ADDTIME>DATE_SUB(NOW(),INTERVAL 10 MINUTE) 
			$result = $this->db->getRow($sql);
			if(!empty($result)){
				$No = $result["gameno"];
			}else{
				//保证采集不到但下盘时间快到时自动下注
				$sql = "SELECT id,kgtime,now() as nowtime FROM gametx28 WHERE kj = 0 AND zdtz_r = 0 AND kgtime > NOW() ORDER BY kgtime LIMIT 1";
				$result = $this->db->getRow($sql);
				if(!empty($result)){
					$NextNo = $result['id'];
					if(strtotime($result['kgtime']) - strtotime($result['nowtime']) < 30){
						//自动投注
						$this->autoPress($NextNo-1,$NextNo);
					}
				}
				return;
			}
		}else{
			$isToAuto = false;
				
			$sql = "SELECT id,kgtime,now() as nowtime FROM gametx28 WHERE id = '{$No}' ";
			$result = $this->db->getRow($sql);
			if(empty($result)){
				return;
			}
			
			if(strtotime($result['kgtime']) >= strtotime($result['nowtime'])){
				return;
			}
		}
		
		$strkjNum = $this->getGameResult($No);//取开奖号码串
		$kjnum_array = explode( "|", $strkjNum );
		
		if(count($kjnum_array) == 9){ //取到了
            //反转 从右到左排序
            $kjnum_array = array_reverse($kjnum_array);

			//更新开奖状态
			$sql = "update game_result set isopen = 1,opentime = now() where gametype = '{$this->gameType}' and gameno = '{$No}'";
			$result = $this->db->execute($sql);
			if($result === FALSE){
				$this->Logger("DB Error! : {$sql} {$this->db->error}");
			}
				
			$this->Logger("{$No} result string:" . $strkjNum);
				
			//开奖腾讯16
			$zjh_a = $kjnum_array[0] + $kjnum_array[3] + $kjnum_array[6];
			$zj_a = ($zjh_a % 6) + 1;
			$zjh_b = $kjnum_array[2] + $kjnum_array[5] + $kjnum_array[8];
			$zj_b = ($zjh_b % 6) + 1;
			$zjh_c = $kjnum_array[1] + $kjnum_array[4] + $kjnum_array[7];
			$zj_c = ($zjh_c % 6) + 1;
			$zj_result = $zj_a + $zj_b + $zj_c;
			$sql = "call web_kj_gametx16({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}')";
			$result = $this->db->MultiQuery($sql);
			$this->Logger("tenxun16 {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
				
			//开奖腾讯11
			$zjh_a = $kjnum_array[0] + $kjnum_array[3] + $kjnum_array[6];
			$zjh_b = $kjnum_array[1] + $kjnum_array[4] + $kjnum_array[7];
			$zj_a = ($zjh_a % 6) + 1;
			$zj_b = ($zjh_b % 6) + 1;
			$zj_c = -1;
			$zj_result = $zj_a + $zj_b;
			$sql = "call web_kj_gametx11({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}')";
			$result = $this->db->MultiQuery($sql);
			$this->Logger("tenxun11 {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
				
			//开奖腾讯36
			$zj_a = $kjnum_array[2];
			$zj_b = $kjnum_array[1];
			$zj_c = $kjnum_array[0];
			$zj_result = $this->getGame36Result($zj_a,$zj_b,$zj_c);
			$sql = "call web_kj_gametx36({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}')";
			$result = $this->db->MultiQuery($sql);
			$this->Logger("tenxun36 {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
			
			//开奖腾讯28
			$zjh_a = $kjnum_array[0] + $kjnum_array[3] + $kjnum_array[6];
			$zjh_b = $kjnum_array[1] + $kjnum_array[4] + $kjnum_array[7];
			$zjh_c = $kjnum_array[0] + $kjnum_array[1] + $kjnum_array[2] + $kjnum_array[3] + $kjnum_array[4] + $kjnum_array[5] + $kjnum_array[6] + $kjnum_array[7];
			$zj_a = substr( $zjh_a, -1 );
			$zj_b = substr( $zjh_b, -1 );
			$zj_c = substr( $zjh_c, -1 );
			$zj_result = $zj_a + $zj_b + $zj_c;
			$sql = "call web_kj_gametx28({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}')";
			$result = $this->db->MultiQuery($sql);
			$this->Logger("tenxun28 {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");

            //开奖腾讯28固定
			$sql = "call web_kj_gametx28gd({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}')";
			//$this->Logger("web_kj_gametx28gd : " . $sql);
			$result = $this->db->MultiQuery($sql);
			$this->Logger("tenxun28gd {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
			
			$sql = "SET GLOBAL group_concat_max_len = 4096";
			$this->db->execute($sql);
			$sql = "SET SESSION group_concat_max_len = 4096";
			$this->db->execute($sql);

            //开奖腾讯外围
            $resultIds = $this->getGameWWResult($kjnum_array);
			$resultIdsCnt = count($resultIds);
			$odds = $this->GetOddByResult(30 , $resultIds);
			$oddsCnt = count($odds);
			if($resultIdsCnt == $oddsCnt && $resultIdsCnt > 0){
				$resultIdStr = implode(",", $resultIds);
				//$this->Logger("resultIds : " . $resultIdStr);
				$oddStr = implode(",", $odds);
				//$this->Logger("odds : " . $oddStr);
				$sql = "call web_kj_gametxww({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}',{$oddsCnt},'{$resultIdStr}','{$oddStr}')";
				//$this->Logger($sql);
				$result = $this->db->MultiQuery($sql);
				$this->Logger("tenxunww {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
			}
			
            //开奖腾讯定位
            $resultIds = $this->getGameDWResult($kjnum_array);
			$resultIdsCnt = count($resultIds);
			$odds = $this->GetOddByResult(31 , $resultIds);
			$oddsCnt = count($odds);
			if($resultIdsCnt == $oddsCnt && $resultIdsCnt > 0){
				$resultIdStr = implode(",", $resultIds);
				$oddStr = implode(",", $odds);
				$sql = "call web_kj_gametxdw({$No},{$zj_a},{$zj_b},{$zj_c},{$zj_result},'{$strkjNum}',{$oddsCnt},'{$resultIdStr}','{$oddStr}')";
				//$this->Logger($sql);
				$result = $this->db->MultiQuery($sql);
				$this->Logger("tenxundw {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
			}

            //开奖腾讯分分彩
            $zjh_a = $kjnum_array[0] + $kjnum_array[3] + $kjnum_array[6];
            $zjh_b = $kjnum_array[1] + $kjnum_array[4] + $kjnum_array[7];
            $zjh_c = $kjnum_array[0] + $kjnum_array[1] + $kjnum_array[2] + $kjnum_array[3] + $kjnum_array[4] + $kjnum_array[5] + $kjnum_array[6] + $kjnum_array[7];
            $zjh_d = $kjnum_array[0] + $kjnum_array[2] + $kjnum_array[7];
            $zjh_e = $kjnum_array[1] + $kjnum_array[3] + $kjnum_array[5];
            $zj_a = substr( $zjh_a, -1 );
            $zj_b = substr( $zjh_b, -1 );
            $zj_c = substr( $zjh_c, -1 );
            $zj_d = substr( $zjh_d, -1 );
            $zj_e = substr( $zjh_e, -1 );
            $kjnum_array_ffc = [$zj_a,$zj_b,$zj_c,$zj_d,$zj_e];
            $strkjNum_ffc = implode('|',$kjnum_array_ffc);
            $resultIds = $this->getGameTxffcResult($kjnum_array_ffc);
            $resultIdsCnt = count($resultIds);
            $odds = $this->GetOddByResult(49 , $resultIds);
            $oddsCnt = count($odds);
            if($resultIdsCnt == $oddsCnt && $resultIdsCnt > 0){
                $zj_result = $kjnum_array_ffc[0] + $kjnum_array_ffc[1] + $kjnum_array_ffc[2] + $kjnum_array_ffc[3] + $kjnum_array_ffc[4];

                $resultIdStr = implode(",", $resultIds);
                $oddStr = implode(",", $odds);
                $sql = "call web_kj_gametxffc({$No},{$zj_result},'{$strkjNum_ffc}',{$oddsCnt},'{$resultIdStr}','{$oddStr}')";
                //$this->Logger($sql);
                $result = $this->db->MultiQuery($sql);
                $this->Logger("tenxunffc {$No} open result is:{$result[0][0]['msg']}({$result[0][0]['result']})");
            }
		}
		
		
		
		if($isToAuto){
			//给下一盘自动投注
			$NextNo = $No+1;
			$sql = "select id from gametx28 where id={$NextNo} and kj=0 and zdtz_r=0 limit 1";
			$result = $this->db->getRow($sql);
			if(!empty($result)){
				//自动投注
				$this->autoPress($No,$NextNo);
			}
		}
			
			
	}
	
	
	private function autoPress($No,$NextNo){
		//腾讯28自动投注
		$sql = "call web_tz_gametx28_auto_new({$No},{$NextNo})";
		$result = $this->db->MultiQuery($sql);
		if($result[0][0]['result'] == 99){
			sleep(1);
			$result = $this->db->MultiQuery($sql);
		}
		$this->Logger("tenxun28 {$NextNo} auto press:{$result[0][0]['result']}");
	
		//腾讯16自动投注
		$sql = "call web_tz_gametx16_auto_new({$No},{$NextNo})";
		$result = $this->db->MultiQuery($sql);
		if($result[0][0]['result'] == 99){
			sleep(1);
			$result = $this->db->MultiQuery($sql);
		}
		$this->Logger("tenxun16 {$NextNo} auto press:{$result[0][0]['result']}");
	
		//腾讯11自动投注
		$sql = "call web_tz_gametx11_auto_new({$No},{$NextNo})";
		$result = $this->db->MultiQuery($sql);
		if($result[0][0]['result'] == 99){
			sleep(1);
			$result = $this->db->MultiQuery($sql);
		}
		$this->Logger("tenxun11 {$NextNo} auto press:{$result[0][0]['result']}");
	
		//腾讯36自动投注
		$sql = "call web_tz_gametx36_auto_new({$No},{$NextNo})";
		$result = $this->db->MultiQuery($sql);
		if($result[0][0]['result'] == 99){
			sleep(1);
			$result = $this->db->MultiQuery($sql);
		}
		$this->Logger("tenxun36 {$NextNo} auto press:{$result[0][0]['result']}");
	}
	
	
	private function getGameWWResult($kjNoArr){//外围开奖结果
		$zjhA = $kjNoArr[1] + $kjNoArr[4] + $kjNoArr[7] + $kjNoArr[10] + $kjNoArr[13] + $kjNoArr[16];
		$zjhB = $kjNoArr[2] + $kjNoArr[5] + $kjNoArr[8] + $kjNoArr[11] + $kjNoArr[14] + $kjNoArr[17];
		$zjhC = $kjNoArr[3] + $kjNoArr[6] + $kjNoArr[9] + $kjNoArr[12] + $kjNoArr[15] + $kjNoArr[18];
		$a = substr( $zjhA, -1 );
		$b = substr( $zjhB, -1 );
		$c = substr( $zjhC, -1 );
	
		$total = $a + $b + $c;
		$result = [];
	
		$is_max = 0;
		if($total >= 14){//大
			$is_max = 1;
			$result[] = 1;
			if($total >= 22){//极大
				$result[] = 9;
			}
		}else{//小
			$result[] = 6;
			if($total <= 5){
				$result[] = 4;//极小
			}
		}
	
		if($total % 2 == 0){//双
			$result[] = 5;
			if($is_max){
				$result[] = 8;//大双
			}else{
				$result[] = 7;//小双
			}
		}else{//单
			$result[] = 0;
			if($is_max){
				$result[] = 3;//大单
			}else{
				$result[] = 2;//小单
			}
		}
	
		if(in_array($total , [0,3,6,9,12,15,18,21,24,27])) $result[] = 10;
		if(in_array($total , [1,4,7,10,13,16,19,22,25])) $result[] = 11;
		if(in_array($total , [2,5,8,11,14,17,20,23,26])) $result[] = 12;
	
		sort($result);
		return $result;
	}
	
	
	private function getGameDWResult($kjNoArr){//定位开奖结果
		$zjhA = $kjNoArr[1] + $kjNoArr[4] + $kjNoArr[7] + $kjNoArr[10] + $kjNoArr[13] + $kjNoArr[16];
		$zjhB = $kjNoArr[2] + $kjNoArr[5] + $kjNoArr[8] + $kjNoArr[11] + $kjNoArr[14] + $kjNoArr[17];
		$zjhC = $kjNoArr[3] + $kjNoArr[6] + $kjNoArr[9] + $kjNoArr[12] + $kjNoArr[15] + $kjNoArr[18];
		$a = substr( $zjhA, -1 );
		$b = substr( $zjhB, -1 );
		$c = substr( $zjhC, -1 );
	
		$total = $a + $b + $c;
		$result = [];
	
		$is_max = 0;
		if($total >= 14){//大
			$is_max = 1;
			$result[] = 1;
			if($total >= 22){//极大
				$result[] = 9;
			}
		}else{//小
			$result[] = 6;
			if($total <= 5){
				$result[] = 4;//极小
			}
		}
	
		if($total % 2 == 0){//双
			$result[] = 5;
			if($is_max){
				$result[] = 8;//大双
			}else{
				$result[] = 7;//小双
			}
		}else{//单
			$result[] = 0;
			if($is_max){
				$result[] = 3;//大单
			}else{
				$result[] = 2;//小单
			}
		}
	
		if($a > $c) $result[] = 10;
		if($a < $c) $result[] = 11;
		if($a == $c) $result[] = 12;
	
		if($a >= 5){//大
			$result[] = 13;
		}else{//小
			$result[] = 14;
		}
	
		if($a % 2 == 0){//双
			$result[] = 16;
		}else{//单
			$result[] = 15;
		}
	
		$result[] = $a + 17;
	
	
		if($b >= 5){//大
			$result[] = 27;
		}else{//小
			$result[] = 28;
		}
	
		if($b % 2 == 0){//双
			$result[] = 30;
		}else{//单
			$result[] = 29;
		}
	
		$result[] = $b + 31;
	
	
		if($c >= 5){//大
			$result[] = 41;
		}else{//小
			$result[] = 42;
		}
	
		if($c % 2 == 0){//双
			$result[] = 44;
		}else{//单
			$result[] = 43;
		}
	
		$result[] = $c + 45;
	
		sort($result);
		return $result;
	}

    private function getGameTxffcResult($kjNoArr){//腾讯分分彩开奖结果
        $total = (int)$kjNoArr[0] + (int)$kjNoArr[1] + (int)$kjNoArr[2] + (int)$kjNoArr[3] + (int)$kjNoArr[4];

        if($total >= 23 && $total <= 45) $result[] = 0;//大
        if($total >= 0 && $total <= 22) $result[] = 1;//小

        if($total % 2 != 0) $result[] = 2;//单
        if($total % 2 == 0) $result[] = 3;//双

        if($kjNoArr[0] > $kjNoArr[4]) $result[] = 4;//龙
        if($kjNoArr[0] < $kjNoArr[4]) $result[] = 5;//虎
        if($kjNoArr[0] == $kjNoArr[4]) $result[] = 6;//和

        //5个车道
        for($n=0;$n<5;$n++){
            $kjNoArr[$n] = (int)$kjNoArr[$n];

            if($kjNoArr[$n] >= 5 && $kjNoArr[$n] <= 9) $result[] = 7 + $n * 14;//大
            if($kjNoArr[$n] >= 0 && $kjNoArr[$n] <= 4) $result[] = 8 + $n * 14;//小

            if($kjNoArr[$n] % 2 != 0) $result[] = 9 + $n * 14;//单
            if($kjNoArr[$n] % 2 == 0) $result[] = 10 + $n * 14;//双

            for($i=0;$i<=9;$i++){
                if($kjNoArr[$n] == $i){
                    $result[] = 11 + $n * 14 + $i;
                    break;
                }
            }
        }

        $a = $this->getGame36Result($kjNoArr[0],$kjNoArr[1],$kjNoArr[2]);
        $result[] = 76 + $a;
        $b = $this->getGame36Result($kjNoArr[1],$kjNoArr[2],$kjNoArr[3]);
        $result[] = 81 + $b;
        $c = $this->getGame36Result($kjNoArr[2],$kjNoArr[3],$kjNoArr[4]);
        $result[] = 86 + $c;

        sort($result);
        return $result;
    }
	
}


