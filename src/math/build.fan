using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyMath"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0"]
  }
}
