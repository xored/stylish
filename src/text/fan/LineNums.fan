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

  virtual protected Int lineNum(Int index) { index + 1 }

  virtual protected StyleRange[] lineStyles(Int index) { [,] }

  protected TextNode createLineNode(Int i)
  {
    TextNode
    {
      it.text = lineNum(i).toStr
      it.styles = lineStyles(i)
    }
  }

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
          text.styles = lineStyles(i)
        }
        else
        {
          text = TextNode
          {
            it.text = lineNum(i).toStr
            it.styles = lineStyles(i)
          }
        }
        cache[i] = text
        node.add(text)
      }
      index := text.text.size - 1
      textSize := sizes[index]
      if (textSize == null)
      {
        textSize = text.size.w
        sizes[index] = textSize
      }
      text.pos = Point(width - textSize, i * size - y)
    }
    trash.each { node.remove(it) }
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

  private Void updateWidth()
  {
    size := lineNumSize
    if (sizes.size < size) sizes.size = size
    if (sizes[size - 1] == null)
    {
      text := TextNode { it.text = "".padl(size, '0') }
      node.add(text)
      sizes[size - 1] = text.size.w
      node.remove(text)
    }
    width = sizes.last
  }

  private Int lineNumSize()
  {
    size := this.text.source.size
    if (size == 0) return 1
    return lineNum(size - 1).toStr.size
  }

  override Group node := Group { clip = true }

  private Notice? notice
  private ListCache cache := ListCache()
  private Int?[] sizes := [,]

}
