using util
using web
using wisp

class WebServer : AbstractMain
{

  @Opt
  Str target := ""

  @Opt
  Str title := "Web Example"

  @Opt { help = "http port" }
  Int port := 8080

  override Int run()
  {
    wisp := WispService
    {
      it.port = this.port
      it.root = WebServerMod(title, target)
    }
    return runServices([wisp])
  }
}

const class WebServerMod : WebMod
{

  const Str methodName
  
  const Str title

  const Uri[] deps

  new make(Str title, Str qname)
  {
    this.title = title
    Method? method := null
    Type? type := null
    Pod? pod := null
    if (qname.contains("."))
    {
      method = Method.findMethod(qname)
      type = method.parent()
      pod = type.pod
    }
    else if (qname.contains("::"))
    {
      type = Type.find(qname)
      method = type.method("main")
      pod = type.pod
    }
    else
    {
      pod = Pod.find(qname)
      type = pod.type("Main")
      method = type.method("main")
    }
    methodName = "fan.${pod.name}.${type.name}.${method.name}()"
    deps := collectDeps(pod)
    this.deps = deps.map |p| { `/pod/$p.name/${p.name}.js` }
  }

  Pod[] collectDeps(Pod pod)
  {
    Pod:Int deps := [:]
    deps[pod] = -1
    markDeps(pod, deps)
    return deps.keys.sort |p1, p2| { deps[p2] - deps[p1] }
  }

  Void markDeps(Pod pod, Pod:Int deps)
  {
    pod.depends.each
    {
      kidPod := Pod.find(it.name)
      val := deps.getOrAdd(kidPod) { 0 }
      deps[kidPod] = val + 1
      markDeps(kidPod, deps)
    }
  }

  override Void onGet()
  {
    name := req.modRel.path.first
    if (name == null)
      onIndex
    else if (name == "pod")
      onPodFile
    else
      res.sendErr(404)
  }

  Void onIndex()
  {
    // write page
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.docType
    out.html
    out.head
      out.title.w(title).titleEnd
      deps.each { out.includeJs(it) }
      out.script.w("window.onload = function() { $methodName; }").scriptEnd
    out.headEnd
    out.body
    out.bodyEnd
    out.htmlEnd
  }

  Void onPodFile()
  {
    // serve up pod resources
    uri := ("fan://" + req.uri[1..-1]).toUri
    File file := uri.get
    if (!file.exists) { res.sendErr(404); return }
    FileWeblet(file).onService
  }
}