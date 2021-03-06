using gfx
using stylishCss
using stylishNotice

@Js
class Node
{

  native Group? parent()

  native Scene? scene()

  native Point pos

  native Size size

  native Style? style

  **
  ** TODO node.pos != node.posOnParent because we can have margin/padding for node.
  ** However I think we need to avoid it
  ** 
  native Point posOnParent()

  native Point posOnScene()

  native Point posOnScreen()

  native Str? tooltip

  native Str? id

  native Bool hover()

  Notice onHover := Notice()

  native Bool thru

  Str:Obj data := [:]
  
  ** Notifies the node that its size is changed (node caches its size)
  protected native Void sizeChanged()

}
