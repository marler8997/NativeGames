#!/usr/bin/env rdmd
import std.stdio;
import std.getopt;
import std.process;
import std.string : format;
import std.array : appender;
import std.path : stripExtension;

ubyte[512] buffer;

//
// Run a shell command and print the output sectioned off if there is any output
//
auto run(string context, string command)
{
  if(context.length) {
    writeln("[EXECUTE] ", context, ": ", command);
  } else {
    writeln("[EXECUTE] ", command);
  }
  stdout.flush();

  auto pipes = pipeShell(command, Redirect.stdout | Redirect.stderr);
  bool output = false;

  void flushPipe(File pipe) {

    while(true) {
      auto data = pipe.rawRead(buffer);
      if(data.length == 0) break;

      if(!output) {
	writeln("--------------------------------------------------------------------------------");
	output = true;
      }
      stdout.rawWrite(data);
      stdout.flush();
    }

  }

  flushPipe(pipes.stdout);
  flushPipe(pipes.stderr);
  auto ret = wait(pipes.pid);

  if(output) {
    writeln("--------------------------------------------------------------------------------");
    stdout.flush();
  }

  return ret;
}
bool runAndCheck(string context, string command)
{
  auto ret = run(context, command);
  if(ret == 0)
    return false;
  
  writefln("[STATUS] Command '%s' failed with return code %s", command, ret);
  return true;
}

void usage()
{
  writeln("Usage: build <source-files>...");
}
int main(string[] args)
{
  string platform;
  version(Windows)
  {
    platform = "windows";
  }
  else
  {
    static assert(0, "Unknown platform");
  }


  getopt(args);

  if(args.length == 1) {
    usage();
    return 0;
  }

  string outputFile = args[1].stripExtension;
  
  auto appender = appender!string();
  foreach(arg; args[1..$]) {
    appender.put(' ');
    appender.put(arg);
  }


  
  if(runAndCheck(null, format(`dmd -I. -of%s platform.d %s/framework.d %s`,
			      outputFile, platform, appender.data))) {
    return 1;
  }

  return 0;
}
