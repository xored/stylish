using kawhyMath
using kawhyNotice
using kawhyCss

@Js
class BaseProjDoc : ProjDoc
{
  private FoldTree tree := FoldTree()
  private ArrayProj proj
  private [Int:DecoratedTextLine] lines := [:]
  
  private |TextLine, Int->StrReplacement[]|[] decorators := [,]
  private |TextLine, Int->StrReplacement[]| complexDecorator := |TextLine line, Int index->StrReplacement[]|
  {
    StrReplacement[] res := [,] 
    decorators.each { res.addAll(it.call(line, index)) }
    return res
  }
  
  private |Fold[]|[] foldListeners := [,]
  
  override TextDoc master { private set }
  
  override protected ListListener[] listeners := [,]
  
  new make(TextDoc master) {
    this.master = master
    proj = SimpleArrayProj(master.size)
    
    master.listen(OriginDocListener
    {
      onAddCallback = |Int index, Int size|
      {
        Range? inserted := proj.insertMaster(Region(index, size).toRange)

        [Int:DecoratedTextLine] newLines := [:]
        lines.each |line|
        {
          if (line.masterIndex >= index)
          {
            line.masterIndex = line.masterIndex + size
            newLines.add(line.masterIndex, line)
          }
          else
          {
            newLines.add(line.masterIndex, line)
          }
        }
        lines = newLines

        if (inserted != null)
        {
          r := Region.fromRange(inserted) 
          fire(AddNotice(r.start, r.size))
        }
      }
      onRemoveCallback = |Int index, Int size|
      {
        region := Region(index, size)
        Range? removed := proj.deleteMaster(region.toRange)
        
        [Int:DecoratedTextLine] newLines := [:]
        lines.each |line|
        {
          if (line.masterIndex >= index + size)
          {
            line.masterIndex = line.masterIndex + size
            newLines.add(line.masterIndex, line)
          }
          else if (line.masterIndex < index)
          {
            newLines.add(line.masterIndex, line)
          }
          else
          {
            line.free
          }
        }
        lines = newLines
        
        if (removed != null)
        {
          r := Region.fromRange(removed) 
          fire(RemoveNotice(r.start, r.size))
        }
      }
    })
  }
  
  @Operator override TextLine get(Int index)
  {
    masterIndex := proj.toMasterIndex(index)
    DecoratedTextLine? line := lines.get(masterIndex) 
    if (line == null)
      line = DecoratedTextLine(this, masterIndex, complexDecorator)
    return line
  }
  
  override Int size() { proj.size }
  
  override Void hide(Range lines)
  {
    BaseFold? fold := tree.getByRange(lines)
    if (fold == null)
    {
      fold = BaseFold(this, lines, false)
      tree.add(fold)
    }
    internalHide(fold)
  }
  
  override Void hideAll(Range[] lines) { lines.each { hide(it) } }
  
  override Void show(Range lines)
  {
    BaseFold? fold := tree.getByRange(lines)
    if (fold != null && !fold.visible)
      internalShow(fold)
  }
  
  override Void showAll(Range[] lines) { lines.each { show(it) } }
  
  override Fold makeFold(Range lines)
  {
    BaseFold? fold := tree.getByRange(lines)
    if (fold == null)
    {
      fold = BaseFold(this, lines, true)
      tree.add(fold)
    }
    else
      fold.markedByUser = true
    
    fireFoldsChange([fold])
    return fold
  }
  
  override Fold? find(Int line)
  {
    BaseFold? fold := tree.getUserMarkedByLine(toMasterLine(line))
    if (fold != null && fold.markedByUser)
      return fold
    return null
  }
  
  override Int toMasterLine(Int lineNum)
  {
    Int? masterIndex := proj.toMasterIndex(lineNum)
    if (masterIndex == null)
      throw Err("Illegal state: in this version BaseProjDoc doesn't support line insertions, " + 
        "so all projection lines must have the corresponding master line, " +
        "but seems that this requirement was broken.")
    return masterIndex
  }

  override Range? fromMasterLines(Range lines) { proj.fromMaster(lines) }

  override Range[] toMasterLines(Range lines) { proj.toMaster(lines) }

  override RangeState getState(Range lines) { proj.getState(lines) }

  override Int? findPrevVisibleLine(Int lineOffset) { proj.findPrevVisible(lineOffset) }
  
  override Int? findNextVisibleLine(Int lineOffset) { proj.findNextVisible(lineOffset) }

  override Void addLineDecorator(|TextLine, Int->StrReplacement[]| decorator)
  {
    decorators.add(decorator)
    // XXX this may cause a very long delay
    lines.each |line| { line.refresh }
  }
  
