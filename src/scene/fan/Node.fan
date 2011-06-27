using gfx
using kawhyCss

@Js
mixin Node
{

  abstract Point pos

  abstract Size size

  abstract Style? style

}
