<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    {tpl style}
    <link rel="stylesheet" type="text/css" href="{$skin}css/js.css??v=1.5.01" />
    <script type="text/javascript" src="{$skin}js/vue.min.js"></script>
    <title>{$webname}</title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header">
            <a href="{:url('game/index')}" class="navbar-brand" onclick="javascript:void(0);"><img src="{$skin}new_imgs/main/bar_back.png"></a>
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#list_nav">
                <img src="{$skin}new_imgs/main/bar_more.png">
            </button>
        </div>

        <div class="collapse navbar-collapse" id="list_nav">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="{:url("game/rule/id/$id")}">游戏规则</a></li>
                <li><a href="{:url("game/record/id/$id")}">投注记录</a></li>
                <li><a href="{:url("game/total/id/$id")}">盈利统计</a></li>
            </ul>
        </div>
        <p onclick="window.location.reload();" class="navbar_title">{$game_name}</p>
    </div>

</nav>
<div id="main">

    <div class="container-fluid">
        <div class="row">
            <div class="list-group white_bg" id="list">
                <template v-for="v in list">
                    <a href="javascript:;" id="{{v.id}}" class="list-group-item status{{v.status}}">
                        <div class="container-fluid">
                            <div class="row list_pad">
                                <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 text-left pad0"><span>{{v.sid}}</span></div>
                                <template v-if="v.kj==0">
                                    <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 text-left pad0"><span>{{v.kgtime}}</span></div>
                                    <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 text-left pad0 w{{v.kj}}" >
                                        <span v-if="v.stoptime>0">截止<span class="red">{{v.stoptime}}</span>秒</span>
                                        <span v-else>
                                            <span v-if="v.kjtime>0">还有<span class="red">{{v.kjtime}}</span>秒,开奖 </span>
                                            <span v-else>开奖中...</span>
                                        </span>
                                    </div>
                                </template>
                                <template v-if="v.kj==1">
                                    <div class="col-lg-7 col-md-7 col-sm-7 col-xs-7 text-left pad0" >
                                        <span style="display:inline-block;">                                            
                                            <template v-for="(index, sv) in v.kjjg">
                                                <span v-if="index==3" style="display:inline-block;">
                                                    <img src="{$skin}img/jg/number_{{type}}{{sv}}.gif">
                                                </span>
                                            </template>
                                            <template v-for="(index, sv) in v.kjjg2">
                                                <span v-if="sv<13" style="display:inline-block;">
                                                    <img src="{$skin}img/ww/ds_{{sv}}.png">
                                                </span>
                                            </template>                                            
                                        </span>
                                    </div>
                                </template>
                                <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3 pad0 press" style="float:right">
                                    <span v-if="v.status==1">{{v.points}}/{{v.hdpoints}}</span>
                                    <span v-if="v.status==2" id="press"><button class="btn btn-info kj"><span v-if="v.points>0">{{v.points}}</span><span v-else>&nbsp;投　注&nbsp;</span></button></span>
                                    <span v-if="v.status==3"><button class="btn btn-warning kj">&nbsp;开奖中&nbsp;</button></span>
                                </div>
                            </div>
                        </div>
                    </a>
                </template>

            </div>
        </div>
    </div>

</div>
<script type="text/javascript">
    var vm = new Vue({
        el: '#list',
        data: {
            list:[],
            type:'',
            name: 'Vue.js'
        }
    });
    var timerid;
    function getContent(){
        var url="{:url("game/ajax/id/$id")}&t=" + Math.random();
        $.ajax({
            type: "GET",
            url: url,
            dataType: "json",
            timeout:1000,
            success: function(data){
                //alert("xx")
                if(!data.points)data.points=0;
                if(!data.bank)data.bank=0;
                $("#money").text(data.points);
                $("#bank").text(data.bank);
                vm.$data.list=data.list;
                vm.$data.type=data.type;
                timerid=setInterval(djs,1000);
            },
            error:function(jqXHR, textStatus, errorThrown){
                if(textStatus=="timeout"){
                    alert("加载超时，请重试");
                }else{
                    if(textStatus.indexOf("script")){
                        location.href='/mobile.php'
                        return;
                    }
                    alert(textStatus);
                }
                getContent();
            }
        })
        //alert("test")
    }
    function djs() {
        for(var i in vm.$data.list){
            --vm.$data.list[i].stoptime;
            --vm.$data.list[i].kjtime;
            if(vm.$data.list[i].kj==0 && vm.$data.list[i].kjtime<1){
                console.info('<<'+vm.$data.list[i].kjtime);
                clearInterval(timerid);
                getContent();
                break;
            }
        }
    }
    $(document).ready(function(){
        clearInterval(timerid);
        getContent();
    });
    $(function () {
        $("#list").on('click','#press',function () {
            if($(this).find(".btn").hasClass("btn-default")){
                alert("投注已结束");
                return false;
            }
            $("#list .btn-danger").removeClass("btn-danger");
            $(this).find('.btn').addClass('btn-danger');
            no=$(this).parents("a").attr("id");
            //location.href="{:url("game/press/id/$id")}&no="+no;

            //TODO
            showPressPannel();
            
            $("#no").text(no);
          	//TODO
            //$(".status1").hide()
            return false;
        });
        $("#list").on("click",".status1 .text-left",function () {
        	no=$(this).parents("a").attr("id");
            window.location="{:url("game/recorddetail/id/$id")}&no="+no;
            //window.location="{:url("game/record/id/$id")}";
        })
        $('#clickIn').click(function(){
            //TODO
            //$(".status1").show()
        })
    })

    function showPressPannel() {
	    var bh = $("body").height();
	    var bw = $("body").width();
	    $("#fullbg").css({
	        height:bh,
	        width:bw,
	        display:"block"
	    });
	    $("#presspannel").show();
	    $("#pressbottom").show();
	}
	
	function closePressPannel() {
	    $("#fullbg,#presspannel,#pressbottom").hide();
	}
