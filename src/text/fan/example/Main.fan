using gfx
using fwt
using kawhyMath
using kawhy
using kawhyCss
using kawhyScene

@Js
class Main
{

  static Void main()
  {
    doc := TestDoc()
    edit := TextEdit
    {
      source = doc
      style = FontStyle.monospace/* + BoxStyle { margin = Insets(5) }*/
    }
    control := ControlPane { it.control = edit }
    Window()
    {
      content = control
    }.open
    control.scene.mouse.left.on(MouseButton#down).add |Bool down|
    {
      if (down) doc.clicks = doc.clicks + 1
    }
  }
}
