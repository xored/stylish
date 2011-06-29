
class RegionTest : Test
{
  Void testSlots()
  {
    region := Region(0, 2)
    verifyEq(region.last, 1)
    verifyEq(region.end, 2)
    verifyEq(region, Region(0, 2))
    verifyEq(region.toStr, "0+2")
  }

  Void testFromRange()
  {
    verifyEq(Region.fromRange(2..5,     7), Region(2, 4))
    verifyEq(Region.fromRange(2..<5, null), Region(2, 3))
    verifyEq(Region.fromRange(5..<2,    7), Region(3, 3))
    verifyEq(Region.fromRange(-1..0, null), null)
    verifyEq(Region.fromRange(0..<0,    7), Region(0, 0))
    verifyEq(Region.fromRange(5..<-1,   7), Region(5, 1))
    verifyEq(Region.fromRange(-1..<1,   7), Region(2, 5))
    verifyEq(Region.fromRange(-4..-2,   7), Region(3, 3))
    verifyEq(Region.fromRange(2..<5), Region.fromRange(4..2))
  }
}
