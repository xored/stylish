
@Js
class Notice
{

  new make() {}

  internal new makeKid(Notice parent) { this.parent = parent }

  This filter(|Obj?->Bool| f) { FilterNotice(this, f) }

  This handle(|Obj?| f) { HandleNotice(this, f) }

  virtual Bool push(Obj? p)
  {
    kids.reduce(false) |res, kid->Bool| { kid.push(p) || res }
  }

  Void discard() { parent?.remove(this) }

  internal Void add(Notice kid) { kids.add(kid) }

  internal Void remove(Notice kid) { kids.remove(kid) }

  private Notice? parent
  private Notice[] kids := [,]

}

@Js
internal class FilterNotice : Notice
{

  new make(Notice parent, |Obj?->Bool| f) : super.makeKid(parent)
  {
    this.f = f
  }

  override Bool push(Obj? p) { f(p) ? false : super.push(p) }

  private |Obj?->Bool| f

}

@Js
internal class HandleNotice : Notice
{

  new make(Notice parent, |Obj?| f) : super.makeKid(parent)
  {
    this.f = f
  }

  override Bool push(Obj? p) { f(p); return true }

  private |Obj?| f

}
