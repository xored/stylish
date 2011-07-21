using kawhyScene

@Js
class Label : Control
{

  Str text
  {
    get { node.text }
    set { node.text = it }
  }

  override TextNode node := TextNode()

}
