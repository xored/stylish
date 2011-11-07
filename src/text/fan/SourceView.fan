using gfx
using stylish

@Js
class SourceView : GroupControl
{

  new make(|This|? f := null) { f?.call(this) }

  TextEdit text := TextEdit()

  Ruler[] leftRulers := [,]

  Ruler[] rightRulers := [,]

  override protected Control[] kids()
  {
    list := Control[,]
    list.add(text)
    list.addAll(leftRulers)
    list.addAll(rightRulers)
    return list
  }

  override protected Void onResize(Size s)
  {
    Int leftWidth  := leftRulers.reduce(0)  |Int w, ruler->Int| { w + ruler.width }
    Int rightWidth := rightRulers.reduce(0) |Int w, ruler->Int| { w + ruler.width }
    textWidth := 0.max(s.w - leftWidth - rightWidth)
    text.node.pos = Point(leftWidth, 0)
    text.resize(Size(textWidth, s.h))

    h := text.clientArea.h
    Int left := leftRulers.reduce(0) |Int l, Ruler r->Int|
    {
      r.node.pos = Point(l, 0)
      r.resize(Size(r.width, h))
      return l + r.width
    }
    left += textWidth
    rightRulers.reduce(left) |Int l, Ruler r->Int|
    {
      r.node.pos = Point(l, 0)
      r.resize(Size(r.width, h))
      return l + r.width
    }
  }

}
