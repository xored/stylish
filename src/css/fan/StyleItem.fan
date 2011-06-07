
@Js
const class StyleItem
{

  static Str toStyleString(StyleItem[] items) { items.join("; ") }

  const Str name
  const Str val

  new make(Str name, Str val) { this.name = name; this.val = val }

  override Str toStr() { "$name: $val" }

  override Int hash() { name.hash.xor(val.hash) }

  override Bool equals(Obj? obj)
  {
    that := obj as StyleItem
    if (that == null) return false
    return that.name == name && that.val == val
  }

}
