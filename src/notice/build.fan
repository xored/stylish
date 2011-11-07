using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishNotice"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "stylishMath 1.0"]
  }
}
