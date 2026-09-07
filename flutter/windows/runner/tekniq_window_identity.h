#pragma once
#include <windows.h>
#include <string>

inline std::wstring TekniqMainWindowProperty(const std::wstring& app_name) {
  return app_name + L".MainWindow";
}

struct TekniqMainWindowSearch {
  std::wstring app_name;
  std::wstring class_name;
  HWND window = nullptr;
};

inline BOOL CALLBACK FindTekniqMainWindowCallback(HWND hwnd, LPARAM parameter) {
  auto& search = *reinterpret_cast<TekniqMainWindowSearch*>(parameter);
  wchar_t class_name[256] = {};
  GetClassNameW(hwnd, class_name, 256);
  if (search.class_name != class_name) return TRUE;
  wchar_t title[512] = {};
  GetWindowTextW(hwnd, title, 512);
  const std::wstring caption(title);
  const auto test_prefix = search.app_name + L" \u00b7 test ";
  if (GetPropW(hwnd, TekniqMainWindowProperty(search.app_name).c_str()) != nullptr ||
      caption == search.app_name || caption.rfind(test_prefix, 0) == 0) {
    search.window = hwnd;
    return FALSE;
  }
  return TRUE;
}

inline HWND FindTekniqMainWindow(const std::wstring& app_name, const wchar_t* class_name) {
  TekniqMainWindowSearch search{app_name, class_name};
  EnumWindows(FindTekniqMainWindowCallback, reinterpret_cast<LPARAM>(&search));
  return search.window;
}
