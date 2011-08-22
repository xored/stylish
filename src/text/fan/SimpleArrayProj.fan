using kawhyMath

**
** Projection text model implementation.
** Current implementation is based on assumption that master text model is static.
** For changeable master text model (e.g. in editor) need to process model change events.
** 
@Js
internal class SimpleArrayProj : ArrayProj 
{
  private Int masterSize
  
  override Int size { private set }
  
  // visible fragments that have a projection in master array
  private ProjRange[] projFragments := [,]

  new make(Int size)
  {
    this.size = size
    this.masterSize = size

    wholeText := Region.fromRange(0..<size)
    projFragments.add(ProjRange(wholeText))
  }
  
  override Range[] hide(Range range)
  {
    // TODO we iterate on ranges in inversion order, it's not efficient, but we return correct values, need to improve this
    Region[] removedRanges := [,]
    masterRanges := computeProjectedMasterRanges(Region.fromRange(range))
    masterRanges.eachr { removedRanges.add(removeProjectedMasterRange(it)) }
    return removedRanges.map { it.toRange }
  }
  
  override Range[] hideAll(Range[] ranges)
  {
    // TODO we iterate on ranges in inversion order, it's not efficient, but we return correct result, need to improve this
    ranges = ranges.unique
    Region[] regions := ranges.map { Region.fromRange(it) }
    regions.sortr |range1, range2| { range1.start.compare(range2.start) }

    Region[] removedRanges := [,]
    regions.each |range|
    {
      masterRanges := computeProjectedMasterRanges(range)
      masterRanges.eachr { removedRanges.add(removeProjectedMasterRange(it)) }
    }
    return removedRanges.map { it.toRange }
  }
  
  override Range[] show(Range range)
  {
    Region[] addedRanges := [,]
    masterRanges := computeUnprojectedMasterRanges(Region.fromRange(range))
    masterRanges.eachr { addedRanges.add(addUnprojectedMasterRange(it)) }
    return addedRanges.map { it.toRange }
  }
  
  override Range[] showAll(Range[] ranges)
  {
    // some optimization attempt
    ranges = ranges.unique
    Region[] regions := ranges.map { Region.fromRange(it) }
    regions.sortr |range1, range2| { range1.start.compare(range2.start) }

    Region[] addedRanges := [,]
    regions.each |range|
    {
      masterRanges := computeUnprojectedMasterRanges(range)
      masterRanges.eachr { addedRanges.add(addUnprojectedMasterRange(it)) }
    }
    return addedRanges.map { it.toRange }
  }

  override Range[] toMaster(Range range)
  {
    Region region := Region.fromRange(range)
    res := Range[,]
    
    fragmentIndex := findFragmentIndexByProjectionIndex(region.start)
    if (fragmentIndex < 0 || fragmentIndex >= projFragments.size)
      return res 
    
    currentPos := region.start
    while (fragmentIndex < projFragments.size && currentPos < region.end)
    {
      fragment := projFragments[fragmentIndex]
      
      indexDiff := currentPos - fragment.projRange.start
      startIndex := fragment.masterRange.start + indexDiff
      if (fragment.projRange.contains(region.last))
      {
        indexDiff = region.last - fragment.projRange.start
        endIndex := fragment.masterRange.start + indexDiff
        
        res.add(startIndex..endIndex)
      }
      else 
      {
        res.add(startIndex..fragment.masterRange.last)
      }
      
      currentPos = fragment.projRange.end
      fragmentIndex++
    }
    return res
  }
  
