module platform;

version(Windows)
{
  public import windows.framework;
}
else
{
  static assert(0, "Unknown platform");
}
