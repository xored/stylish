
**
** Presents the class that makes array transformations.
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
  ** By the specified projection index
  ** return corresponding master array index.
  ** 
  abstract Int toMasterIndex(Int index)

  **
  ** Return the state for the given master range.
  ** 
  abstract RangeState getState(Range range)

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
  abstract Range? insert(Range indexes)

  **
  ** Used to notify, that indexes were deleted from the master array.
  ** Return the range that were removed from projection.
  ** 
  abstract Range? delete(Range indexes)

}