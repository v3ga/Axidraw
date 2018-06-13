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

ArrayList<Boid> boids;
ArrayList<PVector> targets;

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
  boids = new ArrayList<Boid>();
  createTargets(4, 4);
  createBoids(1);
}

// --------------------------------------------------
void createTargets(int resx, int resy)
{
  targets = new ArrayList<PVector>();

  float wBlock = width/float(resx);
  float hBlock = height/float(resy);
  float y = 0;
  float x = 0;
  float dirx = 1;
  for (int j=0; j<resy; j++)
  {
    x =  ( (j%2 == 0) ? 0.5*wBlock : resx*wBlock-0.5*wBlock); 
    dirx = (j%2 == 0) ? 1 : -1; 
    y = j*hBlock + 0.5*hBlock;
    for (int i=0; i<resx; i++)
    {
      targets.add( new PVector(x, y) );
      x = x+dirx*wBlock;
    }
  }
}

// --------------------------------------------------
void createBoids(int nbBoids)
{
  for (int i=0; i<nbBoids; i++)
  {
    Boid b = new Boid(0, 0);
    b.targetIndex = 0;

    boids.add( b );
  }
}

// --------------------------------------------------
void drawTargets()
{
  pushStyle();
  noStroke();
  fill(0);
  rectMode(CENTER);
  for (PVector p : targets)
    rect(p.x, p.y, 6, 6);
  popStyle();
}

// --------------------------------------------------
void drawBoids()
{
  for (Boid b : boids)
  {
    b.render();
    b.renderHistory();
  }
}

// --------------------------------------------------
void draw()
{
  background(255);

  PVector target = null;
  int nbTargets = targets.size();
  for (Boid b : boids)
  {
    target = targets.get(b.targetIndex);

    b.update();
    PVector force = b.seek( target );
    b.applyForce(force);

    if (dist(b.position, target) < 5)
    {
      b.targetIndex = (b.targetIndex+1)%nbTargets;
    }
  }
  drawTargets();
  drawBoids();
}