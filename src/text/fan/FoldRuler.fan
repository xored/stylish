using gfx
using fwt
using stylish
using stylishNotice
using stylishScene
using stylishCss

@Js
class FoldRuler : Ruler
{

  static const Size iconSize := Size(7, 7)
  static const Int iconIndent := 2
  static const Color iconColor := Color(0x797979)
  static const Color rangeColor := Color.makeRgb(192, 192, 192)

  internal static Int foldWidth() { iconSize.w + iconIndent * 2 }

  private Int lastMouseY := -1 
  
  ProjDoc doc

  new make(|This|? f := null)
  {
    style = FontStyle.monospace + TextStyle { color = Color.gray }
    f?.call(this)
    width = foldWidth
  }

  internal Void update()
  {
    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    start := y / size
    end := (text.source.size - 1).min((y + h) / size)
    folds := findFolds(start..end)

    collapsed := this.collapsed.dup
    expanded := this.expanded.dup
    folds.each |fold|
    {
      FoldShape? shape := null
      if (fold.collapsed)
      {
        if (collapsed.size > 0)
        {
          shape = collapsed.removeAt(collapsed.size - 1)
        }
        else
        {
          shape = FoldShape(node, true, size)
          this.collapsed.add(shape)
        }
      }
      else
      {
        if (expanded.size > 0)
        {
          shape = expanded.removeAt(expanded.size - 1)
        }
        else
        {
          shape = FoldShape(node, false, size)
          this.expanded.add(shape)
        }
      }
      shape.attach(fold, fold.range.start * size - y)
    }
    collapsed.each { it.hide }
    expanded.each { it.hide }
    
    drawRange(lastMouseY)
  }

  private Void drawRange(Int mouseY)
  {
    if (mouseY < 0)
    {
      bg.figures = [,]
      return
    }
    
    item := text.itemSize
    scroll := text.scroll.y
    line := (mouseY + scroll) / item
    range := findFold(line)
    if (range == null) bg.figures = [,]
    else
    {
      start := 0.max(range.start * item - scroll + item / 2)
      end := range.last * item - scroll + item / 2
      w := bg.size.w / 2

      points := [Point(w, start)]
      if (end < bg.size.h)
      {
        points.add(Point(w, end))
        points.add(Point(w + iconSize.w / 2, end))
      }
      else
      {
        points.add(Point(w, bg.size.h))
      }
      bg.figures = [Polyline { brush = rangeColor; it.points = points }]
    }
  }

  protected Range? findFold(Int line)
  {
    Fold? fold := doc.find(line)
    return fold == null ? null : (fold.collapsed ? null : fold.range)
  }

  protected Fold[] findFolds(Range lines)
  {
    res := Fold[,]
    lines.each |line|
    {
      Fold? fold := doc.find(line)
      if (fold != null)
        res.add(fold)
    }
    return res
  }

  override Void attach()
  {
    super.attach()
    if (text.source as ProjDoc == null)
      throw Err("Unable to attach to TextEdit that isn't based on the ProjDoc.")
    doc = (ProjDoc)text.source
    node.add(bg)
    notice = text.onScroll.handle |Point p| { update() }
    mouseMove = onMouseMove.handle |Point p| { lastMouseY = p.y; drawRange(lastMouseY) }
    hover = onHover.handle |hover| { if (!hover) { lastMouseY = -1; bg.figures = [,] } }
    doc.listen(docListener)
    doc.addFoldListener(foldListener)
  }

  override Void detach()
  {
    notice?.discard
    mouseMove?.discard
    hover?.discard
    doc.discard(docListener)
    doc.removeFoldListener(foldListener)
    collapsed.each { it.detach }
    expanded.each { it.detach }
    collapsed = [,]
    expanded = [,]
  }

  override protected Void onResize(Size s)
  {
    bg.size = node.size
    update()
  }

  override Group node := Group { clip = true }

  private Shape bg := Shape()

  private FoldShape[] collapsed := [,]
  private FoldShape[] expanded := [,]

  private Notice? notice
  private Notice? mouseMove
  private Notice? hover

  private |Fold[]| foldListener := |Fold[] folds| { update }
  private DocListener docListener := DocListener
  {
    onAddCallback = |->| { update }
    onRemoveCallback = |->| { update }
  }
}

@Js
internal class FoldShape
{

  Bool folded

  private Int h
  private MouseListener listener
  private Shape shape

  new make(Group node, Bool folded, Int h)
  {
    this.folded = folded
    this.h = h
    shape = Shape
    {
      it.style = CursorStyle(Cursor.pointer)
      it.size = Size(FoldRuler.foldWidth, h)
      it.figures = [createFold(folded)]
    }
    listener = MouseListener { it.node = shape }
    node.add(shape)
    hide()
  }

  Void attach(Fold fold, Int y)
  {
    shape.pos = Point(0, y)
    listener.onClick = |Bool down|
    {
      if (!down)
      {
        fold.toggle
      }
    }
  }

  Void hide()
  {
    listener.onClick = null
    shape.pos = Point(0, -h)
  }

  Void detach()
  {
    shape.parent.remove(shape)
    listener.detach
  }

  private Figure createFold(Bool folded)
  {
    points := Point[,]
    size := FoldRuler.iconSize
    pos := Point(FoldRuler.iconIndent, (h - size.h) / 2)
    if (folded)
    {
      points.add(pos)
      points.add(pos.translate(Point(0, size.h)))
      points.add(pos.translate(Point(size.w, size.h / 2)))
    }
    else
    {
      points.add(pos)
      points.add(pos.translate(Point(size.w, 0)))
      points.add(pos.translate(Point(size.w / 2, size.h)))
    }
    return Polygon
    {
      brush = FoldRuler.iconColor
      it.points = points
    }
  }

}

@Js
internal class DocListener : ListListener
{

  |Int index, Int size| onAddCallback := |index| {}
  |Int index, Int size| onRemoveCallback := |index| {}

  override Void onAdd(Int index, Int size) { onAddCallback(index, size) }
  override Void onRemove(Int index, Int size) { onRemoveCallback(index, size) }

}
