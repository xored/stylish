using gfx
using kawhyNotice

@Js
class Mouse
{

  Point pos   := Point.defVal { private set }

  Bool left   := false { private set }

  Bool right  := false { private set }

  Bool middle := false { private set }

  Notice onPos    := Notice()

  Notice onLeft   := Notice()

  Notice onRight  := Notice()

  Notice onMiddle := Notice()

  internal Bool pushPos(Point val) { pos = val; return onPos.push(val) }

  internal Bool pushLeft(Bool val) { left = val; return onLeft.push(val) }

  internal Bool pushRight(Bool val) { right = val; return onRight.push(val) }

  internal Bool pushMiddle(Bool val) { middle = val; return onMiddle.push(val) }

}
