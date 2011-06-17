using gfx

@Js
const class BoxStyle : AtomStyle
{

  const Insets? padding
  const Insets? margin

  new make(|This| f)
  {
    f.call(this)
  }

  override BoxStyle mergeSame(AtomStyle s)
  {
    that := (BoxStyle)s
    return BoxStyle
    {
      it.padding = that.padding ?: this.padding
      it.margin = that.margin ?: this.margin
    }
  }

  protected override Int priority() { 2 }

  override Bool equals(Obj? o)
  {
    that := o as BoxStyle
    if (that == null) return false
    return that.padding == padding && that.margin == margin
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + (padding == null ? 0 : padding.hash)
    result = prime * result + (margin == null ? 0 : margin.hash)
    return result
  }

  override StyleItem[] toCss()
  {
    items := [,]
    if (padding != null) items.add(StyleItem("padding", asCss(padding)))
    if (margin != null) items.add(StyleItem("margin", asCss(margin)))
    return items
  }

  private static Str asCss(Insets i) { "${i.top}px ${i.right}px ${i.bottom}px ${i.left}px" }

}
