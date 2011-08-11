using gfx
using fwt
using kawhy
using kawhyNotice
using kawhyScene
using kawhyCss

@Js
class FoldRuler : Ruler
{

  const Size iconSize := Size(7, 7)
  const Int iconIndent := 2
  const Color iconColor := Color(0x797979)
  const Color rangeColor := Color.makeRgb(192, 192, 192)

  new make(|This|? f := null)
  {
    style = FontStyle.monospace + TextStyle { color = Color.gray }
    f?.call(this)
    width = iconSize.w + iconIndent * 2
  }

  protected Void update()
  {
    node.kids.each { (it.data["ml"] as MouseListener)?.detach }
    node.removeAll()
    bg.size = node.size
    bg.pos = Point.defVal
    node.add(bg)

    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    start := y / size
    end := (text.source.size - 1).min((y + h) / size)
    folds := findFolds(start..end)
    folds.each |fold|
    {
      shape := Shape
      {
        itShape := it
        itShape.size = Size(width, size)
        listener := MouseListener
        {
          it.node = itShape
          onClick = |Bool down| { if (!down) fold.toggle }
        }
        itShape.data["ml"] = listener
      }
      shape.style = CursorStyle(Cursor.pointer)
      node.add(shape)
      shape.pos = Point(width - shape.size.w, fold.range.start * size - y)
      shape.figures = [createFold(fold.collapsed)]
    }
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

  private Figure createFold(Bool folded)
  {
    points := Point[,]
    pos := Point(iconIndent, (text.itemSize - iconSize.h) / 2)
    if (folded)
    {
      points.add(pos)
      points.add(pos.translate(Point(0, iconSize.h)))
      points.add(pos.translate(Point(iconSize.w, iconSize.h / 2)))
    }
    else
    {
      points.add(pos)
      points.add(pos.translate(Point(iconSize.w, 0)))
      points.add(pos.translate(Point(iconSize.w / 2, iconSize.h)))
    }
    return Polygon
    {
      brush = iconColor
      it.points = points
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
    notice = text.onScroll.handle |Point p| { update() }
    mouseMove = onMouseMove.handle |Point p| { drawRange(p) }
    hover = onHover.handle |hover| { if (!hover) bg.figures = [,] }
  }

  override Void detach()
  {
    notice?.discard
    mouseMove?.discard
    hover?.discard
  }

  override protected Void onResize(Size s) { update() }

  private Shape bg := Shape()

  override Group node := Group { clip = true }

  private Notice? notice
  private Notice? mouseMove
  private Notice? hover

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
