using javaDeploy

class Build : BuildJar
{
  new make()
  {
    podName = "stylishDeploy"
    version = Version.fromStr((scriptDir.parent + `src/version`).readAllLines.first)
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", 
      "stylish 1.2", "stylishText 1.2", "stylishMath 1.2", "stylishCss 1.2", 
      "stylishScene 1.2", "stylishNotice 1.2", "stylishUtil 1.2"]
    
    subordinate = true
    jarName = "com.xored.stylish.jar"
    mainMethod = "stylishDeploy::Main.main"
    excludeFromJar = ["gfx", "fwt"]
    
    mvnGroupId = "com.xored"
    mvnArtifactId = "stylish"
    mvnVersion = version.toStr
    
    mvnRepositoryUrl = "http://maven.xored.com/nexus/content/repositories/cisco-releases/"
    mvnRepositoryId = "xored"
  }
}
