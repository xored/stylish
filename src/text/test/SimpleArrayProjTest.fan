
class SimpleArrayProjectionTest : Test
{

  Void testHide()
  {
    ArrayProj proj := SimpleArrayProj(10)
    verifyEq(proj.getState(0..<10), RangeState.visible)
    verifyEq(proj.toMasterIndex(0), 0)
    verifyEq(proj.toMaster(0..9), [0..9,])
    verifyEq(proj.fromMaster(1..3), 1..<4)
    verifyEq(proj.size, 10)
    
    proj.hide(1..2)
    verifyEq(proj.getState(0..10), RangeState.partiallyVisible)
    verifyEq(proj.getState(1..2), RangeState.invisible)
    verifyEq(proj.toMasterIndex(2), 4)
    verifyEq(proj.toMaster(0..4), [0..0, 3..6])
    verifyNull(proj.fromMaster(1..<1))
    verifyEq(proj.fromMaster(1..3).toList, (1..1).toList)
    verifyEq(proj.size, 8)
  }
  
  Void testShow()
  {
    ArrayProj proj := SimpleArrayProj(10)

    proj.hide(1..5)
    proj.show(1..5)
    verifyEq(proj.getState(0..9), RangeState.visible)
    verifyEq(proj.toMasterIndex(0), 0)
    verifyEq(proj.toMaster(0..9), [0..9,])
    verifyEq(proj.size, 10)
    
    proj.hide(1..5)
    proj.hide(5..7)
    verifyEq(proj.getState(1..7), RangeState.invisible)
    verifyEq(proj.getState(8..9), RangeState.visible)
    verifyEq(proj.getState(0..<1), RangeState.visible)
    verifyEq(proj.size,  3)
    
    proj = SimpleArrayProj(10)
    proj.hide(4..8)
    proj.show(6..8)
    verifyEq(proj.getState(4..<6), RangeState.invisible)
    verifyEq(proj.getState(0..<4), RangeState.visible)
    verifyEq(proj.getState(6..<10), RangeState.visible)
    verifyEq(proj.size,  8)
    
    proj.show(4..<5)
    verifyEq(proj.getState(5..<6), RangeState.invisible)
    verifyEq(proj.getState(0..<5), RangeState.visible)
    verifyEq(proj.getState(6..<10), RangeState.visible)
    verifyEq(proj.size,  9)
  }
  
  Void testFindPrevVisible()
  {
    ArrayProj proj := SimpleArrayProj(10)

    proj.hide(1..5)
    verifyEq(proj.findPrevVisible(0), 0)
    verifyEq(proj.findPrevVisible(3), 0)
    verifyEq(proj.findPrevVisible(6), 1)

    proj.hide(0..<1)
    verifyNull(proj.findPrevVisible(0))
    verifyNull(proj.findPrevVisible(5))
    verifyEq(proj.findPrevVisible(7), 1)
  }
  
  Void testFindNextVisible()
  {
    ArrayProj proj := SimpleArrayProj(10)

    proj.hide(1..5)
    verifyEq(proj.findNextVisible(0), 0)
    verifyEq(proj.findNextVisible(3), 1)
    verifyEq(proj.findNextVisible(7), 2)

    proj.hide(7..<10)
    verifyNull(proj.findNextVisible(7))
    verifyNull(proj.findNextVisible(9))
    verifyEq(proj.findNextVisible(6), 1)
  }
}
