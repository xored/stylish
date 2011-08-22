using kawhyCss

**
** The document that may apply text transformations to the master document.
** This document contains transformed content.
** 
@Js
mixin ProjDoc : TextDoc
{
  **
  ** Master (base) document.
  ** 
  abstract TextDoc master 
  
  **
  ** Hide the range of lines (range is related to the master document).
  ** 
  abstract Void hide(Range lines)
  
  **
  ** Hide the batch of ranges (each range is related to the master document).
  ** 
  abstract Void hideAll(Range[] lines)
  
  **
  ** Show the range of lines (range is related to the master document).
  ** Do nothing if the exactly the same range wasn't hidden with 'hide' or 'hideAll'.
  ** 
  abstract Void show(Range lines) 
  
  **
  ** Show the brach of ranges (range is related to the master document).
  **  
  abstract Void showAll(Range[] lines)
  
  **
  ** Mark the given range as foldable by user (range is related to the master document).
  ** 
  abstract Fold makeFold(Range lines)
  
  **
  ** By the line in this document retrieve the line in the master document.
  ** 
  abstract Int toMasterLine(Int line)
  
  **
  ** By the specified line range in the master document return corresponding range in this document
  ** or 'null' if the corresponding range has been hidden.
  ** 
  abstract Range? fromMasterLines(Range lines)
  
  **
  ** By the given line range in this document return corresponding ranges in the master document.
  ** 
  abstract Range[] toMasterLines(Range lines)
  
  **
  ** Return the state of the given range (range is related to master document).
  ** 
  abstract RangeState getState(Range lines)
  
  **
  ** Return the registered with 'makeFold' fold with the mininal length of range that contains the given line
  ** or 'null', if there isn't such registered fold.
  **
  abstract Fold? find(Int line)
  
  **
  ** Register the given line decorator for this document. The concept is a point to discuss, currrently
  ** decorators aren't allowed to return replacement ranges that overlap each other.
  ** Decorator receives the line to decorate and the index of this line in the master document.
  ** 
  abstract Void addLineDecorator(|TextLine, Int->StrReplacement[]| decorator)
  
  **
  ** Remove line decorator.
  ** 
  abstract Void removeLineDecorator(|TextLine, Int->StrReplacement[]| decorator)
  
  **
  ** Add listener that will be notified when state of folds is changed or folds added/removed.
  ** Listener accepts a list of modified/added/removed folds.
  ** 
  abstract Void addFoldListener(|Fold[]| listener)
  
  **
  ** Remove fold listener.
  ** 
  abstract Void removeFoldListener(|Fold[]| listener)
}

**
** Present one string replacement.
** 
@Js
const class StrReplacement
{
  **
  ** Range to remove.
  **
  const Range remove
  
  **
  ** String to insert instead of removed range.
  ** 
  const Str insert
  
  **
  ** Style of inserted string.
  ** 
  const Style? style
  
  new make(Range remove, Str insert, Style? style)
  {
    this.remove = remove
    this.insert = insert
    this.style = style
  }
}

**
** Present master range state: it may be completely removed from projection, partialy removed,
** or completely added to projection.
** 
@Js
enum class RangeState { visible, partiallyVisible, invisible }
