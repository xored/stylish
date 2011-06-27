using kawhyMath
using kawhyNotice
using kawhyCss

@Js
mixin TextDoc : ListNotifier
{

  **
  ** Number of lines. Always positive
  **
  abstract Int lineCount()

  **
  ** throws IndexErr when invalid index
  **
  abstract TextLine line(Int index)

  **
  ** 
  **
  virtual TextLine[] lines(Range range)
  {
    region := Region.fromRange(range, lineCount)
    if (region == null) return [,]
    return region.toRange.map |l| { line(l) }
  }

}
