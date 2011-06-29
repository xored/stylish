
**
** This class is used to cache range of elements in the list
** and updates this cache correspond to list changes
**
@Js
class ListCache
{

  ** get element in the list by real index
  @Operator Obj? get(Int i) { elements[i - region.start] }

  ** set element in the list by real index
  @Operator Void set(Int i, Obj element) { elements[i - region.start] = element }

  @Operator Obj?[] getRange(Range r)
  {
    elements[r.offset(-region.start)]
  }

  Obj?[] getAll() { elements.dup }

  ** region of elements in the list we need to cache
  Region region := Region.defVal { private set }

  Void moveRegion(Region nr)
  {
    if (region.equals(nr)) return
    ne := [,] { fill(null, nr.size) }
    ir := region.intersect(nr)
    if (ir != null)
    {
      end := ir.end
      toTrash(0, ir.start - region.start)
      toTrash(end - region.start, region.size)
      for(i := ir.start; i < end; i++)
        ne[i - nr.start] = elements[i - region.start]
    }
    else
    {
      toTrash(0, elements.size)
    }
    elements = ne
    region = nr
  }

  ** list of elements we need to remove
  Obj[] trash := [,]
  {
    get { &trash.dup }
    private set
  }

  ** clear trash and return list of elements which should be disposed
  Void clearTrash() { trash = [,] }

  Void add(Int index, Int size)
  {
    if (index >= region.end) return
    if (index < region.start)
    {
      region = region.offset(size)
      return
    }
    start := index - region.start
    ext := start + size < elements.size ? elements.size - size : start
    toTrash(ext, elements.size)
    for(i := ext - 1; i >= start; i--)
      elements[i + size] = elements[i]
    end := elements.size.min(start + size)
    for(i := end - 1; i >= start; i--)
      elements[i] = null
  }

  Void remove(Int index, Int size)
  {
    if (index >= region.end) return
    if (index + size <= region.start)
    {
      region = region.offset(-size)
      return
    }
    from := index - region.start
    start := 0.max(from)
    end := elements.size.min(from + size)
    toTrash(start, end)
    elements.removeRange(start..<end)
    for(i := start; i < end; i++) elements.add(null)
    if (from < 0) region = region.offset(from)
  }

  private Void toTrash(Int from, Int to)
  {
    for(i := from; i < to; i++)
    {
      element := elements[i]
      if (element != null) &trash.add(element)
    }
  }

  ** list of cached elements
  private Obj?[] elements := [,]

}