  override Void removeLineDecorator(|TextLine, Int->StrReplacement[]| decorator)
  {
    decorators.remove(decorator)
    // XXX this may cause a very long delay
    lines.each |line| { if (line.decorated) line.refresh }
  }
  
  override Void addFoldListener(|Fold[]| listener) { foldListeners.add(listener) }
  
  override Void removeFoldListener(|Fold[]| listener) { foldListeners.remove(listener) } 
  
  **
  ** Change folding state for the given fold.
  ** Only for internal usage, don't call this method, use `Fold.toggle()` instead.
  ** 
  internal Void toggle(BaseFold fold)
  {
    if (fold.collapsed)
    {
      handleShowLines(proj.showAll(getRangesToFold(fold)))
      restoreChildrenState(fold)
      fold.setCollapsedDirectly(false)
    }
    else
    {
      handleHideLines(proj.hideAll(getRangesToFold(fold)))
      fold.setCollapsedDirectly(true)
    }
    fireFoldsChange([fold])
  }
  
  internal Void addToCache(DecoratedTextLine line)
  {
    if (lines.containsKey(line.masterIndex))
      throw Err("Illegal state: trying to add line to cache, but there is already line with the same index.")
    lines.add(line.masterIndex, line)
  }
  
  internal Void removeFromCache(DecoratedTextLine line)
  {
    if (lines.get(line.masterIndex) !== line)
      throw Err("Illegal state: trying to free cache for line, that isn't in the cache.")
    lines.remove(line.masterIndex)
    line.free
  }
  
  internal TextLine getMasterLine(Int index) { master.get(index) }
  
  **
  ** Hide the given fold completely.
  ** 
  private Void internalHide(BaseFold fold)
  {
    handleHideLines(proj.hide(fold.masterRange))
    fold.visible = false
  }
  
  **
  ** Show the given fold content (with respect to it collapsed status)
  ** 
  private Void internalShow(BaseFold fold)
  {
    fold.visible = true
    
    if (!tree.isParentHidden(fold)) // doesn't show the fold, if one of it's parent hidden
    {
      handleShowLines(proj.show(fold.masterRange))
      restoreChildrenState(fold)
    }
    
    // remove fold, if we don't need to store it
    if (!fold.markedByUser) {
      tree.remove(fold)
    }
  }
  
  **
  ** Used after showing content of the given fold.
  ** 
  private Void restoreChildrenState(BaseFold fold)
  {
    BaseFold[]? children := tree.getChildren(fold)
    if (children == null)
      throw ArgErr("Fold $fold hasn't been added to model.")

    children.each
    { 
      if (it.visible) {
        if (it.collapsed)
         handleHideLines(proj.hideAll(getRangesToFold(it)))
      }
      else
        handleHideLines(proj.hide(it.masterRange))
    }
  }
  
  private Void handleHideLines(Range[] ranges)
  {
    ranges.each
    {
      Region r := Region.fromRange(it)
      fire(RemoveNotice(r.start, r.size))
    }
  }
  
  private Void handleShowLines(Range[] ranges)
  {
    ranges.each
    {
      Region r := Region.fromRange(it)
      fire(AddNotice(r.start, r.size))
    }
  }
  
  private Range[] getRangesToFold(BaseFold fold)
  {
    Region region := Region.fromRange(fold.masterRange)
    Region res := Region(region.start + 1, region.size - 1)
    return [res.toRange,]
  }
  
  private Void fireFoldsChange(Fold[] folds) { foldListeners.each { it.call(folds) } }
}

**
** Folds tree is based on the assumption that for every two different folds one of the following statements is true:
**  - Folds' text ranges don't intersect
**  - One fold's text range contains another fold's text range
** 
@Js
internal class FoldTree
{
  private RootTreeElement root := RootTreeElement()
  
  **
  ** Return the smallest (by length) `Fold` that contains the given position,
  ** or 'null' if nothing was found.
  **   
  BaseFold? getUserMarkedByLine(Int line) { getUserMarkedElementByLine(root, line).fold }
  
  BaseFold? getByRange(Range range) { findByRange(root, range)?.fold }

  BaseFold[]? getChildren(BaseFold fold)
  {
    element := findByRange(root, fold.masterRange)
    if (element == null) return null

    Fold[] res := [,]
    element.children.each { res.add(it.fold) }
    return res
  }
  
  **
  ** Return whether one of the parent folds is hidden/collapsed.
  ** 
  Bool isParentHidden(BaseFold fold)
  {
    // not efficient, but it saves tree from complexity of storing links child->parent
    Bool res := false
    findByRange(root, fold.masterRange)
    {
      if (it.fold != null)
        res = res || (!it.fold.visible || it.fold.collapsed)
    }
    return res
  }
  
