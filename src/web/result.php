<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<script language="javascript" type="text/javascript"
	src="lib/jquery-1.11.3.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/t/dt/dt-1.10.11/datatables.min.css" />

<script type="text/javascript"
	src="https://cdn.datatables.net/t/dt/dt-1.10.11/datatables.min.js"></script>

<link rel="stylesheet" type="text/css"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

<script language="javascript" type="text/javascript"
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="lib/as.css" type="text/css">

<title>alternative splicing function prediction</title>

</head>

<body bgcolor="white">


	<div id="header">
		<img src="pic/iu.png" align='left' name="center_logo" width="90"
			height="90" id="Insert_logo" style="display: block;" /> <img
			src="pic/center_logo.png" width="96" height="95" align="right" "display:block;"/>

		<p align='center'>ExonImpact</p>
		<div id="header_txt" style="color: white">ExonImpact</div>
		<!-- end .header -->
	</div>


	<table id="event-desc">
		<tr>
			<td>Skipped Exon</td>
			<td>A5SS</td>
			<td>A3SS</td>
			<td>Retained intron</td>
		</tr>
		<tr>

			<td width="250px"><img src="pic/SE_icon.png"></td>
			<td width="250px"><img src="pic/A5SS_icon.png"></td>
			<td width="250px"><img src="pic/A3SS_icon.png"></td>
			<td width="250px"><img src="pic/RI_icon.png"></td>
		</tr>

	</table>
	</br>
	</br>

	<table id="example" class="display" cellspacing="0">
		<thead>
			<tr>

				<th></th>
				<th>transcript_id</th>
				<th>raw_input</th>
				<th>disease_probability</th>
				<th>phylop</th>
				<th>ss_1</th>
				<th>ss_2</th>
				<th>ss_3</th>
				<th>ss_4</th>
				<th>ss_5</th>
				<th>ss_6</th>
				<th>ss_7</th>
				<th>ss_8</th>
				<th>ss_9</th>
				<th>ss_10</th>
				<th>ss_11</th>
				<th>ss_12</th>
				<th>asa_1</th>
				<th>asa_2</th>
				<th>asa_3</th>
				<th>disorder_1</th>
				<th>disorder_2</th>
				<th>disorder_3</th>
				<th>disorder_4</th>
				<th>disorder_5</th>
				<th>disorder_6</th>
				<th>disorder_7</th>
				<th>disorder_8</th>
				<th>disorder_9</th>
				<th>disorder_10</th>
				<th>disorder_11</th>
				<th>disorder_12</th>
				<th>pfam1</th>
				<th>pfam2</th>
				<th>ptm</th>
				<th>proteinLength</th>
			</tr>

		</thead>
		<tfoot>
			<tr>
				<th></th>
				<th>transcript_id</th>
				<th>raw_input</th>
				<th>disease_probability</th>
				<th>phylop</th>
				<th>ss_1</th>
				<th>ss_2</th>
				<th>ss_3</th>
				<th>ss_4</th>
				<th>ss_5</th>
				<th>ss_6</th>
				<th>ss_7</th>
				<th>ss_8</th>
				<th>ss_9</th>
				<th>ss_10</th>
				<th>ss_11</th>
				<th>ss_12</th>
				<th>asa_1</th>
				<th>asa_2</th>
				<th>asa_3</th>
				<th>disorder_1</th>
				<th>disorder_2</th>
				<th>disorder_3</th>
				<th>disorder_4</th>
				<th>disorder_5</th>
				<th>disorder_6</th>
				<th>disorder_7</th>
				<th>disorder_8</th>
				<th>disorder_9</th>
				<th>disorder_10</th>
				<th>disorder_11</th>
				<th>disorder_12</th>
				<th>pfam1</th>
				<th>pfam2</th>
				<th>ptm</th>
				<th>proteinLength</th>

			</tr>
		</tfoot>
	</table>

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


	$error=exec("/data2/www/ExonImpact2/jdk1.8.0_51/bin/java -jar Run.jar ".$query_file_name. " configuration.txt > error1_".$query_file_name." 2>&1",$output1 );

	//putenv("R_LIBS=C:\\Documents and Settings\\Administrator\\My Documents\\R\win-library\\3.2");
	//putenv("R_LIBS=/home/yunliu/R/x86_64-redhat-linux-gnu-library/3.2");
	putenv("R_LIBS=/home/yunliu/R/x86_64-redhat-linux-gnu-library/3.2");
	//$error=exec("");
	//$error=exec("/usr/bin/Rscript R/predict.r usr_input/".$query_file_name. " > error2_".$query_file_name." 2>&1",$output2);
	$error=exec("/usr/bin/Rscript R/predict.r usr_input/".$query_file_name. " > error2_".$query_file_name." 2>&1",$output2);

	echo "<div id=\"runPart\">";

	print($error);
	print_r($output1);
	print_r($output2);

	//echo $error;

	echo "<p id=\"query_file_name\">".$query_file_name."</p>";

	echo "</div>";


