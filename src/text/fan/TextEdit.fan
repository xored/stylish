using kawhy
using kawhyCss
using kawhyScene
using kawhyNotice

@Js
class TextEdit : ListView
{

  override TextDoc source { private set }

  new make(TextDoc source) { this.source = source }

  override protected Node createItem(Int i)
  {
    TextNode { it.data[lineData] = LineListener(it, source[i]) }
  }

  override protected Void disposeItem(Node node)
  {
    (node.data[lineData] as LineListener)?.dispose
  }

  private static const Str lineData := "lineListener"

}

@Js
internal class LineListener : ListListener
{

  new make(TextNode node, TextLine line)
  {
    this.node = node
    this.line = line
    line.listen(this)
    sync()
  }

  override Void fire(ListNotice n) { sync() }

  private Void sync()
  {
    //TODO place for lazy update
    node.text = ""
    node.styles = line.styles.ranges
    node.text = line.text
  }

  Void dispose() { line.discard(this) }

  private TextNode node
  private TextLine line

}
