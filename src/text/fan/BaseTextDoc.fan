using stylishCss
using stylishNotice

@Js
class BaseTextDoc : TextDoc
{

  override Int size := 1

  override TextLine get(Int index) { BaseTextLine() }

}

@Js
class BaseTextLine : TextLine
{

  override Str text := ""

  override StyleList styles := StyleList([,])

  override Style? style

}