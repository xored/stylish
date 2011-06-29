using gfx
using kawhyMath
using kawhyNotice
using kawhyScene

@Js
abstract class ListView : Control
{

  Point scroll
  {
    get { node.scroll }
    set { node.scroll = it }
  }

  abstract protected ListNotifier source()

  abstract protected Int itemSize()

  abstract protected Node createView(Int i)

  virtual protected Void disposeView(Node node) {}

  internal override Void attach(GroupControl? parent)
  {
    super.attach(parent)
    source.listen(listener)
    node.onScroll = |p| { sync() }
    sync()
  }

  internal override Void detach(GroupControl? parent)
  {
    source.discard(listener)
    node.onScroll = |p| {}
    super.detach(parent)
  }

  protected Void sync()
  {
    start := scroll.y / itemSize
    size := (node.clientArea.h.toFloat / itemSize.toFloat).ceil.toInt
    cache.moveRegion(Region(start, size))
    height := source.size * itemSize
    content.size = Size(100, height)
    for(i := start; i < start + size; i++)
    {
      node := cache[i] as Node
      if (node == null)
      {
        node = createView(i)
        content.add(node)
        cache[i] = node
      }
      node.pos = Point(0, i * itemSize)
    }
    cache.trash.each
    {
      disposeView(it)
      content.remove(it)
    }
    cache.clearTrash()
  }

  protected Group content := Group()

  override internal ScrollArea node := ScrollArea() { it.add(content) }

  private ListCache cache := ListCache()

  private ListViewListener listener := ListViewListener(cache)

}

@Js
internal class ListViewListener : ListListener
{

  new make(ListCache cache) { this.cache = cache }

  override Void onAdd(Int index, Int size)
  {
    cache.add(index, size)
  }

  override Void onRemove(Int index, Int size)
  {
    cache.remove(index, size)
  }

  private ListCache cache

}
