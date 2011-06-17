using gfx
using kawhyCss

@Js
class BaseNode : Node
{

  override Scene scene() { throw ArgErr() }

  override Point pos := Point.defVal

  override Size size := Size.defVal

  override Node? parent

  override Style? style

}
