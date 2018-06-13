int currWidth, currHeight;

// --------------------------------------------------
// https://forum.processing.org/two/discussion/327/trying-to-capture-window-resize-event-to-redraw-background-to-new-size-not-working
class Format
{
  String name;
  int w, h, factor;
  Format(int w, int h, int factor)
  {
    this.w = w;
    this.h = h;
    this.factor = factor;
    this.name = w+"x"+h;
  }

  void applySize()
  {
    println("size("+w+","+h+")");
    size(w*factor, h*factor);
    currWidth = width;
    currHeight = height;
  }

  void applyFrameSize()
  {
    println("size("+w+","+h+")");
    setSize(w*factor, h*factor);
   applet.frame.setSize(w*factor, h*factor);
  }
}


// --------------------------------------------------
void defineFormats()
{
  formats = new ArrayList<Format>();
  formats.add( new Format(30, 40, 20) ); // 1
  formats.add( new Format(50, 50, 15) ); // 2
  formats.add( new Format(50, 70, 15) ); // 3
  formats.add( new Format(70, 70, 15) ); // 4
  formats.add( new Format(70, 100, 12)); // 5
  formats.add( new Format(50, 100, 12)); // 6
  formats.add( new Format(28, 22, 40)); // 7
}

// --------------------------------------------------
Format getFormat(String name)
{
  for (Format f : formats) {
    if (f.name.equals(name)) {
      return f;
    }
  }
  return null;
}

// --------------------------------------------------
void applyFormatSize(String name)
{
  Format f = getFormat(name);
  if (f!=null)
    f.applySize();
}

// --------------------------------------------------
void applyFrameSize(String name)
{
  Format f = getFormat(name);
  if (f!=null)
    f.applyFrameSize();
}