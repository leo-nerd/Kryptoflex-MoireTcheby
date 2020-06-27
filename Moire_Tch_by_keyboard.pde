//import promidi.*;

//MidiIO midiIO;

float s = 0 ;
float t = 0 ;
float u = 0 ;
float w = 0 ;
float ww = 0 ;
float ax = 0 ;
float ay = 0 ;
float tx = 0 ;
float tx2 = 0 ;
float ty = 0 ;
float ty2 = 0 ;
float rotAngle = 0 ;

//int hMax = 1200 ;
int defaultWidth = 2000 ;
int windowSize = 1080 ;
//int windowSizeH = 768 ;
//int windowSizeW = 1080 ; 
int squareWidth = 6 ; //pixels
int dotCount = floor(defaultWidth/squareWidth) ;
int startPos = 0 ;
//int order = 9 ;

int backX = 0 ;
int backY = 0 ;

float[] vSpher = { defaultWidth, t, u } ;
float[] vCart = { 0, 0, 1 } ;

float[] xPos = new float[dotCount];
float[][] zMat = new float[dotCount][dotCount] ; 
float[][] kMat = new float[dotCount][dotCount] ;
float[][] xMat = new float[dotCount][dotCount] ;
float[][] yMat = new float[dotCount][dotCount] ;

//Controller controller;

void setup() {
  
  noSmooth();
  
  //println(dotCount) ;

  fill(0);
  frameRate(30);
  noStroke();
  //stroke(0);
  //textSize(5);

  // get an instance of midiIO
  //midiIO = MidiIO.getInstance(this);

  // print a list of all devices
  //midiIO.printDevices();

  //midiIO.openInput(1, 0);


  size(1080, 1080);
  colorMode(HSB);

  startPos = floor((windowSize - defaultWidth) / 2 ) ; 

  for (int i = 0; i < dotCount - 1; i++) {
    xPos[i] = squareWidth * i + startPos;
  }

  //fill(0) ;
}

