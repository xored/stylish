using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyMath"
    summary = ""
    srcDirs = [`test/`, `fan/`]
    depends = ["sys 1.0"]
  }
}
