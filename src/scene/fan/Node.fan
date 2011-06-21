using gfx
using kawhyCss

@Js
mixin Node
{

  abstract Point pos

  abstract Size size()

  virtual Rect bounds() { Rect.makePosSize(pos, size) }

  abstract Style? style

}
