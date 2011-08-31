
**
** Present the class that makes array transformations.
** 
@Js
internal mixin ArrayProj
{

  **
  ** Return the length of the projection array.
  ** 
  abstract Int size()

  **
  ** Hide the specified master range.
  ** Return the ranges in projection that become invisible. 
  ** 
  abstract Range[] hide(Range range)

  **
  ** Hide the specified master ranges.
  ** It's preferable to use this method intead of several calls of
  ** 'remove()' for each range, because model may do some internal optimizations
  ** for removing a set of ranges.
  ** Return the ranges in projection that become invisible. 
  ** 
  abstract Range[] hideAll(Range[] ranges)

  **
  ** Show the specified master range.
  ** Return the ranges in projection that become visible. 
  ** 
  abstract Range[] show(Range range)

  ** 
  ** Show the specified master ranges.
  ** It's preferable to use this method intead of several calls of
  ** 'add()' for each range,because implementation may do some internal optimizations
  ** for adding a set of ranges.
  ** Return the ranges in projection that become visible. 
  ** 
  abstract Range[] showAll(Range[] ranges)

  **
  ** By the specified projection range return corresponding master array ranges.
  ** 
  abstract Range[] toMaster(Range range)

  **
  ** By the specified master range return corresponding projection array range
  ** or 'null' if the corresponding master array range was removed.
  ** 
  abstract Range? fromMaster(Range range)

  **
  ** By the specified projection index return corresponding master array index
  ** or 'null' if there is not underlying master index (e.g. index was inserted with `ArrayProj::insert`).
  ** 
  abstract Int? toMasterIndex(Int index)

  **
  ** Return the state for the given master range.
  ** 
  abstract RangeState getState(Range range)
  
  **
  ** Insert range of indexes. This range doesn't have underlying master ranges.
  ** 
  abstract ProjInsertion insert(Range indexes)

  **
  ** Used to notify, that new indexes were inserted to the master array.
  ** For now the login of insertion to projection the following:
  **  - if the start of the given range lies in visible range,
  **    then the corresponding visible range will be extended to include the given range
  **  - if the start of the given range in the 'masterSize' (range added to master), 
  **    then the given range will be visible;
  **  - if the start of the given range lies in invisible range,
  **    then the given range will also become invisible.
  ** Return the range that have been added to this projection and becomes visible
  ** or 'null' if inserted range becomes invisible.
  ** 
  abstract Range? insertMaster(Range indexes)

  **
  ** Used to notify, that indexes were deleted from the master array.
  ** Return the range that were removed from projection.
  ** 
  abstract Range? deleteMaster(Range indexes)

  ** 
  ** Find the previous visible index in this projection array,
  ** starting the search at the given master index offset and looking backward.
  ** 
  ** If a visible index occurs in this projection array and
  ** the corresponding master array index is no greater than 'masterOffset', then
  ** the index of the last such occurrence is returned.
  ** 
  ** Return the found projection array index or 'null' if nothing found.
  ** 
  abstract Int? findPrevVisible(Int masterOffset)

  ** 
  ** Find the next visible index in this projection array,
  ** starting the search at the given master index offset and looking forward.
  ** 
  ** If a visible index occurs in this projection array and
  ** the corresponding master array index is no smaller than 'masterOffset', then
  ** the index of the first such occurrence is returned.
  ** 
  ** Return the found projection array index or 'null' if nothing found.
  ** 
  abstract Int? findNextVisible(Int masterOffset)

}

**
** Present the range of indexes that was inserted into `ArrayProj` instance.
** 
@Js
internal mixin ProjInsertion
{

  **
  ** Current ranges of insertion in the projection array.
  ** This method returns a list, because there is following possible scenario:
  **  1. `ArrayProj.insert` is called to insert range [1..4] 
  **  2. `ArrayProj.insert` is called to insert range [2..3]
  ** After this scenarion the first insertion has two ranges: [1..2) and [4..6] 
  ** 
  abstract Range[] ranges()

  **
  ** Remove this insertion from the projection array.
  ** 
  abstract Void discard()

}
