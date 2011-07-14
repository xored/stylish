using kawhy
using kawhyUtil
using kawhyMath

@Js
class WordSelect : Policy
{

  override TextEdit control { private set }

  new make(TextEdit control)
  {
    this.control = control
    onClick = |Bool down, Int count|
    {
      if (down && count >= 2 && 1.and(count) == 0 && control.mouse != null)
      {
        pos := control.textPos(control.mouse)
        row := pos.row
        col := pos.col
        text := control.source[row].text
        if (col < text.size)
        {
          if (KeyUtil.isWordChar(text[col]))
          {
            from := col
            while(from > 0 && KeyUtil.isWordChar(text[from - 1])) from--;
            to := col
            while(to < text.size - 1 && KeyUtil.isWordChar(text[to + 1])) to++;
            control.selection.range = GridRange(GridPos(row, from), GridPos(row, to + 1))
          }
        }
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
