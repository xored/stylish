**
** Presents a foldable range.
** 
@Js
mixin Fold
{
  **
  ** Lines range in the master document that corresponds to this fold.
  ** TODO Would be better to have 'abstract const' field...
  ** 
  abstract Range masterRange 
  
  **
  ** Lines range in the current document context (with some folded part).
  ** 
  abstract Range range() 

  **
  ** Whether this fold is collapsed or not.
  ** 
  abstract Bool collapsed

  **
  ** Toggle the state (expanded/collapsed) of this fold.
  ** 
  abstract Void toggle()
  
  **
  ** Collapse this fold.
  ** 
  abstract Void collapse()
  
  **
  ** Expand this fold.
  ** 
  abstract Void expand()
  
  **
  ** Remove foldable nature from the range.
  ** 
  abstract Void discard();
}