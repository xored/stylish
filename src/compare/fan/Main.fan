using gfx
using fwt
using kawhy
using kawhyCss
using kawhyMath
using kawhyText
using kawhyScene

@Js
class Main
{

  static Void main()
  {
    doc := TestDoc(1000)
    edit := TextEdit { source = doc }
    view := SourceView
    {
      text = edit
      leftRulers = [LineNums(), SeparatorRuler()]
      rightRulers = [,]
    }
    container := Container(CompareView())
    container.open
  }

}
