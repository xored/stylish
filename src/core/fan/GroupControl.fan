using kawhyScene

@Js
class GroupControl : Control
{

  override Void attach(GroupControl parent)
  {
    super.attach(parent)
    kids.each { it.attach(this) }
  }

  override Void detach(GroupControl parent)
  {
    kids.each { it.detach(this) }
    super.detach(parent)
  }

  protected Control[] kids := [,]

  override internal Group node := Group()

}
