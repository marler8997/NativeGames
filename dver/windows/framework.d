module windows.framework;

public import core.sys.windows.windows;
public import core.runtime;
import std.string : toStringz, format;
import std.utf;
import std.array : Appender, appender;
import std.stdio;
import std.conv : to;

pragma(lib, "gdi32.lib");

int windowX;
int windowY;

WORD windowContentWidth = 0;
WORD windowContentHeight = 0;

struct WinMainParams {
  HINSTANCE hInstance;
  HINSTANCE hPrevInstance;
  LPSTR lpCmdLine;
  int nCmdShow;
};

WinMainParams winMainParams;

enum PlatformMixins = `
extern (Windows) int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
  winMainParams = WinMainParams(hInstance, hPrevInstance, lpCmdLine, nCmdShow);

  int result;
  try {
    Runtime.initialize();
    scope(exit) Runtime.terminate();
    result = frameworkMain();
  } catch(Throwable e) {
    MessageBoxA(null, e.toString().toStringz(), "Error", MB_OK | MB_ICONEXCLAMATION);
    result = 1;
  }
  return result;
}
`;

// Public API
void MakeWindow()
{
  //writefln("[LIB-DEBUG] messageHandlers.length = %s", messageHandlers.length);

  // Register the window class
  {
    WNDCLASSA wndClass;
    wndClass.style         = CS_HREDRAW | CS_VREDRAW;
    wndClass.lpfnWndProc   = &WndProc;
    wndClass.cbClsExtra    = 0;
    wndClass.cbWndExtra    = 0;
    wndClass.hInstance     = winMainParams.hInstance;
    wndClass.hIcon         = LoadIcon(null, IDI_APPLICATION);
    wndClass.hCursor       = LoadCursor(null, IDC_ARROW);
    wndClass.hbrBackground = cast(HBRUSH)GetStockObject(WHITE_BRUSH);
    wndClass.lpszMenuName  = null;
    wndClass.lpszClassName = cast(const(char)*)AppName.ptr;

    if(!RegisterClassA(&wndClass)) {
      throw new Exception("This program requires Windows NT");
      //MessageBoxA(null, "This program requires Windows NT", AppName.ptr, MB_ICONERROR);
      //return 0;
    }
  }

  HWND hwnd = CreateWindowA(AppName.ptr, // class name
			    "My Example App\0", // window caption
			    WS_OVERLAPPEDWINDOW,
			    CW_USEDEFAULT,
			    CW_USEDEFAULT,
			    600, //CW_USEDEFAULT,
			    400, //CW_USEDEFAULT,
			    null,
			    null,
			    winMainParams.hInstance,
			    null);
  ShowWindow(hwnd, winMainParams.nCmdShow);
}

// Public API
void WindowLoop()
{
  writeln("[DEBUG] WindowLoop: enter");
  
  MSG msg;
  while(GetMessageA(&msg, null, 0, 0)) {
    if(LOWORD(msg.message) == WM_MOUSEMOVE || LOWORD(msg.message) == WM_NCMOUSEMOVE) {
      // drop log message for now
    } else {
      writefln("[MessageLoop] Got Message %s", GetMessageName(LOWORD(msg.message)));
    }
    //TranslateMessage(&msg);
    DispatchMessageA(&msg);
  }

  writeln("[DEBUG] WindowLoop: exit");
}

/*
int WinMain2(HINSTANCE instance, HINSTANCE prevInstance,
	     LPSTR cmdLine, int cmdShow)
{
  exampleGetScreenSize();

  writefln("[LIB-DEBUG] messageHandlers.length = %s", messageHandlers.length);
  
  {
    WNDCLASSA wndClass;
    wndClass.style         = CS_HREDRAW | CS_VREDRAW;
    wndClass.lpfnWndProc   = &WndProc;
    wndClass.cbClsExtra    = 0;
    wndClass.cbWndExtra    = 0;
    wndClass.hInstance     = instance;
    wndClass.hIcon         = LoadIcon(null, IDI_APPLICATION);
    wndClass.hCursor       = LoadCursor(null, IDC_ARROW);
    wndClass.hbrBackground = cast(HBRUSH)GetStockObject(WHITE_BRUSH);
    wndClass.lpszMenuName  = null;
    wndClass.lpszClassName = cast(const(char)*)AppName.ptr;

    if(!RegisterClassA(&wndClass)) {
      MessageBoxA(null, "This program requires Windows NT", AppName.ptr, MB_ICONERROR);
      return 0;
    }
  }

  HWND hwnd = CreateWindowA(AppName.ptr, // class name
			    "My Example App\0", // window caption
			    WS_OVERLAPPEDWINDOW,
			    CW_USEDEFAULT,
			    CW_USEDEFAULT,
			    600, //CW_USEDEFAULT,
			    400, //CW_USEDEFAULT,
			    null,
			    null,
			    instance,
			    null);
  ShowWindow(hwnd, cmdShow);
  //UpdateWindow(hwnd);

  //appSetup();

  
  MSG msg;
  while(GetMessageA(&msg, null, 0, 0)) {
    if(LOWORD(msg.message) == WM_MOUSEMOVE || LOWORD(msg.message) == WM_NCMOUSEMOVE) {
      // drop log message for now
    } else {
      writefln("[MessageLoop] Got Message %s", GetMessageName(LOWORD(msg.message)));
    }
    //TranslateMessage(&msg);
    DispatchMessageA(&msg);
  }

  return msg.wParam;
}
*/
void exampleGetScreenSize(/*Appender!string msg*/)
{
  auto screenWidth = GetSystemMetrics(SM_CXSCREEN);
  auto screenHeight = GetSystemMetrics(SM_CYSCREEN);

  //msg.put(format("screen %s x %s", screenWidth, screenHeight));
  writefln("Screen %s x %s", screenWidth, screenHeight);
}

