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

  new make(|This|? f := null)
  {
    style = FontStyle.monospace
    f?.call(this)
  }

//////////////////////////////////////////////////////////////////////////
// State
//////////////////////////////////////////////////////////////////////////

  override TextDoc source := BaseTextDoc()

  Selection selection := Selection(this)

//////////////////////////////////////////////////////////////////////////
// Mertics
//////////////////////////////////////////////////////////////////////////

  Int? colByPos(Int row, Int pos) { item(row).offsetAt(pos) }

  //TODO don't like this method
  Region colRegion(Int row, Int col) { item(row).charRegion(col) }

  GridPos textPos(Point pos)
  {
    row := rowByPos(pos.y)
    if (row == null) row = source.size - 1
    rows := visibleRows
    if (row < rows.start) return GridPos(rows.start - 1, 0)
    if (row > rows.last) return GridPos(rows.last + 1, 0)
    col := colByPos(row, pos.x)
    if (col == null) col = source[row].size
    return GridPos(row, col)
  }

  GridPos end()
  {
    row := source.size - 1
    return GridPos(row, source[row].size)
  }

//////////////////////////////////////////////////////////////////////////
// Implementation
//////////////////////////////////////////////////////////////////////////

  override protected Void attach()
  {
    content.add(contentArea)
    content.style = CursorStyle(Cursor.text)
    attachSelection()
    policies =
    [
      SelectPoint { control = this },
      SelectAll   { control = this },
      SelectWord  { control = this },
      SelectLine  { control = this }
    ]
    policies.each { it.attach() }
    super.attach()
  }

  override protected Void detach()
  {
    policies.each { it.detach() }
    super.detach()
  }

  protected Void attachSelection()
  {
    selectStyle := BgStyle(Color.makeArgb(100, 51, 153, 255))
    node.scene.clipboard.textSource = TextEditSource(this)
    selectArea.add(Group { it.style = selectStyle }) 
    selectArea.add(Group { it.style = selectStyle }) 
    selectArea.add(Group { it.style = selectStyle })
    content.add(selectArea)
    selection.onChange { syncSelection() }
  }

  override protected Node createItem(Int i)
  {
    TextNode
    {
      it.data[lineData] = LineListener(this, it, source[i])
    }
  }

  override protected Void disposeItem(Node node)
  {
    (node.data[lineData] as LineListener)?.dispose
  }

  override once Int itemSize()
  {
    view := TextNode { it.text = "text" }
    contentArea.add(view)
    size := view.size.h
    contentArea.remove(view)
    return size
  }

  override protected Void sync()
  {
    super.sync()
    syncSelection()
  }

  internal Void doNodeUpdate(Node node) { nodeUpdate(node) }

  virtual protected Void syncSelection()
  {
    // TODO this piece of code waiting for a good refactoring
    kids := selectArea.kids
    header := kids[0]
    body := kids[1]
    footer := kids[2]
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
        if (sel.end.col > 0 && sel.end.row <= loadedRows.last)
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

  private TextNode? item(Int row)
  {
    loadedRows.contains(row) ? (itemByIndex(row) as TextNode) : null
  }

  private GridRange? visibleSelection()
  {
    range := selection.range.norm
    rows := loadedRows
    if (rows.start > range.end.row || rows.last < range.start.row) return null
    start := rows.start > range.start.row ? GridPos(rows.start, 0) : range.start
    end := rows.last < range.end.row ? GridPos(rows.last + 1, 0) : range.end
    return GridRange(start, end)
  }

  private Policy[] policies := [,]
  private Group selectArea := Group()
  override protected Group contentArea := Group()

  private static const Str lineData := "lineListener"

}

@Js
internal class LineListener : ListListener
{

  new make(TextEdit edit, TextNode node, TextLine line)
  {
    this.edit = edit
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
    edit.doNodeUpdate(node)
  }

  Void dispose() { line.discard(this) }

  private TextNode node
  private TextLine line
  private TextEdit edit

}

@Js
internal class TextEditSource : TextSource
{

  new make(TextEdit edit)
  {
    this.edit = edit
    edit.selection.onChange { this.onChange?.call() }
  }

  override |->|? onChange := null

  override Str text(Range range := 0..-1) { edit.selection.text(range) }

  override Int size() { edit.selection.size }

  override Bool isEmpty() { edit.selection.isEmpty }

  private TextEdit edit

}
