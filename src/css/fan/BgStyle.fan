using gfx

@Js
const class BgStyle : AtomStyle
{

  const Brush bg

  new make(Brush bg) { this.bg = bg }

  override AtomStyle mergeSame(AtomStyle s) { s }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as BgStyle
    if (that == null) return false
    return that.bg == bg
  }

  override StyleItem[] toCss()
  {
    color := bg as Color
    return [StyleItem("background", color != null ? color.toCss : bg.toStr)]
  }

  override Int hash() { bg.hash }

}
