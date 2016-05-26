// package name
var ASPlot={};

ASPlot.Utility=function(){

}

ASPlot.Utility.prototype.plotStrand=function(context,leftWidth,canvasWidth,height,name,strand){
	//context.beginPath();
	
	if(leftWidth!=0){
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}
	
	/*
	context.moveTo(leftWidth,height);
	context.lineTo(canvasWidth,height);
	
	var pos=leftWidth;
	if(strand=="POSITIVE")
		for(pos;pos<canvasWidth;){
			context.moveTo(pos,height-10);
			context.lineTo(pos+10,height);
		
			context.moveTo(pos,height+10);
			context.lineTo(pos+10,height);
		
			pos+=40;
		}
		
	else{
	
		for(pos;pos<canvasWidth;){
			context.moveTo(pos+10,height-10);
			context.lineTo(pos,height);
		
			context.moveTo(pos+10,height+10);
			context.lineTo(pos,height);
		
			pos+=50;
		}
		
		
	}
	*/
	
	context.fillText(strand,(canvasWidth)/2.0,height+15);
	
	
	
}

ASPlot.Utility.prototype.continuousValuePlot=function(context,disValue,regionBegPos,regionEndPos,unitWidth,height,leftWidth,name){


	context.fillStyle  = '#000000';

	//console.log(height);

   	context.fillStyle = "#000000";
   	context.font = "10px monospace";

	if(leftWidth!=0){
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}

	for(var j=0;j<disValue.length;++j){

		disValue[j]=parseFloat(disValue[j]);

		if (j+1<regionBegPos) {
			//code
			continue;
		}

		if (j+1>regionEndPos) {
			//code
			continue;
		}

		//console.log(disValue[j]);

		context.fillRect(leftWidth+(1+j-(regionBegPos))*unitWidth,height+15*(1-disValue[j]),14,disValue[j]*15);

		//if(j%5==0)
		//	context.fillText(disValue[j],leftWidth+(1+j-(regionBegPos))*unitWidth,height+15*(1-disValue[j]));
	}
}

ASPlot.Utility.prototype.alphabetPlot=function(context,sequence,regionBegPos,regionEndPos,unitWidth,height,leftWidth,name){

	/*
	if (nucliedWidth<6) {
		//code
		context.font = leftPanelFontWidth+"px monospace";
		if (strand=="+")
			context.fillText("5'", 0, tracksHeight);
		//tracksHeight=tracksHeight+15;
		if (strand=="-")
			context.fillText("3'",0,tracksHeight);

		return;
	}
	*/
	//context.fillStyle = "black";
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}

   	context.fillStyle = "#000000";
   	context.font = "10px monospace";


	//context.fillStyle   = '#0000ff'; // blue

	context.font = 200/114*unitWidth+"px monospace";
	//var drawSeq=seq.substring(seqPlotPos,seq.length);

	//context.font = leftPanelFontWidth+"px monospace";
	//context.fillText("5'", 0, height);
	//context.font = 2*unitWidth+"px monospace";

	var col=0;
	for(var i=0;i<regionEndPos-regionBegPos;++i){

		if(i>sequence.length-1)
			break;
		context.fillText(sequence[i],leftWidth+col, height+15);
		col+=unitWidth;

	}


}

ASPlot.Utility.prototype.alphabetPlotColorTable=function(context,sequence,regionBegPos,regionEndPos,unitWidth,height,leftWidth,name){

	/*
	if (nucliedWidth<6) {
		//code
		context.font = leftPanelFontWidth+"px monospace";
		if (strand=="+")
			context.fillText("5'", 0, tracksHeight);
		//tracksHeight=tracksHeight+15;
		if (strand=="-")
			context.fillText("3'",0,tracksHeight);

		return;
	}
	*/
	//context.fillStyle = "black";
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}

   	context.fillStyle = "#000000";
   	context.font = "10px monospace";


	//context.fillStyle   = '#0000ff'; // blue

	context.font = 200/114*unitWidth+"px monospace";
	//var drawSeq=seq.substring(seqPlotPos,seq.length);

	//context.font = leftPanelFontWidth+"px monospace";
	//context.fillText("5'", 0, height);
	//context.font = 2*unitWidth+"px monospace";

	var col=0;
	for(var i=0;i<regionEndPos-regionBegPos;++i){

		if(i>sequence.length-1)
			break;


		if(sequence[i]=='b')
		   	context.fillStyle = "#FA8072";
		else if(sequence[i]=='n')
		   	context.fillStyle = "#8470FF";
		else if(sequence[i]=='g')
		   	context.fillStyle = "#DAA520";
		else if(sequence[i]=='p')
			context.fillStyle = "#98FB98";
		else if(sequence[i]=='a')
			context.fillStyle = "#00FFFF";
		else
			context.fillStyle = "#ffffff";

		//context.fillRect(leftWidth+col,height-23,unitWidth,28);
		context.fillRect(leftWidth+col,height,unitWidth,28);

		context.fillStyle = "#000000";
		context.fillText(sequence[i],leftWidth+col, height+22);


		col+=unitWidth;

	}


}

ASPlot.Utility.prototype.coordinatePlotAS=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){

	//code
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}
   	context.fillStyle = "#000000";
   	context.strokeStyle = '#000000'; // black
   	context.lineWidth   = 2;

   	context.font = "10px monospace";
   	//context.beginPath();
   	//context.moveTo(0,0);
   	//context.lineTo(200,100);
   	//context.stroke();

	//context.fill();

	var beginPos=regionBegPos;
	var endPos=regionEndPos;
	//var change=(Math.round(beginPos/(100.0/unitWidth)+0.5))*(100.0/unitWidth)-beginPos;
	//
	//var change=(Math.round(beginPos/(100.0/unitWidth)))*(100.0/unitWidth)-beginPos;
	var change=0;
	
	var coordinateWidth=100;
	if(unitWidth>=5){
		coordinateWidth=100-100%unitWidth;
		console.log(coordinateWidth+" "+unitWidth);
		
			
	}
	
	//var coorPos=0;

	
	for(var coorPos=0;coorPos<Math.round(endPos-beginPos);){
		var asLengthSum=0;
		//context.beginPath();
		context.moveTo(leftWidth+(coorPos+change)*unitWidth,height+5);
		context.lineTo(leftWidth+(coorPos+change)*unitWidth,height+15);
		//context.closePath();

		var size = parseInt(context.measureText(Math.round(beginPos+coorPos+change)).width);
		//console.log(parseFloat(leftWidth+Math.round(coorPos+change)*unitWidth+100+size));
		//console.log(parseFloat(cavanseWidth));
		//console.log(Math.round(beginPos+coorPos+change));
		
		
		//console.log((leftWidth+Math.round(coorPos+change)*unitWidth+size-cavanseWidth));
		
		if(leftWidth+Math.round(coorPos+change)*unitWidth+parseFloat(size)-cavanseWidth>0){
			break;
			
		}
		var coorText=Math.round(beginPos+coorPos+change);
		for(var i=0;i<blocks.length;++i){
			if(coorText<blocks[i].begPos){
				break;	
			}
			else if(coorText>blocks[i].endPos)			
			{
				asLengthSum+=blocks[i].endPos-blocks[i].begPos;
			}
			else{
				asLengthSum+=coorText-blocks[i].begPos;			
			}
		
		}
		
		coorText+="("+(coorText-parseInt(asLengthSum))+")";
		
		context.fillText(coorText,leftWidth+Math.round(coorPos+change)*unitWidth,height);
		coorPos=coorPos+coordinateWidth/unitWidth;
		
		
	}

	context.moveTo(leftWidth+0,height+15);
	context.lineTo(cavanseWidth,height+15);

	//tracksHeight+=30;


}

ASPlot.Utility.prototype.coordinatePlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){

	//code
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}
   	context.fillStyle = "#000000";
   	context.strokeStyle = '#000000'; // black
   	context.lineWidth   = 2;

   	context.font = "10px monospace";
   	//context.beginPath();
   	//context.moveTo(0,0);
   	//context.lineTo(200,100);
   	//context.stroke();

	//context.fill();

	var beginPos=regionBegPos;
	var endPos=regionEndPos;
	
	var coordinateWidth=100;
	if(unitWidth>=5){
		coordinateWidth=100-100%unitWidth;
		console.log(coordinateWidth+" "+unitWidth);
		
			
	}
	
	
	
	//var change=(Math.round(beginPos/(100.0/unitWidth)+0.5))*(100.0/unitWidth)-beginPos;
	//
	//var change=(Math.round(beginPos/(100.0/unitWidth)))*(100.0/unitWidth)-beginPos;
	var change=0;

	//var coorPos=0;

	for(var coorPos=0;coorPos<Math.round(endPos-beginPos);){

		//context.beginPath();
		context.moveTo(leftWidth+(coorPos+change)*unitWidth,height+5);
		context.lineTo(leftWidth+(coorPos+change)*unitWidth,height+15);
		//context.closePath();

		var size = parseInt(context.measureText(Math.round(beginPos+coorPos+change)).width);
		//console.log(parseFloat(leftWidth+Math.round(coorPos+change)*unitWidth+100+size));
		//console.log(parseFloat(cavanseWidth));
		//console.log(Math.round(beginPos+coorPos+change));
		
		
		//console.log((leftWidth+Math.round(coorPos+change)*unitWidth+size-cavanseWidth));
		
		if(leftWidth+Math.round(coorPos+change)*unitWidth+parseFloat(size)-cavanseWidth>0){
			break;
			
		}
		
		context.fillText(Math.round(beginPos+coorPos+change),leftWidth+Math.round(coorPos+change)*unitWidth,height);
		coorPos=coorPos+coordinateWidth/unitWidth;
		
		
	}

	context.moveTo(leftWidth+0,height+15);
	context.lineTo(cavanseWidth,height+15);

	//tracksHeight+=30;


}

