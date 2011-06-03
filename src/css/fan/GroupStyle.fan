
@Js
const class GroupStyle: Style
{

  const AtomStyle[] styles

  internal new make(AtomStyle[] styles) { this.styles = styles }

  override AtomStyle[] atomize() { styles }

  override Bool equals(Obj? o)
  {
    that := o as GroupStyle
    if (that == null) return false
    return that.styles == styles
  }

  override Int hash() { styles.hash }

  override Str toStr() { styles.join(" ") }

}
