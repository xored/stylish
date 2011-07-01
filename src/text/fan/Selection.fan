using kawhyMath

@Js
class Selection
{

  new make(TextEdit edit) { this.edit = edit }

  GridRange range := GridRange.defVal
  {
    get { &range }
    set { &range = it; ranges = [it] }
  }

  GridRange[] ranges := [range].toImmutable
  {
    get { &ranges }
    set
    {
      if (it.size == 0) throw ArgErr("Empty ranges is not appropriate")
      &ranges = it.toImmutable
    }
  }

  Str text() { throw UnsupportedErr() }

  Bool isEmpty()
  {
    for(i := 0; i < ranges.size; i++)
      if (!ranges[i].isEmpty) return false
    return true
  }

  override Bool equals(Obj? o)
  {
    that := o as Selection
    if (that == null) return false
    return ranges == that.ranges 
  }

  override Int hash() { ranges.hash }

  override Str toStr() { ranges.toStr }

  private TextEdit edit

}
