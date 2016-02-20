
import mapCodeGen;

// Example 1
Surface[] RedBoxExample()
{
  return
    [Surface(SurfaceType.window,
	     ["background"], // layer names
	     [
	      new ColorBox(AlphaColor(0xFFFF0000), Box(10, 10, 100, 100))
	      ]
 )];
}

int main(string[] args)
{
  import std.stdio;
  
  // Examples
  Surface[] function()[string] examples =
    [
     "RedBox": &RedBoxExample
     ];

  if(args.length <= 2) {
    writeln("Usage: gameMap <example-name> <platform>");
    writeln("Examples Names:");
    foreach(example; examples.byKey) {
      writefln("  %s", example);
    }
    writeln("Platforms:");
    foreach(platform; EnumMembers!Platform) {
      writefln("  %s", platform);
    }
    return 0;
  }

  auto exampleName = args[1];
  auto platform = to!Platform(args[2]);

  auto example = examples.get(exampleName, null);
  if(!example) {
    writefln("Unknown example '%s'", exampleName);
    return 1;
  }

  auto surfaces = example();
  
  generateCode(surfaces);

  
  return 0;
}

