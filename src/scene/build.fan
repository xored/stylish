using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishScene"
    summary = ""
    srcDirs = [`fan/`, `fan/trash/`, `fan/example/`]
    javaDirs = [`java/`]
    jsDirs = [`js/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", "stylishCss 1.0", "stylishNotice 1.0", "stylishMath 1.0", "stylishUtil 1.0"]
  }
}