  override Range? fromMaster(Range range) {
    if (projFragments.size == 0)
      return null
    Region region := Region.fromRange(range)
    
    fragmentIndexBegin := findFragmentIndexByMasterIndex(region.start)
    fragmentIndexEnd := findFragmentIndexByMasterIndex(region.last)
    if (fragmentIndexBegin < 0) fragmentIndexBegin = -(fragmentIndexBegin + 1)
    if (fragmentIndexEnd < 0)
      fragmentIndexEnd = -(fragmentIndexEnd + 1) - 1
    
    if (fragmentIndexEnd < fragmentIndexBegin)
      return null
    
    rangeStart := projFragments[fragmentIndexBegin].projRange.start
    if (projFragments[fragmentIndexBegin].masterRange.contains(region.start))
    {
      masterRangeStart := projFragments[fragmentIndexBegin].masterRange.start
      indexDiff := region.start - masterRangeStart
      rangeStart = rangeStart + indexDiff
    }
    
    rangeEnd := projFragments[fragmentIndexEnd].projRange.end
    if (projFragments[fragmentIndexEnd].masterRange.contains(region.last))
    {
      masterRangeStart := projFragments[fragmentIndexEnd].masterRange.start
      indexDiff := region.end - masterRangeStart
      projRangeStart := projFragments[fragmentIndexEnd].projRange.start
      rangeEnd = projRangeStart + indexDiff
    }

    return rangeStart < rangeEnd || region.isEmpty ? rangeStart..<rangeEnd : null 
  }
  
  override Int toMasterIndex(Int index) {
    Int fragmentIndex := findFragmentIndexByProjectionIndex(index)
    Int result := 0 
    if (fragmentIndex < 0) 
      result = index   
    else
      result = projFragments[fragmentIndex].masterRange.start + 
        (index - projFragments[fragmentIndex].projRange.start) 
    return result
  }

  override RangeState getState(Range range)
  {
    Region region := Region.fromRange(range)
    Int fragmentIndex := findFragmentIndexByMasterIndex(region.start)
    if (fragmentIndex >= 0) // then may be partially removed or completely added to projection 
    {
      if (projFragments[fragmentIndex].masterRange.end >= region.end)  // based on assumption that the count of projection fragments is minimized
        return RangeState.visible
      else
        return RangeState.partiallyVisible
    }
    else // may be partially or completely removed 
    {
      fragmentIndex = -(fragmentIndex + 1)
      if (fragmentIndex >= projFragments.size) // the given master range and all master ranges on the right from it are removed
        return RangeState.invisible
      if (projFragments[fragmentIndex].masterRange.start < range.end)
        return RangeState.partiallyVisible
      else
        return RangeState.invisible
    }
  }
  
  override Range? insert(Range indexes)
  {
    Region r := Region.fromRange(indexes)
    Range? insertedRange := null
    if (r.start == masterSize) // the elements were added to the end of master array
    {
      fragment := projFragments.last
      if (fragment.masterRange.last == masterSize - 1) // can extend the last fragment
      {
        fragment.masterRange = Region(fragment.masterRange.start, fragment.masterRange.size + r.size)
        fragment.projRange = Region(fragment.projRange.start, fragment.masterRange.size + r.size)
      }
      else
      {
        lastProjIndex := fragment.projRange.last
        projFragments.add(ProjRange(Region(lastProjIndex + 1, r.size), Region(masterSize, r.size)))
      }
    }
    else
    {
      index := findFragmentIndexByMasterIndex(r.start)
      if (index >= 0) // insert into visible region
      {
        fragment := projFragments[index]
        insertedRange = Region(fragment.projRange.start + (r.start - fragment.masterRange.start), r.size).toRange
        fragment.masterRange = Region(fragment.masterRange.start, fragment.masterRange.size + r.size)
        fragment.projRange = Region(fragment.projRange.start, fragment.projRange.size + r.size)
        changeMasterIndexesForFragments(index + 1, r.size)
        moveFragmentsTailTo(index + 1, fragment.projRange.end)
      }
      else // insert into invisible region
      {
        index = -(index + 1) - 1
        changeMasterIndexesForFragments(index, r.size)
      }
    }
    masterSize = masterSize + r.size
    size = size + r.size
    return insertedRange
  }
  
