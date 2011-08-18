
@Js
const class StyleList
{

  const StyleRange[] ranges

  new make(StyleRange[] ranges)
  {
    this.ranges = ranges
  }

  override Str toStr() { ranges.toStr }

  StyleList replace(Int pos, Int remove, Int insert, Style? style)
  {
    before := before(pos)
    after := after(pos + remove)
    ranges := StyleRange[,]
    if (before.size > 0)
      ranges.addAll(before)
    if (insert > 0 && style != null)
      ranges.add(StyleRange(style, pos..pos+insert-1))
    if (after.size > 0)
    {
      diff := insert - remove
      if (diff != 0)
      {
        after = after.map |sr| { StyleRange(sr.style, sr.range.offset(diff))  }
      }
      ranges.addAll(after)
    }
    return StyleList(ranges)
  }

  private StyleRange[] before(Int pos)
  {
    index := findRangeIndex(pos)
    if (index < 0)
    {
      index = -index - 1
      return index > 0 ? ranges.getRange(0..index-1) : [,]
    }
    else
    {
      before := StyleRange[,]
      if (index > 0)
        before = ranges.getRange(0..index-1)
      sr := ranges[index]
      if (sr.range.start < pos)
        before.add(StyleRange(sr.style, sr.range.start..pos-1))
      return before
    }
  }

  private StyleRange[] after(Int pos)
  {
    index := findRangeIndex(pos)
    if (index < 0)
    {
      index = -index - 1
      return index < ranges.size ? ranges.getRange(index..-1) : [,]
    }
    else
    {
      after := StyleRange[,]
      sr := ranges[index]
      if (pos <= sr.range.end)
        after.add(StyleRange(sr.style, pos..sr.range.end))
      if (index < ranges.size - 1)
        after.addAll(ranges.getRange(index+1..-1))
      return after
    }
  }

  private Int findRangeIndex(Int pos)
  {
    ranges.binaryFind |StyleRange sr->Int|
    {
      if (pos < sr.range.start) return -1
      if (pos > sr.range.end) return 1
      return 0
    }
  }

}