</script>

<div id="presspannel">
	<div style="position:absolute;right:0px;top:0px;"><img src="{$skin}img/close.png" alt="关闭" id="closeimg" onclick="closePressPannel();"></div>
    <div class="container-fluid">
        <div class="row">
        
            <!-- 选号区 -->
            <div class="small-show">
				<div id="press">
                    <div class="row small-btn small-36">
                        <p style="margin-bottom:5px;"><a class="btn btn-danger btn-block small-red"><span>和值</span></a></p>
                        {loop $pressoption $k $v}
                        {if $k<10}
                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 pad0">
                            <a id="tbNum<?php echo $k;?>" class="col-lg-2 btn btn-default small-bg">
                                <span style="display:block;line-height:21px;">{$v}</span>
                                <span class="betXSmall">x{$odds[$k]}</span>
                            </a>
                        </div>
                        {/if}
                        {/loop}
                    </div>
                    <div class="row small-btn small-36">
                        <p style="margin-bottom:5px;"><a class="btn btn-danger btn-block small-red"><span>龙虎豹</span></a></p>
                        {loop $pressoption $k $v}
                        {if $k>=10 && $k<13}
                        <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 pad0">
                            <a id="tbNum<?php echo $k;?>" class="col-lg-2 btn btn-default small-bg">
                                <span style="display:block;line-height:21px;">{$v}</span>
                                <div class="betXSmall">x{$odds[$k]}</div>
                            </a>
                        </div>
                        {/if}
                        {/loop}
                    </div>
				</div>
            </div>
            <!-- 选号区 -->
            
        </div>
    </div>
</div>

<nav class="navbar-default navbar-fixed-bottom" id="pressbottom" style="display:none;">
    <div class="container-fluid betting_bottom">
        <div class="row">
            <div class="col-lg-9 col-md-9 col-sm-8 col-xs-8 bottom_left">
                <input type="hidden" name="total" id="total" class="form-control total_press" value="0"/>
                <p><span style="display:inline-block;"><b>投注:</b></span><span name="total" style="display:inline-block;min-width:50px;">0</span><span style="display:inline-block;">余额:{$info.points}</span></p>
                <div class="chips">
                    <a href="javascript:chouma(1);"><img src="{$skin}img/chips_1000.png" class="img-responsive" alt="1"></a>
                    <a href="javascript:chouma(10);"><img src="{$skin}img/chips_10000.png" class="img-responsive" alt="10"></a>
                    <a href="javascript:chouma(100);"><img src="{$skin}img/chips_100000.png" class="img-responsive" alt="100"></a>
                    <a href="javascript:chouma(500);"><img src="{$skin}img/chips_500000.png" class="img-responsive" alt="500"></a>
                    <a href="javascript:chouma(1000);"><img src="{$skin}img/chips_1000000.png" class="img-responsive" alt="1000"></a>
                    <a href="javascript:chouma(5000);"><img src="{$skin}img/chips_5000000.png" class="img-responsive" alt="5000"></a>
                </div>
            </div>
            <div class="col-lg-3 col-md-3 col-sm-4 col-xs-4 bottom_right">
                <div class="button-group">
                    <a href="javascript:retz();" class="btn-tz btn btn-info">撤销</a>
                    <a href="javascript:cancel();" class="btn-tz btn btn-warning">取消</a>
                </div>
                <a href="javascript:;" class="btn-tz btn btn-danger" style="border-color:#af8344;" onclick="tz()">确认投注</a>
            </div>
        </div>
    </div>
</nav>

