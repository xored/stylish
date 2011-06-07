
using util
using web
using wisp

class Example : AbstractMain
{
  @Opt { help = "http port" }
  Int port := 8080

  override Int run()
  {
    wisp := WispService
    {
      it.port = this.port
      it.root = ExampleMod()
    }
    return runServices([wisp])
  }
}

const class ExampleMod : WebMod
{
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
      out.title.w("Text widget demo").titleEnd
      out.includeJs(`/pod/sys/sys.js`)
      out.includeJs(`/pod/concurrent/concurrent.js`)
      out.includeJs(`/pod/gfx/gfx.js`)
      out.includeJs(`/pod/fwt/fwt.js`)
      out.includeJs(`/pod/kawhyCss/kawhyCss.js`)
      out.includeJs(`/pod/kawhyScene/kawhyScene.js`)
      out.script.w("window.onload = function() { fan.kawhyScene.Main.main(); }").scriptEnd
    out.headEnd
    out.body
    out.h1
    out.w("Web Editor")
    out.h1End
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