?>

	<a id="feature_label" data-toggle="collapse" data-target="#feature">Click
		to see feature symbols meaning</a>

	<div id="feature" class="collapse">
		<pre>
</br>ss_1                     max probability of all amino acids' most probable structure in translated amino acid sequence.
</br>ss_2                     min probability of all amino acids' most probable structure in translated amino acid sequence.
</br>ss_3                     average probability of all amino acids' most probable structure in translated amino acid sequence
</br>ss_4                     average probability of the amino acid in beta sheet structure.
</br>ss_5                     min probability of the amino acid in beta sheet structure.
</br>ss_6                     max probability of the amino acid in beta sheet structure.
</br>ss_7                     average  probability of the amino acid in coil.
</br>ss_8                     min  probability of the amino acid in coil.
</br>ss_9                     max  probability of the amino acid in coil
</br>ss_10                    ave probability of the amino acid in alpha-helix structure.
</br>ss_11                    min probability of the amino acid in alpha-helix structure.
</br>ss_12                    max probability of the amino acid in alpha-helix structure.

</br>asa_1                    average ASA in translated amino acid sequence.
</br>asa_2                    min ASA in translated amino acid sequence.
</br>asa_3                    max ASA in translated amino acid sequence.

</br>disorder_score_1         min disorder score in exons' translated amino acid sequence.
</br>disorder_score_2         max disorder score in exons' translated amino acid sequence.
</br>disorder_score_3         average score of disorder region.
</br>disorder_score_4         average score of structured region.
</br>disorder_score_5         times of switch between disorder region and structured region.
</br>disorder_score_6         average disorder region length.
</br>disorder_score_7         average structured region length.
</br>disorder_score_8         max disorder region length.
</br>disorder_score_9         min disorder region length.
</br>disorder_score_10        max structured region length.
</br>disorder_score_11        min structured region length.
</br>disorder_score_12        average disorder score of the exon.

</br>plylop                   average phylop score of the exon.
</br>pfam1                    domain coverage percentile of the exon.
</br>pfam2                    overlap percentile with domain.
</br>ptm                      normalized number of PTM sites in the exon.
</pre>
	</div>



	<div id="runPart">
	</div>

	<!-- the title
<h2>Alternative splicing browser<a id="help" href="http://191.101.1.231/browserhome/help.html">help</a></h2>




part-->
<hr></hr>

<script type="text/javascript">





</script>

	<img src="lib/xx.jpg" name="leftPanelButton" width="20" height="20"
		border="0" alt="javascript button" onClick="return leftPanelExpand();"
		onMouseEnter="return leftPanelButtonOver();">expand the left
		control panel Control: drag and scroll


		<div id="leftPanelControl" onMouseLeave="return leftPanelButtonOut();">


			<input type="checkbox" name="GenePart" value="GenePart" checked=true
				onchange="checkBox(this)">gene <input type="checkbox"
				name="proteinPart" value="proteinPart" checked=true
				onchange="checkBox(this)">protein <input type="checkbox"
					name="transcriptPart" value="transcriptPart" checked=true
					onchange="checkBox(this)">transcripts <br />go to a
						coordinate position <input type="text" name="coordinate position"
						id="coordiantePosition" value=""> <input type="button"
							name="go" id="gotoposition" value="Go"> 
							<a id="download_xml" href=''>Download the XML datafile.</a> <a href=''>
							<a id="download_tsv" href=''>Download prediction result file.</a>
							<a id="download_csv" href=''>Download raw feature file.</a>
							
									 <br> <br>
		</div>
		<p></p>


		<div id="mainPage">
			<p></p>
			<hr></hr>
			<hr></hr>
			<p class="modualTitle">Exons Structure</p>
			<br> <br>

					<div id="geneVisualModule">
						<canvas id="geneVisual" width="900" height="200" tabindex='1'>
					</div>

					<p></p>
					<hr></hr>
					<hr></hr>
					<p class="modualTitle">Protein Fucntions</p> <br>
						<div id="proteinVisualModule1">
							<canvas id="proteinVisual1" width="900" height="200" tabindex='2'>
						</div>

						<p></p>
						<hr></hr>
						<hr></hr>
						<p class="modualTitle">Gene Structure</p> <br> <br>
								<div id="transcriptsVisualModule">
									<canvas id="transcriptsVisual" width="900" height="150"
										tabindex='3'>
								</div>
		</div>

		<hr></hr>


