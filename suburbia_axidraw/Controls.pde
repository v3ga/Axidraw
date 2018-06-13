// --------------------------------------------------
void initControls()
{
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  dlModes = cp5.addScrollableList("modes");
  dlModes.setBarHeight(cp5_height).setItemHeight(cp5_height).setPosition(0, 0).setWidth(100);
  //  dlModes.getCaptionLabel().getStyle().marginTop = 6;

  Group groupGlobals = cp5.addGroup("Globals").setBackgroundHeight(320).setPosition(100+5, 20).setBarHeight(20).setWidth(400).setBackgroundColor(cp5_group_bg_color);
  groupGlobals.getCaptionLabel().getStyle().marginTop = 6;

  cp5.begin(5, 5);

  cp5.addButton("generate").setHeight(cp5_height).setGroup(groupGlobals);
  cp5.addButton("export").setHeight(cp5_height).setLabel("image").setGroup(groupGlobals);
  cp5.addButton("exportPDF").setHeight(cp5_height).setLabel("PDF").setGroup(groupGlobals);
  cp5.addButton("btnExportAxidraw").setHeight(cp5_height).setLabel("Axidraw").setGroup(groupGlobals).linebreak();
  cp5.addToggle("debug").setHeight(cp5_height).setValue(__DEBUG__).setGroup(groupGlobals).linebreak().getCaptionLabel().setColor(0xff000000);

  cp5.addSlider("subdivide_factor_polygon_scale").setGroup(groupGlobals).setHeight(cp5_height).setRange(0.6f, 4.0f).setValue(subdivide_factor_polygon_scale).setTriggerEvent(Slider.RELEASE).linebreak();
  cp5.addSlider("subdivide_depth_max").setGroup(groupGlobals).setHeight(cp5_height).setRange(1, 10).setNumberOfTickMarks(10).setValue(subdivide_depth_max).setTriggerEvent(Slider.RELEASE).linebreak();
  cp5.addSlider("subdivide_random").setGroup(groupGlobals).setHeight(cp5_height).setRange(0.7, 1.0).setValue(subdivide_random).setTriggerEvent(Slider.RELEASE).linebreak();

  cp5.addSlider("subdivide_draw_alpha").setGroup(groupGlobals).setHeight(cp5_height).setRange(0, 255).setValue(subdivide_draw_alpha).linebreak();
  cp5.addToggle("subdivide_draw_stroke").setGroup(groupGlobals).setHeight(cp5_height).setValue(subdivide_draw_stroke).linebreak().getCaptionLabel().setColor(0xff000000);
  cp5.addToggle("subdivide_draw_filled").setGroup(groupGlobals).setHeight(cp5_height).setValue(subdivide_draw_filled).linebreak().getCaptionLabel().setColor(0xff000000);

  cp5.end();
}

// --------------------------------------------------
void modes(int index)
{
  selectMode( index );
}

// --------------------------------------------------
void subdivide_factor_polygon_scale(float v)
{
  subdivide_factor_polygon_scale = v;
  if (modeCurrent!=null)
    modeCurrent.setPolygonScale(v);
}

// --------------------------------------------------
void debug(boolean is)
{
  __DEBUG__ = is;
}

// --------------------------------------------------
void subdivide_depth_max(float v)
{
  subdivide_depth_max = (int)v;
  if (modeCurrent!=null)
    modeCurrent.setSubdivideDepthMax();
}

// --------------------------------------------------
void subdivide_random(float v)
{
  subdivide_random = v;
  if (modeCurrent!=null)
    modeCurrent.setSubdivideRandom();
}

// --------------------------------------------------
public void btnExportAxidraw(int theValue)
{
  println("btnExportAxidraw");
  if (modeCurrent != null)
  {
    modeCurrent.exportForAxidraw(true);
  }
}

// --------------------------------------------------
void export(int theValue)
{
  println("exportAxidraw");
  doSaveframe = true;
}