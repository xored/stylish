using fwt

@Js
const class CursorStyle : AtomStyle
{

  const Cursor cursor

  new make(Cursor cursor) { this.cursor = cursor }

  override AtomStyle mergeSame(AtomStyle s) { s }

  protected override Int priority() { 1 }

  override Bool equals(Obj? o)
  {
    that := o as CursorStyle
    if (that == null) return false
    return that.cursor == cursor
  }

  override StyleItem[] toCss() { [StyleItem("cursor", cursor.toStr)] }

  override Int hash() { cursor.hash }

}
