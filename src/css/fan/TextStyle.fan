using gfx

@Js
const class TextStyle : AtomStyle
{

  const Color? color
  const FontWeight? weight
  const Bool? italic

  new make(|This| f)
  {
    f.call(this)
  }

  override TextStyle mergeSame(AtomStyle s)
  {
    that := (TextStyle)s
    return TextStyle
    {
      it.color = that.color ?: this.color
      it.weight = that.weight ?: this.weight
      it.italic = that.italic ?: this.italic
    }
  }

  protected override Int priority() { 2 }

  override Bool equals(Obj? o)
  {
    that := o as TextStyle
    if (that == null) return false
    return that.color == color && that.weight == weight && that.italic == italic
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + (color == null ? 0 : color.hash)
    result = prime * result + (weight == null ? 0 : weight.hash)
    result = prime * result + (italic == null ? 0 : italic.hash)
    return result;
  }

  override StyleItem[] toCss()
  {
    items := [,]
    if (color != null) items.add(StyleItem("color", color.toCss))
    if (weight != null) items.add(StyleItem("font-weight", weight.toStr))
    if (italic != null) items.add(StyleItem("font-style", italic ? "italic" : "normal"))
    return items
  }

}

@Js
const class FontWeight
{

  static const FontWeight thin       := make(100, "100")
  static const FontWeight extraLight := make(200, "200")
  static const FontWeight light      := make(300, "300")
  static const FontWeight normal     := make(400, "normal")
  static const FontWeight medium     := make(500, "500")
  static const FontWeight semiBold   := make(600, "600")
  static const FontWeight bold       := make(700, "bold")
  static const FontWeight extraBold  := make(800, "800")
  static const FontWeight heavy      := make(900, "900")

  static const FontWeight[] vals := [thin, extraLight, light, normal, medium, semiBold, bold, extraBold, heavy]

  static FontWeight byNum(Int num)
  {
    index := (num / 100 - 1).max(0).min(8)
    return vals[index]
  }

  override Str toStr() { name }

  override Int hash() { num }

  private new make(Int num, Str name) { this.num = num; this.name = name }

  const Int num
  const Str name
}
