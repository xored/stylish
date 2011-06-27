using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyUtil"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "kawhyMath 1.0"]
  }
}
