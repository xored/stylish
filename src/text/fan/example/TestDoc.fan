using gfx
using kawhyCss
using kawhyNotice

@Js
class TestDoc : TextDoc
{

  override TextLine get(Int index) { TestLine(this, index) }

  Int clicks := 0
  {
    set
    {
      &clicks = it
      lines.each { it.updateText }
    }
  }

  override Int size() { 1000 }

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
    if (index % 5 == 0) styles = StyleList([StyleRange(TextStyle { color = Color.blue }, 0..3), StyleRange(LinkStyle(`http://google.com`), 5..10)])
    else styles = StyleList([StyleRange(TextStyle { color = Color.blue } + TextLineStyle { under = true; over = true; strike = true }, 0..3)])
    updateText()
  }

  Void updateText()
  {
    replace(baseText.size, text.size - baseText.size, doc.clicks.toStr, null)
  }

  override Void listen(ListListener l)
  {
    listeners.add(l)
    if (!doc.lines.contains(this)) doc.lines.add(this)
  }

  override Void discard(ListListener l)
  {
    listeners.remove(l)
    if (listeners.size == 0) doc.lines.remove(this)
  }

  override Str text := ""

  override StyleList styles := StyleList([,])

  override protected ListListener[] listeners := [,]

}
