using gfx

@Js
class ScrollBar : Node
{

  **
  ** Horizontal or vertical.
  **
  native Orientation orientation { private set }

  new make(Orientation orientation := Orientation.horizontal, |This|? f := null)
  {
    this.orientation = orientation
    f?.call(this)
    doInit()
  }

  native internal Void doInit()

  native Int val

  native Int max

  native Int thumb

  native Bool enabled

  |Int| onScroll := |i| {}

}
