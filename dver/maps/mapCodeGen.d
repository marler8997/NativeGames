module mapCodeGen;

import std.conv : to;
import std.traits : EnumMembers;

struct CodeGenerator
{
  ubyte tabSpaceCount;
  ushort spaces;
  void tab()
  {
    spaces += tabSpaceCount;
  }
  void untab()
  {
    if(spaces == 0) {
      throw new Exception("Too many untabs");
    }
    spaces -= tabSpaceCount;
  }
  
  import std.stdio : stdout;
  import core.stdc.stdlib;

  void writeln() const
  {
    stdout.writeln();
  }
  void writeln(string msg) const
  {
    if(msg.length == 0) {
      stdout.writeln();
    } else {
      auto spacesString = (cast(char*)alloca(spaces))[0..spaces];
      spacesString[] = ' ';
      stdout.write(spacesString);
      stdout.writeln(msg);
    }
  }
  void writefln(A...)(string format, A a) const
  {
    auto spacesString = (cast(char*)alloca(spaces))[0..spaces];
    spacesString[] = ' ';
    stdout.write(spacesString);
    stdout.writefln(format, a);
  }
}
CodeGenerator codegen = CodeGenerator(3, 0);


Surface[] surfaces;


enum SurfaceType {
  window, // The surface draws directly to the window
          // Currently, their coordinates are based off the top left corner.
          // 
}

struct Surface
{
  SurfaceType type;
  
  //int[string] layerNameToIndexMap; Should be created dynamically
  string[] layerNames;

  RenderItem[] renderItems;
}

struct AlphaColor
{
  uint argb;
  
  @property ubyte alpha() {
    return argb >> 24;
  }
}

struct Box {
  uint x;
  uint y;
  uint width;
  uint height;
}

abstract class RenderItem
{
  Box box;
  this(Box box) {
    this.box = box;
  }
  abstract void generateDataStructures();
  abstract void generateRenderCode();
}


class ColorBox : RenderItem
{
  AlphaColor color;
  this(AlphaColor color, Box box) {
    super(box);
    this.color = color;
  }
  override void generateDataStructures()
  {
    
  }
  override void generateRenderCode()
  {
    if(color.alpha != 0xFF) {
      throw new Exception("Non alpha not supported");
    }
    //codegen.writefln("Rectangle(hdc, %s, %s, %s, %s);",
    //box.x, box.y, box.x + box.width, box.y + box.height);
    codegen.writeln("{");
    codegen.tab();
    codegen.writefln("RECT rect = {%s,%s,%s,%s};",
		     box.x, box.y, box.x + box.width, box.y + box.height);
    codegen.writeln("FillRect(hdc, &rect, cast(HBRUSH)(COLOR_HIGHLIGHTTEXT));");
    codegen.untab();
    codegen.writeln("}");
  }
}

enum Platform {
  windowsGdi,
};

void generateCode(Surface[] surfaces)
{
  // Prepare data structures for code generation
  //

  // 
  // Get all the colors
  //
  


  codegen.writeln("module gameMapExample;");
  codegen.writeln();
  codegen.writeln("import core.runtime;");
  codegen.writeln("import core.sys.windows.windows;");
  codegen.writeln();
  codegen.writeln("import platform;");
  codegen.writeln();
  
  // Generate Data Structures
  foreach(surfaceIndex, surface; surfaces) {
    generateDataStructures(surface);
  }

  codegen.writeln("LRESULT Paint(HWND hwnd, WPARAM wParam, LPARAM lParam)");
  codegen.writeln("{");
  codegen.tab();

  codegen.writeln("PAINTSTRUCT paintStruct;");
  codegen.writeln("HDC hdc = BeginPaint(hwnd, &paintStruct);");
  codegen.writeln("scope(exit)EndPaint(hwnd, &paintStruct);");
  
  foreach(surfaceIndex, surface; surfaces) {
    if(surface.type == SurfaceType.window) {
      generateCodeWindowSurface(surface);
    } else {
      throw new Exception("Unknown surface type");
    }
  }
  /*
  codegen.writeln("WM_PAINT_Handler!");

  PAINTSTRUCT paintStruct;
  HDC hdc = BeginPaint(hwnd, &paintStruct);
  scope(exit)EndPaint(hwnd, &paintStruct);

  char metricString[32];
  
  int y = 10;
  foreach(metric; sysMetrics) {
    TextOutA(hdc, 10      , y, metric.label.ptr, metric.label.length);
    int metricValue = GetSystemMetrics(metric.index);

    int metricValueStringLength = sformat(metricString, "%s", metricValue).length;
    
    TextOutA(hdc, 10 + 220, y, metricString.ptr, metricValueStringLength);

    TextOutA(hdc, 10 + 300, y, metric.desc.ptr, metric.desc.length);
    y += textMetric.tmHeight + 10;
  }
  
  return 0;
  */  
  codegen.writeln("return 0;");
  codegen.untab();
  codegen.writeln("}");
}

void generateDataStructures(Surface surface)
{
  foreach(itemIndex, item; surface.renderItems) {
    item.generateDataStructures();
  }
}

void generateCodeWindowSurface(Surface surface)
{
  codegen.writefln("// Window surface!");
  foreach(itemIndex, item; surface.renderItems) {
    codegen.writefln("// Item %s", itemIndex);
    codegen.writefln("if(%s < windowContentWidth || %s < windowContentHeight) {",
	     item.box.x, item.box.y);
    codegen.tab();
    item.generateRenderCode();
    codegen.untab();
    codegen.writefln("}");
    
  }
}
