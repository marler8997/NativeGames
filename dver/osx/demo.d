import cocoa;

extern (C) void NSRectFill(Cocoa.NSRect rect);

// Subclassing Objective-C classes:
class DView : ObjC.NSView
{
  mixin RegisterObjCClass;
  void drawRect_(Cocoa.NSRect rect)
  {
    mixin(_ObjC!q{
	[[NSColor redColor] set];
	NSRectFill(rect);
      });
  }
}

int main(string[] args)
{
  // Calling Objective-C code:
  mixin(_ObjC!q{
      ObjC.NSString oStr = [ObjC.NSString stringWithFormat: "%d, %.2f, %d", 12, 34.56, 78];
      string dStr = [oStr description];
      assert(dStr == "123, 34.56, 78");
      
      id array = [ObjC.NSArray arrayWithObjects: "Hello", "world", null];
      dStr = [array componentsJoinedByString: ", "];
      assert(dStr == "Hello, world");
    });


  return Cocoa.applicationMain(args);
}
