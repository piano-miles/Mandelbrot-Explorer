float z = 0; 
int n = 0; 
float h = 0;
float s = 0;
float v = 100;
float a = 0;
float b = 0;
float b2 = 0; //new b
float a2 = 0; //new a
float b3 = 0; //original b
float a3 = 0; //original a
float bright = 255; 
//starting zoom level, usually a value of 2
float zoom = 2;
//coordinates
float xoff = 0;
float yoff = 0;
int iterations = 50; 
int imageInt = 1; 
float zoomFac = 0.1; 
float zoomSpeed = 1;
float zoomTar = 1.05;
boolean newCoordinate = true;
boolean notPause = true;

PImage fractalExport;

//f(z) = z^2 + c
//a^2-b^2 + 2abi

void setup() {  // this is run once.  
  size(1440, 900); 
  frameRate(30);
  background(200, 100, 100);
  colorMode(HSB, 100);
  smooth(); 
  fractalExport = createImage(width, height, 0); 
  zoomFac = 1;
} 

void draw() {
  if (notPause) {
    zoomFac = float(width)/float(height);
    fractalExport.loadPixels();
    for (int i=0; i<width; i++) {
      for (int j=0; j<height; j++) {
        a = map(i, 0, width, -zoom+xoff, zoom+xoff); 
        b = map(j, 0, height, (-zoom/zoomFac)-yoff, (zoom/zoomFac)-yoff);

        n = 0;
        z = 0;

        a3 = a;
        b3 = b;

        while (n < iterations) {
          a2 = (a*a) - (b*b);
          b2 = 2*a*b; 
          a = a2 + a3; 
          b = b2 + b3; 
          if ((a2*a2) + (b2*b2) > 4.6225) {
            break;
          }
          n++;
        }
        bright = map(n, 0, iterations, 0, 100); 
        //bright = map((sqrt(bright)+(bright*20))/21, 0, 1, 0, 100); 
        if (n == iterations) {
          bright = 0;
        }

        bright = bright*(iterations/50);
        bright = bright%100;

        h = ((bright-50)*2)%100;
        s = 50;
        v = bright;
        fractalExport.pixels[i + (j*width)] = color(h, s, v);
      }
    }
    fractalExport.updatePixels();
    image(fractalExport, 0, 0);
    notPause = false;
  }
  if (mousePressed && (mouseButton == LEFT)) {
    zoom = zoom/zoomSpeed;
    zoomSpeed = ((zoomSpeed*5)+zoomTar)/6;
    iterations = 100; 
    if (newCoordinate) {
      xoff += 2*((mouseX-(width/2))*zoom)/width;
      yoff += 1.25*(((height-mouseY)-(height/2))*zoom)/height;
      newCoordinate = false;
    }
    notPause = true;
  } else {
    zoomSpeed = (zoomSpeed+1)/2;
    newCoordinate = true;
  }
  if (iterations<200) {
    fill(0, 0, 255, 20);
    rectMode(CENTER);
    rect(width/2, height/2, 10, 10);
  }
}

void keyPressed() {
  if (key == 'r') {
    iterations = 1000;
    notPause = true;
  }
  if (key == 'e') {
    fractalExport.save("MandelbrotExplorerExport" + str(imageInt) + ".png");
    imageInt++;
  }
}
