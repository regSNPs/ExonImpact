<?php

$cur_time=time();

$query_file_name="query".$cur_time;

if(isset($_POST['data_file'])){
$queryfile = fopen($query_file_name, "w") or die("Unable to open file!");
fwrite($queryfile, file_get_contents($_POST['data_file']) );
fclose($queryfile);

}

if(isset($_POST['data_textbox'])){

$queryfile = fopen($query_file_name, "w") or die("Unable to open file!");
fwrite($queryfile, $_POST['data_textbox']);
fclose($queryfile);
}

//echo "query result\n";

$error=system("sh code/run.sh ".$query_file_name." ".$query_file_name." >error 2>&1");

readfile('part1.html');

echo "<a href=\"/data2/www/ExonImpact/".$query_file_name."/".$query_file_name.".predict.tsv\">Click to download your prediction result</a>";

echo "<p id=\"query_file_name\" style=\"display:none\">".$query_file_name."</p>";

readfile('part2.html');

?>
