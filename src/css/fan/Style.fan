
@Js
const abstract class Style
{

  static const Style defVal := GroupStyle([,])

  Style merge(Style s)
  {
    Type:AtomStyle map := [:]
    parts1 := this.atomize()
    parts1.each { map[it.typeof] = it }
    parts2 := s.atomize()
    parts2.each |AtomStyle ps|
    {
      val := map[ps.typeof]
      if (val != null) ps = val.mergeSame(ps)
      map[ps.typeof] = ps
    }
    styles := map.vals.sort
    if (styles.size == 0) return defVal
    if (styles.size == 1) return styles[0]
    return GroupStyle(styles)
  }

  Style? findStyle(Type t)
  {
    styles := atomize()
    return styles.eachWhile |style->Style?| { t == style.typeof ? style : null }
  }

  @Operator
  Style plusStyle(Style s) { merge(s) }

  abstract AtomStyle[] atomize()

}
