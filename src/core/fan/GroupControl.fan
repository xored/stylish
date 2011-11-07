using stylishScene

@Js
abstract class GroupControl : Control
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

  abstract protected Control[] kids()

  override Group node := Group()

}
