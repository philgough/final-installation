// poisson points object
PoissonPoints pp;



// graphics context on which to draw the river
PGraphics riverBG;
PImage riverBuffer;

// river background variables
PVector[] locations;

int[] pixelList;
float[] hueList;
float[] satList;
volatile boolean bufferReady = false;


// how far to distort the poisson distribution for the river view
float widthScale = 10;


void ppSetup(float pp_w, float pp_h) 
{
  // create the poisson distribution
  pp = new PoissonPoints(this, 10000, 10, 40, pp_w, pp_h);

  // initialize the river graphic
  riverBG = createGraphics(int(pp_w), int(pp_h));


  riverBG.beginDraw();
  riverBG.colorMode(HSB, 360, 100, 100, 100);
  PVector[] locations = new PVector[0];

  //println("map locations");
  for (int i = 0; i < pp.ppLocations.length; i++) 
  {
    float mapx = map(pp.getPPLocation(i).x, 0, pp_w, 0, pp_w*widthScale);
    //    if (mapx <= width) {
    PVector pv = new PVector(mapx, pp.getPPLocation(i).y);
    //      PVector[] tempLocations = new PVector[locations.length + 1]
    locations = (PVector[]) append(locations, pv);
  }

  riverBG.loadPixels();
  pixelList = new int[riverBG.pixels.length];
  hueList = new float[riverBG.pixels.length];
  satList = new float[riverBG.pixels.length];
  for (int x = 0; x < pp_w; x++) 
  {
    for (int y = 0; y < pp_h; y++) 
    {
      int closestLocation = 0;
      float distToClosestLocation = 9001;
      for (int i = 0; i < locations.length; i++) 
      {
        // color colour = color(i, 100, 100, 100);
        float mapx = map(pp.getPPLocation(i).x, 0, pp_w, 0, pp_w*widthScale);
        float distToThisLocation = dist(mapx, pp.getPPLocation(i).y, x, y);
        if (distToThisLocation < distToClosestLocation) 
        {
          distToClosestLocation = distToThisLocation;
          closestLocation = i;
        } // end if
      } // end for i
      int xyToPixelArray = x + y * int(pp_w);
      pixelList[xyToPixelArray] = closestLocation;
      hueList[xyToPixelArray] = 200+(pixelList[xyToPixelArray])%10;
      satList[xyToPixelArray] = 70+(pixelList[xyToPixelArray])%10;
    } // end for y
  } // end for x
  riverBG.endDraw();
  riverBuffer = riverBG.get();
}




void drawRiverBG() {
  println("starting river draw thread");
  while(true)
  {
  //bufferReady = true;
  riverBG.beginDraw();
  riverBG.loadPixels();
  // colour the pixels by their nearest cell
  for (int i = 0; i < riverBG.pixels.length; i++) {
    satList[i] += sin(radians(pixelList[i] * frameCount*0.0015)) * 10;
    riverBG.pixels[i] = color(hueList[i], satList[i], 100, 100);
  }
  riverBG.updatePixels();
  riverBG.endDraw();
  bufferReady = false;
  riverBuffer = riverBG.get();
  bufferReady = true;
  }
}