using gfx
using kawhy
using kawhyScene
using kawhyCss
using kawhyText

@Js
class CompareView : GroupControl
{

  TextDoc a := BaseTextDoc { it.size = 1000 }

  TextDoc b := BaseTextDoc { it.size = 1000 }

  new make(|This|? f := null) : super()
  {
    f?.call(this)
    aView = SourceView
    {
      text = CompareTextEdit { source = a }
      leftRulers = [LineNums(), SeparatorRuler()]
    }
    bView = SourceView
    {
      text = CompareTextEdit { source = b }
      leftRulers = [LineNums(), SeparatorRuler()]
    }
    scroll = Slider(Orientation.vertical)
  }

  override protected Control[] kids()
  {
    list := Control[,]
    list.add(aView)
    list.add(bView)
    list.add(scroll)
    return list
  }

  override protected Void onResize(Size s)
  {
    sw := scroll.size.w
    w := s.w - sw
    w1 := w / 2
    w2 := w - w1
    aView.node.pos = Point.defVal
    aView.resize(Size(w1, s.h))
    bView.node.pos = Point(w1, 0)
    bView.resize(Size(w2, s.h))
    scroll.node.pos = Point(w, 0)
    scroll.resize(Size(sw, s.h - sw))
  }

  private SourceView aView
  private SourceView bView
  private Slider scroll

}

@Js
class CompareTextEdit : TextEdit
{

  new make(|This|? f := null) : super()
  {
    node = ScrollArea { vertical = false }
    style = FontStyle.monospace
    onMouseWheel
    {
      y := it.y * itemSize
      x := it.x * 10
      this.scroll = Point(this.scroll.x + x, this.scroll.y + y)
    }
    f?.call(this)
  }

}