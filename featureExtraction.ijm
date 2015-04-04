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

//Input path - ushizima=cafofo, dani=trampo
	var username="ushizima";
	
	//binary images from the conference
	var pathRoot = "/Users/"+username+"/Dropbox/aqui/others/Cervix/ISBI2015/data/imagensOriginais/Training_R1_01Dec2014/Training/"
	//graylevel images
	var pathOriginal = pathRoot + "EDF/";
	//binary images from the conference
	var pathRootNuc = pathRoot + "NucleusGT/frame";
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

	start = getTime; 	
	
		for (k=0;k<N;k++){
			
			open(pathOriginal+FileList[k]); rename("orig");
			nImgFile = split(FileList[k],"frame");
			nImgFile = split(nImgFile[0],".");
			nImgFile = nImgFile[0];
			//imgFile = "frame"+nImgFile+".tif"; //results save as tif :/ 
			open(pathRootNuc+nImgFile+ "_NUGT.png"); rename("nuc");
			run("8-bit");	
			
			print(pathRootCito+nImgFile+"_png/"); 
			FileListCito = getFileList(pathRootCito+nImgFile+"_png/");
			Ncito=FileListCito.length;

			run("Analyze Particles...", "size="+0+"-Infinity pixels circularity=0.00-1.00 show=Masks in_situ stack");//100=40microns

			//for each cytoplasm
			for (c=0;c<Ncito;c++){
				print(pathRootCito+nImgFile+"_png/"+FileListCito[c]);
				rename("cito");
			}
			//rename("cito");
			
			jujuba
			//frame004_NUGT.png
			//seg_frame004_png/
			
			
			open(pathOriginal+FileList[k]); //opens the original image
			rename("cinza");
			
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
		
	
