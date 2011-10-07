using gfx
using kawhyCss
using kawhyNotice

@Js
class TestDoc : TextDoc
{

  override Int size

  new make(Int size) { this.size = size }

  override TextLine get(Int index) { TestLine(this, index) }

  Int clicks := 0
  {
    set
    {
      &clicks = it
      lines.each { it.updateText }
    }
  }

  Void addLines(Int size)
  {
    oldSize := this.size
    this.size = oldSize + size
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
    baseText = "line number: $index clicks count: "
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

  override Style? style

}
