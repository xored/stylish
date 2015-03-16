using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishUtil"
    version = Version.fromStr((scriptDir.parent + `version`).readAllLines.first)
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "fwt 1.0", "stylishMath 1.2"]
  }
}
