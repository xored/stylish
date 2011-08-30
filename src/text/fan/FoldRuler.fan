using gfx
using fwt
using kawhy
using kawhyNotice
using kawhyScene
using kawhyCss

@Js
class FoldRuler : Ruler
{

  static const Size iconSize := Size(7, 7)
  static const Int iconIndent := 2
  static const Color iconColor := Color(0x797979)
  static const Color rangeColor := Color.makeRgb(192, 192, 192)

  internal static Int foldWidth() { iconSize.w + iconIndent * 2 }

  new make(|This|? f := null)
  {
    style = FontStyle.monospace + TextStyle { color = Color.gray }
    f?.call(this)
    width = foldWidth
  }

  protected Void update()
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
  }

  private Void drawRange(Point mouse)
  {
    item := text.itemSize
    scroll := text.scroll.y
    line := (mouse.y + scroll) / item
    range := findFold(line)
    if (range == null) bg.figures = [,]
    else
    {
      start := 0.max(range.start * item - scroll + item / 2)
      end := range.end * item - scroll + item / 2
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
    start := 5 * (line / 5)
    if (start % 2 == 0) return null
    range := start..start + 2
    return range.contains(line) ? range : null
  }

  protected Fold[] findFolds(Range lines)
  {
    result := Fold[,]
    start := lines.start / 5
    end := lines.end / 5
    for(i := start; i <= end; i++)
    {
      result.add(Fold(i * 5..i * 5 + 2, i % 2 == 0))
    }
    return result
  }

  override Void attach()
  {
    super.attach()
    node.add(bg)
    notice = text.onScroll.handle |Point p| { update() }
    mouseMove = onMouseMove.handle |Point p| { drawRange(p) }
    hover = onHover.handle |hover| { if (!hover) bg.figures = [,] }
  }

  override Void detach()
  {
    notice?.discard
    mouseMove?.discard
    hover?.discard
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

  private Shape bg := Shape()

  override Group node := Group { clip = true }

  private FoldShape[] collapsed := [,]
  private FoldShape[] expanded := [,]

  private Notice? notice
  private Notice? mouseMove
  private Notice? hover

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
    listener.onClick = |Bool down| { if (!down) fold.toggle }
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
const class Fold
{

  const Range range

  const Bool collapsed

  new make(Range range, Bool collapsed)
  {
    this.range = range
    this.collapsed = collapsed
  }

  Void toggle() { echo("toggle!") }

  override Int compare(Obj fold)
  {
    range.start - (fold as Fold).range.start
  }
}