<script type="text/javascript" src="lib/ASPlot.js"></script>


<script type="text/javascript">

document.getElementById("feature_label").style.cursor="pointer";

var textareas = document.getElementsByTagName('textarea');
var count = textareas.length;
for(var i=0;i<count;i++){
    textareas[i].onkeydown = function(e){
        if(e.keyCode==9 || e.which==9){
            e.preventDefault();
            var s = this.selectionStart;
            this.value = this.value.substring(0,this.selectionStart) + "\t" + this.value.substring(this.selectionEnd);
            this.selectionEnd = s+1;
        }
    }
}

var query_file_name=document.getElementById('query_file_name').innerHTML;

document.getElementById('download_tsv').setAttribute("href","usr_input/"+query_file_name+".predict.tsv" );
document.getElementById('download_csv').setAttribute("href","usr_input/"+query_file_name+"" );

$(document).ready(function() {
var selected = [];

    $('#example').DataTable( {

        "processing": true,
        "serverSide": true,
        //"ajax": '/ExonImpact/'+query_file_name+'/'+query_file_name+'.predict.json.tsv',
        "ajax": 'usr_input/'+query_file_name+'.predict.json.tsv',

		"columns": [
			{"className": 'details-control',
				"orderable":      false,
                "data":           "                   ",
                "defaultContent": '                   '},

			{ "data": "transcript_id" },
			{ "data": "raw_input" },
			{ "data": "disease_probability" },
            { "data": "phylop" },
            { "data": "ss_1" },
			{ "data": "ss_2" },
			{ "data": "ss_3" },
            { "data": "ss_4" },
            { "data": "ss_5" },
			{ "data": "ss_6" },
			{ "data": "ss_7" },
            { "data": "ss_8" },
            { "data": "ss_9" },
			{ "data": "ss_10" },
			{ "data": "ss_11" },
			{ "data": "ss_12" },
            { "data": "asa_1" },
            { "data": "asa_2" },
			{ "data": "asa_3" },
			{ "data": "disorder_1" },
			{ "data": "disorder_2" },
            { "data": "disorder_3" },
            { "data": "disorder_4" },
			{ "data": "disorder_5" },
			{ "data": "disorder_6" },
			{ "data": "disorder_7" },
            { "data": "disorder_8" },
            { "data": "disorder_9" },
			{ "data": "disorder_10" },
			{ "data": "disorder_11" },
			{ "data": "disorder_12" },
            { "data": "pfam1" },
            { "data": "pfam2" },
            { "data": "ptm" },
            { "data": "proteinLength" }

            ],
			
	"scrollX": true
	} );
	
	var table = $('#example').DataTable();

    $('#example tbody').on('click', 'tr', function () {
		
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }
        else {
            table.$('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
		
        var index=table.row('.selected').index();
		
		var raw_input = table.row( index ).data()["raw_input"];
		var transcript_id = table.row( index ).data()["transcript_id"];

		var output_file_name="event_"+Math.random().toString(36).substr(2, 5);
		
		document.getElementById('download_xml').setAttribute("href","usr_xml/"+output_file_name+".xml");

		$.ajax({ url: 'gen_xml.php',
			data: {raw_input: raw_input,file_name:output_file_name,transcript_id:transcript_id},
			type: 'post',
			success: function(output) {
				//alert(output);
				console.log("generate xml file is: "+output);
				browser_init("usr_xml/"+output);

				},
				async:true
		});
		
    });
	
} );


//var table = $('#example').DataTable();

</script>

</body>
</html>
