/*
 * This macro reads training data and extract features of the cells to perform feature inference on unseen samples 
 * 1. read the original image 
 * 2. read nucleus and citoplasm (notice that the assumption here is that there's no dependency between the nucleus and the cytoplasm it depends upon
 * 3. mask nucleus and extract features
 * 4. mask cytoplasm and extract features
 * 
 * Created by: 
 * 	Dani Ushizima - dani.lbnl@gmail.com
 * 	03/24/2015
 */

//Input path - ushizima=laptop, dani=desktop
	var username="ushizima";
	//graylevel images
	var pathOriginal = "/Users/"+username+"/Dropbox/aqui/others/Cervix/ISBI2015/data/nossosResultados/testLBNL/EDF/";
	//"/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/nossosResultados/testandoAvaliacao/verdadeTerrestre/segmentacao (1)";
	
	//binary images from the conference
	var pathRoot = "/Users/ushizima/Dropbox/aqui/others/Cervix/ISBI2015/data/imagensOriginais/Training_R1_01Dec2014/Training/"
	var pathRootNuc = pathRoot + "nucleoGT/frame0";
	var pathRootCito =  pathRoot + "seg_frame";

//Output
	var pathOutput = pathRoot + "features/";

//"/Users/ushizima/Dropbox/aqui/others/Cervix/isbi2015/data/nossosResultados/testLBNL/resSPVD_0322/"

macro "featureExtractionNucCit" {
	
	run("Close All");
	//Output path
	File.makeDirectory(pathOutput);
	
	FileList = getFileList(pathOriginal);
	N=FileList.length;
	print(N);

	//frame004_NUGT.png
	//seg_frame004_png/
	
	start = getTime; 

	
	
		for (k=0;k<N;k++){
			open(pathOriginal+FileList[k]); //opens the original image
			rename("cinza");
			nImgFile = split(FileList[k],"frame");
			nImgFile = split(nImgFile[0],".");
			nImgFile = nImgFile[0];
			imgFile = "frame"+nImgFile+".tif"; //results save as tif :/ 
			print(imgFile);
			//papsmearMeasure(imgFile); //main function!!!
			
		}
		
}


/***************************************************************
* Create borders for nuc and cit to overlay on original image *
***************************************************************/
function papsmearSeg(imgFile){
		
	filename=getTitle();
	//a = fParseFileName(filename);
	if(1==0)
		print("Error open images --- check line 44");
	else{
		
		//mount paths for nuc and cito
		open(pathRootNucCito+"frame000CitoNucleo"+imgFile);

		
		rename("nucleo");
		run("Find Edges");
		run("Invert");
		imageCalculator("AND", "cinza","nucleo");
		selectWindow("nucleo");
		run("Invert");
		
		open(pathRootNucCito+"cito/"+imgFile);
		rename("cito");
		run("Find Edges");
		run("Invert");
		imageCalculator("AND", "cinza","cito");
		selectWindow("cito");
		run("Invert");
		//run("Tile");
		wait(100);
		
		//create rgb images with each open image as one channel
	 	run("Merge Channels...", "c1=cito c3=nucleo c4=cinza"); //
	 	saveAs("Tiff", pathOutput+imgFile+".tif");
	 	wait(200);
	 	close();
	 	
	}
	
}
		
	
