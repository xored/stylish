
@Js
const class Region
{

  static const Region defVal := Region(0, 0)

  const Int start
  const Int size

  new make(Int start, Int size)
  {
    if (size < 0) throw ArgErr("Expect size >= 0, but size = $size")
    this.start = start
    this.size = size
  }

  **
  ** - (2..5,     7) -> 2+4
  ** - (2..<5, null) -> 2+3
  ** - (5..<2,    7) -> 3+3
  ** - (-1..0, null) -> null
  ** - (0..<0,    7) -> 0+0
  ** - (5..-1,    7) -> 5+1
  ** - (-1..<1,   7) -> 2+5
  ** - (-4..-2,   7) -> 3+3
  **
  static Region? fromRange(Range range, Int? size := null)
  {
    start := range.start
    end := range.end
    if (size == null || size <= 0)
    {
      //no way to get normal region
      if (start < 0 || end < 0) return null
    }
    else
    {
      start = abs(start, size)
      end = abs(end, size)
    }
    return fromPosRange(start, end, range.inclusive)
  }

  Bool isEmpty() { size == 0 }

  Int end() { start + size }

  Int last() { end - 1 }

  Range toRange() { start..<end }

  Region? intersect(Region r)
  {
    if (r.end < start || end < r.start) return null
    s := start.max(r.start)
    e := end.min(r.end)
    return Region(s, e - s)
  }

  Region offset(Int offset)
  {
    if (offset == 0) return this
    return Region(start + offset, size)
  }

  override Bool equals(Obj? obj)
  {
    that := obj as Region
    if (that == null) return false
    return start == that.start && size == that.size
  }

  override Int hash() { start.xor(size.shiftl(16)) }

  override Str toStr() { "$start+$size" }

  private static Region? fromPosRange(Int start, Int end, Bool inclusive)
  {
    if (start < end) return region(start, end - (inclusive ? 0 : 1))
    else if (start > end) return region(end + (inclusive ? 0 : 1), start)
    else return Region(start, inclusive ? 1 : 0)
  }

  private static Region region(Int start, Int end) { Region(start, end - start + 1) }

  private static Int abs(Int i, Int size) { while(i < 0) i += size; return i }
}