  Void remove(BaseFold fold) { delete(root, fold) }
  
  Void add(BaseFold fold) { insert(root, fold) }
  
  Void modify(BaseFold newFold, BaseFold oldFold)
  {
    // TODO implement this method
  }
  
  Void clear() { root.children.clear }
  
  private TreeElement? findByRange(TreeElement parent, Range range, |TreeElement| parentHandler := |->| {})
  {
    parentHandler.call(parent)
    
    index := findByLine(parent.children, range.start)
    if (index >= 0)
    {
      element := parent.children[index]
      if (element.fold.masterRange == range)
        return element
      else if (Region.fromRange(element.fold.masterRange).includes(Region.fromRange(range)))
        return findByRange(element, range, parentHandler)
    }
    return null
  }
  
  private Void insert(TreeElement parent, BaseFold toIns)
  {
    index := findByLine(parent.children, toIns.masterRange.start)
    if (index >= 0)
    {
      element := parent.children[index]
      if (toIns.masterRange.equals(element.fold.masterRange))
        throw ArgErr("Inserted element $toIns has the same range as already inserted element")
      
      if (includes(element.fold, toIns)) // add as child
      {
        insert(element, toIns)  
      }
      else if (includes(toIns, element.fold)) // add as parent
      {
        newElement := FoldTreeElement(toIns)
        newElement.children.add(element)
        
        i := index + 1
        nextElement := parent.children.getSafe(i)
        while (nextElement != null && toIns.masterRange.contains(nextElement.fold.masterRange.start))
        {
          if (!includes(toIns, nextElement.fold))
            throw ArgErr("Inserted element $toIns intersects with the existent element $nextElement.fold")
          newElement.children.add(nextElement)
          nextElement = parent.children.getSafe(++i)
        }
        if (newElement.children.size > 1)
          parent.children.removeRange(index + 1 ..< index + newElement.children.size)
        parent.children[index] = newElement
      }
      else
      {
        throw ArgErr("Inserted element $toIns intersects with the existent element $element.fold")
      }
    }
    else
    {
      index = -(index + 1)
      if (index < parent.children.size && checkIntersect(parent.children[index].fold, toIns))
      {
        // may be this range is a parent for several children
        endIndex := index
        newElement := FoldTreeElement(toIns)
        while (endIndex < parent.children.size && checkIntersect(parent.children[endIndex].fold, toIns))
        {
          if (!includes(toIns, parent.children[endIndex].fold))
            throw ArgErr("Inserted element $toIns intersects with the existent element $parent.children[endIndex].fold")
          
          newElement.children.add(parent.children[endIndex])
          endIndex++
        }
        if (newElement.children.size > 1)
          parent.children.removeRange(index + 1 ..< index + newElement.children.size)
        parent.children[index] = newElement
      }
      else
      {
        parent.children.insert(index, FoldTreeElement(toIns))
      }
    }
  }
  
  private Void delete(TreeElement parent, BaseFold toDel)
  {
    index := findByLine(parent.children, toDel.masterRange.start) 
    if (index >= 0)
    {
      element := parent.children[index]
      if (element.fold.masterRange == toDel.masterRange)
      {
        parent.children.removeAt(index)
        if (element.children.size > 0)
        {
          indexToIns := findByLine(parent.children, element.children[0].fold.masterRange.start)
          indexToIns = -(indexToIns + 1)
          parent.children.insertAll(indexToIns, element.children)
        }
      }
      else if (includes(element.fold, toDel))
      {
        delete(element, toDel)
      }
    }
    
  }
  
  // parent must contain the given line
  private TreeElement getUserMarkedElementByLine(TreeElement parent, Int line)
  {
    index := findByLine(parent.children, line)
    TreeElement? el := index >= 0 ? parent.children.getSafe(index) : null
    TreeElement? canditate :=  el != null ? getUserMarkedElementByLine(el, line) : null
    return canditate != null && canditate.fold.markedByUser ? canditate : parent
  }

  private static Int findByLine(TreeElement[] elements, Int line) {
    elements.binaryFind |TreeElement el->Int|
    {
      if (line < el.fold.masterRange.start)
        return -1
      else if (line > el.fold.masterRange.end)
        return 1
      else
        return 0
    }
  }

  **
  ** Return whether the parent range contains the child range
  ** 
  private static Bool includes(Fold parent, Fold child)
  {
    Region.fromRange(parent.masterRange).includes(Region.fromRange(child.masterRange))
  }

  private static Bool checkIntersect(Fold fold1, Fold fold2)
  {
    Region? intersection := Region.fromRange(fold1.masterRange).intersect(Region.fromRange(fold2.masterRange))
    return (intersection != null && !intersection.isEmpty)
  }
}

