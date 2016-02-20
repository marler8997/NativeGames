import std.stdio;
import core.runtime;
import core.sys.windows.windows;

import std.format : sformat;

import platform;
import gameMapExample;

mixin(PlatformMixins);

int frameworkMain()
{
  writefln("[DEMO-GAME-DEBUG] Calling MakeWindow()...");
  MakeWindow();

  writefln("[DEMO-GAME-DEBUG] Setting message handler...");
  messageHandlers[WM_PAINT] = &Paint;

  writefln("[DEMO-GAME-DEBUG] Calling WindowLoop...");
  WindowLoop();
  
  return 0;
}
