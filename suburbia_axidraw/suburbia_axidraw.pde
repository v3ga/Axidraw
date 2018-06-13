// --------------------------------------------------
import java.io.*;
import java.util.*;
import java.lang.reflect.*;
import java.awt.event.*;
import processing.opengl.*;
import processing.pdf.*;
import controlP5.*;
import geomerative.*;
import toxi.geom.mesh.TriangleMesh;
import toxi.geom.mesh2d.*;
import toxi.geom.*;
import toxi.geom.Line2D;
import toxi.geom.Polygon2D;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.processing.*;
import toxi.math.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.*;

// --------------------------------------------------
boolean __DEBUG__ = false;

boolean doSaveframe = false;
boolean doSavePDF = false;
String filenameSave = "";

float subdivide_min = 200.0; // if subdivide_use_circumference = true
int subdivide_depth_max = 7;
boolean subdivide_use_circumference = false;
float subdivide_angle_normal = PI/10;
float subdivide_random = 0.95;
float[] subdivide_segment_f = { 0.2, 0.8 };
boolean subdivide_use_polygon_scale = true;
float subdivide_factor_polygon_scale = 1.00;
boolean subdivide_draw_filled = false;
boolean subdivide_draw_stroke = true;
float subdivide_draw_alpha = 100;
boolean subdivide_voronoi_compute_graph = true;

int voronoi_nb_points = 100;

int depth_max = 0;

int cp5_height = 18;
color cp5_group_bg_color = color(0, 50);
ScrollableList dlModes;


// --------------------------------------------------
ToxiclibsSupport gfx;
Mode modeCurrent = null;
ArrayList<Mode> modes;
ArrayList<Format> formats;

PApplet applet;
ControlP5 cp5;



// --------------------------------------------------
void initModes()
{
  modes = new ArrayList<Mode>();
  modes.add( new ModeGrid(10, 10) );
  modes.add( new ModeVoronoi() );
  modes.add( new ModeGeomerative("E", "Futura.ttf", 20) );
  modes.add( new ModeBox2D() );

  for (Mode mode : modes)
    mode.initControls();
  updateControlsMode();
}


// --------------------------------------------------
void initGlobals()
{
  applet=(PApplet)this;

  smooth();
  rectMode(CENTER);
  initLibs();
  frame.addMouseWheelListener(new MouseWheelInput()); 
  frame.setResizable(true);

  registerMethod("pre", this); // V2.0.3
}


// --------------------------------------------------
void initLibs()
{
  gfx = new ToxiclibsSupport( this );
  RG.init(this);
}

// --------------------------------------------------
void updateControlsMode()
{
  int indexMode = 0;
  for (Mode mode : modes) {
    dlModes.addItem(mode.name, indexMode++);
  }
}


// --------------------------------------------------
void generate()
{
  if (modeCurrent!=null)
    modeCurrent.generate();
}

// --------------------------------------------------
void selectMode(int which)
{
  if (which < modes.size())
  {
    Mode modeSelected = modes.get(which);
    if (modeCurrent == null || (modeCurrent != null && modeCurrent != modeSelected))
    {
      if (modeCurrent !=null)
      {
        modeCurrent.showControls(false);
      }

      modeCurrent = modeSelected;
      modeCurrent.setup();
      modeCurrent.showControls(true);

      println("selecting "+modeCurrent.name);
    }
  }
}


// --------------------------------------------------
void settings()
{
  defineFormats();
  //  applyFormatSize("30x40");  
  applyFormatSize("28x22");
}

// --------------------------------------------------
void setup()
{
  initGlobals();
  initControls();
  initModes();

  selectMode(3);
}

// --------------------------------------------------
void pre()
{
  if (currWidth != width || currHeight != height) 
  {
    if (modeCurrent!=null)
      modeCurrent.resize();

    currWidth = width;
    currHeight = height;
  }
}


// --------------------------------------------------
void draw()
{
  if (modeCurrent!=null)
  {
    modeCurrent.update();
    if (modeCurrent.isDrawBackground()) 
      background(255);
    modeCurrent.draw();
    if (modeCurrent!=null && __DEBUG__) 
      modeCurrent.drawDebug();

    if (doSaveframe) 
    {
      saveFrame("exports/img/export_"+timestamp()+".png");
      doSaveframe = false;
    }
    
    cp5.draw();
  } else
  {
    background(0);
  }
}

// --------------------------------------------------
void mouseMoved()
{
  if (cp5.getWindow(this).isMouseOver()) return;
  if (modeCurrent!=null)
  {
    modeCurrent.mouseMoved();
  }
}

// --------------------------------------------------
void mousePressed()
{
  if (cp5.getWindow(this).isMouseOver()) return;

  if (modeCurrent!=null)
  {
    modeCurrent.mousePressed();
  }
}

// --------------------------------------------------
void mouseDragged()
{
  if (cp5.getWindow(this).isMouseOver()) return;
}

// --------------------------------------------------
void mouseReleased()
{
  if (cp5.getWindow(this).isMouseOver()) return;
}

// --------------------------------------------------
void keyPressed()
{
  if (key >= '1' && key <= '9')
  {
    int index = key-'1';
    if (index < formats.size())
    {
      Format f = formats.get(index);
      if (f!=null)
      {
        f.applyFrameSize();
      }
    }
  } else
    if (key == 'e')
    {
      if (modeCurrent!=null) 
        modeCurrent.exportForAxidraw(true);
    } else
    {
      if (modeCurrent!=null) 
        modeCurrent.keyPressed();
    }
}