<script type="text/javascript">
    var MAX_SCORE = {$pl.press_max};
    var MIN_SCORE = {$pl.press_min};
    var MY_SCORE = {};
    var GTYPE = {$pl.gameType};
    var PRESSNUM = '{$pl.pressNum}';
    var money=0,jf=0;
    var no='';
    var num=0;
    var curr_cm=0;
    var data = PRESSNUM.split(",");
    var v_gid={$id};

    $(function () {
        $(".btn-qc").on('click',function () {
            $("#press ").removeClass('small-red');
        })
        $("#dx").on("click",'a',function () {
            useModel($(this).attr('rel'));
            $(this).addClass("small-red");
        })
        $("#press").on("click","a",function () {
            if($(this).hasClass("small-red")){
                $(this).removeClass("small-red");
            }else {
                $(this).addClass("small-red");
            }
            money=0;
            total();
        })
        //TODO
        $("#total").on('change',function () {
        	money=parseInt($(this).val());
        	total();
        });
        if (v_gid == 30) {
            $('#press .row:eq(0) .pad0:eq(0)').hide();
            $('#press .row:eq(0) .pad0:eq(5)').hide();
        }
    });
    function last_press() {
        $.ajax({
            type:"post",
            url:"{:url('game/getLastPress')}",
            data:{gtype:{$id}},
            timeout:3000,
            cache:false,
            dataType:"json",
            success:function (data) {
                jf=0;
                var pre=data.message.split('|');
                for(var i in pre){
                    var v=pre[i].split(',');
                    $("#tbNum" + v[0]).addClass("small-red");
                    jf+=parseInt(v[1]);
                }
                console.info(jf);

                money=Math.ceil(jf/1000);
                console.info(jf);
                total();
            }
        });
    }
    function remove(){
        for(var i= 0; i < data.length; i++) {
            $("#inNum" + i).val(0)
        }
        money=0;
        total();
    }
    function total() {
    	//TODO
        $('span[name="total"]').text(money);
        $("#total").val(money);
        jf=money*1000;
    }
    function chouma(v) {
        money+=parseInt(v);
        total();
    }
    function tz() {
        var press="";
        $("#press a").each(function (i) {
            if($(this).hasClass("small-red"))num++;
        });
        if(num>money){
            //money=num;
            //total();
        }
        if(num==0){
            alert("您还没有投注");return;
        }
        if(money==0){
            alert("请选择金额,筹码可以多次点击");return;
        }
        press=usefenpei(jf);
        if(jf > MAX_SCORE)
        {
            alert("您的投注额已大于最大限制" + MAX_SCORE);
            return;
        }
        if(!confirm("您确定投注 ¥" + money + " 吗?"))
            return;
        if(no==0){
            alert("请选择投资的期数");
            return;
        }
        $.ajax({
            type: "POST",
            url: "{:url('game/PostPress')}",
            data:{gtype:{$id},no:no,press:press},
            dataType: "json",
            timeout:3000,
            success: function(data){
                console.info(data);

                if(data.status==0){
                    alert("投注成功!");
                  	//TODO
                    closePressPannel();
                    location.href='{:url("game/game/id/$id")}';
                }else{
                    alert(data.message);
                  	//TODO
                    closePressPannel();
                }

            },
            error:function(){
            }
        });
        total();
    }
    function retz() {
        $.ajax({
            type: "POST",
            url: "{:url('game/ResetPress')}",
            data:{gtype:{$id},no:no},
            dataType: "json",
            timeout:3000,
            cache:false,
            success: function(data){
                if(data.status==0){
                    alert("投注撤销成功!");
                  	//TODO
                    closePressPannel();
                    window.location='{:url("game/game/id/$id")}';
                } else {
                    alert(data.message);
                  	//TODO
                    closePressPannel();
                }
            }
        });
    }
    $(function () {
        $("#press").on("mousedown",".item",function(event){
            if($(this).hasClass("active")){
                $(this).removeClass('active');
            }else {
                $(this).addClass('active');
                console.info($(this).find(".form-control").val())
                z=parseInt($(this).find(".form-control").val());
                console.info(z);
                if(isNaN(z)){
                    $(this).find(".form-control").val("0");
                    console.info("x");
                }
            }
        })
    });
    function usefenpei(Input_Score){
        var data = PRESSNUM.split(",");
        var totalScore = 0,totalPressScore = 0;
        var perScore = 0, tnum=0, tsnum=0;
        var result="";

        for(var i = 0; i < data.length; i++)
        {
            if($("#tbNum" + i).hasClass("small-red"))
            {
                tnum++;
                totalScore += parseInt(data[i]);
            }
        }
        for(var i= 0; i < data.length; i++)
        {
            perScore=0;

            if($("#tbNum" + i).hasClass("small-red"))
            {
                tsnum +=1;
                if(Input_Score <= MAX_SCORE)
                {
                    perScore = Input_Score / totalScore * parseInt(data[i]);
                }
                else
                {
                    perScore = MAX_SCORE / totalScore * parseInt(data[i]);
                }
                totalPressScore += parseInt(perScore);
                if (tsnum==tnum){
                    if(Input_Score <= MAX_SCORE){
                        perScore += (Input_Score-totalPressScore);
                    } else {
                        perScore += (MAX_SCORE-totalPressScore);
                    } 
                }
            }
            result+=parseInt(perScore)+',';
        }
        return result;
    }
    function cancel() {
    	//TODO
    	closePressPannel();
        money=0;
        total();
    }
</script>
        
<div id="fullbg"></div>
        
</body>
</html>

