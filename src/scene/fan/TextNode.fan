using stylishCss
using stylishMath

@Js
class TextNode : Node
{

  native Str text

  native Int? offsetAt(Int pos)

  native Region charRegion(Int index)

  native StyleRange[] styles

}
