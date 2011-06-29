using kawhy
using kawhyScene
using kawhyNotice

@Js
class TextEdit : ListView
{

  new make(TextDoc source)
  {
    this.source = source
  }

  ** TODO need to fix sizing issue
  override protected Int itemSize() { 20 }

  override protected Node createView(Int i)
  {
    item := source[i]
    node := TextNode()
    node.data["lineListener"] = LineListener(node, item)
    return node
  }

  override protected Void disposeView(Node node)
  {
    listener := node.data["lineListener"] as LineListener
    listener?.dispose
  }

  override TextDoc source { private set }

}

@Js
class LineListener : ListListener
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
