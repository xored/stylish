using gfx

@Js
mixin Node
{

  abstract Scene scene()

  abstract Point pos

  abstract Size size()

  abstract Rect bounds()

  abstract Node? parent()

}
