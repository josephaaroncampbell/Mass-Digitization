////////////////////////////////////////////////////////////////////////////
//Creator: Joseph Aaron Campbell
//http://josephaaroncampbell.com
//Photographer/Imaging Specialist
// Copyright 2015 - Chicago Historical Society
/////////////////////////////////////////////////////////////////////////////

//assign a name to the original open document
var originalDoc = activeDocument;
var scriptPath = Folder(File($.fileName).parent).fullName;

//remove dialogs
displayDialogs = DialogModes.NO; 

//store the ruler unit for later use
var originalUnit = preferences.rulerUnits;
//change document ruler to pixels  
preferences.rulerUnits = Units.PIXELS;

//set the foreground color to black
app.foregroundColor.rgb.red = 0;
app.foregroundColor.rgb.green = 0;
app.foregroundColor.rgb.blue = 0;
//set the background color to white
app.backgroundColor.rgb.red = 255;
app.backgroundColor.rgb.green = 255;
app.backgroundColor.rgb.blue = 255;

//return the color mode [ greyscale, rgb, cmyk...]
var originalMode = originalDoc.mode;

//return the color profile [ adobe98 or srgb, or custom ]
//ONLY IF not LAB color mode
if(originalMode != DocumentMode.LAB){
    var originalProfile = app.activeDocument.colorProfileName;
}

//record the height and width of the document for later use
var originalH = originalDoc.height;
var originalW = originalDoc.width;

//return value of current dpi for original active document
var originalRes = originalDoc.resolution;
//return the originalDocuments  bitdepth
var originalBit = originalDoc.bitsPerChannel;

//open the target file
var fileRef = File(scriptPath + "/Digital-Reference.tif");
var targetDoc = app.open(fileRef);
//make target file the activeDocument
app.activeDocument = targetDoc;

//LAB color mode does not accept color profiles
//run ONLY IF not LAB
if(originalMode != DocumentMode.LAB){
    //change the color space to match the original
    targetDoc.convertProfile(originalProfile, Intent.RELATIVECOLORIMETRIC, true, false);
}

// change bitdepth to match original document
targetDoc.bitsPerChannel = originalBit;
//change resolution to match original document
targetDoc.resizeImage(undefined,undefined, originalRes);

//store height of target after image size change
targetH = targetDoc.height;

//select all of target file
app.activeDocument.selection.selectAll()
//copy target file
app.activeDocument.selection.copy()

////close target file
targetDoc.close(SaveOptions.DONOTSAVECHANGES);

//make original file the activeDocument
app.activeDocument = originalDoc;

//set length to extend canvas
extendH=targetH + originalRes/8;
//resize the canvas by adding the resolution in pixels to document height, centering from the top center anchor 
var canvasExt = (originalDoc.height + extendH );
originalDoc.resizeCanvas(undefined, canvasExt, AnchorPosition.TOPCENTER);

//define the new selection area
var shapeRef = [
    [0,originalH],// top left
    [originalW, originalH],//top right
    [originalW, canvasExt],//bottom right
    [0,canvasExt]//bottom left
]

//select the defined area
originalDoc.selection.select(shapeRef);

//store the bounds of the new selection
var boundsLeft =activeDocument.selection.bounds[0];
var boundsTop = activeDocument.selection.bounds[1];
var boundsRight= activeDocument.selection.bounds[2];
var boundsBottom= activeDocument.selection.bounds[3];

//alert(boundsTop);

//paste target file
originalDoc.paste();

////function makeLine(leftAnchor, rightAnchor, topAnchor, opacityValue%)
///draws the line that seperates the new target white space and original document
makeLine (boundsLeft, boundsRight, boundsTop, 50);

//flatten the original Document
originalDoc.flatten();

// Restore original ruler unit setting
app.preferences.rulerUnits = originalUnit;



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function makeLine(leftAnchor, rightAnchor, topAnchor, opacityValue){
var idDraw = charIDToTypeID( "Draw" );
    var desc181 = new ActionDescriptor();
    var idShp = charIDToTypeID( "Shp " );
        var desc182 = new ActionDescriptor();
        var idStrt = charIDToTypeID( "Strt" );
        //////////////////////LEFT ANCHOR//////////////////////////////////////
            var desc183 = new ActionDescriptor();
            var idHrzn = charIDToTypeID( "Hrzn" );
            var idPxl = charIDToTypeID( "#Pxl" );
            desc183.putUnitDouble( idHrzn, idPxl, leftAnchor );// left anchor
            var idVrtc = charIDToTypeID( "Vrtc" );
            var idPxl = charIDToTypeID( "#Pxl" );
            desc183.putUnitDouble( idVrtc, idPxl, topAnchor );// left top anchor
        var idPnt = charIDToTypeID( "Pnt " );
        desc182.putObject( idStrt, idPnt, desc183 );
        var idEnd = charIDToTypeID( "End " );
        ////////////////////////RIGHT ANCHOR////////////////////////////////
            var desc184 = new ActionDescriptor();
            var idHrzn = charIDToTypeID( "Hrzn" );
            var idPxl = charIDToTypeID( "#Pxl" );
            desc184.putUnitDouble( idHrzn, idPxl, rightAnchor);// right anchor
            var idVrtc = charIDToTypeID( "Vrtc" );
            var idPxl = charIDToTypeID( "#Pxl" );
            desc184.putUnitDouble( idVrtc, idPxl, topAnchor );//right top anchor
        var idPnt = charIDToTypeID( "Pnt " );
        desc182.putObject( idEnd, idPnt, desc184 );
        //////////////////////WIDTH//////////////////////////////////////////////
        var idWdth = charIDToTypeID( "Wdth" );
        var idPxl = charIDToTypeID( "#Pxl" );
        desc182.putUnitDouble( idWdth, idPxl, 1.000000 );//width of line
    var idLn = charIDToTypeID( "Ln  " );
    desc181.putObject( idShp, idLn, desc182 );
    //////////////////OPACITY////////////////////////////////////////
    var idOpct = charIDToTypeID( "Opct" );
    var idPrc = charIDToTypeID( "#Prc" );
    desc181.putUnitDouble( idOpct, idPrc, opacityValue );//opacity percentage
    ////////////////////////ANIT ALIASING////////////////////////////////
    /////////////////////////TURN THIS OFF////////////////////////////
    var idAntA = charIDToTypeID( "AntA" );
    desc181.putBoolean( idAntA, false);// set to false to turn off aliasing
executeAction( idDraw, desc181, DialogModes.NO );
    
    }// end makeLine

