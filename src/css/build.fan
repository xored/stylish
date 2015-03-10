using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishCss"
    version = Version.fromStr((scriptDir.parent + `version`).readAllLines.first)
    summary = ""
    srcDirs = [`test/`, `fan/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0"]
  }
}
