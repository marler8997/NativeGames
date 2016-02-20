

version(Windows)
{
  import windowsFramework;
}
else
{
  static assert(0, "Platform unknown");
}


