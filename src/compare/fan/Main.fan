using gfx
using fwt
using stylish
using stylishCss
using stylishMath
using stylishText
using stylishScene

@Js
class Main
{

  static Void main()
  {
    blocks := CompareBlock[,]
    for(i := 0; i < 10; i++)
    {
      
      blocks.add(asBlock([,] { fill("ccccccccccccccc", 10)}, CompareBlockType.common))
      blocks.add(asBlock([,] { fill("aaaaaaaaaaaaaaa", 10)}, CompareBlockType.a))
      blocks.add(asBlock([,] { fill("bbbbbbbbbbbbbbb", 10)}, CompareBlockType.b))
    }

    view := CompareView
    {
      doc = CompareDoc(blocks)
    }
    container := Container(view)
    container.open
  }

  static CompareBlock asBlock(Str[] lines, CompareBlockType type)
  {
    CompareBlock(lines.map |text| { BaseTextLine { it.text = text } }, type)
  }

}
