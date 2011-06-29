using kawhy
using kawhyScene

@Js
class TextEdit : ListView
{

  new make(TextDoc source)
  {
    this.source = source
  }

  override protected Int itemSize() { 20 }

  override protected Node createView(Int i)
  {
    TextNode { it.text = source[i].text }
  }

  override TextDoc source { private set }

}
