PGraphics bg;


void setup () 
{
  size(1920, 1080);
  colorMode(HSB, 360, 100, 100, 100);
  bg = createGraphics(1920, 1080);

  bg.beginDraw();
  bg.background(0);
  bg.endDraw();

  // set up the poisson points for river/benthic backgrounds
  ppSetup(1920, 300);
  fill(360);
  noStroke();
}


void draw() 
{
  //drawRiverBG();
  // rect(0, 0, width, height);
  image(bg, 0, 0);  
  text(frameRate, 10, 10);
  // if the buffer isn't being drawn to right now
  image(riverBedBG, 0, (height - 300));  
  if (bufferReady)
  {
    // draw the watery image 
    image(riverBuffer, 0, height - 600);
  } else
  {
    // draw the image that the watery image is beign updated from.
    image(riverBG, 0, (height-600));
  } // end if/else bufferReady
  
}