ASPlot.Utility.prototype.pointPlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){
	var leftHeight=height;
   	context.fillStyle = "#000000";
   	context.font = "12px monospace";
	
	if(typeof(color) == 'undefined' || color == null)
		color='#800000';
	
	if(typeof(height) == 'undefined' || height == null)
		rowHeight=40;

	context.fillStyle  = color;
	var numberOfRowInThisRegion=0;
	var maxNumberOfRowInThisRegion
	var lastBegPos=-1;

	for(var block in blocks){

		var boxBegPos=(blocks[block].begPos);
		if(boxBegPos>regionEndPos)
			continue;

		var begPos=boxBegPos>regionBegPos?boxBegPos:regionBegPos;

		if(lastBegPos!=-1&&(begPos-lastBegPos)*unitWidth<50 ){
			height=height+rowHeight;
			numberOfRowInThisRegion++;
			
			if(numberOfRowInThisRegion>maxNumberOfRowInThisRegion){
				maxNumberOfRowInThisRegion=numberOfRowInThisRegion;
			}
			
			console.log("The threshold pixel is: "+( (begPos-lastBegPos)*unitWidth) );
			
		}else{
			numberOfRowInThisRegion=0;
			height=leftHeight;
		}
		
		var endPos=(blocks[block].begPos);

		if(endPos<regionBegPos)
			continue;

		var len=endPos-begPos+1;

		context.fillStyle  = color;
		context.fillRect(leftWidth+ (begPos-regionBegPos)*unitWidth,height,len*unitWidth,rowHeight );

		var des=blocks[block].description;

		context.fillStyle = "#000000";
		context.fillText(des,leftWidth+(begPos-regionBegPos)*unitWidth,height+rowHeight-4);



		if(leftWidth!=0){
   			context.fillStyle = "#000000";
			context.font = "13px monospace";
			context.fillText(name,0,leftHeight+15);
		}
		
		lastBegPos=begPos;
		//numberOfRowInThisRegion=1;
	}

	return (maxNumberOfRowInThisRegion==0?1:maxNumberOfRowInThisRegion)*(rowHeight+10);

}

//This function is used to plot blocks with pipe each other.
ASPlot.Utility.prototype.blocksPlotPipeLine=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){
	//    context.fillStyle   = '#aa66aa';


	var leftHeight=height;
   	context.fillStyle = "#000000";
   	context.font = "12px monospace";
	
	if(typeof(color) == 'undefined' || color == null)
		color='#800000';
	
	if(typeof(height) == 'undefined' || height == null)
		rowHeight=40;

	context.fillStyle  = color;
	var numberOfRowInThisRegion=0;

	for(var block in blocks){

		var boxBegPos=(blocks[block].begPos);
		if(boxBegPos>regionEndPos)
			continue;

		var begPos=boxBegPos>regionBegPos?boxBegPos:regionBegPos;

		var endPos=(blocks[block].endPos);

		if(endPos<regionBegPos)
			continue;

		var len=endPos-begPos+1;

		context.fillStyle  = color;
		context.fillRect(leftWidth+ (begPos-regionBegPos)*unitWidth,height,len*unitWidth,rowHeight );

		var des=blocks[block].description;

		context.fillStyle = "#000000";
		context.fillText(des,leftWidth+(begPos-regionBegPos)*unitWidth,height+rowHeight-4);

		height=height+rowHeight;
		
		numberOfRowInThisRegion++;

	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,leftHeight+15);

	}
	
		//numberOfRowInThisRegion=1;
	}

	return numberOfRowInThisRegion*(rowHeight+10);

}


//This function is used to plot blocks.
ASPlot.Utility.prototype.blocksPlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){
	//    context.fillStyle   = '#aa66aa';
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}

	context.fillStyle="#000000";


	if(typeof(color) == 'undefined' || color == null)
		color='#800000';


	if(typeof(height) == 'undefined' || height == null)
		rowHeight=20;

	context.fillStyle  = color;

	for(var block in blocks){



		var boxBegPos=(blocks[block].begPos);
		if(boxBegPos>regionEndPos)
			continue;

		var begPos=boxBegPos>regionBegPos?boxBegPos:regionBegPos;

		var endPos=(blocks[block].endPos);

		if(endPos<regionBegPos)
			continue;

		var len=endPos-begPos+1;


		context.fillRect( leftWidth+ (begPos-regionBegPos)*unitWidth,height,len*unitWidth,rowHeight );


	}

}

ASPlot.Utility.prototype.blocksPlotWithLine=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color){
	//    context.fillStyle   = '#aa66aa';


	if(typeof(color) == 'undefined' || color == null)
		color='#800000';


	if(typeof(height) == 'undefined' || height == null)
		rowHeight=20;

	context.fillStyle  = color;
    	context.strokeStyle = '#000000'; // black
    	context.lineWidth   = 2;

	var begPos=-1,endPos=-1,len=-1;
	for(var block in blocks){

		var boxBegPos=(blocks[block].begPos);


		var begPos=boxBegPos>regionBegPos?boxBegPos:regionBegPos;

		var endPos=endPos<regionBegPos?regionBegPos:endPos;


		context.moveTo((endPos-regionBegPos)*unitWidth,height+rowHeight/2);
	        context.lineTo((endPos-regionBegPos+(begPos-endPos)/2)*unitWidth,height);

		context.moveTo((endPos-regionBegPos+(begPos-endPos)/2)*unitWidth,height);
	        context.lineTo((begPos-regionBegPos)*unitWidth,height+rowHeight/2);

		//context.fillRect((endPos-regionBegPos)*unitWidth,height+rowHeight/2,len*unitWidth,2 );

		//endPos=(blocks[block].endPos);
		var endPos=(blocks[block].endPos);

		if(boxBegPos>regionEndPos)
			continue;

		if(endPos<regionBegPos)
			continue;

		var len=endPos-begPos+1;

		//len=endPos-begPos;

		context.fillRect( (begPos-regionBegPos)*unitWidth,height,len*unitWidth,rowHeight );


	}

}

ASPlot.Utility.prototype.blocksPlotWithLineAS=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){
	//    context.fillStyle   = '#aa66aa';
	if(leftWidth!=0){
   		context.fillStyle = "#000000";
		context.font = "13px monospace";
		context.fillText(name,0,height+15);

	}

	context.fillStyle = "#000000";
   	context.font = "10px monospace";


	if(typeof(color) == 'undefined' || color == null)
		color='#800000';


	if(typeof(height) == 'undefined' || height == null)
		rowHeight=20;


	var begPos=-1,endPos=-1,len=-1;
    	context.strokeStyle = '#000000'; // black
    	context.lineWidth   = 2;

	for(var block in blocks){
		context.fillStyle  = color;
		var ifAS=blocks[block].ifAS;

		var boxBegPos=(blocks[block].begPos);


		var begPos=boxBegPos>regionBegPos?boxBegPos:regionBegPos;

		var endPos=endPos<regionBegPos?regionBegPos:endPos;

		if(block!=0){
			//alert(begPos);
			//alert(regionBegPos);
			//alert(endPos-regionBegPos+1);
			//alert(begPos-endPos);
			//if(endPos-regionBegPos+1<(cavanseWidth-leftWidth)/unitWidth){
			if(leftWidth+(endPos-regionBegPos+1)*unitWidth<cavanseWidth){
				context.moveTo(leftWidth+(endPos-regionBegPos+1)*unitWidth,height+rowHeight/2);
				
				if(leftWidth+(endPos-regionBegPos+(begPos-endPos)/2)*unitWidth>cavanseWidth)
		context.lineTo(cavanseWidth,height);					
				else
		context.lineTo(leftWidth+(endPos-regionBegPos+(begPos-endPos)/2)*unitWidth,height);					

			}
			
			//if(endPos-regionBegPos+(begPos-endPos)/2<(cavanseWidth-leftWidth)/unitWidth){
			if(leftWidth+(endPos-regionBegPos+(begPos-endPos)/2)*unitWidth<cavanseWidth){
				
				context.moveTo(leftWidth+(endPos-regionBegPos+(begPos-endPos)/2)*unitWidth,height);
				
				if(leftWidth+(begPos-regionBegPos)*unitWidth>cavanseWidth)
					context.lineTo(cavanseWidth,height+rowHeight/2);
				else
					context.lineTo(leftWidth+(begPos-regionBegPos)*unitWidth,height+rowHeight/2);
			}
			
		}

		//context.fillRect((endPos-regionBegPos)*unitWidth,height+rowHeight/2,len*unitWidth,2 );

		//endPos=(blocks[block].endPos);
		var endPos=(blocks[block].endPos);

		if(boxBegPos>regionEndPos)
			continue;

		if(endPos<regionBegPos)
			continue;

		var len=(endPos-begPos+1);



		if(ifAS)
			context.fillStyle  = '#FA8072';
		else
			context.fillStyle  = '#800000';
		context.fillRect(leftWidth+ (begPos-regionBegPos)*unitWidth,height,len*unitWidth,rowHeight );


	}

}

//ASPlot.Utility.prototype.alphabetPlot=function(sequence,regionBegPos,regionEndPos,unitWidth,height){
//ASPlot.Utility.prototype.coordinatePlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color){
ASPlot.visualPage=function(xml){
	if(typeof(xml) == 'undefined' || xml == null||xml=="")
		return;

	var xmlParser=new ASPlot.xmlParser();
	this.plotEngine=new ASPlot.Utility();
	this.xml=xmlParser.parseXML(xml);

	this.genePlot=new ASPlot.GenePlot(xmlParser,this.plotEngine);

	this.isoforms=xmlParser.parseIsoforms();
	//var isoform=this.isoforms[0];

	var plotLeft=true;
	this.leftFont="10px monospace";

	//alert(isoform.proteinSequence);
	if(this.isoforms[0]!=null)
		this.proteinPlot1=new ASPlot.ProteinPlot("proteinVisual1",this.isoforms[0],this.isoforms[1],xmlParser,this.plotEngine,false);
	//if(this.)

	this.transcriptPlot=new ASPlot.transcriptPlot(xmlParser,this.plotEngine);

	//this.proteinPlot2=new ASPlot.ProteinPlot("proteinVisual2",this.isoforms[1],xmlParser,this.plotEngine,true);

}

ASPlot.visualPage.prototype.setIfPlotLeft=function(plotLeft){

	this.genePlot.plotLeft=plotLeft;
	this.proteinPlot1.plotLeft=plotLeft;
	//this.proteinPlot2.plotLeft=plotLeft;


}

