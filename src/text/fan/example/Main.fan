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
    Container(edit).open
  }
}
