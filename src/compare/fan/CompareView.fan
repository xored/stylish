using gfx
using stylish
using stylishScene
using stylishCss
using stylishText

@Js
class CompareView : GroupControl
{

  CompareDoc doc

  TextDoc a { private set }

  TextDoc b { private set }

  new make(|This|? f := null) : super()
  {
    f?.call(this)
    aView = SourceView
    {
      text := CompareTextEdit { source = doc.a }
      it.text = text
      leftRulers = [LineNums(), SeparatorRuler()]
      text.onScroll.handle |Point p|
      {
        echo("a: try (a=$aSkip b=$bSkip)")
        if (aSkip) { aSkip = false; return }
        echo("a: start (a=$aSkip b=$bSkip)")
        item := text.itemSize
        line := p.y / item
        newY := doc.c2b(doc.a2c(line)) * item
        scroll := bView.text.scroll
        if (newY != scroll.y)
        {
          bView.text.scroll = Point(scroll.x, newY)
          aSkip = true
        }
        else { bSkip = false; aSkip = false }
        echo("a: end (a=$aSkip b=$bSkip)")
      }
    }
    bView = SourceView
    {
      text := CompareTextEdit { source = doc.b }
      it.text = text
      leftRulers = [LineNums(), SeparatorRuler()]
      text.onScroll.handle |Point p|
      {
        echo("b: try (a=$aSkip b=$bSkip)")
        if (bSkip) { bSkip = false; return }
        echo("b: start (a=$aSkip b=$bSkip)")
        bSkip = true
        item := text.itemSize
        line := p.y / item
        scroll := aView.text.scroll
        newY := doc.c2a(doc.b2c(line)) * item
        if (newY != scroll.y)
        {
          aView.text.scroll = Point(scroll.x, newY)
          bSkip = true
        }
        else { bSkip = false; aSkip = false }
        echo("b: end (a=$aSkip b=$bSkip)")
      }
    }
    scroll = Slider(Orientation.vertical)
    scale := 4
    scroll.node.max = doc.total * scale
    scroll.node.thumb = aView.text.visibleRows.size * scale
    scroll.node.onScroll = |Int i|
    {
      item := aView.text.itemSize
      a := doc.c2a(i / scale)
      b := doc.c2b(i / scale)

      aView.text.scroll = Point(aView.text.scroll.x, a * item)
      bView.text.scroll = Point(bView.text.scroll.x, b * item)
    }
  }

  private Bool aSkip := false
  private Bool bSkip := false

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