ASPlot.ProteinPlot=function(canvasElement,isoform1,isoform2,xmlParser,plotEgnine,asOut){
	if(typeof(canvasElement) == 'undefined' || canvasElement == null||canvasElement=="")
		return;

	this.plotLeft=true;
	this.leftWidth=120;

	this.isoform1=isoform1;
	this.isoform2=isoform2;
	this.strand=xmlParser.getStrand();

	this.proteinLength=isoform1.proteinSequence.length;
	this.start=1;
	this.end=this.proteinLength;

	this.plotEngine=plotEgnine;
	this.canvasProtein=document.getElementById(canvasElement);
	this.contextProtein=this.canvasProtein.getContext("2d");
	this.canvasProteinWidth=this.canvasProtein.width;

	this.currentPosition=0;
	//this.unitwidth=-1;//nuclied width
	//this.unitwidth=10;//nuclied width
	this.x=-1;//current mouse x position
	this.y=-1;//current mouse y position
	this.mouseIsDown=false;
	this.moveWidth=10;
	this.coordinatePosition=-1;

	this.ifASOut=asOut;
	this.browserName=getBrowserName();
	this.unitWidth=11;
	this.maxUnitWidth=15;
	this.minUnitWidth=1;
	this.minFontWidth=7;

	this.imgData;
	this.moveLastX=-1;
	this.moveLastY=-1;

	this.geneStrucBlocks=xmlParser.parseTranscript();

	this.currentPosition=this.start;
	this.residue=0;

	var a=this;
	this.alternativeSplicingRegions=[];

	this.canvasProtein.addEventListener("mouseup", function(e){a.mouseUp(e)}, false);
	this.canvasProtein.addEventListener("mousedown", function(e){a.mouseDown(e)}, false);
	this.canvasProtein.addEventListener("mousemove", function(e){a.mouseMove(e)}, false);
	this.canvasProtein.addEventListener("keydown", function(e){a.keyDown(e)}, false);
	this.canvasProtein.addEventListener("mouseout", function(e){a.mouseOut(e)}, false);

	if(this.browserName=="Firefox"){
		this.canvasProtein.addEventListener("DOMMouseScroll", function(e){a.mouseWheel(e)}, false);
	}
	else{
		this.canvasProtein.addEventListener("mousewheel", function(e){a.mouseWheel(e)}, false);
	}

	//modify strand
	if(this.strand=="POSITIVE"){


	}else{
		this.geneStrucBlocks=this.geneStrucBlocks.reverse();

	}


	//modify isoform2

	this.canvasProtein.height='400';
	if(typeof(this.isoform2)=='undefined'||this.isofrom2!=null){
		this.canvasProtein.height='450';
		return null;

	}
	var currentPosition=0;
	var asProteinBegPos=-1;
	var asProteinEndPos=-1;


	for(var block=0;block<this.geneStrucBlocks.length;block++){

		var boxBegPos=this.geneStrucBlocks[block].begPos;
		var boxEndPos=this.geneStrucBlocks[block].endPos;
		var ifAS=this.geneStrucBlocks[block].ifAS;
		var boxLength=((boxEndPos-boxBegPos+1)/3);

		if(ifAS){
			if(asProteinBegPos!=-1&&asProteinEndPos!=currentPosition){
				asProteinEndPos=Math.floor(currentPosition+boxLength);


			}else{
				if(asProteinBegPos!=-1){

	this.alternativeSplicingRegions.push({begPos:asProteinBegPos,endPos:asProteinEndPos});

				}
				asProteinBegPos=Math.floor(currentPosition);
				asProteinEndPos=Math.floor(currentPosition+boxLength);



			}


		}

		currentPosition+=boxLength;

	}

	if(asProteinBegPos!=-1){

		this.alternativeSplicingRegions.push({begPos:asProteinBegPos,endPos:asProteinEndPos});

	}


	for(var asRegionIndex=0;asRegionIndex<this.alternativeSplicingRegions.length;++asRegionIndex){
		var begPos=this.alternativeSplicingRegions[asRegionIndex].begPos;
		var endPos=this.alternativeSplicingRegions[asRegionIndex].endPos;

		var length= Math.floor(endPos-begPos);

		//pfam

			var numberOfPfams=this.isoform2.pfams.length;
			for(var i=0;i<numberOfPfams;++i){
				var pfam=this.isoform2.pfams[i];

				var pfamBegPos=pfam.begPos;
				var pfamEndPos=pfam.endPos;
				if(pfamBegPos<begPos&&pfamEndPos>begPos){
					this.isoform2.pfams[i].endPos=begPos;

					pfamBegPos=endPos;
					pfamEndPos+=length;
					//console.log(pfam);
					//console.log(pfam.pfamDescription+"\t"+pfam.pfamFamily);

	this.isoform2.pfams.push({'begPos':pfamBegPos,'endPos':pfamEndPos,'description':(pfam.description),'pfamFamily':(pfam.pfamFamily)});


				}else{

					if(pfamBegPos>begPos){
						this.isoform2.pfams[i].begPos=pfamBegPos+length;

					}
					if(pfamEndPos>begPos){
						this.isoform2.pfams[i].endPos=pfamEndPos+length;
					}

				}

			}


		//disprot
		for(var i=0;i<length;++i){
			this.isoform2.disorderValue.splice(begPos,0,0.0);



		}
		//sequence
		this.start,isoform2.proteinSequence.substring(0,begPos);
		var prepareInsertStr="";
		for(var i=0;i<length;++i){
			prepareInsertStr+=" ";

		}
		
		//if(begPos>0)
		//	begPos=begPos-1;
			
		this.isoform2.polarity=this.isoform2.polarity.substring(0,begPos)+prepareInsertStr+this.isoform2.polarity.substring(begPos,this.isoform2.polarity.length);

		this.isoform2.charge=this.isoform2.charge.substring(0,begPos)+prepareInsertStr+this.isoform2.charge.substring(begPos,this.isoform2.charge.length);

		this.isoform2.proteinSequence=this.isoform2.proteinSequence.substring(0,begPos)+prepareInsertStr+this.isoform2.proteinSequence.substring(begPos,this.isoform2.proteinSequence.length);


	}


}


ASPlot.ProteinPlot.prototype.mouseDown=function(e){
	//alert('meng1');
	this.mouseIsDown=true;
	//this.x=(e.offsetX==undefined?e.layerX:e.offsetX);
	//this.y=(e.offsetY==undefined?e.layerY:e.offsetY);
	var position=getOffset(e);
	this.x=position.x;
	this.y=position.y;

}

ASPlot.ProteinPlot.prototype.mouseWheel=function(e){
   
	var delta=e.wheelDelta;
	if(this.browserName=="Firefox"){
		delta=e.detail;

	}
	var shiftDown = e.shiftKey;
	//if(!shiftDown)
	//	return;

        if (delta<0){
		this.unitWidth--;//zoom in
		if(this.unitWidth<this.minUnitWidth){
			this.unitWidth=this.minUnitWidth;
		}

        } else{
		//code
		this.unitWidth++;//zoom out
		if(this.unitWidth>this.maxUnitWidth){
			this.unitWidth=this.maxUnitWidth;
		}

        }
	var plotEndPos=this.end-Math.round((this.canvasProteinWidth-this.leftWidth)/this.unitWidth)+13;
	if(plotEndPos<0)
		plotEndPos=0;

	//alert(this.currentPosition);
	if (this.currentPosition>plotEndPos) {

		this.currentPosition=plotEndPos;
	}
	//alert(this.currentPosition);
	if (this.currentPosition<this.start) {
		//code
		this.currentPosition=this.start;
	}


	this.plot();

        event.preventDefault();
        event.returnValue=false;
}

ASPlot.ProteinPlot.prototype.mouseOut=function(e){
	this.mouseIsDown=false;
}

ASPlot.ProteinPlot.prototype.mouseUp=function(e){
	//alert('meng2');
	this.mouseIsDown=false;
}

ASPlot.ProteinPlot.prototype.mouseMove=function(e){
	//var curX=(e.offsetX==undefined?e.layerX:e.offsetX);
	//var curY=(e.offsetY==undefined?e.layerY:e.offsetY);
	var position=getOffset(e);
	var curX=position.x;
	var curY=position.y;


	if (this.mouseIsDown&&(Math.abs(curX-this.x)>this.moveWidth)) {
		//code
		//alert(Math.abs(curX-this.x));
		//alert(this.currentPosition);


		var offset=curX-this.x+this.residue;

		this.residue=offset%this.unitWidth;

		this.currentPosition=this.currentPosition+parseInt(-1*offset/this.unitWidth);

		var plotEndPos=this.end-Math.round((this.canvasProteinWidth-this.leftWidth)/this.unitWidth)+13;
		if(plotEndPos<0)
			plotEndPos=0;

		//alert(this.currentPosition);

		//alert(this.currentPosition);
		if (this.currentPosition>plotEndPos) {


			this.currentPosition=plotEndPos;
		}
		if (this.currentPosition<this.start) {
			//code
			this.currentPosition=this.start;
		}
		//alert(this.currentPosition);
		this.plot();

		this.x=curX;
		this.y=curY;
	}else{
		if(Math.abs(curX-this.moveLastX)>this.moveWidth/2||Math.abs(curY-this.moveLastY)>this.moveWidth/2){
			this.contextProtein.beginPath();
			this.contextProtein.strokeStyle = '#000000'; // black
		   	this.contextProtein.lineWidth= 2;


			//this.tmpContext=this.contextGene.save();
			this.contextProtein.putImageData(this.imgData,0,0);
			this.imgData=this.contextProtein.getImageData(0,0,this.canvasProtein.width, this.canvasProtein.height);

			this.contextProtein.moveTo(0,curY);
			this.contextProtein.lineTo(this.canvasProteinWidth,curY);

			this.contextProtein.moveTo(curX,0);
			this.contextProtein.lineTo(curX,this.canvasProtein.height);

			this.contextProtein.stroke();
			this.moveLastX=curX;
			this.moveLastY=curY;

			//this.tmpContext=this.contextGene.restore();

		}


	}


}

ASPlot.ProteinPlot.prototype.keyDown=function(e){

	//console.log(2);
	if(e.keyCode == 39){
		this.currentPosition+=1;

	}

	if(e.keyCode == 37){
		this.currentPosition+=-1;

	}

	var plotEndPos=this.end-Math.round((this.canvasProtein.width-this.leftWidth)/this.unitWidth)+13;
	if(plotEndPos<0)
		plotEndPos=0;

	//alert(this.currentPosition);

	//alert(this.currentPosition);
	if (this.currentPosition>plotEndPos) {

		this.currentPosition=plotEndPos;
	}

	if (this.currentPosition<this.start) {
		//code
		this.currentPosition=this.start;
	}

	this.plot();


}

