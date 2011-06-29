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

  protected Void init()
  {
    source.listen(cache)
    node.onScroll = |p| { sync() }
  }

  protected Void sync()
  {
    start := scroll.y / itemSize
    size := (node.clientArea.h.toFloat / itemSize.toFloat).ceil.toInt
    cache.area = Region(start, size)
    height := source.size * itemSize
    content.size = Size(100, height)
    for(i := 0; i < size; i++)
    {
      node := cache[i]
      if (node == null)
      {
        node = createView(i)
        content.add(node)
      }
      node.pos = Point((start + i) * itemSize, 0)
    }
  }

  protected Group content := Group()

  override internal ScrollArea node := ScrollArea() { it.add(content) }

  private ListViewCache cache := ListViewCache()

}

@Js
internal class ListViewCache : ListListener
{

  @Operator Node? get(Int i) { nodes[i] }

  @Operator Void set(Int i, Node node) { nodes[i] = node }

  Region area := Region.defVal
  {
    set
    {
      updateCache(&area, it)
      &area = it
    }
  }

  private Void updateCache(Region or, Region nr)
  {
    if (or.equals(nr)) return
    Node?[] nn := [,] { fill(null, nr.size) }
    ir := or.intersect(nr)
    if (ir != null)
    {
      end := ir.end
      toTrash(0, ir.start - or.start)
      toTrash(end - or.start, or.size)
      for(i := ir.start; i < end; i++)
        nn[i - nr.start] = nodes[i - or.start]
    }
    else
    {
      toTrash(0, nodes.size)
    }
    nodes = nn
  }

  override Void onAdd(Int index, Int size)
  {
    if (index < area.start || index >= area.end) return
    diff := index - area.start
    toTrash(diff, nodes.size.min(index + size))
  }

  override Void onRemove(Int index, Int size)
  {
    
  }

  private Void toTrash(Int from, Int to)
  {
    for(i := from; i < to; i++)
    {
      node := nodes[i]
      if (node != null) trash.add(node)
    }
  }

  private Node?[] nodes := [,]

  private Node[] trash := [,]

}
