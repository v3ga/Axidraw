class ModeVoronoi extends Mode
{
  Voronoi voronoi;
  UndirectedGraph graph;
  ArrayList<Area> areas;
  int modeDistribution = 2;
  boolean useDelaunay = false;
  String cp5_prefix = "";
  Vec2D graphSelectedVertex=null;
  float graphSnapDist = 10;
  boolean isTraveller = false;
  boolean useOutsidePolygons = false;
  ScrollableList dlModes;

  // --------------------------------------------------
  ModeVoronoi()
  {
    name = "GEOMETRY";
    cp5_prefix = "geom";
  }



  // --------------------------------------------------
  void initControls()
  {
    super.initControls();

    dlModes = cp5.addScrollableList("modesShapes");
    dlModes.setBarHeight(cp5_height).setItemHeight(cp5_height).setPosition(5, 5).setWidth(100);
//    dlModes.getCaptionLabel().getStyle().marginTop = 6;
    dlModes.setGroup(this.cp5Group);
    dlModes.addItem("RANDOM", 0);
    dlModes.addItem("CIRCLES", 1);
    dlModes.addItem("SPIRAL", 2);
    dlModes.plugTo(this);

    //createControls();
  }

  // --------------------------------------------------
  public void modesShapes(int index)
  {
    areas = null;
    modeDistribution = index;
    distributePoints();
    generate();
  }

  // --------------------------------------------------
  public void geomNavigationPath(boolean is)
  {
    isTraveller = is;
  }



  // --------------------------------------------------
  public void controlEvent(ControlEvent theEvent)
  {
    String name = theEvent.getName();
    
    if (name.equals(cp5_prefix+"useDelaunay"))
    {
      useDelaunay = (theEvent.getValue()) == 1 ? true : false;
      areas = null;
      generate();
    }

  }


  // --------------------------------------------------
  void setup()
  {
    distributePoints();
    generate();
  }

  // --------------------------------------------------
  void mouseMoved()
  {
    graphSelectedVertex = null;
    if (graph!=null)
    {
      Vec2D mousePos=new Vec2D(mouseX, mouseY);
      for (Vec2D v : graph.getVertices()) 
      {
        if (mousePos.distanceToSquared(v) < graphSnapDist) {
          graphSelectedVertex=v;
          break;
        }
      }
    }
  }

  // --------------------------------------------------
  void distributePoints()
  {
    voronoi = new Voronoi();  

    // >>> RANDOM
    if (modeDistribution == 0)
    {
      for ( int i = 0; i < voronoi_nb_points; i++ ) {
        voronoi.addPoint( new Vec2D( random(width), random(height) ) );
      }
    }
    // >>> CIRCLES
    else if (modeDistribution == 1)
    {
      voronoi.addPoint( new Vec2D(width/2, height/2) );
      float angle=0.0f;
      float r = 1.0f;
      for ( int i = 0; i < voronoi_nb_points; i++ ) 
      {
        angle = float(i)/float(voronoi_nb_points)*TWO_PI;
        r = random(0.8, 1)*0.3*min(width, height);
        for (int j=0; j<10; j++)
        {
          voronoi.addPoint( new Vec2D( width/2+map(j, 0, 10, 1, 2)*random(1.1, 1.5)*r*cos(angle), height/2+map(j, 0, 10, 1, 2)*random(1.1, 1.5)*r*sin(angle) ) );
          //voronoi.addPoint( new Vec2D( width/2+random(1.1, 1.5)*r*cos(angle), height/2+random(1.1, 1.5)*r*sin(angle) ) );
        }
      }
    }
    // >>> SPIRALES
    else if (modeDistribution == 2)
    {
      voronoi.addPoint( new Vec2D(width/2, height/2) );
      float angle=0.0f;
      float r = 1.0f;
      for ( int i = 0; i < voronoi_nb_points; i++ ) 
      {
        angle = float(i)/float(voronoi_nb_points)*TWO_PI;
        r = random(0.8, 1)*0.5*map(angle, 0, TWO_PI, 0, 1)*min(width, height);
        voronoi.addPoint( new Vec2D( width/2+r*cos(angle), height/2+r*sin(angle) ) );
        //  voronoi.addPoint( new Vec2D( width/2+random(1.1,1.5)*r*cos(angle), height/2+random(1.1,1.5)*r*sin(angle) ) );
      }
    }
  }

  // --------------------------------------------------
  void setPolygonScale(float f)
  {
    for (Area area : areas)
    {
      area.setPolygonScale(f);
    }
  }

  // --------------------------------------------------
  void draw()
  {
    if (areas == null) return;
    for (Area area : areas)
    {
      area.draw();
    }
  }


  // --------------------------------------------------
  void drawDebug()
  {
    noFill();
    stroke(200, 0, 0);
    if (voronoi != null)
    {
      if (useDelaunay)
      {
        for (Triangle2D t : voronoi.getTriangles())
        {
          gfx.triangle(t);
        }
      } else
      {
        for (Polygon2D region : voronoi.getRegions())
        {
          gfx.polygon2D(region);
        }
      }
    }
    if (graphSelectedVertex!=null)
    {
      stroke(0, 200, 0);
      ellipse(graphSelectedVertex.x, graphSelectedVertex.y, graphSnapDist, graphSnapDist);
    }
  }

  // --------------------------------------------------
  void keyPressed()
  {
    if (key == ' ')
    {
      generate();
    }
  }

  // --------------------------------------------------
  boolean isOutside(Polygon2D p_)
  {
    if (useOutsidePolygons) return false;

    boolean is = false;
    for (Vec2D v : p_.vertices) {
      if (v.x<0 || v.x>width || v.y<0 || v.y>height) return true;
    }

    return is;
  }

  // --------------------------------------------------
  boolean filter(Polygon2D polygon_)
  {
    return isOutside(polygon_);
  }

  // --------------------------------------------------
  void generate()
  {
    graph = null;

    if (areas == null)
    {
      areas = new ArrayList<Area>();

      // DELAUNAY
      if (useDelaunay)
      {
        for ( Triangle2D t : voronoi.getTriangles() ) 
        {
          Polygon2D polygon = new Polygon2D();
          polygon.add(t.a);
          polygon.add(t.b);
          polygon.add(t.c);

          if (!filter(polygon))
          {
            Area area = new Area(polygon, 0);
            //area.subdivide(0, subdivide_min, 0);

            areas.add( area );
          }
        }
      }
      // VORONOI
      else
      {
        if (subdivide_voronoi_compute_graph)
        {
          graph=new UndirectedGraph();
        }

        for ( Polygon2D polygon : voronoi.getRegions() ) 
        {
          if (!filter(polygon))
          {
            Area area = new Area(polygon, 0);
            //area.subdivide(0, subdivide_min, 0);

            areas.add( area );

            /*            if (subdivide_voronoi_compute_graph)
             {
             for (int i=0,num=polygon.vertices.size(); i<num; i++) 
             {
             graph.addEdge(polygon.vertices.get(i), polygon.vertices.get((i+1)%num));
             }
             }
             */
          }
        }
      }
    }

    if (areas != null)
    {
      for (Area area : areas)
        area.subdivide(0, subdivide_min, 0);
    }
  }


  // --------------------------------------------------
  public void exportForAxidraw(boolean normalize) 
  {
    exportAxidraw("data/exports/axidraw/axidraw_modevoronoi_"+timestamp()+".json", areas, normalize);
  }


}