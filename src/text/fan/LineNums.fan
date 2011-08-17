using gfx
using kawhy
using kawhyMath
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

  protected TextNode createLineNode(Int i)
  {
    TextNode
    {
      it.text = lineNum(i).toStr
      it.styles = lineStyles(i)
    }
  }

  virtual protected Int lineNum(Int index) { index + 1 }

  virtual protected StyleRange[] lineStyles(Int index) { [,] }

  protected Void update()
  {
    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    start := y / size
    end := (text.source.size - 1).min((y + h) / size) + 1
    cache.moveRegion(Region(start, end - start))
    trash := cache.trash
    cache.clearTrash()
    for(i := start; i < end; i++)
    {
      text := cache[i] as TextNode
      if (text == null)
      {
        if (trash.size > 0)
        {
          text = trash.removeAt(trash.size - 1)
          text.text = lineNum(i).toStr
        }
        else
        {
          text = createLineNode(i)
        }
        cache[i] = text
        node.add(text)
      }
      text.pos = Point(width - charSize * text.text.size, i * size - y)
    }
  }

  internal Void updateWidth()
  {
    text := TextNode { it.text = this.text.source.size.toStr }
    node.add(text)
    w := text.size.w
    node.remove(text)
    width = w
    charSize = width / text.size.w
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

  override protected Void onResize(Size s) { update() }

  override Void fire(ListNotice notice)
  {
    updateWidth()
    node.removeAll
    update()
  }

  override Group node := Group { clip = true }

  private Notice? notice
  private ListCache cache := ListCache()
  private Int charSize := 1

}
