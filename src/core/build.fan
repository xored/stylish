using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "kawhy"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "gfx 1.0"]
  }
}
