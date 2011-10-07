using gfx
using kawhyCss
using kawhyText
using kawhyNotice

@Js
class CompareDoc
{

  TextDoc a { private set }

  TextDoc b { private set }

  Int total

  Int c2a(Int i) { aMap[i] }

  Int c2b(Int i) { bMap[i] }

  Int a2c(Int val) { aMap.findIndex |v| { v == val } ?: 0 }

  Int b2c(Int val) { bMap.findIndex |v| { v == val } ?: 0 }

  new make(CompareBlock[] blocks)
  {
    this.blocks = blocks
    aLines := BaseTextLine[,]
    bLines := BaseTextLine[,]

    aMap = [0]
    bMap = [0]
    ac := 0; bc := 0; total = 0
    blocks.each
    {
      lines := it.lines
      switch (it.type)
      {
        case CompareBlockType.a:
          aLines.addAll(lines.map |line|
          {
            ac++
            aMap.add(ac)
            bMap.add(bc)
            return BaseTextLine
            {
              text = line.text
              style = BgStyle(Color.purple)
            }
          })
        case CompareBlockType.b:
          bLines.addAll(lines.map |line|
          {
            bc++
            aMap.add(ac)
            bMap.add(bc)
            return BaseTextLine
            {
              text = line.text
              style = BgStyle(Color.orange)
            }
          })
        default:
          aLines.addAll(lines)
          bLines.addAll(lines)
          lines.each
          {
            ac++
            bc++
            aMap.add(ac)
            bMap.add(bc)
          }
      }
      total += lines.size
    }

    a = LineDoc(aLines)
    b = LineDoc(bLines)
  }

  private CompareBlock[] blocks
  private Int[] aMap
  private Int[] bMap

}

@Js
class LineDoc : TextDoc
{

  new make(BaseTextLine[] lines) { this.lines = lines }

  override Int size() { lines.size }

  override TextLine get(Int index) { lines[index] }

  override protected ListListener[] listeners := [,]

  private BaseTextLine[] lines

}

@Js
class CompareBlock
{
  TextLine[] lines
  CompareBlockType type

  new make(TextLine[] lines, CompareBlockType type)
  {
    this.lines = lines
    this.type = type
  }
}

@Js
enum class CompareBlockType { common, a, b}
