using gfx
using kawhyCss

@Js
class BaseNode : Node
{

  override Point pos := Point.defVal

  override Size size := Size.defVal

  override Style? style

}
