using kawhyScene

@Js
class GroupControl : Control
{

  override protected Void attach()
  {
    super.attach()
    kids.each { it.doAttach(this, this.node) }
  }

  override protected Void detach()
  {
    kids.each { it.doDetach() }
    super.detach()
  }

  protected Control[] kids := [,]

  override protected Group node := Group()

}
