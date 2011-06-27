using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyText"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "gfx 1.0", "kawhyCss 1.0", "kawhyNotice 1.0", "kawhyMath 1.0", "kawhyUtil 1.0", "kawhyMath 1.0"]
  }
}
