class ModeGrid extends Mode
{
  ArrayList<Area> areas;
  ArrayList<Polygon2D> polygons;
  float margin = 10.0f;
  int resx = 1; //nb cells
  int resy = 1;

  // --------------------------------------------------
  ModeGrid(int resx_, int resy_)
  {
    this.name = "GRID";
    this.resx = resx_;
    this.resy = resy_;
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
  void setup()
  {
    generate();
  }

  // --------------------------------------------------
  void generate()
  {
    polygons = new ArrayList<Polygon2D>();
    float w = width - 2*margin;
    float h = height - 2*margin;
    float stepx = w/float(resx);
    float stepy = h/float(resy);

    float x=margin, y=margin;
    for (int j=0; j<resy; j++)
    {
      x = margin;
      for (int i=0; i<resx; i++)
      {
        Vec2D a = new Vec2D(x, y);
        Vec2D b = new Vec2D(x+stepx, y);
        Vec2D c = new Vec2D(x+stepx, y+stepy);
        Vec2D d = new Vec2D(x, y+stepy);

        Polygon2D polygon = new Polygon2D();
        polygon.add(a);
        polygon.add(b);
        polygon.add(c);
        polygon.add(d);

        polygons.add( polygon );
        x+=stepx;
      }  
      y+=stepy;
    }

    areas = new ArrayList<Area>();
    for (Polygon2D p : polygons)
    {
      Area area = new Area(p, 0);
      area.subdivide(0, subdivide_min, 0);

      areas.add( area );
    }
    
    //println(areas.size());
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
  void drawGrid()
  {
    for (Polygon2D p : polygons)
    {
      gfx.polygon2D(p);
    }
  }

  // --------------------------------------------------
  public void exportForAxidraw(boolean normalize) 
  {
    exportAxidraw("data/exports/axidraw/axidraw_modegrid_"+timestamp()+".json", areas, normalize);
  }

}