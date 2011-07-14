using kawhy
using kawhyMath

@Js
class LineSelect : Policy
{

  override TextEdit control { private set }

  new make(TextEdit control)
  {
    this.control = control
    onClick = |Bool down, Int count|
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
    control.onMouseClick(onClick)
  }

  override Void dispose()
  {
    control.unMouseClick(onClick)
  }

  private |Bool, Int| onClick

}
