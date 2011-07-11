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
    edit := TextEdit { source = TestDoc() }
    Container(edit).open
  }
}
