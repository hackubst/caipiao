<nav class="navbar navbar-default navbar-fixed-top nav_bg navbar_width">
    <div class="container">
        <div class="navbar-header">
            <a href="{:url('game/index')}" class="navbar-brand logo" onclick="javascript:void(0);"><img src="{$skin}new_imgs/main/bar_back.png" alt="{$webname}"></a>
            
            {if $info.usersid > 0}
                <ul class="navbar_info">
                    <li>￥<span>{$info.points}</span></li>
                    <li><a href="{:url('users/mytransfer')}">金币互转</a></li>
                </ul>
            {else}
                <ul class="navbar_ul" style="display:none;">
                    <li><a href="{:url('users/reg')}" class="btn-white btn-danger">注 册</a></li>
                    <li><a href="{:url('users/login')}" class="btn-white btn-success">登 录</a></li>
                </ul>
            {/if}

        </div>
        <p class="navbar_title">游戏中心</p>
    </div>
</nav>