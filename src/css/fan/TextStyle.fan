using gfx

@Js
const class TextStyle : AtomStyle
{

  const Brush? brush
  const FontWeight? weight
  const Bool? italic

  new make(|This| f) { f.call(this) }

  override TextStyle mergeSame(AtomStyle s)
  {
    that := (TextStyle)s
    return TextStyle
    {
      it.brush = that.brush ?: this.brush
      it.weight = that.weight ?: this.weight
      it.italic = that.italic ?: this.italic
    }
  }

  protected override Int priority() { 2 }

  override Bool equals(Obj? o)
  {
    that := o as TextStyle
    if (that == null) return false
    return that.brush == brush && that.weight == weight && that.italic == italic
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + (brush == null ? 0 : brush.hash)
    result = prime * result + (weight == null ? 0 : weight.hash)
    result = prime * result + (italic == null ? 0 : italic.hash)
    return result;
  }

  override Str toStr()
  {
    list := Str[,]
    if (brush != null) list.add("fg=$brush")
    if (weight != null) list.add("weight=$weight")
    if (italic != null) list.add("italic=$italic")
    return list.join(" ")
  }

}

const class FontWeight
{

  static const FontWeight thin       := make(100, "Thin")
  static const FontWeight extraLight := make(200, "Extra Light")
  static const FontWeight light      := make(300, "Light")
  static const FontWeight normal     := make(400, "Normal")
  static const FontWeight medium     := make(500, "Medium")
  static const FontWeight semiBold   := make(600, "Semi Bold")
  static const FontWeight bold       := make(700, "Bold")
  static const FontWeight extraBold  := make(800, "Extra Bold")
  static const FontWeight heavy      := make(900, "Heavy")

  static const FontWeight[] vals := [thin, extraLight, light, normal, medium, semiBold, bold, extraBold, heavy]

  static FontWeight byNum(Int num)
  {
    index := (num / 100 - 1).max(0).min(8)
    return vals[index]
  }

  override Str toStr() { name }

  override Int hash() { num }

  private new make(Int num, Str name) { this.num = num; this.name = name }

  private const Int num
  private const Str name
}
