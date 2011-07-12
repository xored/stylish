
@Js
const class LinkStyle : AtomStyle
{

  const Uri href

  new make(Uri href) { this.href = href }

  override AtomStyle mergeSame(AtomStyle s) { s }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as LinkStyle
    if (that == null) return false
    return that.href == href
  }

  override StyleItem[] toCss() { [,] }

  override Int hash() { href.hash }
  
}
