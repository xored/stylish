
**
** This class represent position in a grid
**
@Js
@Serializable { simple = true }
const class GridPos
{
  ** Default instance is 0, 0.
  const static GridPos defVal := GridPos(0, 0)

  const Int row

  const Int col

  new make(Int row, Int col) { this.row = row; this.col = col }

  ** Parse from string.  If invalid and checked is
  ** true then throw ParseErr otherwise return null.
  static GridPos? fromStr(Str s, Bool checked := true)
  {
    try
    {
      comma := s.index(",")
      return make(s[0..<comma].trim.toInt, s[comma+1..-1].trim.toInt)
    }
    catch {}
    if (checked) throw ParseErr("Invalid GridPos: $s")
    return null
  }

  override Int hash() { row.xor(col.shiftl(16)) }

  override Bool equals(Obj? obj)
  {
    that := obj as GridPos
    if (that == null) return false
    return this.row == that.row && this.col == that.col
  }

  override Str toStr() { "$row,$col" }

  GridPos min(GridPos p) { this > p ? p : this }

  GridPos max(GridPos p) { this > p ? this : p }

  override Int compare(Obj obj)
  {
    GridPos that := obj
    diff := row - that.row
    if (diff != 0) return diff
    return col - that.col
  }
}
