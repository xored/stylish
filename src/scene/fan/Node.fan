using gfx
using kawhyCss

@Js
mixin Node
{

  abstract Scene scene()

  abstract Point pos

  abstract Size size()

  abstract Rect bounds()

  abstract Node? parent()

  abstract Style? style

}
