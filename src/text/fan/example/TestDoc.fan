using gfx
using stylishCss
using stylishNotice

@Js
class TestDoc : TextDoc
{
  override Int size() { lines.size }

  new make(Int size) { 
    for (i := 0; i < size; ++i) {
      lines.add(TestLine(this, i))
    }
  }

  override TestLine get(Int index) { lines[index] }

  Int clicks := 0
  {
    set
    {
      &clicks = it
      lines.each { it.updateText }
    }
  }
  
  Void removeLines(Int start, Int size) 
  {
    lines.removeRange(start..<start+size)
    fire(RemoveNotice(start, size))
  }

  Void addLines(Int size)
  {
    oldSize := this.size
    for (i := oldSize; i < oldSize + size; ++i) {
      lines.add(TestLine(this, i))
    }
    fire(AddNotice(oldSize, size))
  }

  internal TestLine[] lines := [,]

}

@Js
class TestLine : TextLine
{

  TestDoc doc
  Str baseText

  new make(TestDoc doc, Int index)
  {
    this.doc = doc
    baseText = "this is long long long long long long long long long long long long line with number: $index clicks count: "
    text = baseText
    style = BgStyle(Color.orange)
    tooltip := PropertyStyle(["title":"tooltip", "onmouseout":"alert(\"Hello!\")"])
    if (index % 5 == 0) styles = StyleList([StyleRange(TextStyle { color = Color.blue }, 0..3), StyleRange(LinkStyle(`http://google.com`, LinkTarget.blank), 5..10)])
    else styles = StyleList([StyleRange(TextStyle { color = Color.blue } + TextLineStyle { under = true; over = true; strike = true } + tooltip, 0..3)])
    updateText()
  }

  Void updateText()
  {
    replace(baseText.size, text.size - baseText.size, doc.clicks.toStr, null)
  }

  override Void listen(ListListener l)
  {
    super.listen(l)
    if (!doc.lines.contains(this)) doc.lines.add(this)
  }

  override Void discard(ListListener l)
  {
    super.discard(l)
    if (doc.lines.contains(this)) doc.lines.remove(this)
  }

  override Str text := ""

  override StyleList styles := StyleList([,])

  override Style? style {
    set {
      &style = it
      echo("someone set style to $it")
    }
  }
  
  Void setStyle(Style st) {
    style = st
    batch |->| {
      fire(RemoveNotice(0, size))
      text = "absdfsdds"
      fire(AddNotice(0, size))
    }
  }

}
