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

  fill(0);
  noStroke();
  thread("drawRiverBG");

}


void draw() 
{
  //drawRiverBG();
  rect(0, 0, width, height);
  
  text(frameRate, 10, 10);
  //if (bufferReady)
  //{  
  //  image(riverBuffer, 0, 300);
  //}
  //else
  //{
  //  image(riverBG, 0, 300);
  //}
  image(riverBG, 0, 300);
}