using kawhyCss

@Js
class TextNode : Node
{

  native Str text

  native Int? offsetAt(Int pos)

  native Range charRange(Int index)

  native StyleRange[] styles

}
