using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyNotice"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0"]
  }
}
