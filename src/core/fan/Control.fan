using gfx

@Js
abstract class Control
{

  Point pos := Point.defVal { internal set }

  Size size := Size.defVal { internal set }

  LayoutHints hints := LayoutHints { private set }

}
