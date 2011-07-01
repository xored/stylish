
**
** This class represents the range in a grid between two position.
**
@Js
const class GridRange
{

  const static GridRange defVal := GridRange(GridPos(0, 0))

  const GridPos start
  const GridPos end

  new make(GridPos start, GridPos end := start)
  {
    this.start = start; this.end = end
  }

  ** Return range representing the same range in the grid
  ** which satisfy following condition: start <= end 
  GridRange norm() { isNorm ? this : GridRange(end, start) }

  ** Return true if start <= end
  Bool isNorm() { start <= end }

  ** return true if start == end
  Bool isEmpty() { start == end }

  **
  ** If we have four grid positions: $1 < $2 < $3 < $4. Then: 
  ** - [$1,$2).intersect[$2,$3) -> [$2,$2)
  ** - [$1,$3).intersect[$2,$4) -> [$2,$3)
  ** - [$1,$2).intersect[$3,$4) -> null
  **
  GridRange? intersect(GridRange r)
  {
    norm1 := norm()
    norm2 := r.norm()
    if (norm2.end < norm1.start || norm1.end < norm2.start) return null
    return GridRange(norm1.start.max(norm2.start), norm1.end.min(norm2.end))
  }

  Range[] split()
  {
    norm := norm()
    start := norm.start
    end := norm.end
    result := Range[,]
    if (start.row == end.row)
    {
      result.add(start.col..<end.col)
    }
    else
    {
      result.add(start.col..-1)
      for(i := start.row + 1; i < end.row; i++) result.add(fullRange)
      result.add(0..<end.col)
    }
    return result
  }

  ** return true if this range contains specified grid position
  Bool contains(GridPos pos)
  {
    norm := norm()
    return norm.start <= pos && norm.end > pos
  }

  ** return true if this range includes specified grid range
  Bool includes(GridRange r)
  {
    norm1 := norm()
    norm2 := r.norm()
    return norm1.start <= norm2.start && norm1.end >= norm2.end
  }

  override Str toStr() { "($start)-($end)" }

  override Int hash() { start.hash.xor(end.hash.shiftl(16)) }

  override Bool equals(Obj? obj)
  {
    that := obj as GridRange
    if (that == null) return false
    return this.start == that.start && this.end == that.end
  }

  private const static Range fullRange := 0..-1

}
