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

  protected Void update()
  {
    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    node.removeAll()
    for(i := y / size; i <= (y + h) / size; i++)
    {
      text := TextNode
      {
        it.text = (i + 1).toStr
        it.pos = Point(0, i * size - y)
      }
      node.add(text)
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
