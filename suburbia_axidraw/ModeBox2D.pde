class ModeBox2D extends Mode
{
  String cp5_prefix = "";
  Box2DProcessing box2d;
  Surface surface;
  ArrayList<Box> boxes;
  float gravity = 0;
  Slider sliderGravity;
  ArrayList<Area> areas;
  ArrayList<Polygon2D> polygons;
  float alphaBox = 0.3;

  ModeBox2D()
  {
    name = "PHYSICS";
    cp5_prefix = "box2d";
  }

  // --------------------------------------------------
  void initControls()
  {
    super.initControls();

    cp5.begin(5, 5);
    sliderGravity = cp5.addSlider(cp5_prefix+"_gravity").setGroup(this.cp5Group).setHeight(cp5_height).addListener(this).setPosition(5, 25).setRange(-10, 10).setValue(gravity);
    cp5.addSlider(cp5_prefix+"_alpha").setGroup(this.cp5Group).setHeight(cp5_height).addListener(this).setPosition(5, 50).setRange(0, 1).setValue(alphaBox);
    cp5.end();
  }  

  // --------------------------------------------------
  public void controlEvent(ControlEvent event)
  {
    String name = event.getName();
    if (name.equals(cp5_prefix+"_gravity"))
    {
      gravity = event.getController().getValue();
    }
    else if (name.equals(cp5_prefix+"_alpha"))
    {
      alphaBox = event.getController().getValue();
    }
  }

  // --------------------------------------------------
  void setup()
  {
    box2d = new Box2DProcessing(applet);
    box2d.createWorld();
    // We are setting a custom gravity
    box2d.setGravity(0, gravity);
    surface = new Surface(box2d);
    boxes = new ArrayList<Box>();
  }

  // --------------------------------------------------
  void draw()
  {
    box2d.setGravity(0, gravity);
    box2d.step();

    // Display all the boxes
    pushStyle();
    noStroke();
    fill(0,alphaBox*255);
    for (Box b : boxes) {
      b.display();
    }
    popStyle();

    if (areas == null) return;
    for (Area area : areas)
    {
      area.draw();
    }

  }

  // --------------------------------------------------
  void mousePressed()
  {
    Box p = new Box(box2d, width/2, height/2, random(70, 130), random(20, 40));
    boxes.add(p);
  }


  // --------------------------------------------------
  void generate()
  {
    ArrayList<Polygon2D> polygons = new ArrayList<Polygon2D>();
    for (Box b : boxes) 
    {
      polygons.add(b.polygon2d.copy());
    }

    
    areas = new ArrayList<Area>();
    for (Polygon2D p : polygons)
    {
      Area area = new Area(p, 0);
      area.subdivide(0, subdivide_min, 0);

      areas.add( area );
    }
  
  }


  // --------------------------------------------------
  public void exportForAxidraw(boolean normalize) 
  {
    if (areas != null)
      exportAxidraw("data/exports/axidraw/axidraw_modephysics_"+timestamp()+".json", areas, normalize);
  }

}



// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A rectangular box
class Box {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  Box2DProcessing box2d;
  Polygon2D polygon2d = new Polygon2D();


  // Constructor
  Box(Box2DProcessing box2d_, float x_, float y_, float w_, float h_) 
  {
    box2d = box2d_;
    w = w_;
    h = h_;
    makeBody(new Vec2(x_, y_), w_, h_);
    
      polygon2d.add( new Vec2D(w/2, h/2) );
      polygon2d.add( new Vec2D(-w/2, h/2) );
      polygon2d.add( new Vec2D(-w/2, -h/2) );
      polygon2d.add( new Vec2D(w/2, -h/2) );
    
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+w*h) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

//    rectMode(CENTER);
  //  pushMatrix();
//    translate(pos.x, pos.y);
//    rotate(-a);
//    fill(0);
//    noStroke();
//    rect(0, 0, w, h);
//    popMatrix();
    //    ellipse(pos.x, pos.y,5,5);
//    Vec2 p = computePoint(pos, w/2, h/2, -a);
//    ellipse(p.x,p.y,5,5);
//    println(pos);

      polygon2d.vertices.get(0).set(computePoint(pos,w/2,h/2,-a));
      polygon2d.vertices.get(1).set(computePoint(pos,-w/2,h/2,-a));
      polygon2d.vertices.get(2).set(computePoint(pos,-w/2,-h/2,-a));
      polygon2d.vertices.get(3).set(computePoint(pos,w/2,-h/2,-a));
      
      gfx.polygon2D(polygon2d);
  }

  Vec2D computePoint(Vec2 pos, float x, float y, float a)
  {
    return new Vec2D
    ( 
      cos(a) * x - sin(a) * y + pos.x,
      sin(a) * x + cos(a) * y + pos.y
      );
  }


  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center, float w_, float h_) {

    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w_/2);
    float box2dH = box2d.scalarPixelsToWorld(h_/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// An uneven surface boundary

class Surface {
  Box2DProcessing box2d;
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface;


  Surface(Box2DProcessing box2d_) {
    box2d = box2d_;
    surface = new ArrayList<Vec2>();

    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    float theta = 0;

    // This has to go backwards so that the objects  bounce off the top of the surface
    // This "edgechain" will only work in one direction!
    float radius = 0.9 * 0.5 * min(width, height);
    for (float angle = 0; angle < 360; angle+=5) {

      float x = width/2 + radius * cos (radians(angle));
      float y = height /2 + radius * sin (radians(angle));

      // Store the vertex in screen coordinates
      surface.add(new Vec2(x, y));
    }

    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface.get(i));
      vertices[i] = edge;
    }

    // Create the chain!
    chain.createChain(vertices, vertices.length);

    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f, 0.0f);
    Body body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain, 1);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(2);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v : surface) {
      vertex(v.x, v.y);
    }
    endShape();
  }
}