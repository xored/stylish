using gfx
using kawhyMath

@Js
class SelectionPolicy
{

  new make(TextEdit edit)
  {
    this.edit = edit
    onMove = |Point mouse|
    {
      this.mouse = mouse
      if (pressed) edit.selection.extend(pos)
    }
    onClick = |Bool down, Int count|
    {
      if (count == 1)
      {
        pressed = down
        if (down) edit.selection.range = GridRange(pos)
      }
    }
    edit.onMouseMove(onMove)
    edit.onMouseClick(onClick)
  }

  private GridPos pos()
  {
    row := edit.rowByPos(mouse.y)
    if (row == null) row = edit.source.size - 1
    col := edit.colByPos(row, mouse.x)
    if (col == null) col = edit.source[row].size
    else
    {
      region := edit.colRegion(row, col)
      if (mouse.x - region.start >= region.size / 2) col++
    }
    return GridPos(row, col)
  }

  Void dispose()
  {
    edit.rmMouseMove(onMove)
    edit.rmMouseClick(onClick)
  }

  private Point mouse := Point.defVal
  private Bool pressed := false

  private |Point| onMove
  private |Bool, Int| onClick

  private TextEdit edit

}
