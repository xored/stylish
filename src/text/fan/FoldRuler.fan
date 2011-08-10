using gfx
using fwt
using kawhy
using kawhyNotice
using kawhyScene
using kawhyCss

@Js
class FoldRuler : Ruler
{

  const Size iconSize := Size(8, 8)
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
    node.removeAll()

    y := text.scroll.y
    h := text.clientArea.h
    size := text.itemSize
    start := y / size
    end := (text.source.size - 1).min((y + h) / size)
    folds := findFolds(start..end)
    folds.each
    {
      fold := it
      shape := Shape
      {
        it.size = Size(width, size)
      }
      shape.style = CursorStyle(Cursor.pointer)
      node.add(shape)
      shape.pos = Point(width - shape.size.w, fold.range.start * size - y)
      shape.figures = [createFold(fold.collapsed)]
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
  }

  override Void detach()
  {
    notice?.discard
  }

  override protected Void onResize(Size s) { update() }

  override Group node := Group { clip = true }

  private Notice? notice

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

  override Int compare(Obj fold)
  {
    range.start - (fold as Fold).range.start
  }
}
