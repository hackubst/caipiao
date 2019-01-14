<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/bootstrap.min.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/basic.css?12" />
<link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>style/index.css?12" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/jquery.min.js"></script>
<link rel="shortcut icon" type="image/png" href="<?php echo isset($skin)?$skin:"";?>img/favicon.png" />
<script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/bootstrap.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<?php echo isset($skin)?$skin:"";?>css/js.css"/>
    <script type="text/javascript" src="<?php echo isset($skin)?$skin:"";?>js/vue.min.js"></script>
    <title><?php echo isset($webname)?$webname:"";?></title>
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
        <p class="navbar_title">自动投注</p>
    </div>
</nav>


<div id="main" class="container-fluid">
    <div class="white_bg detailed_coin" style="padding:0px;">
        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad0">
            <p>¥: <span class="red" id="money"><?php echo isset($info->points)?$info->points:"";?></span></p>
        </div>
        <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 pad0">
            <p>银行: ¥<span class="red" id="bank"><?php echo isset($info->bankpoints)?$info->bankpoints:"";?></span></p>
        </div>
    </div>
    <div class='Edit'>
        <ul class='new' style="margin:10px auto;">
            <li>
                <lable>开始模式:</lable><select id='sltcurModel' name='select'>
                    <?php if(is_array($list))  foreach($list as $k=>$v) { ?>
                    <option value='<?php echo isset($v->id)?$v->id:"";?>' <?php if($curr->autoid==$v->id){?>selected='selected'<?php }?>><?php echo isset($v->tzname)?$v->tzname:"";?></option>
                    <?php }?>
                </select>
            </li>
            <li><lable>开始期号: </lable><input id='txtbeginno' name='txt' maxlength='12' type='text' value='<?php echo isset($curr->startNO)?$curr->startNO:"";?>' onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeyup="this.value=this.value.replace(/\D/g,'')" /></li>
            <li><lable>投注期数: </lable><input id='txttzcount' name='txt' maxlength='8' type='text' value='<?php echo isset($curr->num)?$curr->num:"";?>' onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeyup="this.value=this.value.replace(/\D/g,'')" /></li>
            <li><lable>金币上限: </lable><input id='txtmaxG' name='txt' maxlength='9' type='text' value='<?php echo isset($curr->maxG)?$curr->maxG:"";?>' onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeyup="this.value=this.value.replace(/\D/g,'')" /></li>
            <li><lable>金币下限: </lable><input id='txtminG' type='text' maxlength='9' name='txt' value='<?php echo isset($curr->minG)?$curr->minG:"";?>' onafterpaste="this.value=this.value.replace(/\D/g,'')" onkeyup="this.value=this.value.replace(/\D/g,'')" /></li>
        </ul>
        <div class='table'>
            <table class='table_list table table-striped table-bordered table-hover' cellspacing='0px' style='border-collapse:collapse;'>
                <tbody>
                    <tr>
                        <th width='150'>模式</th>
                        <th width='150'>乐豆</th>
                        <th width='350'>赢用模式</th>
                        <th width='350'>输用模式</th>
                    </tr>
                    <?php if(is_array($list))  foreach($list as $k=>$v) { ?>
                    <tr>
                        <td><?php echo isset($v->tzname)?$v->tzname:"";?></td>
                        <td><?php echo isset($v->tzpoints)?$v->tzpoints:"";?></td>
                        <td>

                            <select id='slt_<?php echo isset($v->id)?$v->id:"";?>' onchange='changemodel(this)' name='select' ct='win' cid='<?php echo isset($v->id)?$v->id:"";?>'>
                                <?php if(is_array($list))  foreach($list as $sk=>$sv) { ?>
                                <option value='<?php echo isset($sv->id)?$sv->id:"";?>' <?php if($v->winid==$sv->id){?>selected='selected'<?php }?>><?php echo isset($sv->tzname)?$sv->tzname:"";?></option>
                                <?php }?>
                            </select>
                        </td>
                        <td>
                            <select id='slt_<?php echo isset($v->id)?$v->id:"";?>' onchange='changemodel(this)' name='select' ct='loss' cid='<?php echo isset($v->id)?$v->id:"";?>'>
                                <?php if(is_array($list))  foreach($list as $sk=>$sv) { ?>
                                <option value='<?php echo isset($sv->id)?$sv->id:"";?>' <?php if($v->lossid==$sv->id){?>selected='selected'<?php }?>><?php echo isset($sv->tzname)?$sv->tzname:"";?></option>
                                <?php }?>
                        </td>
                    </tr>
                    <?php }?>
                </tbody>
            </table>
            <p class='tial' style="text-align:center;">
                <span class='ifo'> <a class="btn btn-warning" href="<?php echo url("game/game/id/$act");?>">返回游戏首页</a></span>
                <span class='btn btn-danger' id='sSubmit' ca='<?php if($curr->start_auto_id){?>cancel<?php }else{?>submit<?php }?>'><?php if($curr->start_auto_id){?>取消自动投注<?php }else{?>确定提交<?php }?></span>
            </p>
        </div>
        <div class='tims'>
            <p>设置方法：</p>
            <p>1．“开始模式”选择第一次投注的模式.</p>
            <p>2．设置“开始期号”与“期数”.</p>
            <p>3．设置“乐豆上限”与“下限”限制,帐号内乐豆数达到限制数量后,自助投注自动停止.</p>
            <p>4．确认并开始自动投注后，系统将会在您指定的期数内帮您自动投注，不论你离线或在线都会持续运行,直到期数终止或您关闭为止.</p>
            <p>5．银行内的乐豆不能用于投注.</p>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function(){
            if($('#sSubmit').attr('ca') == 'cancel')changestat(0);
            $('#sSubmit').click(function(){
                var toaction = $('#sSubmit').attr('ca');
                if(toaction == 'submit') {
                    var bno = $('#txtbeginno').val();
                    var cnt = $('#txttzcount').val();
                    var maxg = $('#txtmaxG').val();
                    var ming = $('#txtminG').val();
                    var cid = $('#sltcurModel').val();
                    if(cid != '')
                    {
                        $.post('<?php echo url('game/auto');?>',{act:'saveautomodel',gtype:<?php if($act){?><?php echo isset($act)?$act:"";?><?php }else{?>0<?php }?>,curno:bno,bno:bno,cnt:cnt,maxg:maxg,ming:ming,cid:cid},function(ret){
                            if(ret.status == 'ok')changestat(0);
                        alert(ret.message);
                        },'json');
                    }
                    else
                    {
                        alert('您还没有设置投注模式，请先设置!');
                    }
                }
                else
                {
                    $.post('<?php echo url('game/auto');?>',{act:'removeautomodel',gtype:<?php if($act){?><?php echo isset($act)?$act:"";?><?php }else{?>0<?php }?>},function(ret){
                        if(ret.status ==0)changestat(1);
                    },'json');
                }
            });
            $('#btn_refsh').click(function(e){ window.location.reload(); });
        });
        function changemodel(o)
        {
            var v = $(o).val();
            var cid = $(o).attr('cid');
            var ct = $(o).attr('ct');
            if(v > 0)
            {
                $.post("<?php echo url('game/auto');?>",{act:'changautomodel',gtype:<?php echo isset($act)?$act:"";?>,cid:cid,ct:ct,v:v},function(ret){
                    alert(ret.message);
                },'json');
            }
        }
        function changestat(t)
        {
            if(t == 0)
            {
                $("select[name='select']").each(function(){
                    $(this).attr('disabled','disabled');
                });
                $("input[name='txt']").each(function(){
                    $(this).attr('disabled','disabled');
                });
                $('#sSubmit').attr('ca','cancel');
                $('#sSubmit').html('取消自动投注');
            }
            else if(t == 1)
            {
                $("select[name='select']").each(function(){
                    $(this).removeAttr('disabled');
                });
                $("input[name='txt']").each(function(){
                    $(this).removeAttr('disabled');
                });
                $('#sSubmit').attr('ca','submit');
                $('#sSubmit').html('确定提交');
            }
        }
    </script>


</div>

</body>
</html>