using gfx

@Js
const class BgStyle : AtomStyle
{

  const Brush brush

  new make(Brush brush) { this.brush = brush }

  override AtomStyle mergeSame(AtomStyle s) { s }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as BgStyle
    if (that == null) return false
    return that.brush == brush
  }

  override Int hash() { brush.hash }

  override Str toStr() { "brush=$brush" }

}
