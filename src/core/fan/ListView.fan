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

  virtual protected Void sync()
  {
    if (source.size == 0)
    {
      cache.moveRegion(Region.defVal)
      content.size = Size.defVal
    }
    else
    {
      if (itemSize == null)
      {
        view := createItem(0)
        content.add(view)
        itemSize = view.size.h
        content.remove(view)
      }
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

  protected Group content := Group()

  override internal ScrollArea node := ScrollArea() { it.add(content) }

  private ListCache cache := ListCache()

  private ListViewListener listener := ListViewListener(cache)

  private Int? itemSize := null

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