ASPlot.ProteinPlot.prototype.plot=function(){
	this.contextProtein.beginPath();
	this.contextProtein.clearRect(0, 0, this.canvasProtein.width, this.canvasProtein.height);


	var hight=30;
	if(typeof(this.isoform2)!='undefined'&&this.isoform2!=null){
		hight+=this.disPlot(hight,this.isoform2);
		hight+=this.pfamPlot(hight,this.isoform2);
		hight+=this.plotAlphabet(hight,this.isoform2);
		//hight-=20;
		hight+=this.plotCharge(hight,this.isoform2);
		hight+=this.plotPolarity(hight,this.isoform2);
		//hight+=35;

		hight+=this.plotProteinBlocks(hight,true);//true indicate it is AS
	}

	this.coordinatePosition=hight;
	hight+=this.plotCoordinate(hight);
	
	hight+=this.plotProteinBlocks(hight,typeof(this.isoform2)=='undefined'?true:false);

	hight+=this.plotPolarity(hight,this.isoform1);
	hight+=this.plotCharge(hight,this.isoform1);

	hight+=this.plotAlphabet(hight,this.isoform1);
	hight+=this.pfamPlot(hight,this.isoform1);
	hight+=this.asaPlot(hight,this.isoform1);
	hight+=this.alpha_helixPlot(hight,this.isoform1);
	hight+=this.beta_sheetPlot(hight,this.isoform1);
	hight+=this.random_coilPlot(hight,this.isoform1);
	hight+=this.disPlot(hight,this.isoform1);
	hight+=this.ptmPlot(hight,this.isoform1);

	this.plotDecoration();
	this.contextProtein.stroke();

	this.imgData=this.contextProtein.getImageData(0,0,this.canvasProtein.width, this.canvasProtein.height);
}

ASPlot.ProteinPlot.prototype.plotDecoration=function(){

   	this.contextProtein.fillStyle = "#000000";
		if(typeof(this.isoform2)!='undefined'&&this.isoform2!=null){

		this.contextProtein.moveTo(this.leftWidth-20,15);
		this.contextProtein.lineTo(this.leftWidth-10,10);
		this.contextProtein.moveTo(this.leftWidth-10,10);
		this.contextProtein.lineTo(this.leftWidth,15);

		this.contextProtein.moveTo(this.leftWidth-10,10);
		this.contextProtein.lineTo(this.leftWidth-10,this.coordinatePosition-5);

		this.contextProtein.moveTo(this.leftWidth-20,this.coordinatePosition-10);
		this.contextProtein.lineTo(this.leftWidth-10,this.coordinatePosition-5);
		this.contextProtein.moveTo(this.leftWidth-10,this.coordinatePosition-5);
		this.contextProtein.lineTo(this.leftWidth,this.coordinatePosition-10);


		this.contextProtein.save();
		this.contextProtein.translate(0, 0);
		this.contextProtein.rotate(-Math.PI/2);
		//this.contextProtein.textAlign = "center";
		this.contextProtein.fillText("AS isoform",10-this.coordinatePosition, this.leftWidth-25);

		//this.contextProtein.translate(0, 0);
		//this.contextProtein.rotate(-Math.PI/2);
		//this.contextProtein.textAlign = "center";
		this.contextProtein.fillText("Canonical isoform",100-this.canvasProtein.height, this.leftWidth-20);

		this.contextProtein.restore();
	}

	//second
	this.contextProtein.moveTo(this.leftWidth-20,this.coordinatePosition+30);
	this.contextProtein.lineTo(this.leftWidth-10,this.coordinatePosition+20);
	this.contextProtein.moveTo(this.leftWidth-10,this.coordinatePosition+20);
	this.contextProtein.lineTo(this.leftWidth,this.coordinatePosition+30);

	this.contextProtein.moveTo(this.leftWidth-10,this.coordinatePosition+20);
	this.contextProtein.lineTo(this.leftWidth-10,this.canvasProtein.height-10);

	this.contextProtein.moveTo(this.leftWidth-20,this.canvasProtein.height-15);
	this.contextProtein.lineTo(this.leftWidth-10,this.canvasProtein.height-10);
	this.contextProtein.moveTo(this.leftWidth-10,this.canvasProtein.height-10);
	this.contextProtein.lineTo(this.leftWidth,this.canvasProtein.height-15);
	
	
}

ASPlot.ProteinPlot.prototype.plotAlphabet=function(hight,isoform){
	//alert(this.start);
	//alert(this.currentPosition);
	if(this.unitWidth<this.minFontWidth)
		return 0;


	var drawSeq=isoform.proteinSequence.substring(this.currentPosition-this.start,isoform.proteinSequence.length);

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	this.plotEngine.alphabetPlot(this.contextProtein,drawSeq,this.currentPosition,coordinateEndPosition,this.unitWidth,hight,this.leftWidth,"amino acid");

	return 35;
}


ASPlot.ProteinPlot.prototype.plotPolarity=function(hight,isoform){
	if(this.unitWidth<this.minFontWidth)
		return 0;

	var drawPolarity=isoform.polarity.substring(this.currentPosition-this.start,isoform.polarity.length);
	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	this.plotEngine.alphabetPlotColorTable(this.contextProtein,drawPolarity,this.currentPosition,coordinateEndPosition,this.unitWidth,hight,this.leftWidth,"polarity");

	return 35;

}

ASPlot.ProteinPlot.prototype.plotCharge=function(hight,isoform){
	if(this.unitWidth<this.minFontWidth)
		return 0;

	var drawCharge=isoform.charge.substring(this.currentPosition-this.start,isoform.charge.length);
	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	this.plotEngine.alphabetPlotColorTable(this.contextProtein,drawCharge,this.currentPosition,coordinateEndPosition,this.unitWidth,hight,this.leftWidth,"charge");
	return 35;
}

ASPlot.ProteinPlot.prototype.plotCoordinate=function(hight){

//ASPlot.Utility.prototype.coordinatePlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color){
	//var unitWidth=this.canvasGeneWidth/(this.start-this.end+1);
	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;
	
	
	//this.alternativeSplicingRegions.push({begPos:asProteinBegPos
	
	this.plotEngine.coordinatePlotAS(this.contextProtein,this.alternativeSplicingRegions,this.currentPosition,coordinateEndPosition,this.canvasProteinWidth,50,this.unitWidth,hight,'#aa66aa',this.leftWidth,"coordinate");

	//this.plotEngine.coordinatePlot(this.contextProtein,this.data,this.currentPosition,coordinateEndPosition,this.canvasProteinWidth,50,this.unitWidth,hight,'#aa66aa',this.leftWidth,"coordinate");
	
	
	return 35;
	
}

ASPlot.ProteinPlot.prototype.plotProteinBlocks=function(hight,ifASIsoform){

	var nucleotideWidth=this.unitWidth/3;
	var curNucleotidePos=(this.currentPosition-1)*3;
	
	var coordinateEndPosition=Math.floor(curNucleotidePos+this.canvasProteinWidth/nucleotideWidth);
	//this.plotEngine.blocksPlotWithLineAS(this.context1,this.data,regionBegPos,regionEndPos,canvasWidth,50,unitWidth,30,'#aa66aa');
//this.plotEngine.blocksPlotWithLineAS//(this.contextProtein,this.geneStrucBlocks,this.currentPosition,coordinateEndPosition,this.canvasGeneWidth,50,this.unitWidth,hight,'#aa66aa');
	if(this.leftWidth!=0){
		this.contextProtein.fillStyle  = '#000000';
   		this.contextProtein.font = "13px monospace";
		this.contextProtein.fillText("exons",0,hight+15);
	}

	this.contextProtein.fillStyle = "#800000";
   	this.contextProtein.font = "10px monospace";



	if(typeof(color) == 'undefined' || color == null)
		color='#800000';


	if(typeof(height) == 'undefined' || height == null)
		rowHeight=20;

	this.contextProtein.fillStyle  = color;
	var col=0;
	color='#800000';
	//color='000000';
	this.contextProtein.fillStyle  = color;
		
		
	for(var block=0;block<this.geneStrucBlocks.length;block++){

		var boxBegPos=this.geneStrucBlocks[block].begPos;
		var boxEndPos=this.geneStrucBlocks[block].endPos;
		var ifAS=this.geneStrucBlocks[block].ifAS;
		if(this.ifASOut&&ifAS)
			continue;

		var boxLength=(boxEndPos-boxBegPos+1);

		var begPos=col+1;
		var endPos=begPos+boxLength-1;
		col+=boxLength;

		if(endPos<curNucleotidePos)
			continue;
		if(begPos>coordinateEndPosition)
			continue;

		begPos=begPos>curNucleotidePos?begPos:curNucleotidePos;
		//endPos=(endPos-0.3)<coordinateEndPosition?(endPos-0.3):coordinateEndPosition;
		endPos=(endPos)<coordinateEndPosition?(endPos):coordinateEndPosition;
		
		var length=(endPos-begPos+1);
		//var length=boxLength;
		if(ifAS&&ifASIsoform)
			this.contextProtein.fillStyle  = '#FA8072';
		else
			this.contextProtein.fillStyle  = '#800000';
		
		console.log("Plotein bloks plot,boxBegPos: "+boxBegPos+" \tboxEndPos: "+boxEndPos+"\t beg: "+begPos+"\t"+"end: "+endPos+"\t"+"length:"+length+"\t"+ "curNucleotidePos: "+curNucleotidePos);
		
		this.contextProtein.fillRect(this.leftWidth+(begPos-curNucleotidePos)*(nucleotideWidth),hight,(length)*(nucleotideWidth),20);

	}

		return 35;
}

//ASPlot.Utility.prototype.blocksPlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color){
ASPlot.ProteinPlot.prototype.pfamPlot=function(hight,isoform){
	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var pfams=isoform.pfams;

var pfamHeight=this.plotEngine.blocksPlotPipeLine(this.contextProtein,pfams,this.currentPosition,coordinateEndPosition,this.canvasProteinWidth,20,this.unitWidth,hight,'#808000',this.leftWidth,"pfam");


	//return 35;
	return pfamHeight;
}

ASPlot.ProteinPlot.prototype.ptmPlot=function(height,isoform){
	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;
	var ptms=isoform.ptms;
	
	var ptmHeight=this.plotEngine.pointPlot(this.contextProtein,ptms,this.currentPosition,coordinateEndPosition,this.canvasProteinWidth,20,this.unitWidth,height,'#808000',this.leftWidth,"ptm");

	//return 35;
	return ptmHeight;
	//pointPlot
}

