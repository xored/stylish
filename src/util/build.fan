using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishUtil"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "fwt 1.0", "stylishMath 1.0"]
  }
}
