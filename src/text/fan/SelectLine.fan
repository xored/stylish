using stylish
using stylishMath

@Js
class SelectLine : Policy
{

  override TextEdit control

  new make(|This| f) { f(this) }

  override Void attach()
  {
    control.onMouseClick(onClick)
  }

  override Void detach()
  {
    control.unMouseClick(onClick)
  }

  private |Bool, Int| onClick := |Bool down, Int count|
  {
    if (down && count >= 2 && 1.and(count) == 1 && control.mouse != null)
    {
      row := control.rowByPos(control.mouse.y)
      size := control.source[row].size
      start := GridPos(row, 0)
      end := row < control.source.size - 1 ? GridPos(row + 1, 0) : GridPos(row, size)
      control.selection.range = GridRange(start, end)
    }
  }

}
