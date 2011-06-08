using gfx

@Js
class RelativeLayout : Layout
{

  static const Str id := "relative"

  override Void layout(Control[] kids, |Control, Rect| layer)
  {
    kids.each |kid|
    {
      p := kid.hints.pos as Point
      layer(kid, Rect.makePosSize(p, kid.hints.prefSize))
    }
  }

}