immutable AppName = "Example Win in D\0";



alias MessageHandler = LRESULT function(HWND hwnd, WPARAM wParam, LPARAM lParam);


TEXTMETRICA textMetric;

LRESULT WM_CREATE_Handler(HWND hwnd, WPARAM wParam, LPARAM lParam)
{
  writeln("WM_CREATE_Handler!");

  HDC hdc = GetDC(hwnd);
  scope(exit) ReleaseDC(hwnd, hdc);

  // Dimensions of the system font don't
  // change during a windows session
  GetTextMetricsA(hdc, &textMetric);

  return 0;
}
LRESULT WM_SIZE_Handler(HWND hwnd, WPARAM wParam, LPARAM lParam)
{
  bool checkSize = false;
  
  switch(wParam) {
  case 0: // SIZE_RESTORED
    checkSize = true;
    writefln("WM_SIZE_Handler(SIZE_RESTORED) %s x %s", LOWORD(lParam), HIWORD(lParam));
    break;
  case 1: // SIZE_MINIMIZED
    writefln("WM_SIZE_Handler(SIZE_MINIMIZED) lParam = %s", lParam);
    break;
  case 2: // SIZE_MAXIMIZED
    writefln("WM_SIZE_Handler(SIZE_MAXIMIZED) %s x %s", LOWORD(lParam), HIWORD(lParam));
    checkSize = true;
    break;
  case 3: // SIZE_MAXSHOW
    writefln("WM_SIZE_Handler(SIZE_MAXSHOW) lParam = %s");
    break;
  case 4: // SIZE_MAXHIDE
    writefln("WM_SIZE_Handler(SIZE_MAXHIDE) lParam = %s");
    break;
  default:
    writefln("WM_SIZE_Handler(%s) lParam = %s", wParam, lParam);
    break;
  }
  
  if(checkSize) {
    WORD newWidth  = LOWORD(lParam);
    WORD newHeight = HIWORD(lParam);
    if(newWidth != windowContentWidth || newHeight != windowContentHeight) {
      writefln("WM_SIZE (%s x %s) TO (%s x %s)",
	       windowContentWidth, windowContentHeight,
	       newWidth, newHeight);
      windowContentWidth = newWidth;
      windowContentHeight = newHeight;
      // TODO: window size has been updated, maybe call a callback here
    }
  }
  
  return 0;
}


extern(Windows)
LRESULT WndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam) nothrow
{
  if(LOWORD(message) < messageHandlers.length) {
    auto handler = messageHandlers[LOWORD(message)];
    if(handler) {
      try {
	return handler(hwnd, wParam, lParam);
      } catch(Throwable e) {
	try {
	  MessageBoxA(null, format("Windows Message (%s) threw %s: %s\0",
				   GetMessageName(LOWORD(message)),
				   e.classinfo.name, e.msg).ptr,
		      AppName.ptr, MB_ICONWARNING);
	} catch(Throwable e2) {
	  MessageBoxA(null, (
			     "Windows Message (" ~ GetMessageName(LOWORD(message)) ~
			     ") threw " ~ e.classinfo.name ~ ": " ~ e.msg ~ "\0").ptr,
		      AppName.ptr, MB_ICONWARNING);
	}
	return 1;
      }
    }
  }
  
  return DefWindowProcA(hwnd, message, wParam, lParam);
}


//
// Windows Debug
//
string GetMessageName(ushort messageID) nothrow
{
  if(messageID < WindowsMessageIDs.length) {
    auto message = WindowsMessageIDs[messageID];
    if(message) {
      return message;
    }
  }
  return to!string(messageID);
}

MessageHandler[256] messageHandlers =
  [
   WM_CREATE    : &WM_CREATE_Handler,
   WM_SIZE      : &WM_SIZE_Handler,
   ];
immutable string[] WindowsMessageIDs =
  [
   WM_NULL            : "WM_NULL",
   WM_CREATE          : "WM_CREATE",
   WM_DESTROY         : "WM_DESTROY",
   WM_MOVE            : "WM_MOVE",
   WM_SIZE            : "WM_SIZE",
   WM_ACTIVATE        : "WM_ACTIVATE",
   WM_SETFOCUS        : "WM_SETFOCUS",
   WM_KILLFOCUS       : "WM_KILLFOCUS",
   WM_ENABLE          : "WM_ENABLE",
   WM_SETREDRAW       : "WM_SETREDRAW",
   WM_SETTEXT         : "WM_SETTEXT",
   WM_GETTEXT         : "WM_GETTEXT",
   WM_GETTEXTLENGTH   : "WM_GETTEXTLENGTH",
   WM_PAINT           : "WM_PAINT",
   WM_CLOSE           : "WM_CLOSE",
   WM_QUERYENDSESSION : "WM_QUERYENDSESSION",
   WM_QUIT            : "WM_QUIT", // 18

   WM_NCMOUSEMOVE     : "WM_NCMOUSEMOVE", // 160

   WM_TIMER           : "WM_TIMER", // 257

   WM_MOUSEMOVE       : "WM_MOUSEMOVE", // 512
   ];
