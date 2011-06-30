using gfx
using fwt

@Js
const class FontStyle : AtomStyle
{

  static const FontStyle sys := FontStyle(Desktop.sysFont.name, Desktop.sysFont.size)

  static const FontStyle monospace := FontStyle(Desktop.sysFontMonospace.name, Desktop.sysFontMonospace.size)

  const Str? name
  const Int? size

  new make(Str? name, Int? size)
  {
    this.name = name; this.size = size
  }

  static FontStyle fromFont(Font font) { FontStyle(font.name, font.size) }

  Font toFont() { Font.makeFields(name, size) }

  override FontStyle mergeSame(AtomStyle s)
  {
    that := (FontStyle)s
    return FontStyle(that.name ?: this.name, that.size ?: this.size)
  }

  protected override Int priority() { 2 }

  override Bool equals(Obj? o)
  {
    that := o as FontStyle
    if (that == null) return false
    return that.name == name && that.size == size
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + (name == null ? 0 : name.hash)
    result = prime * result + (size == null ? 0 : size.hash)
    return result;
  }

  override StyleItem[] toCss()
  {
    items := [,]
    if (name != null) items.add(StyleItem("font-family", name))
    if (size != null) items.add(StyleItem("font-size", size.toStr + "px"))
    return items
  }

  **
  ** Format as '"<size>px <name>"'
  **
  override Str toStr() { "${size}px name" }

}
