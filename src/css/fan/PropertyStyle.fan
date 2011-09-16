
@Js
const class PropertyStyle : AtomStyle
{

  const Str:Str properties

  new make(Str:Str properties) { this.properties = properties }

  override AtomStyle mergeSame(AtomStyle s)
  {
    that := (PropertyStyle)s
    map := properties.rw.setAll(that.properties)
    return PropertyStyle(map)
  }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as PropertyStyle
    if (that == null) return false
    return that.properties == properties
  }

  override StyleItem[] toCss() { [,] }

  override Int hash() { properties.hash }

}
