using gfx
using kawhyCss

@Js
class BaseNode : Node
{

  override Scene scene() { throw ArgErr() }

  override Point pos

  override Size size

  override Rect bounds() { Rect.makePosSize(pos, size) }

  override Node? parent

  override Style? style

}
