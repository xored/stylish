
class ListRangeCacheTest : Test
{

  Void testRegionUpdates()
  {
    cache := fillListCache()
    cache.moveRegion(Region(3, 5))
    verifyEq(cache.getAll, Obj?[null, null, 5, 6, 7])
    verify(contentEquals(cache.trash, [8, 9]))

    cache.moveRegion(Region(6, 5))
    verifyEq(cache.getAll, Obj?[6, 7, null, null, null])
    verify(contentEquals(cache.trash, [5, 8, 9]))

    cache.moveRegion(Region(10, 1))
    verifyEq(cache.getAll, Obj?[null])
    verify(contentEquals(cache.trash, [5, 6, 7, 8, 9]))
  }

  Void testAdd()
  {
    cache := fillListCache()
    cache.add(7, 2)
    verifyEq(cache.getAll, Obj?[5, 6, null, null, 7])
    verify(contentEquals(cache.trash, [8, 9]))

    cache = fillListCache()
    cache.add(8, 3)
    verifyEq(cache.getAll, Obj?[5, 6, 7, null, null])
    verify(contentEquals(cache.trash, [8, 9]))

    cache = fillListCache()
    cache.add(2, 5)
    verifyEq(cache.getAll, Obj?[5, 6, 7, 8, 9])
    verifyEq(cache.region, Region(10, 5))
    verify(cache.trash.isEmpty)

    cache = fillListCache()
    cache.add(15, 10)
    verifyEq(cache.getAll, Obj?[5, 6, 7, 8, 9])
    verifyEq(cache.region, Region(5, 5))
    verify(cache.trash.isEmpty)
  }

  Void testRemove()
  {
    cache := fillListCache()
    cache.remove(3, 3)
    verifyEq(cache.getAll, Obj?[6, 7, 8, 9, null])
    verifyEq(cache.region, Region(3, 5))
    verify(contentEquals(cache.trash, [5]))

    cache = fillListCache()
    cache.remove(6, 3)
    verifyEq(cache.getAll, Obj?[5, 9, null, null, null])
    verifyEq(cache.region, Region(5, 5))
    verify(contentEquals(cache.trash, [6, 7, 8]))

    cache = fillListCache()
    cache.remove(8, 4)
    verifyEq(cache.getAll, Obj?[5, 6, 7, null, null])
    verifyEq(cache.region, Region(5, 5))
    verify(contentEquals(cache.trash, [8, 9]))

    cache = fillListCache()
    cache.remove(15, 5)
    verifyEq(cache.getAll, Obj?[5, 6, 7, 8, 9])
    verifyEq(cache.region, Region(5, 5))
    verify(cache.trash.isEmpty)

    cache = fillListCache()
    cache.remove(2, 3)
    verifyEq(cache.getAll, Obj?[5, 6, 7, 8, 9])
    verifyEq(cache.region, Region(2, 5))
    verify(cache.trash.isEmpty)
  }

  private Bool contentEquals(Obj[] a, Obj[] b)
  {
    if (a.size != b.size) return false
    c := b.dup
    for(i := 0; i < a.size; i++)
    {
      if (c.remove(a[i]) == null) return false
    }
    return true
  }

  private ListCache fillListCache()
  {
    cache := ListCache()
    cache.moveRegion(Region(5, 5))
    for(i := 5; i < 10; i++) cache[i] = i
    return cache
  }
}
