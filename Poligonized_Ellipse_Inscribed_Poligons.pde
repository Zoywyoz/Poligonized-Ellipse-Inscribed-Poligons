float sides = 3; // Number of sides the polygons will have
float limr = 0; // Minimun value of the radius of the smallest polygon
int polygons = 49; // Maximun number of polygons that will be created 

// RECORDING
int nFramesInLoop = 300;
int nElapsedFrames;
boolean bRecording;

void setup() {
  size(1080, 1080);
  
  // RECORDING
  frameRate(30);
  bRecording = true;
  nElapsedFrames = 0;
}

void renderMyDesign (float percent) {
  
  float angle = map(cos(map(percent, 0, 1, 0, PI)), -1, 1, 0, TWO_PI/sides); // Value of the difference in rotation between two adjacent polygons
  float factor = map(cos(map(percent, 0, 1, 0, TWO_PI)), -1, 1, 0, 1); // Value that goes from 0 to 1, it is used to create the animation
  float inverseFactor = map(factor, 0, 1, 1, 0); // Instead of going from 0 to 1 it goes from 1 to 0
  
  float theta = HALF_PI * (sides-2) / sides;
  float maxR = width * 0.46;
  float mRs;
  float minR;

  translate(width/2, height/2);
  if (sides == 3) translate(0, height/14 * factor);  // Correction of position to compensate bad composition when sides = 3
  
  rotate(-theta); // Rotation to make the project more visually attractive
  rotate(map(cos(map(percent, 0, 1, 0, PI)), 0, 2, 0, TWO_PI));
  
  colorMode(HSB, 255);
  noStroke();
  background(80);

  for (int n = 0; n < polygons; n++) {
    
    maxR *= sin(HALF_PI * (1 - 2 / sides)) / sin(HALF_PI * (1 + 2 / sides) - angle);
    mRs = maxR * sin(theta);
    minR = mRs / sin(PI/sides);
    
    // BLACK AND WHITE - CHECKBOARD PATTERN
    fill(255);
    if ((n%2) == 0) fill(0);
    
    beginShape();
    for (float initialAngle = 0; initialAngle < sides; initialAngle++) {
      for (float alpha = 0; alpha < TWO_PI/sides; alpha += PI/60) {
        float r = (mRs / (sin(PI - alpha - theta)) - minR) * factor + minR + minR*2 * inverseFactor;
        float x = cos(alpha + TWO_PI/sides * initialAngle) * r;
        float y = sin(alpha + TWO_PI/sides * initialAngle) * r;
        vertex(x, y);
        if (r <= limr) n = polygons;
      }
    }
    endShape(CLOSE);
    rotate(angle);
  }
}

void draw() {
  float percentCompleteFraction = 0; 
  if (bRecording) {
    percentCompleteFraction = (float) nElapsedFrames / (float)nFramesInLoop;
  } else {
    percentCompleteFraction = (float) (frameCount % nFramesInLoop) / (float)nFramesInLoop;
  }

  renderMyDesign (percentCompleteFraction);

  if (bRecording) {
    saveFrame("3sds_10s_b&w/frame" + nf(nElapsedFrames, 4) + ".png");
    nElapsedFrames++; 
    if (nElapsedFrames >= nFramesInLoop) {
      bRecording = false;
    }
  }
}
