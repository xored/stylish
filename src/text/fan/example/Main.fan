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
    doc := TestDoc(1000)
    edit := TextEdit { source = doc }
    overview := OverviewRuler()
    overview.add(Marker
    {
      range = GridRange(GridPos.defVal, GridPos(3, 5))
      color = Color.makeRgb(252, 45, 150)
      tooltip = "Error"
    })
    overview.add(Marker
    {
      range = GridRange(GridPos(999, 0), GridPos(999, 4))
      color = Color.makeRgb(244, 190, 150)
      tooltip = "Warning"
    })
    overview.add(Marker
    {
      range = GridRange(GridPos(600, 5), GridPos(700, 5))
      color = Color.makeRgb(244, 190, 150)
      tooltip = "Warning"
    })
    overview.add(Marker
    {
      range = GridRange(GridPos(500, 5), GridPos(502, 0))
      color = Color.makeRgb(45, 150, 252)
      tooltip = "Info"
    })
    view := SourceView
    {
      text = edit
      leftRulers = [LineNums(), SeparatorRuler()]
      rightRulers = [overview]
    }
    container := Container(view)
    container.open
  }

}
