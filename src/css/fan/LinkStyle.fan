
@Js
const class LinkStyle : AtomStyle
{

  const Uri href

  const LinkTarget target

  new make(Uri href, LinkTarget target := LinkTarget.auto)
  {
    this.href = href
    this.target = target
  }

  override AtomStyle mergeSame(AtomStyle s) { s }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as LinkStyle
    if (that == null) return false
    return that.href == href && that.target == target
  }

  override StyleItem[] toCss() { [,] }

  override Int hash() { href.hash.shiftl(16).xor(target.hash) }

}

@Js
enum class LinkTarget
{
  auto,
  blank,
  self
}
