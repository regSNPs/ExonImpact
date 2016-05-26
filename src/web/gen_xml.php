<?php

$raw_input=$_POST['raw_input'];
$file_name=$_POST['file_name'];
$transcript_id=$_POST['transcript_id'];

$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
//socket_bind($sock, '127.0.0.1', 8889+2);


$msg = $raw_input."$".$transcript_id."$".$file_name;
$len = strlen($msg);

socket_sendto($sock, $msg, $len, 0, '127.0.0.1', 8889);


$buf="ID";
$from = '127.0.0.1';
$port = 8889;
$r = socket_recvfrom($sock, $buf, 512, 0, $from, $port);
#echo "the recieve message is:".$buf;

socket_close($sock);
echo $file_name;

?>
