using gfx

@Js
class Scene
{

  native Node root

  native Mouse mouse()

  native Keyboard keyboard()

  native Point posOnScreen()

  native Void focus()

  |Size| onResize := |Size s| {}

}
