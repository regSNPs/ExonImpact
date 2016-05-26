<?php

$raw_input=$_POST['raw_input'];
$file_name=$_POST['file_name'];
$transcript_id=$_POST['transcript_id'];

$error=exec("/data2/www/ExonImpact2/jdk1.8.0_51/bin/java -cp \"Run.jar:lib_jar/*\" ccbb.hrbeu.exonimpact.test.Gen_xml ".$raw_input." ".$transcript_id." ".$file_name." >error3_".$file_name." 2>&1");

//print_r("java -jar Gen_xml.jar ".$raw_input." ".$transcript_id." ".$file_name." >error3_".$file_name." 2>&1");
//echo $error;
//print_r($raw_input);
//print_r($file_name);
echo $file_name;


?>