@Js
internal class DecoratedTextLine : TextLine
{
  private BaseProjDoc doc
  private TextLine masterLine
  private |TextLine, Int->StrReplacement[]| decorator 
  
  override Str text
  override StyleList styles
  override Style? style
  override protected ListListener[] listeners := [,]
  
  internal Int masterIndex
  
  private ListListener masterLineListener := OriginDocListener
  {
    onAddCallback = |->| { if (visible) refresh }
    onRemoveCallback = |->| { if (visible) refresh }
  }
  
  Bool decorated := false
  Bool visible := true
  
  new make(BaseProjDoc doc, Int masterIndex, |TextLine, Int->StrReplacement[]| decorator)
  {
    this.doc = doc
    this.masterLine = doc.getMasterLine(masterIndex)
    this.masterIndex = masterIndex
    this.text = masterLine.text
    this.styles = masterLine.styles
    this.style = masterLine.style
    this.decorator = decorator
    
    refresh
    masterLine.listen(masterLineListener)
  }

  override Void listen(ListListener l)
  {
    TextLine.super.listen(l)
    if (listeners.size == 1)
      doc.addToCache(this)
  }
  
  override Void discard(ListListener l)
  {
    TextLine.super.discard(l)
    if (listeners.isEmpty)
      doc.removeFromCache(this)
  }
  
  internal Void refresh()
  {
    fire(RemoveNotice(0, size))
    this.text = masterLine.text
    this.styles = masterLine.styles
    this.style = masterLine.style
    fire(AddNotice(0, size))

    StrReplacement[] replacements := decorator.call(masterLine, masterIndex)
    if (replacements.isEmpty)
    {
      decorated = false
    }
    else
    {
      decorated = true
      replacements.each |replacement|
      {
        region := Region.fromRange(replacement.remove)
        replace(region.start, region.size, replacement.insert, replacement.style)  
      }
    }
  }
  
  internal Void free() { masterLine.discard(masterLineListener) }
}

@Js
internal class OriginDocListener : ListListener
{
  |Int index, Int size| onAddCallback := |index| {}
  |Int index, Int size| onRemoveCallback := |index| {}
  
  override Void onAdd(Int index, Int size) { onAddCallback(index, size) }

  override Void onRemove(Int index, Int size) { onRemoveCallback(index, size) }
}

@Js
internal class BaseFold : Fold
{
  private BaseProjDoc model
  internal Bool markedByUser := false
  internal Bool visible := true

  override Range masterRange { private set }
  
  override Bool collapsed
  {
    set
    {
      if (it)
        collapse()
      else
        expand()
    }
  }
  
  new make(BaseProjDoc model, Range masterRange, Bool markedByUser := false)
  {
    this.model = model
    this.masterRange = masterRange
    this.markedByUser = markedByUser
  }
  
  override Range range() { model.fromMasterLines(masterRange) }
  
  override Void toggle()
  {
    checkStateForUserFolding
    model.toggle(this)
  }
  
  override Void collapse()
  {
    if (!collapsed)
    {
      checkStateForUserFolding
      model.toggle(this)
    }
  }
  
  override Void expand()
  {
    if (collapsed)
    {
      checkStateForUserFolding
      model.toggle(this)
    }
  }
  
  override Void discard()
  {
    throw Err("Operation isn't supported yet.")
  }
  
  **
  ** Set collapsed property directly (without calling `expand` or `collapse` methods).
  ** Must not be used outside of `FoldModelImpl` class. 
  ** 
  internal Void setCollapsedDirectly(Bool collapsed)
  {
    &collapsed = collapsed
  }
  
  private Void checkStateForUserFolding()
  {
    if (!markedByUser)
      throw Err("Invalid state: unable to toggle fold, that wasn't marked by user.")
    if (!visible)
      throw Err("Invalid state: unable to toggle fold, fold is completely hidden.")
  }
  
  override Int hash() { range.hash }
  
  override Bool equals(Obj? obj)
  {
    that := obj as BaseFold
    if (that == null) return false
    return this.masterRange == that.masterRange
  }
  
  override Str toStr() { "Fold[$range]" }
  
  override Int compare(Obj fold) { range.start - (fold as BaseFold).masterRange.start }
}


@Js
internal mixin TreeElement
{
  abstract BaseFold? fold()
  
  abstract TreeElement[] children()
}

@Js
internal class RootTreeElement : TreeElement
{
  override BaseFold? fold := null
  
  override TreeElement[] children := [,] { private set }
}

@Js
internal class FoldTreeElement : TreeElement
{
  override BaseFold? fold
  
  override TreeElement[] children := [,] { private set }
  
  new make(BaseFold fold) { this.fold = fold }
}

