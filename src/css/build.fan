using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishCss"
    summary = ""
    srcDirs = [`test/`, `fan/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0"]
  }
}