  override Range? delete(Range indexes)
  {
    Region r := Region.fromRange(indexes)
    Region? res := null
    index := findFragmentIndexByMasterIndex(r.start)
    if (index >= 0)
    {
      fragment := projFragments[index]
      Region common := r.intersect(fragment.masterRange)
      res = Region(fragment.projRange.start + (common.start - fragment.masterRange.start), common.size) 

      fragment.projRange = Region(fragment.projRange.start, fragment.projRange.size - common.size)
      fragment.masterRange = Region(fragment.masterRange.start, fragment.masterRange.size - common.size)
    }
    
    lastFragmentIndex := index >= 0 ? index + 1 : -(index + 1) - 1
    startIndexToRemove := lastFragmentIndex
    while (lastFragmentIndex < projFragments.size) // is it always more efficient than binary search?
    {
      fragment := projFragments[lastFragmentIndex]
      if (!r.includes(fragment.masterRange))
        break
      
      if (res != null)
        res = Region(res.start, res.size + fragment.projRange.size)
      else
        res = fragment.projRange
      
      lastFragmentIndex++
    }
    
    lastFragment := projFragments.getSafe(lastFragmentIndex)
    endIndexToRemove := lastFragmentIndex - 1
    if (lastFragment != null && !lastFragment.masterRange.intersect(r).isEmpty)
    {
      Region common := r.intersect(lastFragment.masterRange)
      if (res != null)
        res = Region(res.start, res.size + common.size)
      else
        res = Region(lastFragment.projRange.start, common.size)
      
      lastFragment.projRange = Region(lastFragment.projRange.start + common.size, lastFragment.projRange.size - common.size)
      lastFragment.masterRange = Region(lastFragment.masterRange.start + common.size, lastFragment.masterRange.size - common.size)
    }
    else
    {
      if (lastFragmentIndex < projFragments.size)
        endIndexToRemove = lastFragmentIndex
    }
    
    if (startIndexToRemove <= endIndexToRemove)
      projFragments.removeRange(startIndexToRemove..endIndexToRemove)
    newProjStartIndex := startIndexToRemove == 0 ? 0 : projFragments[startIndexToRemove - 1].projRange.end
    changeMasterIndexesForFragments(startIndexToRemove, -r.size)
    moveFragmentsTailTo(startIndexToRemove, newProjStartIndex)
    
    masterSize = masterSize - r.size
    size = size - r.size
    return res?.toRange
  }
  
  **
  ** Remove master range with assumption that it has only one corresponding projection.
  ** Return projection range of removed master range.
  ** 
  private Region removeProjectedMasterRange(Region region)
  {
    Region removedProjRange := Region.defVal
    
    fragmentIndex := findFragmentIndexByMasterIndex(region.start)
    fragment := projFragments.getSafe(fragmentIndex)
    if (fragment == null || !fragment.masterRange.includes(region))
      throw ArgErr("The specified range doesn't have the only one corresponding projection.")

    projectedMasterRange := fragment.masterRange
    if (projectedMasterRange.start == region.start && projectedMasterRange.end == region.end) // can remove the whole fragment
    {
      removedProjRange = fragment.projRange
      movingPos := fragment.projRange.start
      projFragments.removeAt(fragmentIndex)
      moveFragmentsTailTo(fragmentIndex, movingPos)
    }
    else // lets divide into 3 fragments
    {
      // create left fragment
      leftMasterRange := Region.fromRange(projectedMasterRange.start..<region.start)
      leftProjectionRange := Region(fragment.projRange.start, leftMasterRange.size) 
      leftFragment := ProjRange(leftProjectionRange, leftMasterRange)
      
      // create right fragment
      indexDiff := projectedMasterRange.end - region.end
      startIndex :=  fragment.projRange.end - indexDiff
      rightMasterRange := Region.fromRange(region.end..<projectedMasterRange.end)
      rightProjectionRange := Region(startIndex, rightMasterRange.size)
      rightFragment := ProjRange(rightProjectionRange, rightMasterRange)
      
      projFragments.removeAt(fragmentIndex)
      startIndexToMove := 0
      if (leftProjectionRange.isEmpty)
      {
        startIndexToMove = fragmentIndex
      }
      else
      {
        projFragments.insert(fragmentIndex, leftFragment)
        startIndexToMove = fragmentIndex + 1
      }
      if (!rightProjectionRange.isEmpty)
        projFragments.insert(startIndexToMove, rightFragment)
      
      removedProjRange = Region.fromRange(leftProjectionRange.end..<rightProjectionRange.start)
      moveFragmentsTailTo(startIndexToMove, leftProjectionRange.end)
    }
    
    size = size - removedProjRange.size
    return removedProjRange
  }
  
