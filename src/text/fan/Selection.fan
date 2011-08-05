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

  Void reveal()
  {
    // TODO This part should be customizable
    visible := edit.fullyVisibleRows
    select  := range.rows
    if (visible.includes(select)) return
    itemSize := edit.itemSize
    capacity := edit.clientArea.h / itemSize
    shift := select.size > capacity ? 0 : (capacity - select.size) / 2
    edit.scroll = Point(0, (select.start - shift) * itemSize)
  }

  Str text(Range range := 0..-1)
  {
    if (isEmpty) return ""
    line := this.range.start.row
    ranges := this.range.split()
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
