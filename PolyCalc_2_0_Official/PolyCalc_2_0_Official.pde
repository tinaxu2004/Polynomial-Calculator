import g4p_controls.*;

float xMin, xMax, yMin, yMax;
float xRange, yRange;
float unitsPerPixel; //the ratio (aMax-aMin)/width;

//String s1 = "1x^2+1x+0";
//String s2 = "2x^2+1x+7";
String s1, s2;

int[][] poly;
int eStart, eEnd, cStart, cEnd, p, n;
String polyPrint = "";
String roots = "";
int selected = 0;

Polynomial a, b;
Polynomial aAndB, aDerive, bDerive;

boolean graphing = true;

void setup() {
  createGUI();
  size(800,800);
  background(255);
  
  xMin = -1.8;
  xMax = 0.5;
  yMin = -1.15;
  yMax = 1.15;
  
  unitsPerPixel = (xMax-xMin)/width;
  
  xRange = xMax - xMin;
  yRange = yMax - yMin;
    
  //a = new Polynomial(s1);
  //b = new Polynomial(s2);
  
  //a.printPoly();
  //b.printPoly();
  
  println();
  
  //aAndB = a.add(b);
  //aAndB.printPoly();
  
  //a.add(b).printPoly();
  //a.sub(b).printPoly();
  //a.mult(b).printPoly();
  
}

void draw() {
  if (graphing == true) {
    line(0,height/2,width,height/2);
    //line(width/2, 0, width/2, height);
    
  }
}
