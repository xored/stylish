using fwt
using kawhy
using kawhyCss
using kawhyScene

@Js
class Main
{
  static Void main()
  {
    doc := TestDoc()
    edit := TextEdit(doc)
    edit.style = FontStyle.monospace
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
