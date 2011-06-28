using kawhyMath
using kawhyUtil
using kawhyNotice
using kawhyCss

@Js
mixin TextLine : ListNotifier
{

  override Int size() { text.size }

  Int get(Int i) { text[i] }

  Str getRange(Range range) { text.getRange(range) }

  abstract Str text

  abstract StyleList styles

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
