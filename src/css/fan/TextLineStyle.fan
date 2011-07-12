
@Js
const class TextLineStyle : AtomStyle
{

  const Bool? under

  const Bool? over

  const Bool? strike

  new make(|This| f) { f(this) }

  override TextLineStyle mergeSame(AtomStyle s)
  {
    that := (TextLineStyle)s
    return TextLineStyle
    {
      it.under  = that.under  ?: this.under
      it.over   = that.over   ?: this.over
      it.strike = that.strike ?: this.strike
    }
  }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as TextLineStyle
    if (that == null) return false
    return that.under == under && that.over == over && that.strike == strike
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + (under == null  ? 0 : under.hash)
    result = prime * result + (over == null   ? 0 : over.hash)
    result = prime * result + (strike == null ? 0 : strike.hash)
    return result;
  }

  override StyleItem[] toCss()
  {
    items := Str[,]
    if (under == true)  items.add("underline")
    if (over == true)   items.add("overline")
    if (strike == true) items.add("line-through")
    if (items.size == 0) return [,]
    return [StyleItem("text-decoration", items.join(" "))]
  }

}
