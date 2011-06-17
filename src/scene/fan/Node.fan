using gfx
using kawhyCss

@Js
mixin Node
{

  abstract Scene scene()

  abstract Point pos

  abstract Size size()

  virtual Rect bounds() { Rect.makePosSize(pos, size) }

  abstract Node? parent()

  abstract Style? style

}
