class ModeAreaObject // used by callback when divide
{
  boolean canSubdivide = false;

  ModeAreaObject(boolean can_)
  {
    canSubdivide = can_;
  }
}

class Mode implements ControlListener
{
  String name = "";
  Group cp5Group = null;
  TriangleMesh mesh;

  // --------------------------------------------------
  void setup() {
  }
  // --------------------------------------------------
  void update() {
  }
  // --------------------------------------------------
  boolean isDrawBackground() {
    return true;
  }
  // --------------------------------------------------
  void draw() {
  } 
  // --------------------------------------------------
  void drawDebug() {
  }
  // --------------------------------------------------
  void keyPressed() {
  }
  // --------------------------------------------------
  void mouseMoved() {
  }
  void mousePressed() {
  }
  // --------------------------------------------------
  void generate() {
  }
  void generate3D() {
  }

  // --------------------------------------------------
  void setPolygonScale(float f) {
  }
  // --------------------------------------------------
  void setSubdivideDepthMax()
  {
    generate();
  }
  // --------------------------------------------------
  void setSubdivideRandom()
  {
    generate();
  }
  // --------------------------------------------------
  void initControls()
  {
    createControlsGroup();
  }
  // --------------------------------------------------
  void createControlsGroup()
  {
     this.cp5Group = cp5.addGroup(this.name).setPosition(500+10,20).setBackgroundHeight(300).setBarHeight(20).setWidth(300).setBackgroundColor(cp5_group_bg_color);  
     this.cp5Group.getCaptionLabel().getStyle().marginTop = 6;
     this.cp5Group.hide();
  }
  // --------------------------------------------------
  void showControls(boolean is)
  {
    println("showControls, cp5Group="+this.cp5Group);
    if (this.cp5Group == null) return;
    if (is)
      this.cp5Group.show();
    else
      this.cp5Group.hide();
  }
  // --------------------------------------------------
  public void controlEvent(ControlEvent theEvent) {
  }
  // --------------------------------------------------
  public void resize() {
  }
  // --------------------------------------------------
  public void exportForAxidraw(boolean normalize) {
  }
}