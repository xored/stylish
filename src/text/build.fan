using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishText"
    summary = ""
    srcDirs = [`test/`, `fan/`, `fan/example/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", "stylishCss 1.0",
      "stylishNotice 1.0", "stylishMath 1.0", "stylishUtil 1.0", "stylishMath 1.0", "stylishScene 1.0", "stylish 1.0"]
  }
}
