using stylish
using stylishUtil
using stylishMath

@Js
class SelectWord : Policy
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

}
