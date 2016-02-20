import std.stdio;
import core.runtime;
import core.sys.windows.windows;

import std.format : sformat;

import platform;

struct SysMetrics
{
  int index;
  string label;
  string desc;
}

enum sysMetrics =
[
    SysMetrics(SM_CXSCREEN,             "SM_CXSCREEN",              "Screen width in pixels"),
    SysMetrics(SM_CYSCREEN,             "SM_CYSCREEN",              "Screen height in pixels"),
    SysMetrics(SM_CXVSCROLL,            "SM_CXVSCROLL",             "Vertical scroll width"),
    SysMetrics(SM_CYHSCROLL,            "SM_CYHSCROLL",             "Horizontal scroll height"),
    SysMetrics(SM_CYCAPTION,            "SM_CYCAPTION",             "Caption bar height"),
    SysMetrics(SM_CXBORDER,             "SM_CXBORDER",              "Window border width"),
    SysMetrics(SM_CYBORDER,             "SM_CYBORDER",              "Window border height"),
    SysMetrics(SM_CXFIXEDFRAME,         "SM_CXFIXEDFRAME",          "Dialog window frame width"),
    SysMetrics(SM_CYFIXEDFRAME,         "SM_CYFIXEDFRAME",          "Dialog window frame height"),
    SysMetrics(SM_CYVTHUMB,             "SM_CYVTHUMB",              "Vertical scroll thumb height"),
    SysMetrics(SM_CXHTHUMB,             "SM_CXHTHUMB",              "Horizontal scroll thumb width"),
    SysMetrics(SM_CXICON,               "SM_CXICON",                "Icon width"),
    SysMetrics(SM_CYICON,               "SM_CYICON",                "Icon height"),
    SysMetrics(SM_CXCURSOR,             "SM_CXCURSOR",              "Cursor width"),
    SysMetrics(SM_CYCURSOR,             "SM_CYCURSOR",              "Cursor height"),
    SysMetrics(SM_CYMENU,               "SM_CYMENU",                "Menu bar height"),
    SysMetrics(SM_CXFULLSCREEN,         "SM_CXFULLSCREEN",          "Full screen client area width"),
    SysMetrics(SM_CYFULLSCREEN,         "SM_CYFULLSCREEN",          "Full screen client area height"),
    SysMetrics(SM_CYKANJIWINDOW,        "SM_CYKANJIWINDOW",         "Kanji window height"),
    SysMetrics(SM_MOUSEPRESENT,         "SM_MOUSEPRESENT",          "Mouse present flag"),
    SysMetrics(SM_CYVSCROLL,            "SM_CYVSCROLL",             "Vertical scroll arrow height"),
    SysMetrics(SM_CXHSCROLL,            "SM_CXHSCROLL",             "Horizontal scroll arrow width"),
    SysMetrics(SM_DEBUG,                "SM_DEBUG",                 "Debug version flag"),
    SysMetrics(SM_SWAPBUTTON,           "SM_SWAPBUTTON",            "Mouse buttons swapped flag"),
    SysMetrics(SM_CXMIN,                "SM_CXMIN",                 "Minimum window width"),
    SysMetrics(SM_CYMIN,                "SM_CYMIN",                 "Minimum window height"),
    SysMetrics(SM_CXSIZE,               "SM_CXSIZE",                "Min/Max/Close button width"),
    SysMetrics(SM_CYSIZE,               "SM_CYSIZE",                "Min/Max/Close button height"),
    SysMetrics(SM_CXSIZEFRAME,          "SM_CXSIZEFRAME",           "Window sizing frame width"),
    SysMetrics(SM_CYSIZEFRAME,          "SM_CYSIZEFRAME",           "Window sizing frame height"),
    SysMetrics(SM_CXMINTRACK,           "SM_CXMINTRACK",            "Minimum window tracking width"),
    SysMetrics(SM_CYMINTRACK,           "SM_CYMINTRACK",            "Minimum window tracking height"),
    SysMetrics(SM_CXDOUBLECLK,          "SM_CXDOUBLECLK",           "Double click x tolerance"),
    SysMetrics(SM_CYDOUBLECLK,          "SM_CYDOUBLECLK",           "Double click y tolerance"),
    SysMetrics(SM_CXICONSPACING,        "SM_CXICONSPACING",         "Horizontal icon spacing"),
    SysMetrics(SM_CYICONSPACING,        "SM_CYICONSPACING",         "Vertical icon spacing"),
    SysMetrics(SM_MENUDROPALIGNMENT,    "SM_MENUDROPALIGNMENT",     "Left or right menu drop"),
    SysMetrics(SM_PENWINDOWS,           "SM_PENWINDOWS",            "Pen extensions installed"),
    SysMetrics(SM_DBCSENABLED,          "SM_DBCSENABLED",           "Double-Byte Char Set enabled"),
    SysMetrics(SM_CMOUSEBUTTONS,        "SM_CMOUSEBUTTONS",         "Number of mouse buttons"),
    SysMetrics(SM_SECURE,               "SM_SECURE",                "Security present flag"),
    SysMetrics(SM_CXEDGE,               "SM_CXEDGE",                "3-D border width"),
    SysMetrics(SM_CYEDGE,               "SM_CYEDGE",                "3-D border height"),
    SysMetrics(SM_CXMINSPACING,         "SM_CXMINSPACING",          "Minimized window spacing width"),
    SysMetrics(SM_CYMINSPACING,         "SM_CYMINSPACING",          "Minimized window spacing height"),
    SysMetrics(SM_CXSMICON,             "SM_CXSMICON",              "Small icon width"),
    SysMetrics(SM_CYSMICON,             "SM_CYSMICON",              "Small icon height"),
    SysMetrics(SM_CYSMCAPTION,          "SM_CYSMCAPTION",           "Small caption height"),
    SysMetrics(SM_CXSMSIZE,             "SM_CXSMSIZE",              "Small caption button width"),
    SysMetrics(SM_CYSMSIZE,             "SM_CYSMSIZE",              "Small caption button height"),
    SysMetrics(SM_CXMENUSIZE,           "SM_CXMENUSIZE",            "Menu bar button width"),
    SysMetrics(SM_CYMENUSIZE,           "SM_CYMENUSIZE",            "Menu bar button height"),
    SysMetrics(SM_ARRANGE,              "SM_ARRANGE",               "How minimized windows arranged"),
    SysMetrics(SM_CXMINIMIZED,          "SM_CXMINIMIZED",           "Minimized window width"),
    SysMetrics(SM_CYMINIMIZED,          "SM_CYMINIMIZED",           "Minimized window height"),
    SysMetrics(SM_CXMAXTRACK,           "SM_CXMAXTRACK",            "Maximum draggable width"),
    SysMetrics(SM_CYMAXTRACK,           "SM_CYMAXTRACK",            "Maximum draggable height"),
    SysMetrics(SM_CXMAXIMIZED,          "SM_CXMAXIMIZED",           "Width of maximized window"),
    SysMetrics(SM_CYMAXIMIZED,          "SM_CYMAXIMIZED",           "Height of maximized window"),
    SysMetrics(SM_NETWORK,              "SM_NETWORK",               "Network present flag"),
    SysMetrics(SM_CLEANBOOT,            "SM_CLEANBOOT",             "How system was booted"),
    SysMetrics(SM_CXDRAG,               "SM_CXDRAG",                "Avoid drag x tolerance"),
    SysMetrics(SM_CYDRAG,               "SM_CYDRAG",                "Avoid drag y tolerance"),
    SysMetrics(SM_SHOWSOUNDS,           "SM_SHOWSOUNDS",            "Present sounds visually"),
    SysMetrics(SM_CXMENUCHECK,          "SM_CXMENUCHECK",           "Menu check-mark width"),
    SysMetrics(SM_CYMENUCHECK,          "SM_CYMENUCHECK",           "Menu check-mark hight"),
    SysMetrics(SM_SLOWMACHINE,          "SM_SLOWMACHINE",           "Slow processor flag"),
    SysMetrics(SM_MIDEASTENABLED,       "SM_MIDEASTENABLED",        "Hebrew and Arabic enabled flag"),
    SysMetrics(SM_MOUSEWHEELPRESENT,    "SM_MOUSEWHEELPRESENT",     "Mouse wheel present flag"),
    SysMetrics(SM_XVIRTUALSCREEN,       "SM_XVIRTUALSCREEN",        "Virtual screen x origin"),
    SysMetrics(SM_YVIRTUALSCREEN,       "SM_YVIRTUALSCREEN",        "Virtual screen y origin"),
    SysMetrics(SM_CXVIRTUALSCREEN,      "SM_CXVIRTUALSCREEN",       "Virtual screen width"),
    SysMetrics(SM_CYVIRTUALSCREEN,      "SM_CYVIRTUALSCREEN",       "Virtual screen height"),
    SysMetrics(SM_CMONITORS,            "SM_CMONITORS",             "Number of monitors"),
    SysMetrics(SM_SAMEDISPLAYFORMAT,    "SM_SAMEDISPLAYFORMAT",     "Same color format flag")
];

mixin(PlatformMixins);

int frameworkMain()
{
  // install custom paint handler
  messageHandlers[WM_PAINT] = &SysMetricsPaintHandler;

  MakeWindow();
  WindowLoop();
  
  return 0;
}


LRESULT SysMetricsPaintHandler(HWND hwnd, WPARAM wParam, LPARAM lParam)
{
  writeln("WM_PAINT_Handler!");

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
}