//ASPlot.Utility.prototype.continuousValuePlot=function(context,disValue,regionBegPos,regionEndPos,unitWidth,height){
ASPlot.ProteinPlot.prototype.disPlot=function(height,isoform){

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var disvalue=isoform.disorderValue;

	this.plotEngine.continuousValuePlot(this.contextProtein,disvalue,this.currentPosition,coordinateEndPosition,this.unitWidth,height,this.leftWidth,"disprot");
	return 35;
}


ASPlot.ProteinPlot.prototype.asaPlot=function(height,isoform){

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var disvalue=isoform.asaValue;

	this.plotEngine.continuousValuePlot(this.contextProtein,disvalue,this.currentPosition,coordinateEndPosition,this.unitWidth,height,this.leftWidth,"asa");
	return 35;
}

ASPlot.ProteinPlot.prototype.random_coilPlot=function(height,isoform){

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var disvalue=isoform.random_coilValue;

	this.plotEngine.continuousValuePlot(this.contextProtein,disvalue,this.currentPosition,coordinateEndPosition,this.unitWidth,height,this.leftWidth,"random_coil");
	return 35;
}

ASPlot.ProteinPlot.prototype.beta_sheetPlot=function(height,isoform){

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var disvalue=isoform.beta_sheetValue;

	this.plotEngine.continuousValuePlot(this.contextProtein,disvalue,this.currentPosition,coordinateEndPosition,this.unitWidth,height,this.leftWidth,"beta_sheet");
	return 35;
}

ASPlot.ProteinPlot.prototype.alpha_helixPlot=function(height,isoform){

	var coordinateEndPosition=this.currentPosition+this.canvasProteinWidth/this.unitWidth;

	var disvalue=isoform.alpha_helixValue;

	this.plotEngine.continuousValuePlot(this.contextProtein,disvalue,this.currentPosition,coordinateEndPosition,this.unitWidth,height,this.leftWidth,"alpha_helix");
	return 35;
}


ASPlot.GenePlot=function(xmlParser,plotEngine){
	//get canvas context
	this.plotLeft=true;

	this.leftWidth=120;

	this.plotEngine=plotEngine;
	this.canvasGene = document.getElementById("geneVisual");
    	this.contextGene = this.canvasGene.getContext("2d");
	this.canvasGeneWidth  = this.canvasGene.width;
	this.strand=xmlParser.getStrand();

	// graphic parameters
	this.currentPosition=-1//plot current position
	this.unitwidth=-1;//nuclied width
	this.x=-1;//current mouse x position
	this.y=-1;//current mouse y position
	this.mouseIsDown=false;
	this.moveWidth=15;

	//this.tmpContext=this.contextGene;
	this.imgData;
	this.moveLastX=-1;
	this.moveLastY=-1;

	this.unitWidth=11;
	this.maxUnitWidth=15;
	this.minUnitWidth=0.01;
	this.minFontWidth=7;
	this.residue=0;
	//this.exons=xmlParser.parseASExons();

	var geneSequenceStruc=xmlParser.parseGeneSequence();
	//this.knownAlt=xmlParser.parseKnownAlt();
	this.conservation=xmlParser.parseConservationScore();
	this.geneSequence=geneSequenceStruc['sequence'];
	this.start=parseInt(geneSequenceStruc['start']);
	this.end=parseInt(geneSequenceStruc['end']);

	this.geneStrucBlocks=xmlParser.parseASExons();

	this.currentPosition=this.start;
	//this.endCoordinatePosition=this.
	this.browserName=getBrowserName();
	var a=this;

	var button = document.getElementById("gotoposition");


	button.addEventListener("click", function(){
		var  po= document.getElementById("coordiantePosition");
		console.log(po.value);
		a.go(po.value)}, false);
	this.canvasGene.addEventListener("mouseup", function(e){a.mouseUp(e)}, false);
	this.canvasGene.addEventListener("mousedown", function(e){a.mouseDown(e)}, false);
	this.canvasGene.addEventListener("mousemove", function(e){a.mouseMove(e)}, false);
	this.canvasGene.addEventListener("keydown", function(e){a.keyDown(e)}, false);
	this.canvasGene.addEventListener("mouseout", function(e){a.mouseOut(e)}, false);

	if(this.browserName=="Firefox"){
		this.canvasGene.addEventListener("DOMMouseScroll", function(e){a.mouseWheel(e)}, false);
		//console.log(navigator.userAgent.toLowerCase().substring(0,6));
	}
	else{
		this.canvasGene.addEventListener("mousewheel", function(e){a.mouseWheel(e)}, false);
		//console.log(navigator.userAgent.toLowerCase().substring(0,6));

	}

}



ASPlot.GenePlot.prototype.mouseDown=function(e){
	//alert('meng1');
	this.mouseIsDown=true;
	this.x=e.clientX;
	this.y=e.clientY;
	//this.moveLeft();
	//this.moveRight();
}

ASPlot.GenePlot.prototype.mouseWheel=function(e){
	var delta=e.wheelDelta;
	if(this.browserName=="Firefox"){
		delta=e.detail;
	}

	var shiftDown = e.shiftKey;
	//if(!shiftDown)
	//	return;
	//e.stopPropagation();

        if (delta<0){

		if(this.unitWidth<=1)
			this.unitWidth=this.unitWidth/1.2;
		else
			this.unitWidth--;//zoom in

		if(this.unitWidth<this.minUnitWidth){
			this.unitWidth=this.minUnitWidth;
		}

        } else{
		//code

		if(this.unitWidth<=1)
			this.unitWidth=this.unitWidth*1.2;
		else
			this.unitWidth++;//zoom out

		if(this.unitWidth>this.maxUnitWidth){
			this.unitWidth=this.maxUnitWidth;
		}

        }
	var plotEndPos=this.end-Math.round((this.canvasGeneWidth-this.leftWidth)/this.unitWidth)+13;
	if(plotEndPos<0)
		plotEndPos=0;

	if (this.currentPosition>plotEndPos) {

		this.currentPosition=plotEndPos;
	}

	//alert(this.currentPosition);
	if (this.currentPosition<this.start) {
		//code
		this.currentPosition=this.start;
	}
	//alert(this.currentPosition);

	this.plot() ;    
	event.preventDefault();
        event.returnValue=false;;
	//e.stopPropagation();
}

ASPlot.GenePlot.prototype.mouseOut=function(e){
	this.mouseIsDown=false;
}

ASPlot.GenePlot.prototype.mouseUp=function(e){
	//alert('meng2');
	this.mouseIsDown=false;
}

ASPlot.GenePlot.prototype.go=function(coordinatePosition){
	this.currentPosition=parseInt(coordinatePosition);
	this.plot();
}

ASPlot.GenePlot.prototype.mouseMove=function(e){
	var curX=(e.offsetX==undefined?e.layerX:e.offsetX);
	var curY=(e.offsetY==undefined?e.layerY:e.offsetY);

	if (this.mouseIsDown&&(Math.abs(curX-this.x)>this.moveWidth)) {
		//code
		//alert(Math.abs(curX-this.x));
		//alert(this.currentPosition);
		document.body.style.cursor ='default'; 
		var offset=curX-this.x+this.residue;

		this.residue=offset%this.unitWidth;

		this.currentPosition=this.currentPosition+parseInt(-1*offset/this.unitWidth);

		var plotEndPos=this.end-Math.round((this.canvasGeneWidth-this.leftWidth)/this.unitWidth)+13;
		if(plotEndPos<0)
			plotEndPos=0;

		//alert(this.currentPosition);

		//alert(this.currentPosition);
		if (this.currentPosition>plotEndPos) {


			this.currentPosition=plotEndPos;
		}
		if (this.currentPosition<this.start) {
			//code
			this.currentPosition=this.start;
		}
		//alert(this.currentPosition);
		this.plot();


		this.x=curX;
		this.y=curY;
	}else{
		if(Math.abs(curX-this.moveLastX)>this.moveWidth/2){
			this.contextGene.beginPath();
			this.contextGene.strokeStyle = '#000000'; // black
		   	this.contextGene.lineWidth= 1;


			//this.tmpContext=this.contextGene.save();
			this.contextGene.putImageData(this.imgData,0,0);
			this.imgData=this.contextGene.getImageData(0,0,this.canvasGene.width, this.canvasGene.height);

			this.contextGene.moveTo(0,curY);
			this.contextGene.lineTo(this.canvasGeneWidth,curY);

			this.contextGene.moveTo(curX,0);
			this.contextGene.lineTo(curX,this.canvasGene.height);

			this.contextGene.stroke();
			this.moveLastX=curX;
			//this.tmpContext=this.contextGene.restore();

		}
		
	}
	
}

ASPlot.GenePlot.prototype.moveLeft=function(){
	this.currentPosition-=1;
	this.plot();

}

ASPlot.GenePlot.prototype.moveRight=function(){
	this.currentPosition+=1;
	this.plot();

}


ASPlot.GenePlot.prototype.keyDown=function(e){
	//javascript: console.log(2);

	console.log(2);
	if(e.keyCode == 37){
		this.currentPosition+=1;

	}

	if(e.keyCode == 39){
		this.currentPosition+=-1;

	}

	var plotEndPos=this.end-Math.round((this.canvasGeneWidth-this.leftWidth)/this.unitWidth)+13;
	if(plotEndPos<0)
		plotEndPos=0;

	//alert(this.currentPosition);

	//alert(this.currentPosition);
	if (this.currentPosition>plotEndPos) {

		this.currentPosition=plotEndPos;
	}
	if (this.currentPosition<this.start) {
		//code
		this.currentPosition=this.start;
	}
	this.plot();
}

ASPlot.GenePlot.prototype.plot=function(){
	this.contextGene .beginPath();
	this.contextGene .clearRect(0, 0, this.canvasGene.width, this.canvasGene.height);

	var hight=20;

	hight+=this.plotCoordinate(hight);
	hight+=this.plotAlphabet(hight);
	hight+=this.plotGeneBlocks(hight);
	//hight+=this.plotKnownAlt(hight);
	hight+=this.plotConservation(hight);
	hight+=this.plotStrand(hight);
	this.contextGene.stroke();

	this.imgData=this.contextGene.getImageData(0,0,this.canvasGene.width, this.canvasGene.height);
}

