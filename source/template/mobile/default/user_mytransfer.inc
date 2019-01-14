
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="{$skin}css/member_basic.css" />
    <link rel="stylesheet" type="text/css" href="{$skin}style/member_total.css" />
    {tpl style}
    <title>会员中心-{$webname}</title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header nav_header">
            <a href="javascript:void(0);" class="navbar-brand" onclick="history.back();"><img src="{$skin}new_imgs/main/bar_back.png"></a>
            <button type="button" class="navbar-toggle break" id="btn_refsh">
                <img src="{$skin}new_imgs/main/bar_break.png">
            </button>
        </div>
        <p class="navbar_title">游戏&彩票互转</p>
    </div>
</nav>
<div id="main" class="container-fluid">
    
    {tpl info}

    <div class="row white_bg member_mycard" style="margin: 0px;padding: 0px;">
        <form action="" style="margin-top:10px;">
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

        <form action="" style="margin-top:10px;">
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

<!-- {tpl foot} -->

<script type="text/javascript">
    $(function () {
        $(".set").bind('click',function () {
            var point = $("input[name=deposit]").val();
            if (parseInt(point) > 0) { 
                $.ajax({type: 'post', url: '{:url('users/mytransfer')}',
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
                $.ajax({type: 'post', url: '{:url('users/mytransfer/')}',
                    data:{ point:point },
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
            url: '{:url('users/getmymoney/')}',
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