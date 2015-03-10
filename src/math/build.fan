using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "stylishMath"
    version = Version.fromStr((scriptDir.parent + `version`).readAllLines.first)
    summary = ""
    srcDirs = [`test/`, `fan/`]
    depends = ["sys 1.0"]
  }
}
