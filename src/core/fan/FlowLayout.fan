using gfx

@Js
class FlowLayout : Layout
{

  Orientation orientation := Orientation.horizontal

  override Void layout(Control[] kids, |Control, Rect| layer)
  {
    if (orientation == Orientation.horizontal)
    {
      x := 0
      kids.each
      {
        size := it.hints.prefSize
        layer(it, Rect.makePosSize(Point(x, 0), size))
        x += size.w
      }
    }
    else
    {
      y := 0
      kids.each
      {
        size := it.hints.prefSize
        layer(it, Rect.makePosSize(Point(0, y), size))
        y += size.h
      }
    }
  }
}
