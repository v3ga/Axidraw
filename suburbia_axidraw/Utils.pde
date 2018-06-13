// ----------------------------------------------------------------
Vec2D axidrawPenUp = new Vec2D(-30, 0);
Vec2D axidrawPenDown = new Vec2D(-31, 0);

// ----------------------------------------------------------------
PVector[] loadAxidraw(String pathRel, PVector scale, PVector translate)
{
  PVector[] a = null;
  JSONArray vectors = loadJSONArray(pathRel);
  if (vectors != null)
  {
    int nbVectors = vectors.size();
    if (nbVectors>0)
    {
      a = new PVector[nbVectors];
      for (int i=0; i<nbVectors; i++)
      {
        a[i] = convertToPVector( vectors.getJSONObject(i), scale, translate);
      }
    }
  }

  return a;
}

// ----------------------------------------------------------------
void exportAxidraw(String filename, ArrayList<Area> areas, boolean normalize)
{
  JSONArray vectors = new JSONArray();
  vectors.append( convertToJSON( new Vec2D(width,height), false, false ) );
  JSONArray a = null;
  try
  {
    if (areas != null)
    {

      for (Area area : areas)
      {
        ArrayList<Area> drawables = area.getDrawables();
        for (Area drawable : drawables)
        {
          if (drawable.polygon2D_scale != null)
          {
            a = convertToJSONArray(drawable.polygon2D_scale, normalize);
            if (a != null)
            {
              int nbVectors = a.size();
              println("nbVectors = "+nbVectors);
              if (nbVectors > 1)
              {
                
                JSONObject firstPoint = a.getJSONObject(0);

                vectors.append( convertToJSON(axidrawPenUp, false, true) );
                vectors.append( firstPoint );
                vectors.append( convertToJSON(axidrawPenDown, false, true) );

                for (int i=1; i<nbVectors; i++)
                {
                  vectors.append( a.getJSONObject(i) );
                }
              }
            }
          }
        }

        vectors.append( convertToJSON(axidrawPenUp, false, true) );
      }

      println("saveJSONArray()");
      saveJSONArray(vectors, filename);
    }
  }
  catch (java.lang.RuntimeException e) {
    println(e);
    println(a);
  }
}

// ----------------------------------------------------------------
PVector convertToPVector(JSONObject j, PVector scale, PVector translate)
{

  if (scale == null)
    scale = new PVector(1, 1);

  float x = j.getFloat("x");
  float y = j.getFloat("y");

  if (x>0) x = translate.x + x*scale.x;
  if (y>0) y = translate.y + y*scale.y;

  //  println("("+x+","+y+")");

  return new PVector(x, y);
}

// ----------------------------------------------------------------
JSONArray convertToJSONArray(Polygon2D polygon, boolean normalize)
{
  JSONArray a = new JSONArray();
  JSONObject j = null;
  for (Vec2D v : polygon.vertices)
  {
    j = convertToJSON(v, normalize, false);
    if (j==null)
    {
      return null;
    }
      a.append( j );
  }
  a.append( convertToJSON(polygon.vertices.get(0), normalize, false) );
  return a;
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
JSONObject convertToJSON(PVector p, boolean normalize, boolean axidrawCommand)
{
  return convertToJSON(new Vec2D(p.x, p.y), normalize, axidrawCommand);
}


// ----------------------------------------------------------------
String timestamp() 
{
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

// ----------------------------------------------------------------
int mouseWheel=0;
class MouseWheelInput implements MouseWheelListener {  

  void mouseWheelMoved(MouseWheelEvent e) {  
    mouseWheel=e.getWheelRotation();  
    println(mouseWheel);
  }
} 

// ----------------------------------------------------------------
class CallBack 
{
  private String methodName;
  private Object scope;

  public CallBack(Object scope, String methodName) 
  {
    this.methodName = methodName;
    this.scope = scope;
  }

  public Object invoke(Object... parameters) throws InvocationTargetException, IllegalAccessException, NoSuchMethodException 
  {
    Method method = scope.getClass().getMethod(methodName, getParameterClasses(parameters));
    return method.invoke(scope, parameters);
  }

  private Class[] getParameterClasses(Object... parameters) 
  {
    Class[] classes = new Class[parameters.length];
    for (int i=0; i < classes.length; i++) {
      classes[i] = parameters[i].getClass();
    }
    return classes;
  }

  public String toString()
  {
    return "Callback : scope="+this.scope+";methodName="+methodName;
  }
}

/**
 * This class implements a undirected vertex graph and provides basic connectivity information.
 * Vertices can only be added by defining edges, ensuring there're no isolated nodes
 * (but allowing for subgraphs/clusters).
 */
public class UndirectedGraph {

  // use vertex position as unique keys and a list of edges as its value
  private final Map<Vec2D, List<Edge>> vertexEdgeIndex = new HashMap<Vec2D, List<Edge>>();

  // set of all edges in the graph
  private final Set<Edge> edges = new HashSet<Edge>();

  // attempts to add new edge for the given vertices
  // if successful also add vertices to index and associate edge with each
  public void addEdge(Vec2D a, Vec2D b) {
    if (!a.equals(b)) {
      Edge e = new Edge(a, b);
      if (edges.add(e)) {
        addEdgeForVertex(a, e);
        addEdgeForVertex(b, e);
      }
    }
  }

  private void addEdgeForVertex(Vec2D a, Edge e) {
    List<Edge> vertEdges = vertexEdgeIndex.get(a);
    if (vertEdges == null) {
      vertEdges = new ArrayList<Edge>();
      vertexEdgeIndex.put(a, vertEdges);
    }
    vertEdges.add(e);
  }

  public Set<Edge> getEdges() {
    return edges;
  }

  // get list of edges for the given vertex (or null if vertex is unknown)
  public List<Edge> getEdgesForVertex(ReadonlyVec2D v) {
    return vertexEdgeIndex.get(v);
  }

  public Set<Vec2D> getVertices() {
    return vertexEdgeIndex.keySet();
  }
}

/**
 * A single immutable, undirected connection between two vertices.
 * Provides equals() & hashCode() implementations to ignore direction.
 */
public class Edge {

  public final ReadonlyVec2D a, b;

  public Edge(ReadonlyVec2D a, ReadonlyVec2D b) {
    this.a = a;
    this.b = b;
  }

  public boolean equals(Object o) {
    if (o != null && o instanceof Edge) {
      Edge e = (Edge) o;
      return
        (a.equals(e.a) && b.equals(e.b)) ||
        (a.equals(e.b) && b.equals(e.a));
    }
    return false;
  }

  public Vec2D getDirectionFrom(ReadonlyVec2D p) {
    Vec2D dir = b.sub(a);
    if (p.equals(b)) {
      dir.invert();
    }
    return dir;
  }

  public ReadonlyVec2D getOtherEndFor(ReadonlyVec2D p) {
    return p.equals(a) ? b : a;
  }

  public int hashCode() {
    return a.hashCode() + b.hashCode();
  }

  public String toString() {
    return a.toString() + " <-> " + b.toString();
  }
}