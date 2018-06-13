// ----------------------------------------------------------------
Vec2D axidrawPenUp = new Vec2D(-30, 0);
Vec2D axidrawPenDown = new Vec2D(-31, 0);


// ----------------------------------------------------------------
String timestamp() 
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}


// ----------------------------------------------------------------
JSONObject convertToJSON(Vec2D p, boolean normalize, boolean axidrawCommand)
{
  if (!axidrawCommand)
    if (p.x < 0 || p.y < 0) 
      return null;
  
  JSONObject j = new JSONObject();
  try
  {
    j.setFloat("x", p.x / (normalize ? float(width) : 1.0));
    j.setFloat("y", p.y / (normalize ? float(height) : 1.0));
  }
  catch (java.lang.RuntimeException e) 
  {
    return null;
  }

  return j;
}


// ----------------------------------------------------------------
/*
void exportAxidraw(String filename, Circle root, boolean normalize)
{
  JSONArray vectors = new JSONArray();
  JSONArray a = null;
  try
  {  
    // Encode width / height for ratio
    vectors.append( convertToJSON( new Vec2D(width,height), false, false ) );
    
    // Pend up
    vectors.append( convertToJSON(axidrawPenUp, false, true) );
    
    if (root != null)
    {
      exportAxidrawCircle(vectors, root, normalize);

      saveJSONArray(vectors, filename);
    }
  }
  catch (java.lang.RuntimeException e) {
    println(e);
    println(a);
  }
}
*/