  **
  ** Add master range with assumption that it hasn't a corresponding projection.
  ** Return projection range of added master range.
  ** 
  private Region addUnprojectedMasterRange(Region region)
  {
    Region insertedProjRange := Region.defVal
    
    fragmentIndex := findFragmentIndexByMasterIndex(region.start)
    if (fragmentIndex >= 0)
      throw ArgErr("The specified range has a projection.")
    fragmentIndex = -(fragmentIndex + 1)
    
    // calculate inserted projection range
    leftIndex := 0 
    if (fragmentIndex > 0)
      leftIndex = projFragments[fragmentIndex - 1].projRange.end
    insertedProjRange = Region(leftIndex, region.size)
    
    // find is there fragment that ends on the start of the specified range
    ProjRange? leftFragment := null
    if (fragmentIndex > 0 && projFragments[fragmentIndex - 1].masterRange.end == region.start)
      leftFragment = projFragments[fragmentIndex - 1]
    // find is there fragment that starts on the end of the specified range
    ProjRange? rightFragment := null
    if (fragmentIndex < projFragments.size && projFragments[fragmentIndex].masterRange.start == region.end)
      rightFragment = projFragments[fragmentIndex]
    
    if (leftFragment != null && rightFragment != null) // we can "stick" fragments
    {
      // remove right fragment and extend left fragment
      newSize := leftFragment.masterRange.size + rightFragment.masterRange.size + region.size
      leftFragment.projRange = Region(leftFragment.projRange.start, newSize)
      leftFragment.masterRange = Region(leftFragment.masterRange.start, newSize)
      projFragments.removeAt(fragmentIndex)
      moveFragmentsTailTo(fragmentIndex, leftFragment.projRange.end)
    }
    else if (leftFragment != null) // we can extend left fragment
    {
      newSize := leftFragment.masterRange.size + region.size
      leftFragment.projRange = Region(leftFragment.projRange.start, newSize)
      leftFragment.masterRange = Region(leftFragment.masterRange.start, newSize)
      moveFragmentsTailTo(fragmentIndex, leftFragment.projRange.end)
    }
    else if (rightFragment != null) // we can extend right fragment
    {
      newSize := rightFragment.masterRange.size + region.size
      rightFragment.projRange = Region(rightFragment.projRange.start - region.size, newSize)
      rightFragment.masterRange = Region(rightFragment.masterRange.start - region.size, newSize)
      
      toMove := 0 
      if (fragmentIndex > 0)
        toMove = projFragments[fragmentIndex - 1].projRange.end
      moveFragmentsTailTo(fragmentIndex, toMove)
    }
    else // we have to create new fragment
    {
      newFragment := ProjRange(insertedProjRange, region)
      projFragments.insert(fragmentIndex, newFragment)
      moveFragmentsTailTo(fragmentIndex + 1, insertedProjRange.end)
    }

    size = size + insertedProjRange.size
    return insertedProjRange
  }
  
