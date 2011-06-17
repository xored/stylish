
@Js
class BaseGroup : BaseNode, Group
{

  override Void add(Node kid) { kids.add(kid) }

  override Void remove(Node kid) { kids.remove(kid) }

  override Void removeAll() { kids = [,] }

  override Position position := Position.horizontal

  private Node[] kids := [,]

}
