using gfx
using fwt
using stylishMath
using stylish
using stylishCss
using stylishScene

@Js
class Main
{

  static Void main()
  {
    doc := TestDoc(50)
    edit := TextEdit { source = doc }    
    
    view := SourceView
    {
      text = edit
      //leftRulers = [ProjLineNums(), FoldRuler(), SeparatorRuler()]
      //rightRulers = [overview]
    }
    container := Container(view)
    
    Desktop.callLater(5sec) |->| {
      10.times {
        doc.removeLines(0, 1)
      }
    }
    
    container.open
    
//    doc := TestDoc(20000)
//    projDoc := BaseProjDoc(doc)
//    projDoc.makeFold(5..10)
//    projDoc.makeFold(15..20)
//    projDoc.makeFold(30..50)
//    edit := TextEdit { source = projDoc }
//    overview := OverviewRuler()
//
//    markers := Marker[,]
//    
//    size := 5000
//    
//    for(i := 0; i < size; i++)
//    {
//      val := i % 3
//      MarkerType type := val == 0 ? MarkerType.info : (val == 1 ? MarkerType.warning : MarkerType.error)
//      markers.add(marker(GridRange(GridPos(i, 0), GridPos(i + 1, 0)), type))
//    }
//
//    overview.replace(markers)
//    overview.add(marker(GridRange(GridPos(size + 999, 0), GridPos(999, 4)), MarkerType.error))
//    overview.add(marker(GridRange(GridPos(size + 1600, 5), GridPos(size + 1700, 5)), MarkerType.warning))
//    overview.add(marker(GridRange(GridPos(size + 2500, 5), GridPos(size + 2502, 0)), MarkerType.info))
//
//    view := SourceView
//    {
//      text = edit
//      leftRulers = [ProjLineNums(), FoldRuler(), SeparatorRuler()]
//      rightRulers = [overview]
//    }
//    container := Container(view)
//    container.open
  }

  private static Marker marker(GridRange range, MarkerType type)
  {
    Marker
    {
      it.range = range
      color = type.color
      tooltip = type.tooltip
    }    
  }

}

@Js
enum class MarkerType
{
  info("Info", Color.makeRgb(45, 150, 252)), 
  warning("Warning", Color.makeRgb(244, 190, 150)), 
  error("Error", Color.makeRgb(252, 45, 150)) 

  private new make(Str tooltip, Color color)
  {
    this.tooltip = tooltip
    this.color = color
  }

  const Str tooltip
  const Color color
}
