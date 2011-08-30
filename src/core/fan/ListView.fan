using gfx
using kawhyCss
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

  Notice onScroll := Notice()

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

  protected Region loadedRows() { cache.region }

  Region fullyVisibleRows()
  {
    region := visibleRows
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

  virtual protected Style? itemStyle(Int i) { null }

  virtual protected Void disposeItem(Node node) {}

  Size clientArea() { node.clientArea }

  override protected Void attach()
  {
    super.attach()
    node.add(content)
    source.listen(listener)
    node.onScroll = |p|
    {
      sync()
      onScroll.push(p)
    }
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
    node := cache[i] as Group
    if (node == null)
    {
      item := createItem(i)
      node = Group { it.add(item) }
      node.style = itemStyle(i)
      contentArea.add(node)
      cache[i] = node
      nodeUpdate(node)
    }
    node.pos = Point(0, i * itemSize)
    size := node.kids[0].size
    node.size = Size(size.w.max(this.node.clientArea.w), size.h)
    return node.kids[0]
  }

  virtual protected Void sync()
  {
    if (source.size == 0)
    {
      visibleRows = Region.defVal
      cache.moveRegion(Region.defVal)
      content.size = clientArea()
    }
    else
    {
      updateVisibleRegion
      rows := loadedRows
      for(i := rows.start; i < rows.end; i++) itemByIndex(i)
      syncContentHeight
      syncContentWidth
    }
    cache.trash.each
    {
      Group node := it
      disposeItem(node.kids[0])
      contentArea.remove(node)
    }
    cache.clearTrash()
  }

  private Void updateVisibleRegion()
  {
    start := scroll.y / itemSize
    end := ((scroll.y + node.clientArea.h).toFloat / itemSize).ceil.toInt
    end = end.min(source.size)
    visibleRows = Region(start, end - start)
    
    size := (end - start).max(1)
    start = 0.max(start - 20)
    end = source.size.min(end + 20)
    cache.moveRegion(Region(start, end - start))
  }

  Region visibleRows := Region.defVal { private set }

  protected Void nodeUpdate(Group node)
  {
    size := node.kids[0].size
    if (maxWidth < size.w)
    {
      maxWidth = size.w
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

  override ScrollArea node := ScrollArea()

  private ListCache cache := ListCache()

  private ListViewListener listener := ListViewListener(cache, |->| { this.sync() })

}

@Js
internal class ListViewListener : ListListener
{

  new make(ListCache cache, |->| onChange)
  {
    this.cache = cache
    this.onChange = onChange
  }

  override Void onAdd(Int index, Int size)
  {
    cache.add(index, size)
    onChange()
  }

  override Void onRemove(Int index, Int size)
  {
    cache.remove(index, size)
    onChange()
  }

  private ListCache cache
  private |->| onChange

}
