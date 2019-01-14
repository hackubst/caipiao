<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    {tpl style}
    <link rel="stylesheet" type="text/css" href="{$skin}style/game_list.css?16" />
    <script type="text/javascript" src="{$skin}js/game.js"></script>
    <title>{$webname}</title>
</head>
<body>
{tpl head}
<div id="main" style="margin-top:62px;">
    <div class="container-fluid">
        <div class="row">
            <div id="panels" class="panel-group">
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#js" data-parent="#panels" data-toggle="collapse" style="color:#e64047;">
                            <!-- 急速类 border-left:3px solid #e64047; -->
                            <img src="template/mobile/default/new_imgs/main/game_name1.png" alt="急速类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="js" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/15/')}" alt="急速10">急速10</a>
                                <a href="{:url('game/game/id/2/')}" alt="急速11">急速11</a>
                                <a href="{:url('game/game/id/1/')}" alt="急速16">急速16</a>
                                <a href="{:url('game/game/id/22/')}" alt="急速22">急速22</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/0/')}" alt="急速28">急速28</a>
                                <a href="{:url('game/game/id/23/')}" alt="急速36">急速36</a>
                                <a href="{:url('game/game/id/24/')}" alt="急速冠亚军">急速冠亚军</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#bj" data-parent="#panels" data-toggle="collapse" style="color:#6a25cb;">
                            <!-- 北京类 border-left:3px solid #6a25cb; -->
                            <img src="template/mobile/default/new_imgs/main/game_name2.png" alt="北京类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="bj" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/38/')}" alt="北京11">北京11</a>
                                <a href="{:url('game/game/id/5/')}" alt="北京16">北京16</a>
                                <a href="{:url('game/game/id/4/')}" alt="北京28">北京28</a>
                                <a href="{:url('game/game/id/12/')}" alt="北京36">北京36</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/41/')}" alt="北京外围">北京外围</a>
                                <a href="{:url('game/game/id/42/')}" alt="北京定位">北京定位</a>
                                <a href="{:url('game/game/id/33/')}" alt="北京28固定">北京28固定</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#pk" data-parent="#panels" data-toggle="collapse" style="color:#fd8823;">
                            <!-- PK类 border-left:3px solid #fd8823; -->
                            <img src="template/mobile/default/new_imgs/main/game_name3.png" alt="PK类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="pk" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/6/')}" alt="PK10">PK10</a>
                                <a href="{:url('game/game/id/14/')}" alt="PK22">PK22</a>
                                <a href="{:url('game/game/id/17/')}" alt="PK冠亚军">PK冠亚军</a>
                                <a href="{:url('game/game/id/7/')}" alt="PK冠军">PK冠军</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/16/')}" alt="PK龙虎">PK龙虎</a>
                                <a href="{:url('game/game/id/29/')}" alt="PK赛车">PK赛车</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#jnd" data-parent="#panels" data-toggle="collapse" style="color:#026fdf;">
                            <!-- 加拿大类 border-left:3px solid #026fdf; -->
                            <img src="template/mobile/default/new_imgs/main/game_name4.png" alt="加拿大类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="jnd" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/10/')}" alt="加拿大11">加拿大11</a>
                                <a href="{:url('game/game/id/9/')}" alt="加拿大16">加拿大16</a>
                                <a href="{:url('game/game/id/8/')}" alt="加拿大28">加拿大28</a>
                                <a href="{:url('game/game/id/13/')}" alt="加拿大36">加拿大36</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/27/')}" alt="加拿大外围">加拿大外围</a>
                                <a href="{:url('game/game/id/28/')}" alt="加拿大定位">加拿大定位</a>
                                <a href="{:url('game/game/id/35/')}" alt="加拿大28固定" style="width:30%;">加拿大28固定</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#dd" data-parent="#panels" data-toggle="collapse" style="color:#9aaa00;">
                            <!-- 蛋蛋类 border-left:3px solid #9aaa00; -->
                            <img src="template/mobile/default/new_imgs/main/game_name5.png" alt="蛋蛋类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="dd" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/39/')}" alt="蛋蛋11">蛋蛋11</a>
                                <a href="{:url('game/game/id/40/')}" alt="蛋蛋16">蛋蛋16</a>
                                <a href="{:url('game/game/id/3/')}" alt="蛋蛋28">蛋蛋28</a>
                                <a href="{:url('game/game/id/11')}" alt="蛋蛋36">蛋蛋36</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/25/')}" alt="蛋蛋外围">蛋蛋外围</a>
                                <a href="{:url('game/game/id/26/')}" alt="蛋蛋定位">蛋蛋定位</a>
                                <a href="{:url('game/game/id/32/')}" alt="蛋蛋28固定">蛋蛋28固定</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>                
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#airship" data-parent="#panels" data-toggle="collapse" style="color:#fd8823;">
                            <!-- 飞艇类 border-left:3px solid #fd8823; -->
                            <img src="template/mobile/default/new_imgs/main/game_name6.png" alt="飞艇类" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="airship" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/43/')}" alt="飞艇10">飞艇10</a>
                                <a href="{:url('game/game/id/44/')}" alt="飞艇22">飞艇22</a>
                                <a href="{:url('game/game/id/45/')}" alt="飞艇冠亚军">飞艇冠亚军</a>
                                <a href="{:url('game/game/id/46/')}" alt="飞艇冠军">飞艇冠军</a>
                                </li>
                                <li>
                                <a href="{:url('game/game/id/47/')}" alt="飞艇龙虎">飞艇龙虎</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading panel_heading">
                        <h4 class="panel-title panel_line" style="font-size:14px;"><a href="#qt" data-parent="#panels" data-toggle="collapse" style="color:#272ba6;">
                            <!-- 时时彩 border-left:3px solid #272ba6; -->
                            <img src="template/mobile/default/new_imgs/main/game_name7.png" alt="时时彩" style="height:28px;" />
                        </a></h4>
                    </div>
                    <div id="qt" class="panel-collapse collapse in">
                        <div class="collapse-body">
                            <ul class="list-unstyled list_game" style="margin-bottom:0;">
                                <li>
                                <a href="{:url('game/game/id/37/')}" alt="重庆时时彩">重庆时时彩</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>