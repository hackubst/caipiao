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

        <div class="collapse navbar-collapse" id="list_nav">
            <ul class="nav navbar-nav navbar-right" style="display: none">
                <li class="active"><a href="auto.shtml">自定义投注模式</a></li>
                <li><a href="../member_mybank.shtml">小金库</a></li>
                <li><a href="trend.shtml"><?php echo isset($game_name)?$game_name:"";?>走势图</a></li>
            </ul>
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
                    <th class="text-center">时间</th>
                    <th class="text-center">投注</th>
                    <th class="text-center">获取</th>
                    <th class="text-center">赢取</th>
                </tr>
                <?php if(is_array($list))  foreach($list as $v) { ?>
                <tr class="item" rel="<?php echo isset($v->no)?$v->no:"";?>">
                    <td><?php echo isset($v->no)?$v->no:"";?></td>
                    <td><?php echo isset($v->time)?$v->time:"";?></td>
                    <td><?php echo isset($v->points)?$v->points:"";?></td>
                    <td><?php echo isset($v->hdpoints)?$v->hdpoints:"";?></td>
                    <td><?php echo isset($v->hd)?$v->hd:"";?></td>
                </tr>
                <?php }?>
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
        $("#list").on('click','#press',function () {
            no=$(this).parents("a").attr("id");
            window.location="<?php echo url("game/press/id/$id");?>&no="+no;
            return false;
        });
        $("#main").on("click",".item",function () {
            no=$(this).attr("rel");
            window.location="<?php echo url("game/recorddetail/id/$id");?>&no="+no;
        });
        $('#btn_refsh').click(function(e){ window.location.reload(); });
    })
</script>
</body>
</html>