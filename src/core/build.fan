using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylish"
    version = Version.fromStr((scriptDir.parent + `version`).readAllLines.first)
    summary = ""
    srcDirs = [`fan/`, `fan/listeners/`, `fan/example/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", "stylishScene 1.2", "stylishCss 1.2", "stylishNotice 1.2", "stylishMath 1.2"]
  }
}