
@Js
class BaseGroup : BaseNode, Group
{

  override Void add(Node kid) { kids.add(kid) }

  override Void remove(Node kid) { kids.remove(kid) }

  private Node[] kids := [,]

}
