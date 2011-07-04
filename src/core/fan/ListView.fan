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

  abstract protected Node createItem(Int i)

  virtual protected Void disposeItem(Node node) {}

  override protected Void attach()
  {
    super.attach()
    source.listen(listener)
    node.onScroll = |p| { sync() }
    sync()
  }

  override protected Void detach()
  {
    source.discard(listener)
    node.onScroll = |p| {}
    super.detach()
  }

  once protected Int itemSize()
  {
    view := createItem(0)
    content.add(view)
    size := view.size.h
    content.remove(view)
    return size
  }

  // max width in pixels
  protected Int maxWidth()
  {
    //TODO how we should calculate it?
    1000
  }

  virtual protected Void sync()
  {
    if (source.size == 0)
    {
      cache.moveRegion(Region.defVal)
      content.size = Size.defVal
    }
    else
    {
      start := scroll.y / itemSize
      size := (node.clientArea.h.toFloat / itemSize.toFloat).ceil.toInt
      cache.moveRegion(Region(start, size))
      height := source.size * itemSize
      content.size = Size(maxWidth(), height)
      for(i := start; i < start + size; i++)
      {
        node := cache[i] as Node
        if (node == null)
        {
          node = createItem(i)
          content.add(node)
          cache[i] = node
        }
        node.pos = Point(0, i * itemSize)
      }
    }
    cache.trash.each
    {
      disposeItem(it)
      content.remove(it)
    }
    cache.clearTrash()
  }

  protected Region visibleLines() { cache.region }

  protected Group content := Group()

  override protected ScrollArea node := ScrollArea() { it.add(content) }

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
