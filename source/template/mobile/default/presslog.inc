
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    {tpl style}
    <link rel="stylesheet" type="text/css" href="{$skin}style/member_total.css" />
    <title>{$webname}</title>
</head>
<body>
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid" style="position:relative;">
        <div class="navbar-header nav_header">
            <a href="javascript:void(0);" class="navbar-brand" onclick="history.back();"><span class="glyphicon glyphicon-chevron-left icon"></span></a>
            <a href="javascript:void(0);" class="btn refresh" onclick="window.location.reload();"><span class="glyphicon glyphicon-refresh"></span></a>
        </div>
        <p class="navbar_title">投注记录</p>
    </div>
</nav>
<div id="main">
    {tpl info}
    <div class="container-fluid">
        <div class="row member_ex white_bg member_gift">
            <div class="media">
                <div class="media-left media-middle">
                    <span class="glyphicon glyphicon-xbt"></span>
                </div>
                <div class="media-body">
                    <h4 class="media-heading">投注记录</h4>
                    <p>
                    <a href="{:url('activity/getpresslog')}&d=1" {$class_1}>昨日投注</a> &nbsp;
                    <a href="{:url('activity/getpresslog')}" {$class_0}>今日投注</a>
                    </p>
                    <p>
                    	总额 : {function=number_format($totalpress)}
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid">
        <div class="row white_bg member_mycard">
            <table class="table table-hover table-striped table-bordered text-center">
                <thead>
                <tr>
                    <th>游戏类型</th>
                    <th>期号</th>
                    <th>投注总分</th>
                    <th>投注时间</th>
                </tr>
                </thead>
                <tbody>
                {if $presslist}
                {loop $presslist $k $v}
                <tr>
                    <td>{$v.gamename}</td>
                    <td>{$v.no}</td>
                    <td style="text-align:right;">{function=number_format($v.totalscore)}</td>
                    <td>{function=date('Y-m-d H:i:s',strtotime($v.presstime))}</td>
                </tr>
                {/loop}
                {else}
                <tr>
                    <td colspan="5">暂无记录</td>
                </tr>
                {/if}
                </tbody>
            </table>
        </div>
    </div>
</div>
{tpl foot}


</body>
</html>