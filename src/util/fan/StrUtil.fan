using kawhyMath

@Js
class StrUtil
{

  **
  ** ("text", 0..2)  -> "tex"
  ** ("text", 2..4)  -> "xt "
  ** ("text", 5..7)  -> "   "
  ** ("text", 2..-1) -> "xt"
  ** ("text", 5..-1) -> ""
  ** ("text", 0..<0) -> ""
  **
  static Str getRange(Str text, Range range)
  {
    if (range.start >= text.size && range.end < 0) return ""
    r := Region.fromRange(range, text.size)
    if (r == null || r.size == 0) return ""
    buf := StrBuf()
    if (r.start < text.size) buf.add(text.getRange(r.start..r.last.min(text.size - 1)))
    spaces := r.end - r.start.max(text.size)
    spaces.times { buf.add(" ") }
    return buf.toStr()
  }

  **
  ** ("",     (0..2),  "wxyz") -> "wxyz"
  ** ("abcd", (0..<2), "wxyz") -> "wxyzcd"
  ** ("abcd", (2..-1), "wxyz") -> "abwxyz"
  ** ("abcd", (2..<2), "wxyz") -> "abwxyzcd"
  ** ("abcd", (4..-1), "wxyz") -> "abcdwxyz"
  **
  static Str replaceRange(Str text, Range range, Str newText)
  {
    if (range.start >= text.size && range.end < 0) return text + newText
    region := Region.fromRange(range, text.size)
    if (region == null) return newText
    return replaceRegion(text, region, newText)
  }

  static Str replaceRegion(Str text, Region region, Str newText)
  {
    before := region.start < 1 ? "" : text.getRange(0..<region.start)
    after := region.end >= text.size ? "" : text.getRange(region.end..-1)
    return before + newText + after
  }

}
