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
// Implementation
//////////////////////////////////////////////////////////////////////////

  override protected Void attach()
  {
    content.add(selectionNode)
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

  protected Void syncSelection()
  {
    content.remove(selectionNode)
    content.add(selectionNode)
    selectionNode.removeAll()
    if (source.size == 0) return
    sel := visibleSelection
    if (sel != null)
    {
      if (sel.start.row == sel.end.row)
      {
        if (sel.start.col < sel.end.col)
          selectionNode.add(createSelectPart(sel.start.row, sel.start.col, sel.end.col - sel.start.col, 1))
      }
      else
      {
        selectionNode.add(createSelectPart(sel.start.row, sel.start.col, 1000, 1))
        size := sel.end.row - sel.start.row - 1
        if (size > 0)
          selectionNode.add(createSelectPart(sel.start.row + 1, 0, 1000, size))
        selectionNode.add(createSelectPart(sel.end.row, 0, sel.end.col, 1))
      }
    }
  }

  private Group createSelectPart(Int row, Int col, Int w, Int h)
  {
    Group
    {
      it.style = BgStyle(Color.makeArgb(100, 51, 153, 255))
      it.pos = charPos(row, col)
      it.size = Size(10 * w, h * itemSize)
    }
  }

  private GridRange? visibleSelection()
  {
    range := selection.range
    lines := visibleLines
    if (lines.start > range.end.row || lines.last < range.start.row) return null
    start := lines.start > range.start.row ? GridPos(lines.start, 0) : range.start
    end := lines.last < range.end.row ? GridPos(lines.last, 100) : range.end
    return GridRange(start, end)
  }

  private Point charPos(Int row, Int col)
  {
    Point(10 * col, row * itemSize - scroll.y)
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
