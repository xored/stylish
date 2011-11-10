
** Merges styles
@Js
class StyleLayer
{

  static StyleRange[] merge(StyleRange[][] ranges)
  {
    ranges = ranges.exclude |StyleRange[] styles->Bool| { styles.isEmpty }
    if (ranges.size == 0) return [,]
    StyleLayer? layer := StyleLayer(ranges[0])
    ranges.eachRange(1..-1) |StyleRange[] styles| { layer = StyleLayer(styles, layer) }
    return layer.getStyles()
  }

  new make(StyleRange[] ranges, StyleLayer? lowLayer := null)
  {
    this.ranges = ranges; this.lowLayer = lowLayer
  }

  private Range range()
  {
    Range range := (ranges.first.range.min..ranges.last.range.max)
    if (lowLayer == null) return range
    Range lowRange := lowLayer.range
    return (range.min.min(lowRange.min)..range.max.max(lowRange.max))
  }

  StyleRange[] getStyles()
  {
    collect(range)
  }

  private StyleRange[] collect(Range range)
  {
    result := StyleRange[,]
    if (range.isEmpty) return result
    start := range.min
    for(i := 0; i < ranges.size; i++)
    {
      Range style := ranges[i].range
      if (style.isEmpty) continue
      if (style.min > range.max) break;
      if (start < style.min && lowLayer != null)
      {
        result.addAll(lowLayer.collect(start..<style.min))
      }
      from := style.min.max(range.min)
      to := style.max.min(range.max)
      if (from <= to)
      {
        result.addAll(mergeStyles(ranges[i].style, from..to))
      }
      if (start < to + 1) start = to + 1
      if (to >= range.max) return result
    }
    if (start <= range.max && lowLayer != null)
    {
      result.addAll(lowLayer.collect(start..range.max))
    }
    return result
  }

  private StyleRange[] mergeStyles(Style style, Range range)
  {
    StyleRange[] lowRanges := lowLayer != null ? lowLayer.collect(range) : [,]
    if (lowRanges.size > 0)
    {
      result := StyleRange[,]
      first := lowRanges.first
      if (range.start < first.range.start) result.add(StyleRange(style, range.start..<first.range.start))
      for (i := 0; i < lowRanges.size - 1; ++i)
      {
        lr := lowRanges[i]
        newStyle := lr.style.merge(style)
        result.add(StyleRange(newStyle, lr.range))
        rangeStart := lr.range.end + 1
        rangeEnd := lowRanges[i + 1].range.start
        if (rangeStart < rangeEnd) result.add(StyleRange(style, rangeStart..<rangeEnd))
      }
      lr := lowRanges.last
      newStyle := lr.style.merge(style)
      result.add(StyleRange(newStyle, lr.range))
      lastEnd := lr.range.end
      if (lastEnd < range.end) result.add(StyleRange(style, lastEnd + 1..range.end))
      return result
    }
    else return [StyleRange(style, range)]
  }

  private StyleRange[] ranges := [,]

  private StyleLayer? lowLayer
}
