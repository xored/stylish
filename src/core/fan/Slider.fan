using gfx
using kawhyScene

@Js
class Slider : Control
{
  new make(Orientation orientation)
  {
    node = ScrollBar(Orientation.vertical)
  }

  override protected Void onResize(Size s)
  {
    node.size = node.orientation == Orientation.horizontal ? Size(s.w, node.size.h) : Size(node.size.w, s.h)
  }

  override ScrollBar node

}
