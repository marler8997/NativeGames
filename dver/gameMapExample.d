module gameMapExample;

import core.runtime;
import core.sys.windows.windows;

import platform;

LRESULT Paint(HWND hwnd, WPARAM wParam, LPARAM lParam)
{
   PAINTSTRUCT paintStruct;
   HDC hdc = BeginPaint(hwnd, &paintStruct);
   scope(exit)EndPaint(hwnd, &paintStruct);
   // Window surface!
   // Item 0
   if(10 < windowContentWidth || 10 < windowContentHeight) {
      {
         RECT rect = {10,10,110,110};
         FillRect(hdc, &rect, cast(HBRUSH)(COLOR_HIGHLIGHTTEXT));
      }
   }
   return 0;
}
