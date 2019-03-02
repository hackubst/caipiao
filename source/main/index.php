<?php
error_reporting(E_ALL ^ E_NOTICE);
include_once("inc/function.php");

// if(is_mobile() && !$_GET['pc']) {
// 	header('location:mobile.php?c=index&a=index');
// }else{ 
// 	header('location:pcindex.php?tj='.$_GET['tj'].'&referer='.$_GET['referer']);
// }
header('location:pcnull.html');

exit;


