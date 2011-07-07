using gfx
using fwt
using kawhy
using kawhyMath
using kawhyCss
using kawhyScene
using kawhyNotice

@Js
class TextEdit : ListView
{

  new make(|This|? f) { f(this) }

//////////////////////////////////////////////////////////////////////////
// State
//////////////////////////////////////////////////////////////////////////

  override TextDoc source := BaseTextDoc()

  Selection selection := Selection(this)

//////////////////////////////////////////////////////////////////////////
// Mertics
//////////////////////////////////////////////////////////////////////////

  Int? colByPos(Int row, Int pos)
  {
    node := itemByIndex(row) as TextNode
    return node.offsetAt(pos)
  }

  Region colRegion(Int row, Int col)
  {
    node := itemByIndex(row) as TextNode
    return node.charRegion(col)
  }

//////////////////////////////////////////////////////////////////////////
// Implementation
//////////////////////////////////////////////////////////////////////////

  override protected Void attach()
  {
    content.add(contentArea)
    content.style = CursorStyle(Cursor.text)
    attachSelection()
    p := SelectionPolicy.make(this)
    super.attach()
  }

  protected Void attachSelection()
  {
    selectStyle := BgStyle(Color.makeArgb(100, 51, 153, 255))
    selectArea.add(Group { it.style = selectStyle }) 
    selectArea.add(Group { it.style = selectStyle }) 
    selectArea.add(Group { it.style = selectStyle })
    content.add(selectArea)
  }

  override protected Node createItem(Int i)
  {
    TextNode
    {
      it.data[lineData] = LineListener(it, source[i])
    }
  }

  override protected Void disposeItem(Node node)
  {
    (node.data[lineData] as LineListener)?.dispose
  }

  override protected Void sync()
  {
    super.sync()
    syncSelection()
  }

  internal Void syncSelection()
  {
    // TODO this piece of code waiting for a good refactoring
    header := selectArea.kid(0)
    body := selectArea.kid(1)
    footer := selectArea.kid(2)
    if (source.size == 0)
    {
      header.size = Size.defVal
      body.size = Size.defVal
      footer.size = Size.defVal
    }
    sel := visibleSelection
    if (sel != null)
    {
      h := itemSize
      y := sel.start.row * h
      pos := Point(colStart(sel.start.row, sel.start.col), y)
      header.pos = pos

      if (sel.start.row == sel.end.row)
      {
        body.pos = Point.defVal
        body.size = Size.defVal
        footer.pos = Point.defVal
        footer.size = Size.defVal

        if (sel.start.col < sel.end.col)
        {
          endRegion := colRegion(sel.end.row, sel.end.col - 1)
          header.size = Size(endRegion.end - header.pos.x, h)
        }
        else
        {
          header.size = Size.defVal
        }
      }
      else
      {
        header.size = Size(content.size.w - header.pos.x, h)

        size := sel.end.row - sel.start.row - 1
        if (size > 0)
        {
          body.pos = Point(0, y + h)
          body.size = Size(content.size.w, size * h)
        }
        else
        {
          body.pos = Point.defVal
          body.size = Size.defVal
        }
        if (sel.end.col > 0)
        {
          footer.pos = Point(0, sel.end.row * h)
          endRegion := colRegion(sel.end.row, sel.end.col - 1)
          footer.size = Size(endRegion.end, h)
        }
        else
        {
          footer.pos = Point.defVal
          footer.size = Size.defVal
        }
      }
    }
  }

  private Int colStart(Int row, Int col)
  {
    node := itemByIndex(row) as TextNode
    size := node.text.size
    if (size == 0) return 0
    if (col < size) return node.charRegion(col).start
    return node.charRegion(size - 1).end
  }

  private Group createSelectPart(Int row, Int h, Int from, Int? to := null)
  {
    Group
    {
      from = colRegion(row, from).first
      if (to == null) to = content.size.w
      else to = colRegion(row + h - 1, to - 1).last
      it.style = BgStyle(Color.makeArgb(100, 51, 153, 255))
      it.pos = Point(from, row * itemSize)
      it.size = Size(to - from + 1, h * itemSize)
    }
  }

  private GridRange? visibleSelection()
  {
    range := selection.range.norm
    raws := visibleRaws()
    if (raws.start > range.end.row || raws.last < range.start.row) return null
    start := raws.start > range.start.row ? GridPos(raws.start, 0) : range.start
    end := raws.last < range.end.row ? GridPos(raws.last + 1, 0) : range.end
    res := GridRange(start, end)
    return res
  }

  private Group selectArea := Group()
  override protected Group contentArea := Group()

  private static const Str lineData := "lineListener"

}

@Js
internal class LineListener : ListListener
{

  new make(TextNode node, TextLine line)
  {
    this.node = node
    this.line = line
    line.listen(this)
    sync()
  }

  override Void fire(ListNotice n) { sync() }

  private Void sync()
  {
    //TODO place for lazy update
    node.text = ""
    node.styles = line.styles.ranges
    node.text = line.text
  }

  Void dispose() { line.discard(this) }

  private TextNode node
  private TextLine line

}