ASPlot.GenePlot.prototype.plotAlphabet=function(hight){
	//alert(this.start);
	//alert(this.currentPosition);
	if(this.unitWidth<this.minFontWidth)
		return 0;
	
	//console.log(this.currentPosition);
	var drawSeq=this.geneSequence.substring(this.currentPosition-this.start,this.geneSequence.length);

	var coordinateEndPosition=this.currentPosition+parseInt(this.canvasGeneWidth/this.unitWidth);

	this.plotEngine.alphabetPlot(this.contextGene,drawSeq,this.currentPosition,coordinateEndPosition,this.unitWidth,hight,this.leftWidth,"DNA");

	return 35;
}

ASPlot.GenePlot.prototype.plotCoordinate=function(hight){

//ASPlot.Utility.prototype.coordinatePlot=function(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color){
	//var unitWidth=this.canvasGeneWidth/(this.start-this.end+1);
	var coordinateEndPosition=this.currentPosition+parseInt(this.canvasGeneWidth/this.unitWidth);

	this.plotEngine.coordinatePlot(this.contextGene,this.data,this.currentPosition,coordinateEndPosition,this.canvasGeneWidth,30,this.unitWidth,hight,'#000000',this.leftWidth,"coordinate");
	return 35;
}

ASPlot.GenePlot.prototype.plotGeneBlocks=function(hight){

	var coordinateEndPosition=this.currentPosition+this.canvasGeneWidth/this.unitWidth;
	//this.plotEngine.blocksPlotWithLineAS(this.context1,this.data,regionBegPos,regionEndPos,canvasWidth,50,unitWidth,30,'#aa66aa');
	this.plotEngine.blocksPlotWithLineAS(this.contextGene,this.geneStrucBlocks,this.currentPosition,coordinateEndPosition,this.canvasGeneWidth,20,this.unitWidth,hight,'#800000',this.leftWidth,"geneExons");

	return 35;
}

ASPlot.GenePlot.prototype.plotKnownAlt=function(hight){

	var coordinateEndPosition=this.currentPosition+this.canvasGeneWidth/this.unitWidth;
	//this.plotEngine.blocksPlotWithLineAS(this.context1,this.data,regionBegPos,regionEndPos,canvasWidth,50,unitWidth,30,'#aa66aa');
	this.plotEngine.blocksPlot(this.contextGene,this.knownAlt,this.currentPosition,coordinateEndPosition,this.canvasGeneWidth,20,this.unitWidth,hight,'#FA8072',this.leftWidth,"knowAltUCSC");

	return 35;
}

ASPlot.GenePlot.prototype.plotConservation=function(hight){
	var coordinateEndPosition=this.currentPosition+this.canvasGeneWidth/this.unitWidth;

	//var conservation=this.conservation;

	this.plotEngine.continuousValuePlot(this.contextGene,this.conservation,this.currentPosition-this.start,coordinateEndPosition-this.start,this.unitWidth,hight,this.leftWidth,"phastCons100way");
	return 35;


}

ASPlot.GenePlot.prototype.plotStrand=function(hight){
//ASPlot.Utility.prototype.plotStrand=function(context,leftWidth,canvasWidth,height,name,strand);
	this.plotEngine.plotStrand(this.contextGene,this.leftWidth,this.canvasGeneWidth,hight,"strand",this.strand);
	return 35;
}


ASPlot.transcriptPlot=function(xmlParser,plotEngine){
	//if(typeof(xml) == 'undefined' || xml == null||xml=="")
	//	return;

	//initialization
	//var xmlParser=new ASPlot.xmlParser();
	//this.plotEngine=new ASPlot.Utility();

	this.leftWidth=200;
	this.xmlParser=xmlParser;
	this.plotEngine=plotEngine;

	//canvas1
    	//this.canvas1 = document.getElementById("visualas");
    	//this.context1 = this.canvas1.getContext("2d");
	//this.xml=xmlParser.parseXML(xml);
	//this.data=this.xml.parseASExons();
	//this.canvas1.height=100;

	//canvas2
	this.canvas2=document.getElementById("transcriptsVisual");
	this.context2=this.canvas2.getContext("2d");
	//this.canvas2.width  = document.documentElement.clientWidth;
	this.transcripts=this.xmlParser.parseTranscripts();
	this.canvas2.height=this.transcripts.length*30+60;


}

//ASPlot.Utility.prototype.blocksPlot=function(context,blocks,regionBegPos,regionEndPos,cavansWidth,rowHeight,unitWidth,height,color){
ASPlot.transcriptPlot.prototype.plotAS=function(){
    	this.context1.beginPath();

	var regionBegPos=parseInt(this.data[0].begPos);
	var regionEndPos=parseInt(this.data[this.data.length-1].endPos);
	var canvasWidth=this.canvas1.width;
	var unitWidth=(canvasWidth-this.leftWidth)/(regionEndPos-regionBegPos+1);
	this.plotEngine.coordinatePlot(this.context1,this.data,regionBegPos,regionEndPos,canvasWidth,50,unitWidth,10,'#aa66aa',this.leftWidth);

	this.plotEngine.blocksPlotWithLineAS(this.context1,this.data,regionBegPos,regionEndPos,canvasWidth,50,unitWidth,30,'#aa66aa');

	this.context1.stroke();

}

ASPlot.transcriptPlot.prototype.plot=function(){
	if(this.transcripts==null||this.transcripts.length==0)
		return;


    	this.context2.beginPath();


	var regionBegPos=1000000000;
	var regionEndPos=-1;

	for(var tranIndex in this.transcripts){
		var oneTranscript=this.transcripts[tranIndex].blocks;
		for(var exonIndex in oneTranscript){
			var begPos=parseInt(oneTranscript[exonIndex].begPos);
			var endPos=parseInt(oneTranscript[exonIndex].endPos);
			if(regionBegPos>begPos){
				regionBegPos=begPos;
			}
			if(regionEndPos<endPos){
				regionEndPos=endPos;
			}

		}

	}


	var canvasWidth=this.canvas2.width;
	var unitWidth=(canvasWidth-this.leftWidth)/(regionEndPos-regionBegPos+1);
	var height=30;

//(context,blocks,regionBegPos,regionEndPos,cavanseWidth,rowHeight,unitWidth,height,color,leftWidth,name){

	this.plotEngine.coordinatePlot(this.context2,this.transcripts,regionBegPos,regionEndPos,canvasWidth,30,unitWidth,height,'#aa66aa',this.leftWidth,"coordinate");
	height+=30;

	for(var transcriptIndex=0; transcriptIndex<this.transcripts.length;transcriptIndex++){

this.plotEngine.blocksPlotWithLineAS(this.context2,this.transcripts[transcriptIndex].blocks,regionBegPos,regionEndPos,canvasWidth,20,unitWidth,height,'#aa66aa',this.leftWidth,this.transcripts[transcriptIndex].ID);

	height+=25;
	}

	this.context2.stroke();

}



ASPlot.xmlParser=function(){


}


ASPlot.xmlParser.prototype.parseConservationScore=function(){
	var conservationNode=this.eventNodes[0].getElementsByTagName("conservation");
	//var exonsNode=transcriptNode[0].childNodes;


	var conservation=(conservationNode[0].innerHTML==null?conservationNode[0].textContent:conservationNode[0].innerHTML).split(" ");

	return conservation;
}


//cassettExonEventPosTable.push({from:0,to:1});
ASPlot.xmlParser.prototype.parseKnownAlt=function(){

	var blocks=[];
	var ucscAltEventNode=this.eventNodes[0].getElementsByTagName("ucscaltevent");
	var exonsNode=ucscAltEventNode[0].childNodes;

	//var exons=position.split("@");
	for(var exonIndex=0; exonIndex<exonsNode.length;++exonIndex){

		//var loneExon=exonsNode[exonIndex].getAttribute();
			//var lchrsosome=exonsNode[exonIndex].getAttribute("");
		var lbegPos=parseInt(exonsNode[exonIndex].getAttribute("start"));
		var lendPos=parseInt(exonsNode[exonIndex].getAttribute("end"));
			//var lstrand=loneExon[3];

			//if(loneExon.length>4){
				//var lIfAS=oneExon[4];
		blocks.push({begPos:lbegPos,endPos:lendPos});

			//}
			//else{

				//blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}

		}

	return blocks;

}

ASPlot.xmlParser.prototype.parseASExons=function(){
	this.blocks=[];
	var transcriptNode=this.eventNodes[0].getElementsByTagName("alternativeExons");
	var exonsNode=transcriptNode[0].childNodes;

	//var exons=position.split("@");
	for(var exonIndex=0; exonIndex<exonsNode.length;++exonIndex){

		//var loneExon=exonsNode[exonIndex].getAttribute();
			//var lchrsosome=exonsNode[exonIndex].getAttribute("");
		var lbegPos=parseInt(exonsNode[exonIndex].getAttribute("start"));
		var lendPos=parseInt(exonsNode[exonIndex].getAttribute("end"));
			//var lstrand=loneExon[3];
		var ifAlternativeStr=exonsNode[exonIndex].getAttribute("IfAlternative");
		var ifAlternative=Boolean(ifAlternativeStr=="true");

			//if(loneExon.length>4){
				//var lIfAS=oneExon[4];
		this.blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}
			//else{

				//blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}

		}

	return this.blocks;
}

ASPlot.xmlParser.prototype.parseTranscript=function(){
	this.blocks=[];
	//this.eventNodes[0].getElementsByTagName("transcript")
	
	var transcriptNode=this.eventNodes[0].getElementsByTagName("transcript");
	var exonsNode=transcriptNode[0].childNodes;
	//var exonsNode=transcriptNode;
	var cds_index=0;
	//var exons=position.split("@");
	for(var exonIndex=0; exonIndex<exonsNode.length;++exonIndex){

		//var loneExon=exonsNode[exonIndex].getAttribute();
			//var lchrsosome=exonsNode[exonIndex].getAttribute("");
		var lbegPos=parseInt(exonsNode[exonIndex].getAttribute("cds_start"));
		var lendPos=parseInt(exonsNode[exonIndex].getAttribute("cds_end"));
		var strand=exonsNode[exonIndex].getAttribute("strand");
		
		if(lbegPos==-1||lendPos==-1){
			continue;
		}
		if(strand==="NEGATIVE"&&cds_index==0){
			lbegPos+=3;
		}
				
		//remove the stop codon in the end of transcript
			//var lstrand=loneExon[3];
		var ifAlternativeStr=exonsNode[exonIndex].getAttribute("IfAlternative");
		var ifAlternative=Boolean(ifAlternativeStr=="true");
		
			//if(loneExon.length>4){
				//var lIfAS=oneExon[4];
		this.blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});
		cds_index++;
		
			//}
			//else{

				//blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}

		}
		
		if(strand==="POSITIVE"&&(exonIndex==exonsNode.length-1) ){
			this.blocks[this.blocks.length-1]["endPos"]=this.blocks[this.blocks.length-1]["endPos"]-3;
			//lendPos-=3;
		}
		
	return this.blocks;
}


