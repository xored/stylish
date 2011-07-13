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
    set
    {
      x := it.x.max(0).min(content.size.w - clientArea.w)
      y := it.y.max(0).min(content.size.h - clientArea.h)
      if (x != it.x || y != it.y)
        it = Point(x, y)
      node.scroll = it
    }
  }

  Int? rowByPos(Int pos)
  {
    row := pos / itemSize
    return row < source.size ? row : null
  }

  Int posByRow(Int row)
  {
    size := source.size
    if (row < size)
      return row * itemSize
    throw ArgErr("require row < lineCount, but row=$row and lineCount=$size")
  }

  Region visibleRows() { cache.region }

  Region fullyVisibleRows()
  {
    region := cache.region
    dropFirst := region.start * itemSize < scroll.y
    dropLast := region.end * itemSize > scroll.y + node.clientArea.h
    if (!dropFirst || !dropLast) return region
    first := dropFirst ? 1 : 0
    last := dropLast ? 1 : 0
    start := region.start + first
    size := region.size - first - last
    return Region(start, size)
  }

  abstract protected ListNotifier source()

  abstract protected Node createItem(Int i)

  virtual protected Void disposeItem(Node node) {}

  Size clientArea() { node.clientArea }

  override protected Void attach()
  {
    super.attach()
    node.add(content)
    source.listen(listener)
    node.onScroll = |p| { sync() }
    content.size = clientArea()
  }

  override protected Void onResize(Size s) { sync() }

  override protected Void detach()
  {
    source.discard(listener)
    node.onScroll = |p| {}
    super.detach()
  }

  abstract Int itemSize()

  // max width in pixels
  protected Int maxWidth := 0

  protected Node itemByIndex(Int i)
  {
    node := cache[i] as Node
    if (node == null)
    {
      node = createItem(i)
      contentArea.add(node)
      cache[i] = node
      nodeUpdate(node)
    }
    node.pos = Point(0, i * itemSize)
    return node
  }

  virtual protected Void sync()
  {
    if (source.size == 0)
    {
      cache.moveRegion(Region.defVal)
      content.size = clientArea()
    }
    else
    {
      start := scroll.y / itemSize
      end := ((scroll.y + node.clientArea.h).toFloat / itemSize).ceil.toInt
      end = end.min(source.size)
      cache.moveRegion(Region(start, end - start))
      for(i := start; i < end; i++) itemByIndex(i)
      syncContentHeight
      syncContentWidth
    }
    cache.trash.each
    {
      disposeItem(it)
      contentArea.remove(it)
    }
    cache.clearTrash()
  }

  protected Void nodeUpdate(Node node)
  {
    if (maxWidth < node.size.w)
    {
      maxWidth = node.size.w
      syncContentWidth
    }
  }

  private Void syncContentWidth()
  {
    content.size = Size(maxWidth.max(this.node.clientArea.w), content.size.h)
  }

  private Void syncContentHeight()
  {
    content.size = Size(content.size.w, source.size * itemSize)
  }

  protected Group content := Group()

  virtual protected Group contentArea() { content }

  override protected Node listenerNode() { content }

  override protected ScrollArea node := ScrollArea()

  protected ListCache cache := ListCache()

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
