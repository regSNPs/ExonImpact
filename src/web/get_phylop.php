<?php

$raw_input=$_POST['input'];

$error=exec("/data2/www/ExonImpact2/jdk1.8.0_51/bin/java -cp \"Run.jar:lib_jar/*\" ccbb.hrbeu.exonimpact.sequencefeaturewrapper.Extractor_phylop ".$raw_input);

echo $raw_input;
echo $error;

?>
