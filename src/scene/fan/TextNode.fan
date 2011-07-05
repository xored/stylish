using kawhyCss
using kawhyMath

@Js
class TextNode : Node
{

  native Str text

  native Int? offsetAt(Int pos)

  native Region charRegion(Int index)

  native StyleRange[] styles

}
