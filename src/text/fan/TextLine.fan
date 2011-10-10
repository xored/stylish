using kawhyMath
using kawhyUtil
using kawhyNotice
using kawhyCss

@Js
abstract class TextLine : ListNotifier
{

  abstract Str text

  abstract StyleList styles

  abstract Style? style

  override Int size() { text.size }

  @Operator Int get(Int i) { text[i] }

  @Operator Str getRange(Range range) { text.getRange(range) }

  protected Void replace(Int index, Int remove, Str insert, Style? style)
  {
    text = StrUtil.replaceRegion(text, Region(index, remove), insert)
    styles = styles.replace(index, remove, insert.size, style)
    fire(TextLineNotice(index, remove, insert, style))
  }

}

@Js
const class TextLineNotice : StrNotice
{

  new make(Int index, Int remove, Str insert, Style? style) : super(index, remove, insert)
  {
    this.style = style
  }

  const Style? style

}
