using javaDeploy

class Build : BuildJar
{
  new make()
  {
    podName = "stylishDeploy"
    summary = ""
    srcDirs = [`fan/`]
    depends = ["sys 1.0", "gfx 1.0", "fwt 1.0", 
      "stylish 1.0", "stylishText 1.0", "stylishMath 1.0", "stylishCss 1.0", 
      "stylishScene 1.0", "stylishNotice 1.0", "stylishUtil 1.0"]
    
    subordinate = true
    jarName = "com.xored.stylish.jar"
    mainMethod = "stylishDeploy::Main.main"
    excludeFromJar = ["gfx", "fwt"]
    
    mvnGroupId = "com.xored"
    mvnArtifactId = "stylish"
    mvnVersion = "1.0.0-SNAPSHOT"
    
    mvnRepositoryUrl = "http://maven.xored.com/nexus/content/repositories/cisco-snapshots/"
    mvnRepositoryId = "xored"
  }
}