ASPlot.IsoformStruct=function(){
	this.proteinSequence="";
	this.pfams;
	this.disorderString="";

}

ASPlot.IsoformStruct.prototype.setProteinSequence=function(seq){
	this.proteinSequence=seq;
}

ASPlot.xmlParser.prototype.parseIsoforms=function(){
	var isoformNodes=this.eventNodes[0].getElementsByTagName("isoform");
	var isoforms=new Array();

	for(var isoformIndex=0; isoformIndex<isoformNodes.length;isoformIndex++){
		var  featuresNode=isoformNodes[isoformIndex].children;
		var oneIsoform=new ASPlot.IsoformStruct();

		var proteinSequence=(isoformNodes[isoformIndex].getElementsByTagName("proteinSequence")[0].innerHTML==null)?(isoformNodes[isoformIndex].getElementsByTagName("proteinSequence")[0].textContent):(isoformNodes[isoformIndex].getElementsByTagName("proteinSequence")[0].innerHTML);

		oneIsoform.proteinSequence=proteinSequence;

		var pfamNodes=isoformNodes[isoformIndex].getElementsByTagName("pfam_domain");

		var onePfam=[];
		for(var pfamIndex=0;pfamIndex<pfamNodes.length;pfamIndex++){

			var pfamBegPos=parseInt((pfamNodes[pfamIndex]).getAttribute("start"));
			var pfamEndPos=parseInt((pfamNodes[pfamIndex]).getAttribute("end"));

			var pfamDescription=(pfamNodes[pfamIndex]).getAttribute("description");
			var pfamFamily=(pfamNodes[pfamIndex]).getAttribute("family");

		onePfam.push({'begPos':pfamBegPos,'endPos':pfamEndPos,'description':pfamDescription,'pfamFamily':pfamFamily});

		}
		oneIsoform.pfams=onePfam;
		
		
		var ptmNodes=isoformNodes[isoformIndex].getElementsByTagName("ptm");
		var onePtm=[];
		for(var ptmIndex=0;ptmIndex<ptmNodes.length;ptmIndex++){

			var ptmBegPos=parseInt((ptmNodes[ptmIndex]).getAttribute("start"));
			//var pfamEndPos=parseInt((pfamNodes[pfamIndex]).getAttribute("end"));

			var modification=(ptmNodes[ptmIndex]).getAttribute("modification");
			//var pfamFamily=(pfamNodes[pfamIndex]).getAttribute("family");

		onePtm.push({'begPos':ptmBegPos,'endPos':ptmBegPos,'description':modification} );

		}
		oneIsoform.ptms=onePtm;

		var disorderNode=isoformNodes[isoformIndex].getElementsByTagName("disProt_value")[0];
		var disorderStr=disorderNode.getAttribute("disOrder_string");
		var disorderValue=(disorderNode.innerHTML==null?disorderNode.textContent:disorderNode.innerHTML).split(" ");

		oneIsoform.disorderValue=disorderValue;

		oneIsoform.disorderString=disorderStr;

		var asaNode=isoformNodes[isoformIndex].getElementsByTagName("asa")[0];
		var asaValue=(asaNode.innerHTML==null?asaNode.textContent:asaNode.innerHTML).split(" ");

		oneIsoform.asaValue=asaValue;
		

		var random_coilNode=isoformNodes[isoformIndex].getElementsByTagName("random_coil")[0];
		var random_coilValue=(random_coilNode.innerHTML==null?random_coilNode.textContent:random_coilNode.innerHTML).split(" ");

		oneIsoform.random_coilValue=random_coilValue;
		
		
		var beta_sheetNode=isoformNodes[isoformIndex].getElementsByTagName("beta_sheet")[0];
		var beta_sheetValue=(beta_sheetNode.innerHTML==null?beta_sheetNode.textContent:beta_sheetNode.innerHTML).split(" ");
		
		oneIsoform.beta_sheetValue=beta_sheetValue;
		
		var alpha_helixNode=isoformNodes[isoformIndex].getElementsByTagName("alpha_helix")[0];
		var alpha_helixValue=(alpha_helixNode.innerHTML==null?alpha_helixNode.textContent:alpha_helixNode.innerHTML).split(" ");
		
		oneIsoform.alpha_helixValue=alpha_helixValue;		
		
		
		
		//http://en.wikipedia.org/wiki/Amino_acid
		var aminoAcidPolarity=new Object();

		aminoAcidPolarity['A']='n';
		aminoAcidPolarity['R']='b';
		aminoAcidPolarity['N']='p';
		aminoAcidPolarity['D']='p';
		aminoAcidPolarity['C']='n';
		aminoAcidPolarity['E']='a';
		aminoAcidPolarity['Q']='p';
		aminoAcidPolarity['G']='n';
		aminoAcidPolarity['H']='b';
		aminoAcidPolarity['I']='b';
		aminoAcidPolarity['L']='n';
		aminoAcidPolarity['K']='b';
		aminoAcidPolarity['M']='n';
		aminoAcidPolarity['F']='n';
		aminoAcidPolarity['P']='n';
		aminoAcidPolarity['S']='p';
		aminoAcidPolarity['T']='p';
		aminoAcidPolarity['W']='n';
		aminoAcidPolarity['X']='n';
		aminoAcidPolarity['Y']='p';
		aminoAcidPolarity['V']='n';

		var aminoAcidCharge=new Object();
		aminoAcidCharge['A']='n';
		aminoAcidCharge['R']='p';
		aminoAcidCharge['N']='n';
		aminoAcidCharge['D']='g';
		aminoAcidCharge['C']='n';
		aminoAcidCharge['E']='g';
		aminoAcidCharge['Q']='n';
		aminoAcidCharge['G']='n';
		aminoAcidCharge['H']='n';
		aminoAcidCharge['I']='n';
		aminoAcidCharge['L']='n';
		aminoAcidCharge['K']='p';
		aminoAcidCharge['M']='n';
		aminoAcidCharge['F']='n';
		aminoAcidCharge['P']='n';
		aminoAcidCharge['S']='n';
		aminoAcidCharge['T']='n';
		aminoAcidCharge['W']='n';
		aminoAcidCharge['X']='n';
		aminoAcidCharge['Y']='n';
		aminoAcidCharge['V']='n';


		//this.polarity="";
		//this.charge="";
		oneIsoform.polarity="";
		oneIsoform.charge="";
		for(var i=0;i<oneIsoform.proteinSequence.length;++i){
			oneIsoform.polarity+=aminoAcidPolarity[oneIsoform.proteinSequence[i]];
			oneIsoform.charge+=aminoAcidCharge[oneIsoform.proteinSequence[i]];

		}

		isoforms.push(oneIsoform);


	}

	return isoforms;

}


ASPlot.xmlParser.prototype.parseGeneSequence=function(){

	var sequenceNode=this.eventNodes[0].getElementsByTagName("geneSequence");
	var sequence=sequenceNode[0].innerHTML==null?sequenceNode[0].textContent:sequenceNode[0].innerHTML;
	var start=sequenceNode[0].getAttribute("start");
	var end=sequenceNode[0].getAttribute("end");

	return {sequence:sequence,start:start,end:end};
}


ASPlot.xmlParser.prototype.parseTranscripts=function(){
	this.transcirpts=[];

	var transcriptsNode=this.eventNodes[0].getElementsByTagName("transcript");//.innerHTML;

	for(var transcriptIndex=0 ; transcriptIndex<transcriptsNode.length;transcriptIndex++){
		var blocks=[];
		var exonsNode=transcriptsNode[transcriptIndex].childNodes;
		var id=transcriptsNode[transcriptIndex].getAttribute("ID");

		//var exons=position.split("@");
		for(var exonIndex=0; exonIndex<exonsNode.length;++exonIndex){

			//var loneExon=exonsNode[exonIndex].getAttribute();
			//var lchrsosome=exonsNode[exonIndex].getAttribute("");
			var strand=parseInt(exonsNode[exonIndex].getAttribute("strand"));
			
			
			var lbegPos=parseInt(exonsNode[exonIndex].getAttribute("start"));
			//remove the stop codon in the s of transcript
			if(strand=="NEGATIVE"&&exonIndex==0){
				lbegPos+=3;
			}
			
			var lendPos=parseInt(exonsNode[exonIndex].getAttribute("end"));
			
			//remove the stop codon in the end of transcript
			if(strand="POSITIVE"&&(exonIndex==exonsNode.length-1) ){
				lendPos-=3;
			}
			
			//var lstrand=loneExon[3];
			var ifAlternative=Boolean(exonsNode[exonIndex].getAttribute("IfAlternative")=="true");

			//if(loneExon.length>4){
				//var lIfAS=oneExon[4];
				blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}
			//else{

				//blocks.push({begPos:lbegPos,endPos:lendPos,ifAS:ifAlternative});

			//}

		}

		this.transcirpts.push({ID:id,blocks:blocks});
	}
	return this.transcirpts;
}

ASPlot.xmlParser.prototype.getStrand=function(){
	var strandNode=this.eventNodes[0].getElementsByTagName("strand");//.innerHTML;
	//return strandNode[0].innerHTML;
	return strandNode[0].innerHTML==null?strandNode[0].textContent:strandNode[0].innerHTML;
}

ASPlot.xmlParser.prototype.parseXML=function(url){


        //xmlHttp = new window.XMLHttpRequest();

	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlHttp=new XMLHttpRequest();

  	}
	else{// code for IE6, IE5

		xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", url,false); // Use syncronous communication
        xmlHttp.send(null);

        this.xmldoc = xmlHttp.responseXML.documentElement;

	this.eventNodes=this.xmldoc.getElementsByTagName("event");
	//this.position=eventNodes[0].getElementsByTagName("position")[0].innerHTML;



	return this;
}



