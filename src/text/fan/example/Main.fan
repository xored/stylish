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
    view := SourceView
    {
      text = edit
      leftRulers = [LineNums(), SeparatorRuler()]
    }
    container := Container(view)
    container.open
  }

}
