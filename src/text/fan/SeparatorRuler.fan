using gfx
using stylishScene
using stylishCss

@Js
class SeparatorRuler : Ruler
{

  new make(|This|? f := null) { f?.call(this) }

  override Void attach()
  {
    super.attach()
    node.add(line)
    line.pos = Point(1, 0)
    line.style = BgStyle(Color(0xf0f0f0))
    width = 4
  }

  override protected Void onResize(Size s)
  {
    line.size = Size(1, s.h)
  }

  override Group node := Group()

  private Group line := Group()

}
