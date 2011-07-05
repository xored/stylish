using gfx
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
    x := scroll.x + pos
    node := itemByIndex(row) as TextNode
    return node.offsetAt(x)
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
    content.add(selectionNode)
    p := SelectionPolicy.make(this)
    super.attach()
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
    content.remove(selectionNode)
    content.add(selectionNode)
    selectionNode.removeAll()
    if (source.size == 0) return
    sel := visibleSelection
    if (sel != null)
    {
      w := content.size.w
      if (sel.start.row == sel.end.row)
      {
        if (sel.start.col < sel.end.col)
        {
          selectionNode.add(createSelectPart(sel.start.row, 1, sel.start.col, sel.end.col))
        }
      }
      else
      {
        selectionNode.add(createSelectPart(sel.start.row, 1, sel.start.col))
        size := sel.end.row - sel.start.row - 1
        if (size > 0)
          selectionNode.add(createSelectPart(sel.start.row + 1, size, 0))
        if (sel.end.col > 0)
          selectionNode.add(createSelectPart(sel.end.row, 1, 0, sel.end.col))
      }
    }
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

  private Group selectionNode := Group()

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
