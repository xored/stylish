using gfx

@Js
mixin Layout
{

  abstract Void layout(Control[] kids, |Control, Rect| layer)

}
