using gfx
using kawhyMath
using kawhyUtil

@Js
class Selection
{

  new make(TextEdit edit) { this.edit = edit }

  GridRange range := GridRange.defVal
  {
    set
    {
      &range = it
      listeners.each { it(&range) }
    }
  }

  Void onChange(|GridRange| f) { listeners.add(f) }

  Void unChange(|GridRange| f) { listeners.remove(f) }

  Void all() { range = GridRange(GridPos.defVal, edit.end) }

  Void extend(GridPos pos, Bool reveal := true)
  {
    range = GridRange(range.start, pos)
    if (reveal)
    {
      yRow := edit.posByRow(range.end.row)
      yScroll := edit.scroll.y
      if (yRow < yScroll)
        edit.scroll = Point(0, yRow)
      else if (yRow + edit.itemSize > yScroll + edit.clientArea.h)
        edit.scroll = Point(0, yRow + edit.itemSize - edit.clientArea.h)
    }
  }

  virtual Void reveal()
  {
    itemSize := edit.itemSize
    rows := range.rows
    visible := Region(edit.scroll.y, edit.clientArea.h)
    actual := Region(rows.start * itemSize, rows.size * itemSize)
    y := findRevealPos(visible, actual)
    if (y == null) return

    edit.scroll = Point(0, y)
  }

  static Int? findRevealPos(Region visible, Region actual)
  {
    if (visible.includes(actual)) return null
    diff := visible.size - actual.size
    return actual.start - (diff > 0 ? diff / 2 : diff)
  }

  Str text(Range range := 0..-1)
  {
    if (isEmpty) return ""
    norm := this.range.norm
    line := norm.start.row
    ranges := norm.split()
    text := ranges.join("\n") |Range r, Int index->Str|
    {
      StrUtil.getRange(edit.source[line + index].text, r)
    }
    return text[range]
  }

  Int size() { text.size }

  Bool isEmpty() { range.isEmpty }

  private |GridRange|[] listeners := [,]

  override Bool equals(Obj? o)
  {
    that := o as Selection
    if (that == null) return false
    return range == that.range 
  }

  override Int hash() { range.hash }

  override Str toStr() { range.toStr }

  private TextEdit edit

}
