<?php
    
	$sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
	socket_bind($socket, '127.0.0.1', 8889+2);
	

	$msg = "/Users/mengli/Documents/splicingSNP_new/data/build_db/test_for_correctness/test_1.txt";
	$len = strlen($msg);

 	socket_sendto($sock, $msg, $len, 0, '127.0.0.1', 8787);
	
	$buf="ID";

	$from = '127.0.0.1';
	$port = 8889;
	$r = socket_recvfrom($sock, $buf, 512, 0, $from, $port);
	echo "the recieve message is:".$buf;
	socket_close($sock);
	

?>
	
