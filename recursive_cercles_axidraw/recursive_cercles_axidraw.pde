// --------------------------------------------------
import java.io.*;
import java.util.*;
import java.lang.reflect.*;
import java.awt.event.*;
import toxi.geom.Vec2D;
import controlP5.*;
PApplet applet;
ArrayList<Format> formats;
Circle root;
boolean bPause = false;
ControlP5 cp5;

float radius_min = 5;
float radius_size_factor = 0.75;
float radius_factor = 1.0;
float angle_speed_min = 1, angle_speed_max = 3;
float angle_speed_child = 0.5;
boolean bDrawFilled = true;


// --------------------------------------------------
void settings()
{
  applet=(PApplet)this;
  defineFormats();
  applyFormatSize("28x22");
}

// --------------------------------------------------
void setup()
{
  initControls();
  generate();
}

// --------------------------------------------------
void draw()
{
  background(255);
  root.update();
  root.draw();
  drawControls();
}


// --------------------------------------------------
void drawControls()
{
  pushStyle();
  fill(0,100);
  noStroke();
  rect(0,0,400,300);
  popStyle();
  cp5.draw();
}

// --------------------------------------------------
void initControls()
{
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  int w = 200;
  int h = 20;
  cp5.addToggle("bDrawFilled").setLabel("draw filled").setSize(h,h).linebreak();
  cp5.addSlider("radius_min").setSize(w,h).setLabel("radius min").setMin(5).setMax(50).linebreak();
  cp5.addSlider("radius_size_factor").setSize(w,h).setMin(0.5).setMax(0.95).setLabel("radius size factor").linebreak();
  cp5.addSlider("angle_speed_child").setSize(w,h).setMin(0.0).setMax(2.0).setLabel("angle speed child").linebreak();
  cp5.addButton("export").setSize(w/2,h).setLabel("axidraw export").linebreak();
}

// --------------------------------------------------
void controlEvent(ControlEvent event)
{
  String name = event.getName();
  if (name.equals("radius_min") || name.equals("radius_size_factor"))
  {
    generate();
  }
  else if (name.equals("angle_speed_child"))
  {
    root.modifyAngleSpeed();
  }
}

// --------------------------------------------------
void generate()
{
  root = new Circle(null,0.5*0.95*min(width,height));
  root.setPos(width/2, height/2);
}

// --------------------------------------------------
void keyPressed()
{
  if (key == ' '){
      bPause = !bPause;
      root.setPause(bPause);
  }
}

// --------------------------------------------------
public void export(int value)
{
  exportAxidraw("data/exports/axidraw_circles_"+timestamp()+".json", root, true);
}