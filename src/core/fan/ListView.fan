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

  Int? rowByPos(Int pos)
  {
    row := pos / itemSize
    return row < source.size ? row : null
  }

  Region visibleRaws() { cache.region }

  abstract protected ListNotifier source()

  abstract protected Node createItem(Int i)

  virtual protected Void disposeItem(Node node) {}

  override protected Void attach()
  {
    super.attach()
    node.add(content)
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
    contentArea.add(view)
    size := view.size.h
    maxWidth = view.size.w
    contentArea.remove(view)
    return size
  }

  // max width in pixels
  protected Int maxWidth := 0

  protected Node itemByIndex(Int i)
  {
    node := cache[i] as Node
    if (node == null)
    {
      node = createItem(i)
      contentArea.add(node)
      maxWidth = maxWidth.max(node.size.w)
      cache[i] = node
    }
    node.pos = Point(0, i * itemSize)
    return node
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
      end := ((scroll.y + node.clientArea.h).toFloat / itemSize).ceil.toInt
      cache.moveRegion(Region(start, end - start))
      height := source.size * itemSize
      content.size = Size(maxWidth.max(node.clientArea.w), height)
      for(i := start; i < end; i++) itemByIndex(i)
    }
    cache.trash.each
    {
      disposeItem(it)
      contentArea.remove(it)
    }
    cache.clearTrash()
  }

  protected Group content := Group()

  virtual protected Group contentArea() { content }

  override protected Node listenerNode() { content }

  override protected ScrollArea node := ScrollArea()

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
