String filename = "suburbia/axidraw_modegrid_170630_210244.json";

// ----------------------------------------------------------------
void GenerateArtwork()
{
  ToDoList = loadAxidraw("data/"+filename);
}

// ----------------------------------------------------------------
PVector[] loadAxidraw(String pathRel)
{
  PVector[] a = null;
  JSONArray vectors = loadJSONArray(pathRel);
  if (vectors != null)
  {
    JSONObject jOriginalSize = vectors.getJSONObject(0);
    float wOriginal = jOriginalSize.getFloat("x");
    float hOriginal = jOriginalSize.getFloat("y");
    float ratio = wOriginal / hOriginal;

    float f = 0.85;
  
    float ww = MousePaperRight-MousePaperLeft;
    float hh = MousePaperBottom-MousePaperTop;
  
    float w = f*ww;
    float h = w / ratio;
  
    float x = MousePaperLeft + 0.5*(ww-w);
    float y = MousePaperTop + 0.5*(hh-h);
  
    PVector scale = new PVector(w,h);
    PVector translate = new PVector(x,y);
    
    
    int nbVectors = vectors.size()-1;
    if (nbVectors>0)
    {
      println("loadAxidraw(), nbvectors="+nbVectors);
      a = new PVector[nbVectors];
      for (int i=1; i<nbVectors+1; i++)
      {
          a[i-1] = convertToPVector( vectors.getJSONObject(i), scale, translate);
      }
    }
  }
  
  return a;
}

// ----------------------------------------------------------------
PVector convertToPVector(JSONObject j, PVector scale, PVector translate)
{
  if (scale == null)
    scale = new PVector(1,1);
  
  float x = j.getFloat("x");
  float y = j.getFloat("y");

  if (x>0) x = translate.x + x*scale.x;
  if (y>0) y = translate.y + y*scale.y;
  
//   println("("+x+","+y+")");
  
  return new PVector(x,y);
}