using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyText"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0"]
  }
}
