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

  Notice/*<Point>*/ onWheel := Notice/*<Point>*/()

  internal Bool pushPos(Point val) { pos = val; return onPos.push(val) }

  internal Bool pushLeft(Bool val)
  {
    if (left != val)
    {
      left = val
      return onLeft.push(val)
    }
    return false
  }

  internal Bool pushRight(Bool val)
  {
    if (right != val)
    {
      right = val
      return onRight.push(val)
    }
    return false
  }

  internal Bool pushMiddle(Bool val)
  {
    if (middle != val)
    {
      middle = val
      return onMiddle.push(val)
    }
    return false
  }

}
