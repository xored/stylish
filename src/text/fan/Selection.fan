using kawhyMath

@Js
class Selection
{

  new make(TextEdit edit) { this.edit = edit }

  GridRange range := GridRange.defVal

  Str text() { throw UnsupportedErr() }

  Bool isEmpty() { range.isEmpty }

  override Bool equals(Obj? o)
  {
    that := o as Selection
    if (that == null) return false
    return range == that.range 
  }

  override Int hash() { range.hash }

  override Str toStr() { range.toStr }

  private TextEdit edit

}
