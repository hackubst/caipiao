<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/bootstrap.min.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/basic.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>style/index.css?12" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/jquery.min.js"></script>
<link rel="shortcut icon" type="image/png" href="<?php echo isset($skin)?$skin:"";?>img/favicon.png" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/js.css" />
    <script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/vue.min.js"></script>
    <title><?php echo isset($webname)?$webname:"";?></title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header">
            <a href="<?php echo url("game/game/id/$id");?>" class="navbar-brand" onclick="javascript:void(0);"><img src="<?php echo isset($skin)?$skin:"";?>new_imgs/main/bar_back.png"></a>
            <button type="button" class="navbar-toggle break" id="btn_refsh">
                <img src="<?php echo isset($skin)?$skin:"";?>new_imgs/main/bar_break.png">
            </button>
        </div>
        <p class="navbar_title"><?php echo isset($game_name)?$game_name:"";?></p>
    </div>

</nav>

<div id="main">
    <div class="container-fluid">
        <div class="row">
            <table class="table table-hover table-striped table-bordered text-center">
                <tr>
                	<th class="text-center">期号</th>
                    <th class="text-center">号码</th>
                    <th class="text-center">投注数</th>
                    <th class="text-center">获得数</th>
                    <th class="text-center">赔率</th>
                </tr>
                <?php if(is_array($list))  foreach($list as $v) { ?>
                <tr class="item">
                	<td><?php echo isset($v['no'])?$v['no']:"";?></td>
                    <td><?php echo isset($v['tznum'])?$v['tznum']:"";?></td>
                    <td><?php echo isset($v['tzpoints'])?$v['tzpoints']:"";?></td>
                    <td><?php echo isset($v['zjpoints'])?$v['zjpoints']:"";?></td>
                    <td><?php echo isset($v['zjpl'])?$v['zjpl']:"";?></td>
                </tr>
                <?php }?>
            </table>
        </div>
        
        <div class="row" style="margin-top:20px;">
            <table class="table table-hover table-striped table-bordered text-center">
                <tr>
                	<td class="text-center" style="width:90px;">期号</td>
                    <td style="text-align:left;"><?php echo isset($no)?$no:"";?></td>
                </tr>
                <tr>
                	<td class="text-center">号码</td>
                    <td style="text-align:left;">
					<?php for($i=0;$i<count($kgNoArr);$i++){?>	
							<span><div class="source_num"><?php echo isset($kgNoArr[$i])?$kgNoArr[$i]:"";?></div></span>
					<?php }?>
                    </td>
                </tr>
                <tr>
                	<td class="text-center">结果</td>
                    <td style="text-align:left;">
                    <?php 
                    if(in_array($id,array(6,7,15,43,46))){
                    ?>
                    	<span><div class="source_num"><?php echo isset($kgjgArr[3])?$kgjgArr[3]:"";?></div></span>
                    <?php 
                    }elseif(in_array($id,array(16,47))){
						if($kgjgArr[0] > $kgjgArr[1]) $total = "龙";
						else  $total = "虎";
                    ?>
						<span><div class="source_num"><?php echo isset($kgjgArr[0])?$kgjgArr[0]:"";?></div></span><span><div class="source_num"><?php echo isset($kgjgArr[1])?$kgjgArr[1]:"";?></div></span>
						<span><div class="source_num" style="margin-left:10px;">=</div></span><span><div class="source_num" style="margin-left:10px;"><?php echo isset($total)?$total:"";?></div></span>
					<?php 
                    }elseif(in_array($id,array(11,12,13,21,23))){
						$res[0] ="";$res[1] = "豹";$res[2] = "对";$res[3] = "顺";$res[4] = "半";$res[5] = "杂";
						$total = $res[$kgjgArr[3]];
                    ?>
                    	<span><div class="source_num"><?php echo isset($kgjgArr[0])?$kgjgArr[0]:"";?></div></span><span><div class="source_num"><?php echo isset($kgjgArr[1])?$kgjgArr[1]:"";?></div><span><div class="source_num"><?php echo isset($kgjgArr[2])?$kgjgArr[2]:"";?></div></span>
                    	<span><div class="source_num" style="margin-left:10px;">=</div></span><span><div class="source_num" style="margin-left:10px;"><?php echo isset($total)?$total:"";?></div></span>
                    <?php 
                    }else{
						$kgjgArrCnt = count($kgjgArr);
						$total = 0;
						foreach($kgjgArr as $idx=>$num){
							if($idx < $kgjgArrCnt-1 && $num > -1){
								$total = $total + $kgjgArr[$idx];
					?>
								<span><div class="source_num"><?php echo isset($kgjgArr[$idx])?$kgjgArr[$idx]:"";?></div></span>
					<?php 
							}
						}	
					?>
						<span><div class="source_num" style="margin-left:10px;">=</div></span><div class="source_num" style="margin-left:10px;"><?php echo isset($total)?$total:"";?></div></span>
					<?php 
                    }
                    ?>
                    </td>
                </tr>
            </table>
        </div>

    </div>
</div>
<!-- <nav class="navbar-default navbar-fixed-bottom nav_bg">
    <div class="container-fluid nav-li">
        <ul class="nav navbar-nav">
            <li><a href="<?php echo url('index/index');?>" style="padding-bottom:5px;padding-top:5px;"><span class="glyphicon glyphicon-home"></span> <b>首页</b></a></li>
            <li><a href="<?php echo url('game/index');?>" style="padding-bottom:5px;padding-top:5px;"><span class="glyphicon glyphicon-th"></span> <b>游戏乐园</b></a></li>
            <li><a href="<?php echo url('index/rankings');?>" style="padding-bottom:5px;padding-top:5px;"><span class="glyphicon glyphicon-stats"></span> <b>排行榜</b></a></li>
            <li><a href="<?php echo url('users/index');?>" style="padding-bottom:5px;padding-top:5px;"><span class="glyphicon glyphicon-user"></span> <b>会员</b></a></li>
        </ul>
    </div>
</nav>
<div style="display: none">
<script>
var lainframe;

$(document).ready(function(){
	function checkAuth()
	{
	   $.post('./refreshstatus.php',{},function(ret){
	   		if(ret.status != 0)
	   		{
	   			alert(ret.msg);
	   			if(ret.status == 1){
	   				window.location='./mobile.php?c=users&a=login';
	   			}

   				if(ret.status == 2){
   					$.post('confirmmsg.php',{},function(data){
						
   	   	   			},'json');
   	   	   		}
	   		}
	   },'json');
	}

	var sessuserid = "<?php echo $_SESSION['usersid']?>";
	if(sessuserid > 0)
		setInterval(checkAuth , 3000);
}); 


</script>
     
</div> -->
<script type="text/javascript">
    $(function () {
        $('#btn_refsh').click(function(e){ window.location.reload(); });
    })
</script>
</body>
</html>