using kawhyNotice
using kawhyScene
using gfx

@Js
abstract class ListView : Control
{

  abstract Point scroll

  abstract protected ListNotifier source()

  abstract protected Int itemSize()

  protected Void sync()
  {
    height := source.size * itemSize
    content.size = Size(10, height)
    node.clientArea()
  }

  protected Group content := Group()

  override protected ScrollArea node := ScrollArea() { it.add(content) }

}
