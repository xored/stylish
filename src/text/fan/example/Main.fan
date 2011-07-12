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
    edit := TextEdit { source = doc }
    container := Container(edit)
    container.scene.mouse.left.on(MouseButton#down).add |val->Bool|
    {
      if (val == true)
      {
        doc.clicks = doc.clicks + 1
        return true
      }
      return false
    }
    container.open
  }
}
