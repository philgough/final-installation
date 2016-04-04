Cogs cogs;
float counter = 0;
void setup() 
{
  size(800, 600);
  colorMode(HSB, 360, 100, 100, 100);
  setupCogs();
}

void draw() 
{
  background(0);
  //shape(cogs.cogSprite, width/2, height/2);
  pushMatrix();
  translate(width/2, height/2);
  rotate(counter);
  shape(cogs.cogSprite, 0, 0);
  popMatrix();
  counter += 0.01;
}


void setupCogs()
{
    cogs = new Cogs();

}

class Cogs
{
  PGraphics cogImage;
  PShape cogSprite;
  //dimensions = new PVector (50, 60);
  float inner = 100.0;
  float outer = 105.0;
  Cogs ()
  {
    cogImage = createGraphics(width, 500);
    cogSprite = createShape();
    //cogSprite.setFill();
    drawCogSprite();
  }

  void drawCogSprite() 
  {
    // start the shape
    cogSprite.beginShape();
    cogSprite.fill(0, 10);
    cogSprite.stroke(40, 100, 80);
    // start the outer contour
    //cogSprite.beginContour();
    for (float i = 0.0; i < 360; i += 6)
    {
      float ifVal = (i % 4)/1.0;
      if (ifVal < 2)
      {
        float x = inner * sin(radians(i));
        float y = inner * cos(radians(i));
        cogSprite.vertex( x, y );
        float u = outer * sin(radians(i));
        float v = outer * cos(radians(i));
        cogSprite.vertex( u, v );
      } else 
      {
        float x = outer * sin(radians(i));
        float y = outer * cos(radians(i));
        cogSprite.vertex( x, y );
        float u = inner * sin(radians(i));
        float v = inner * cos(radians(i));
        cogSprite.vertex( u, v );
      }
    }
    //cogSprite.endContour();

    // start the inner cutouts
    for (float i = 1; i < 5; i++)
    {
      cogSprite.beginContour();
      float startValue = 130 + 90 * i;
      float endValue = 50 + 90 * i;
      for (float j = startValue; j > endValue; j-= 2) {
        float x = 90 * sin(radians(j));
        float y = 90 * cos(radians(j));
        cogSprite.vertex(x, y);
      }

      for (float k = startValue; k > endValue; k -= 10)
      {
        float x = 10 * sin(radians(k));
        float y = 10 * cos(radians(k));
        cogSprite.vertex(x, y);
      }
      
      cogSprite.endContour();
    }
    // finish off the shape
    cogSprite.endShape(CLOSE);
  }
}