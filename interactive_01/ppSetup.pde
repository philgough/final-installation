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


// Graphics context for the riverbed
PGraphics riverBedBG;


// how far to distort the poisson distribution for the river view
float widthScale = 10;


void ppSetup(float pp_w, float pp_h) 
{
  // create the poisson distribution
  pp = new PoissonPoints(this, 10000, 10, 40, pp_w, pp_h);
  setupRiverBed(1920, 300);

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
  thread("drawRiverBG");
}

void drawRiverBG() {
  println("starting river draw thread");
  // loop forever
  while (true)
  {
    // start drawing the background
    riverBG.beginDraw();
    // load the pixels from the image
    riverBG.loadPixels();
    // pick one frame and stick with it for the entire loop (we aren't in the draw function any more, toto), or the water looks streaky.
    float thisFrame = frameCount * 0.0015;
    // colour the pixels by their nearest cell
    for (int i = 0; i < riverBG.pixels.length; i++) {
      float satVal = satList[i] + sin(radians(pixelList[i] * thisFrame)) * 10;
      riverBG.pixels[i] = color(hueList[i], satVal, 100, 100);
    }
    // that's the drawing we're gonna do
    riverBG.updatePixels();
    riverBG.endDraw();
    // let the draw loop know that we're updating the buffer
    bufferReady = false;
    // update the buffer
    riverBuffer = riverBG.get();
    // tell the draw loop we're done
    bufferReady = true;
  }
}




void setupRiverBed (int rb_w, int rb_h) 
{
  println("drawing river bed");
  riverBedBG = createGraphics(rb_w, rb_h);

  riverBedBG.beginDraw();
  riverBedBG.fill(100, 100, 100);
  riverBedBG.rect(0, 0, rb_w, rb_h);  
  riverBedBG.loadPixels();

  for (int x = 0; x < rb_w; x++) 
  {
    for (int y = 0; y < rb_h; y++) 
    {
      int closestLocation = 0;
      float distToClosestLocation = 9001;
      for (int i = 0; i < pp.ppLocations.length; i++) 
      {
        // which is the closest poisson point to the current pixel
        float distToThisLocation = dist(pp.getPPLocation(i).x, pp.getPPLocation(i).y, x, y);
        if (distToThisLocation < distToClosestLocation) 
        {
          distToClosestLocation = distToThisLocation;
          closestLocation = i;
        } // end if
      } // end for i
      int xyToPixelArray = x + y * int(rb_w);
      // draw onto the image
      float rb_hue = 10+(closestLocation)%15;
      float rb_sat = 70+(closestLocation)%20;
      riverBedBG.pixels[xyToPixelArray] = color(rb_hue, rb_sat, 60);
    } // end for y
  } // end for x
  
  
  riverBedBG.updatePixels();
  riverBedBG.endDraw();
  
  println("finished drawing riverbed");
  
}