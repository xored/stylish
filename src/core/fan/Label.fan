using kawhyScene

@Js
class Label : Control
{

  Str text
  {
    get { node.text }
    set { node.text = it }
  }

  override protected Void sync(Group parent)
  {
    
  }

  override protected TextNode node

}
