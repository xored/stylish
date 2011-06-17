using kawhyCss

@Js
const class StyleRange
{

  const Style style
  const Range range

  new make(Style style, Range range)
  {
    this.style = style
    this.range = range
  }

  override Bool equals(Obj? that)
  {
    c := that as StyleRange
    if (c == null) return false
    return c.style == style && c.range == range
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + style.hash
    result = prime * result + range.hash
    return result;
  }

  override Str toStr() { "$style $range" }

}
