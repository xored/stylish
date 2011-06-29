using kawhyMath
using kawhyNotice
using kawhyCss

@Js
mixin TextDoc : ListNotifier
{

  **
  ** throws IndexErr when invalid index
  **
  @Operator abstract TextLine get(Int index)

  **
  ** 
  **
  @Operator virtual TextLine[] getRange(Range range)
  {
    region := Region.fromRange(range, size)
    if (region == null) return [,]
    return region.toRange.map |l| { get(l) }
  }

}