ASPlot.submitQuery=function(){
	var text=document.getElementById("searchFild").value;
	if(typeof(text) == 'undefined' || text == null||text=="")
		return;

	var loadingPage=new ASPlot.firstPage(text);

	loadingPage.plotAS();
	loadingPage.plotTranscript();

}

//var searchButton = document.getElementById("submitQuery");
//event handler:
function cumulativeOffset(element) {
    var top = 0, left = 0;
    do {
        top += element.offsetTop  || 0;
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    } while(element);

    return {
        top: top,
        left: left
    };
}

//http://nickthecoder.wordpress.com/2013/02/26/offsetx-and-offsety-in-firefox/
function getOffset(evt){
	if(evt.offsetX!=undefined)
		return {x:evt.offsetX,y:evt.offsetY};

	var el = evt.target;
	var offset = {x:0,y:0};

	while(el.offsetParent)
	{
		offset.x+=el.offsetLeft;
		offset.y+=el.offsetTop;
		el = el.offsetParent;
	}

	offset.x = evt.pageX - offset.x;
	offset.y = evt.pageY - offset.y;

	return offset;
}
//http://www.javascripter.net/faq/browsern.htm
function getBrowserName(){
	var browserName  = navigator.appName;
	var nAgt = navigator.userAgent;

	if ((verOffset=nAgt.indexOf("Opera"))!=-1) {
		browserName = "Opera";
	}
	// In MSIE, the true version is after "MSIE" in userAgent
	else if ((verOffset=nAgt.indexOf("MSIE"))!=-1) {
	 browserName = "Microsoft Internet Explorer";

	}
	// In Chrome, the true version is after "Chrome"
	else if ((verOffset=nAgt.indexOf("Chrome"))!=-1) {
	 browserName = "Chrome";

	}
	// In Safari, the true version is after "Safari" or after "Version"
	else if ((verOffset=nAgt.indexOf("Safari"))!=-1) {
	 browserName = "Safari";
	}
	// In Firefox, the true version is after "Firefox"
	else if ((verOffset=nAgt.indexOf("Firefox"))!=-1) {
	 browserName = "Firefox";

	}

	return browserName;



}

function submitQueryEvent(e){


/*
	var xmlhttp;

	if (window.XMLHttpRequest){// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();

  	}
	else{// code for IE6, IE5

		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}


	xmlhttp.onreadystatechange=function(){

		if (xmlhttp.readyState==4 && xmlhttp.status==200){
			//loadingEle.style.display = "none";
			document.write(xmlhttp.responseText);
			console.log("sucess get the responseText");

		}

	}


	//xmlhttp.open("post","testAjax.html",false);
	xmlhttp.open("post","visualPage.php",true);
	xmlhttp.send();

*/
	return true;

}

function leftPanelButtonOver(){
	document.images["leftPanelButton"].src= "pic/xl.jpg";
	var leftPanelControl = document.getElementById("leftPanelControl");
	leftPanelControl.style.display = "block";


}

function validatFrom(){
	return false;

}

function leftPanelButtonOut(){
	document.images["leftPanelButton"].src= "pic/xx.jpg";

	var leftPanelControl = document.getElementById("leftPanelControl");
	leftPanelControl.style.display = "none";

}

function leftPanelExpand(){}

function checkBox(t){
	var check=t.checked;
	var value=t.value;
	if(value=="GenePart"){
		var ele = document.getElementById("geneVisualModule");
		if(!check){

			ele.style.display = "none";
		}
		else{
			ele.style.display = "block";
		}

	}

	if(value=="proteinPart"){
		var ele = document.getElementById("proteinVisualModule1");
		if(!check){
			ele.style.display = "none";
		}
		else{
			ele.style.display = "block";
		}
	}

	if(value=="transcriptPart"){
		var ele = document.getElementById("transcriptsVisualModule");
		if(!check){
			ele.style.display = "none";
		}
		else{
			ele.style.display = "block";
		}
	}

}

//@chr17:7572927:7573008:@chr17:7573927:7574033:-:Splice@chr17:7576853:7576926:-@chr17:7577019:7577155:-:Splice@chr17:7577499:7577608:-@chr17:7578177:7578289:-@chr17:7578371:7578544:-@chr17:7579312:7579590:-@chr17:7579700:7579721:-@chr17:7579839:7579912:-
function validate_form(form){
	var regexCasseteExon = "chr\\w+:(\\d+):(\\d+):(\\+|-)@chr\\w+:(\\d+):(\\d+):(\\+|-)@chr\\w+:(\\d+):(\\d+):(\\+|-)";

	var regexA5SS = "chr\\w+:(\\d+):(\\d+)\\|(\\d+):(\\+|-)@chr(\\w+):(\\d+):(\\d+):(\\+|-)";

	var regexA3SS = "chr(\\w+):(\\d+):(\\d+):(\\+|-)@chr\\w+:(\\d+)\\|(\\d+):(\\d+):(\\+|-)";

	var regexRetainedIntro = "chr(\\w+):(\\d+)-(\\d+):(\\+|-)@chr(\\w+):(\\d+)-(\\d+):(\\+|-)";

	var regexEnsembl="\^ENST";
	var regexUCSC="\^uc";
	var regexRefSeq="\^NM";

	var exons="\(@chr\\w+:(\\d+):(\\d+):(\\+\-)((:Splice)*))+";

	var eventIdNode = document.getElementById("searchFild");
	var eventId=eventIdNode.value;
	var patt1 = new RegExp(regexCasseteExon);
	var patt2=new RegExp(regexA5SS);
	var patt3=new RegExp(regexA3SS);
	var patt4=new RegExp(regexRetainedIntro);
	var patt5=new RegExp(regexEnsembl);
	var patt6=new RegExp(regexUCSC);
	var patt7=new RegExp(regexRefSeq);
	var patt7=new RegExp(exons);

	var res = patt1.test(eventId);
	res = patt2.test(eventId)||res;
	res = patt3.test(eventId)||res;
	res = patt4.test(eventId)||res;
	res = patt5.test(eventId)||res;
	res = patt6.test(eventId)||res;
	res = patt7.test(eventId)||res;

	if(res==false){
		alert('Your input format is not right.');
		return false;
	
	}

	var eventIDEle = document.getElementById("searchFild");
	var eventId=eventIDEle.value;
	//alert("It needs a few mimuites to finish runing!!!");
	
	
	
	
	document.cookie=("eventId="+eventId);

	var subQueryEle = document.getElementById("submitQuery");
	var x_pos=cumulativeOffset(subQueryEle).left;
	var y_pos=cumulativeOffset(subQueryEle).top;
	subQueryEle.style.display="none";


	var loadingEle = document.getElementById("loadingGif");
	loadingEle.style.display = "block";
	loadingEle.style.position = "absolute";
	loadingEle.style.left = x_pos+"px";
	loadingEle.style.top = y_pos-50+"px";

		return true;
	}

// init page
function initFirstPage(){
	
		
	//var mainPage = document.getElementById("mainPage");
	//mainPage.style.width=document.documentElement.clientWidth-32+'px';


    	//var canvas1 = document.getElementById("visualas");
	//context1 = this.canvas1.getContext("2d");
	//canvas1.width  = document.documentElement.clientWidth-60;

	//this.xml=xmlParser.parseXML(xml);
	//this.data=this.xml.parseASExons();


	//var canvas2=document.getElementById("visualtranscripts");
	//canvas2.width  = document.documentElement.clientWidth-60;



    	//var module1 = document.getElementById("inputModule");
	//var module2 = document.getElementById("visualASModule");
	//var module3 = document.getElementById("exonsModule");

	//module1.style.width=document.documentElement.clientWidth-60+'px';
	//module2.style.width=document.documentElement.clientWidth-60+'px';
	//module3.style.width=document.documentElement.clientWidth-60+'px';


}

function initVisualPage(event){
	var mainPage = document.getElementById("mainPage");
	mainPage.style.width=document.documentElement.clientWidth-12+"px";
	var canvasWidth=document.documentElement.clientWidth-20;

    	var canvasGene = document.getElementById("geneVisual");
	//context1 = this.canvas1.getContext("2d");
	if(typeof(canvasGene) == 'undefined' || canvasGene == null)
		return;

	canvasGene.width  = canvasWidth;

    	//canvasGene.addEventListener("mousew", mouse, false);

	//this.xml=xmlParser.parseXML(xml);
	//this.data=this.xml.parseASExons();

	var canvasProtein1=document.getElementById("proteinVisual1");
	canvasProtein1.width  =canvasWidth;

	//var canvasProtein2=document.getElementById("proteinVisual2");
	//canvasProtein2.width  = canvasWidth;

    var canvasTranscriptId = document.getElementById("transcriptsVisual");
	canvasTranscriptId.width=canvasWidth;

	//var eventId = document.getElementById("eventId");
	//eventId.style.width=document.documentElement.clientWidth-32+'px';
	//var eventId0=eventId.innerHTML=null?eventId.textContent:eventId.innerHTML;
	var visualPage=new ASPlot.visualPage(event+".xml");
	
	//visualPage.proteinPlot1.initEventlistener();


	visualPage.genePlot.plot();
	if(visualPage.proteinPlot1!=null)
		visualPage.proteinPlot1.plot();

	if(visualPage.transcriptPlot!=null)
		visualPage.transcriptPlot.plot();

	//document.body.style.overflow=allowScroll?"":"hidden";


		//visualPage.proteinPlot2.plot();
		//visualPage.plotGene();
		//visualPage.plotProtein();
}


	//



//page initialization
function browser_init(event){
	console.log("your input xml is: "+event+".xml");
	
	if(window.addEventListener){
		//window.addEventListener('DOMMouseScroll',wheel,false);
	}

	function wheel(event)
	{
	    event.preventDefault();
	    event.returnValue=false;
	}
	//window.onmousewheel=document.onmousewheel=wheel;


	//initData();
	var ua = navigator.userAgent.toLowerCase();
	//console.log(ua);
	//alert(navigator.appName);
	//console.log(getBrowserName());
	initFirstPage();
	initVisualPage(event);


	//getElementById('div_register').setAttribute("style","width:500px");

	//var data=ASPlot.parseXML("all.xml");
	//alert(data.position);
	//var loadingPage=new ASPlot.firstPage("all.xml");
	//loadingPage.plotAS();
	
}


