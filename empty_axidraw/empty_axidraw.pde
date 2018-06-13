// --------------------------------------------------
import controlP5.*;
import java.io.*;
import java.util.*;
import java.lang.reflect.*;
import java.awt.event.*;
import toxi.geom.Vec2D;

// --------------------------------------------------
PApplet applet;
ArrayList<Format> formats;
ControlP5 cp5;

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
}

// --------------------------------------------------
void draw()
{
  background(255);
}