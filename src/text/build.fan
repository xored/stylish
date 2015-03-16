using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishText"
    version = Version.fromStr((scriptDir.parent + `version`).readAllLines.first)
    summary = ""
    srcDirs = [`test/`, `fan/`, `fan/example/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", "stylishCss 1.2",
      "stylishNotice 1.2", "stylishMath 1.2", "stylishUtil 1.2", "stylishMath 1.2", "stylishScene 1.2", "stylish 1.2"]
  }
}
