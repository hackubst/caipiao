<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    {tpl style}
    <link rel="stylesheet" type="text/css" href="{$skin}css/js.css" />
    <script type="text/javascript" src="{$skin}js/vue.min.js"></script>
    <title>{$webname}</title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header">
            <a href="{:url("game/game/id/$id")}" class="navbar-brand" onclick="javascript:void(0);"><img src="{$skin}new_imgs/main/bar_back.png"></a>
            <button type="button" class="navbar-toggle break" id="btn_refsh">
                <img src="{$skin}new_imgs/main/bar_break.png">
            </button>
        </div>
        <p class="navbar_title">{$game_name}</p>
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
                {loop $list $v}
                <tr class="item">
                	<td>{$v['no']}</td>
                    <td>{$v['tznum']}</td>
                    <td>{$v['tzpoints']}</td>
                    <td>{$v['zjpoints']}</td>
                    <td>{$v['zjpl']}</td>
                </tr>
                {/loop}
            </table>
        </div>
        
        <div class="row" style="margin-top:20px;">
            <table class="table table-hover table-striped table-bordered text-center">
                <tr>
                	<td class="text-center" style="width:90px;">期号</td>
                    <td style="text-align:left;">{$no}</td>
                </tr>
                <tr>
                	<td class="text-center">号码</td>
                    <td style="text-align:left;">
					<?php for($i=0;$i<count($kgNoArr);$i++){?>	
							<span><div class="source_num">{$kgNoArr[$i]}</div></span>
					<?php }?>
                    </td>
                </tr>
                <tr>
                	<td class="text-center">结果</td>
                    <td style="text-align:left;">
                    <?php 
                    if(in_array($id,array(6,7,15,43,46))){
                    ?>
                    	<span><div class="source_num">{$kgjgArr[3]}</div></span>
                    <?php 
                    }elseif(in_array($id,array(16,47))){
						if($kgjgArr[0] > $kgjgArr[1]) $total = "龙";
						else  $total = "虎";
                    ?>
						<span><div class="source_num">{$kgjgArr[0]}</div></span><span><div class="source_num">{$kgjgArr[1]}</div></span>
						<span><div class="source_num" style="margin-left:10px;">=</div></span><span><div class="source_num" style="margin-left:10px;">{$total}</div></span>
					<?php 
                    }elseif(in_array($id,array(11,12,13,21,23))){
						$res[0] ="";$res[1] = "豹";$res[2] = "对";$res[3] = "顺";$res[4] = "半";$res[5] = "杂";
						$total = $res[$kgjgArr[3]];
                    ?>
                    	<span><div class="source_num">{$kgjgArr[0]}</div></span><span><div class="source_num">{$kgjgArr[1]}</div><span><div class="source_num">{$kgjgArr[2]}</div></span>
                    	<span><div class="source_num" style="margin-left:10px;">=</div></span><span><div class="source_num" style="margin-left:10px;">{$total}</div></span>
                    <?php 
                    }else{
						$kgjgArrCnt = count($kgjgArr);
						$total = 0;
						foreach($kgjgArr as $idx=>$num){
							if($idx < $kgjgArrCnt-1 && $num > -1){
								$total = $total + $kgjgArr[$idx];
					?>
								<span><div class="source_num">{$kgjgArr[$idx]}</div></span>
					<?php 
							}
						}	
					?>
						<span><div class="source_num" style="margin-left:10px;">=</div></span><div class="source_num" style="margin-left:10px;">{$total}</div></span>
					<?php 
                    }
                    ?>
                    </td>
                </tr>
            </table>
        </div>

    </div>
</div>
<!-- {tpl foot} -->
<script type="text/javascript">
    $(function () {
        $('#btn_refsh').click(function(e){ window.location.reload(); });
    })
</script>
</body>
</html>