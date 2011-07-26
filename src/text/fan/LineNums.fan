using gfx
using kawhy
using kawhyNotice
using kawhyScene
using kawhyCss

@Js
class LineNums : Ruler, ListListener
{

  new make(|This|? f := null)
  {
    style = FontStyle.monospace + TextStyle { color = Color.gray }
    f?.call(this)
  }

  virtual protected Node createLineNode(Int i)
  {
    TextNode
    {
      it.text = (i + 1).toStr
    }
  }

  protected Void update()
  {
    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    node.removeAll()
    end := (text.source.size - 1).min((y + h) / size)
    for(i := y / size; i <= end; i++)
    {
      text := createLineNode(i)
      node.add(text)
      text.pos = Point(width - text.size.w, i * size - y)
    }
  }

  internal Void updateWidth()
  {
    text := TextNode { it.text = this.text.source.size.toStr }
    node.add(text)
    w := text.size.w
    node.remove(text)
    width = w
  }

  override Void attach()
  {
    super.attach()
    notice = text.onScroll.handle |Point p| { update() }
    text.source.listen(this)
    updateWidth()
  }

  override Void detach()
  {
    text.source.discard(this)
    notice?.discard
  }

  override Void fire(ListNotice notice)
  {
    updateWidth()
  }

  override protected Void onResize(Size s) { update() }

  private Notice? notice

  override Group node := Group { clip = true }

}
