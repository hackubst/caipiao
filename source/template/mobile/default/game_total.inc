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
                    <th class="text-center">时间</th>
                    <th class="text-center">期数</th>
                    <th class="text-center">输赢</th>
                </tr>
                {loop $list $v}
                <tr>
                    <th class="text-center">合计</th>
                    <th class="text-center">{$v.no}</th>
                    <th class="text-center">{$v.hdpoints}</th>
                </tr>
                {/loop}
            </table>
        </div>

    </div>
</div>
<!-- {tpl foot} -->
<script type="text/javascript">
    $(function () {
        $("#list").on('click','#press',function () {
            no=$(this).parents("a").attr("id");
            window.location="{:url("game/press/id/$id")}&no="+no;
            return false;
        });
        $("#main").on("click",".item",function () {
            no=$(this).attr("rel");
            window.location="{:url("game/item/id/$id")}&no="+no;
        });
        $('#btn_refsh').click(function(e){ window.location.reload(); });
    })
</script>
</body>
</html>