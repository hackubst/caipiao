
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/member_basic.css" />
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>style/member_total.css" />
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/bootstrap.min.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/basic.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>style/index.css?12" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/jquery.min.js"></script>
<link rel="shortcut icon" type="image/png" href="<?php echo isset($skin)?$skin:"";?>img/favicon.png" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/bootstrap.min.js"></script>
    <title>会员中心-<?php echo isset($webname)?$webname:"";?></title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header nav_header">
            <a href="javascript:void(0);" class="navbar-brand" onclick="history.back();"><img src="<?php echo isset($skin)?$skin:"";?>new_imgs/main/bar_back.png"></a>
            <button type="button" class="navbar-toggle break" id="btn_refsh">
                <img src="<?php echo isset($skin)?$skin:"";?>new_imgs/main/bar_break.png">
            </button>
        </div>
        <p class="navbar_title">游戏&彩票互转</p>
    </div>
</nav>
<div id="main" class="container-fluid">
    
    <div class="row member_header">
    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 pad0" style="display:none;">
        <div class="media">
            <div class="media-left">
                <img src="<?php echo isset($info->head)?$info->head:"";?>" alt="用户头像" class="media-object"  width="50" height="50">
            </div>
            <div class="media-body">
                <h4 class=""><div class="red"><?php echo isset($info->nickname)?$info->nickname:"";?></div> (ID : <span class="red"><?php echo isset($info->usersid)?$info->usersid:"";?></span>)</h4>
            </div>
        </div>
    </div>
    <div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 info_login pad0" style="display:none;">
        <div class="loginout pull-right">
            <a href="<?php echo url('users/out');?>" class="btn btn-default">退出登录</a>
            <a style="display: none" href="member_mysignin.shtml" class="btn btn-default">签到</a>
        </div>
    </div>

    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad4" style="height:45px;line-height:45px;">
        <p style="margin:0px;padding:0px;"><img src="<?php echo isset($skin)?$skin:"";?>img/user/coin_1.png" alt="乐币"> 余额 : ¥ <span class="red"><?php echo isset($info->points)?$info->points:"";?></span></p>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad4" style="height:45px;line-height:45px;">
        <p style="margin:0px;padding:0px;"><img src="<?php echo isset($skin)?$skin:"";?>img/user/coin_2.png" alt="金币"> 银行 : ¥  <span class="red"><?php echo isset($info->bankpoints)?$info->bankpoints:"";?></span></p>
    </div>
    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 member_bank white_bg" style="height:1px;line-height:1px;"></div>

    <!-- <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad4">
        <p style="margin:0px;padding:0px;"><img src="<?php echo isset($skin)?$skin:"";?>img/user/pay.png" width="25" height="25" alt="乐币"> 充值 : ¥ <span class="red"><?php echo isset($rmb)?$rmb:"";?></span></p>
    </div>
    <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad4">
        <p style="margin:0px;padding:0px;"><img src="<?php echo isset($skin)?$skin:"";?>img/user/payls.png" width="25" height="25" alt="金币"> 流水 : ¥ <span class="red"><?php echo isset($tzpoint)?$tzpoint:"";?></span></p>
    </div> -->
</div>

    <div class="row white_bg member_mycard">
        <form action="">
            <div class="form-group member_coin">
                <label for="desposit">存豆金额:</label>
                <input type="text" class="form-control" name="deposit" id="deposit" placeholder="请输入金额整数">
            </div>
            
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="savemoney(50)">50</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="savemoney(100)">100</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="savemoney(500)">500</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="savemoney(1000)">1K</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="savemoney(5000)">5K</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="removes1()">清除</button>
            
            <button type="button" class="btn btn-danger btn-block set" style="margin-top:10px;">游戏转入彩票</button>
            
        </form>

        <form action="">
            <div class="form-group member_coin">
                <label for="desposit">取豆金额:</label>
                <input type="text" class="form-control" name="take" id="take" placeholder="请输入金额整数">
            </div>
            
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getmoney(50)">50</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getmoney(100)">100</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getmoney(500)">500</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getmoney(1000)">1K</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getmoney(5000)">5K</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="getall()">全部</button>
            <button type="button"  class="btn btn-danger" style="font-size:12px;" onclick="removes2()">清除</button>
            
            <button type="button" class="btn btn-danger btn-block get" style="margin-top:10px;">彩票转入游戏</button>
        </form>
        <p class="green message_text">温馨提示:游戏金币和彩票乐豆的互转</p>
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
        $(".set").bind('click',function () {
            var point = $("input[name=deposit]").val();
            if (parseInt(point) > 0) { 
                $.ajax({type: 'post', url: '<?php echo url('users/mytransfer');?>',
                    data:{t:'save', point:point},
                    dataType:'json',cache:false,
                    success:function (data) {
                        alert(data.message);
                        if(data.status==0){
                            location.reload();
                        }
                    },
                    error:function () {
                        window.alert("请求超时，请稍后重试.");
                    }
                });
            } else {                
                window.alert('请输入大于0的金额');
                return false;
            }
        });
        $(".get").bind('click',function () {
            var point = $("input[name=take]").val();
            if (parseInt(point) > 0) { 
                $.ajax({type: 'post', url: '<?php echo url('users/mytransfer/');?>',
                    data:{point:point},
                    dataType:'json', cache:false,
                    success:function (data) {
                        alert(data.message);
                        if(data.status==0){
                            location.reload();
                        }
                    },
                    error:function () {
                        window.alert("请求超时，请稍后重试.");
                    }
                });
            } else {
                window.alert('请输入大于0的金额.');
                return false;
            }
        });
    });

    function savemoney(i) {
        var deposit=parseInt($("#deposit").val());
        if(isNaN(deposit))deposit=0;
        $("#deposit").val(deposit+parseInt(i));
    }
    function removes1() {
        $("#deposit").val("");
    }

    function getmoney(i) {
        var take=parseInt($("#take").val());
        if(isNaN(take))take=0;
        $("#take").val(take+parseInt(i));
    }
    function removes2() {
        $("#take").val("");
    }
    function getall(){
        $.ajax({
            type: 'post',
            url: '<?php echo url('users/getmymoney/');?>',
		    dataType:'json',
		    cache:false,
            success: function (data) {
                if(data.status==0) {
                    $("#take").val(Math.floor(data.points/1000));
                }
		    },
		    error: function () {
		        window.alert("请求超时，请稍后重试.");
		    }
		});
    }
    
</script>
</body>
</html>