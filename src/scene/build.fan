using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhyScene"
    summary = ""
    srcDirs = [`fan/`, `fan/native/`, `fan/example/`, `fan/base/`]
    javaDirs = [`java/`]
    jsDirs = [`js/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0"]
  }
}
