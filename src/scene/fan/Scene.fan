using gfx

@Js
class Scene
{

  native Node root

  native Mouse mouse()

  native Keyboard keyboard()

  native Clipboard clipboard()

  native Point posOnScreen()
  
  native Focus focus()

  internal native Void setFocus()

}