  **
  ** By the given master range divide it to the list of master ranges that have a projection,
  ** so the result is the partial coverage of the specified range.
  **   
  private Region[] computeProjectedMasterRanges(Region masterRange)
  {
    fragmentIndex := findFragmentIndexByMasterIndex(masterRange.start)
    if (fragmentIndex < 0) fragmentIndex = -(fragmentIndex + 1)
    
    res := Region[,]
    if (fragmentIndex >= projFragments.size)
      return res
    fragment := projFragments[fragmentIndex]
    while (fragment.masterRange.start < masterRange.end)
    {
      res.add(Region.fromRange(masterRange.start.max(fragment.masterRange.start) ..< fragment.masterRange.end.min(masterRange.end)))
      fragmentIndex++
      if (fragmentIndex >= projFragments.size) break
      fragment = projFragments[fragmentIndex]
    }
    
    return res
  }
  
  **
  ** By the given master range divide it to the list of master ranges that haven't a projection,
  ** so the result is the partial coverage of the specified range.
  **   
  private Region[] computeUnprojectedMasterRanges(Region masterRange)
  {
    fragmentIndex := findFragmentIndexByMasterIndex(masterRange.start)
    if (fragmentIndex < 0) fragmentIndex = -(fragmentIndex + 1)
    
    res := Region[,]
    currentPos := masterRange.start
    while (fragmentIndex < projFragments.size && currentPos < masterRange.end)
    {
      fragment := projFragments[fragmentIndex]
      if (currentPos < fragment.masterRange.start)
        res.add(Region.fromRange(currentPos ..< masterRange.end.min(fragment.masterRange.start)))
      currentPos = fragment.masterRange.end

      fragmentIndex++
    }
    if (currentPos < masterRange.end)
      res.add(Region.fromRange(currentPos ..< masterRange.end))
    
    return res
  }
  
  **
  ** Binary find for the fragment that contains the given in this projected array.
  ** 
  private Int findFragmentIndexByProjectionIndex(Int index)
  {
    return projFragments.binaryFind |ProjRange projRange->Int| {
      range := projRange.projRange
      if (range.start > index)
        return -1
      else if (range.last < index)
        return 1
      else
        return 0
    }
  }
  
  **
  ** Binary find for the fragment that contains the given index in master array.
  ** 
  private Int findFragmentIndexByMasterIndex(Int index)
  {
    return projFragments.binaryFind |ProjRange projRange->Int| {
      range := projRange.masterRange
      if (range.start > index)
        return -1
      else if (range.last < index)
        return 1
      else
        return 0
    }
  }
  
  private Void changeMasterIndexesForFragments(Int startIndex, Int diff)
  {
    if (diff == 0) return
    i := startIndex
    fragment := projFragments.getSafe(i++)
    if (fragment == null) return
    
    while (fragment != null)
    {
      fragment.masterRange = Region(fragment.masterRange.start + diff, fragment.masterRange.size)
      fragment = projFragments.getSafe(i++)
    }
  }
  
  **
  ** Moves indexes in projection ranges of fragments to the specified index.
  ** 
  private Void moveFragmentsTailTo(Int startIndex, Int index)
  {
    i := startIndex
    fragment := projFragments.getSafe(i++)
    if (fragment == null) return

    indexDiff := index - fragment.projRange.start
    if (indexDiff == 0) return
    
    while (fragment != null)
    {
      fragment.projRange = Region(fragment.projRange.start + indexDiff, fragment.projRange.size)
      fragment = projFragments.getSafe(i++)
    }
  }
  
}

**
** Text range in projection array that has a corresponding text range in the master array.
** 
@Js
internal class ProjRange
{
  
  Region projRange
  Region masterRange

  new make(Region projRange, Region masterRange := projRange)
  {
    if (projRange.size != masterRange.size)
      throw ArgErr("The sizes should be the same.")
    this.projRange = projRange
    this.masterRange = masterRange;
  }
  
  override Int hash() { 31 * projRange.hash + masterRange.hash }

  override Bool equals(Obj? obj)
  {
    that := obj as ProjRange
    if (that == null) return false
    return this.projRange == that.projRange && this.masterRange == that.masterRange
  }
  
  override Str toStr()
  {
    "[" + projRange.toStr() + "]->[" + masterRange.toStr() + "]"; 
  }

}
