using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyCompare"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", "kawhyScene 1.0", "kawhyCss 1.0",
      "kawhyNotice 1.0", "kawhyMath 1.0", "kawhy 1.0", "kawhyText 1.0"]
  }
}