void draw() {

  background(255) ;
  rotAngle = ( tx - 1 ) * HALF_PI / 126 ;

  fill(0);
  for (int i = 0; i < dotCount - 1; i++) {
    //if( dotCount % 2 != 0 ){ wb = -(wb - 255) ;}

    for (int j = i%2; j < dotCount - 1; j = j+2) {
      //fill(wb) ;
      
      backX = floor( ( xPos[i] - (defaultWidth - windowSize)/2 )* cos( rotAngle ) + ( xPos[j] - (defaultWidth - windowSize)/2) * sin( rotAngle ) + (defaultWidth  - windowSize)/2);
      backY = floor( -( xPos[i] - (defaultWidth - windowSize)/2 )* sin( rotAngle ) + ( xPos[j] -(defaultWidth - windowSize)/2) * cos( rotAngle ) + (defaultWidth  - windowSize)/2) ;
      //println(backX);
      //println(backY);
      rect( backX, backY, squareWidth, squareWidth) ;
      //point( xPos[i], xPos[j] ) ;
      //text("x",xPos[i], xPos[j]);
      
      //wb = -(wb - 255) ;
    }
  }

  ww = ( w - 1 ) / 126 * ( 10 ) + 1 ; //value between brackets = zoom factor
  tx2 = tx % (10 * squareWidth) ;
  //println(tx2); 
  ty2 = ty % (10 * squareWidth) ;
  //println(ty2); 

  for (int i = 0; i < dotCount - 1; i++) {
    for (int j = i%2; j < dotCount - 1; j = j+2) {

// #### SOME FUNCTIONS
      //println("xPos[i] = ", xPos[i], "xPos[j] = ", xPos[j]) ;

      //zMat[i][j] = s*(xPos[i]*xPos[i]/defaultWidth/defaultWidth + xPos[j]*xPos[j]/defaultWidth/defaultWidth) ;
      //zMat[i][j] = s*xPos[i]/(xPos[j]+1) ;

      //zMat[i][j] = cos(xPos[i]+xPos[j]);

      //zMat[i][j] = cos(xPos[i]/s)*cos(xPos[j]/s);
      //zMat[i][j] = cos(xPos[i]/s)*cos(xPos[j]/s) + 1;
      //zMat[i][j] = zMat[i][j] + 10*(xPos[i]*xPos[i]/defaultWidth/defaultWidth + xPos[j]*xPos[j]/defaultWidth/defaultWidth);

      //zMat[i][j] = s*pow((xPos[i] - 1/2), 3)/10000000 + s*pow((xPos[j] - 1/2), 2)/10000000 - (xPos[i] - 1/2) - (xPos[j] - 1/2);
      
// #### CHEBYSHEV POLYNOMIALS
      zMat[i][j] = s * cos(ax*acos((xPos[i] - tx2 + startPos)/(defaultWidth/2)/ww))/2 + s * cos(ay*acos((xPos[j] - ty2 + startPos)/(defaultWidth/2)/ww))/2 ;  
      //zMat[i][j] = s * cos(ax*acos((xPos[i] + startPos)/(defaultWidth/2)/ww))/2 + s * cos(ay*acos((xPos[j] + startPos)/(defaultWidth/2)/ww))/2 ;

// #### PROJECTION
      //println("xPos[i]*xPos[i]/defaultWidth/defaultWidth = ",xPos[i]*xPos[i]/defaultWidth/defaultWidth) ;
      //println("z = ", zMat[i][j]);
      
      kMat[i][j] = -zMat[i][j] / vCart[2] ;
      //println("z = ", zMat[i][j]);
      xMat[i][j] = floor( xPos[j] + kMat[i][j] * vCart[0] );
      //println("z = ", zMat[i][j]);
      yMat[i][j] = floor( xPos[i] + kMat[i][j] * vCart[1] );

      //      println(i,", ",j);
      //println("xMat[i][j] = ", xPos[i] + kMat[i][j] * v[1], "yMat[i][j], ", xPos[i] + kMat[i][j] * v[1], "z = ", zMat[i][j]) ;
      //println("k = ", kMat[i][j]);
      //      println(v);
      
      rect( xMat[i][j], yMat[i][j], squareWidth, squareWidth ) ;
      //point( xMat[i][j], yMat[i][j] );
      //text( "x", xMat[i][j], yMat[i][j] );
    }
  }

// #### CALCULATING NEXT PROJECTION VECTOR
  vSpher[1] = ( t ) / 126 * TAU ; //Azimut (TAU = 2π)
  vSpher[2] = ( u ) / 126 * HALF_PI;
  vCart = spherToCart( vSpher ) ;
  //println(vCart) ;
  
}

/*parameters:
s = amplitude
t = azimuth
u = elevation
w = zoom
*/

void keyPressed() {
  if (key == 'a'){
    ax = max(0, ax-5);
    println(ax);
  }
  if (key == 'd'){
    ax = min(255, ax+5);
    println(ax);
  }
  
  if (key == 's'){
    ay = max(0, ay-5);
    println(ay);
  }
  if (key == 'w'){
    ay = min(255, ay+5);
    println(ay);
  }

  if (key == 'j') {
    tx = max(0, tx-5);
    println(tx);
  }
  if (key == 'l') {
    tx = min(255, tx+5);
    println(tx);
  }
  
  if (key == 'i') {
    ty = min(255, ty+5);
    println(ty);
  }
  if (key == 'k') {
    ty = max(0, ty-5);
    println(ty);
  }
}
  void mouseMoved(){
    s = map(mouseX, 0, windowSize, 0, 255);
    w = s;
    println(s);
    t = map(mouseY, 0, windowSize, 0, 255);
    u = t;
    println(t);
  }
  
  
  //parameter ax (order of the x function)
  //if (a == 3) {
  //  ax = float(controller.getValue()) ;
  //  //println(ax);
  //}
  
  //if (a == 4) {
  //  ay = float(controller.getValue()) ;
  //  //println(ay);
  //}
  
  //if (a == 7) {
  //  tx = float(controller.getValue()) ;
  //  //println(tx);
  //}
  
  //if (a == 8) {
  //  ty = float(controller.getValue()) ;
  //  //println(ty);
  //}


float[] spherToCart( float[] vSpher ) {

  float r  = vSpher[0] ;
  float az = vSpher[1] ;
  float el = vSpher[2] ;
  float[] vCart = { 
    r * sin(el) * cos(az), r * sin(el) * sin(az), r * cos(el)
  };
  return vCart ;
}
