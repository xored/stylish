using kawhyCss
using kawhyNotice

@Js
class BaseTextDoc : TextDoc
{

  override Int size := 1

  override TextLine get(Int index) { BaseTextLine() }

  override protected ListListener[] listeners := [,]

}

@Js
class BaseTextLine : TextLine
{

  override Str text := ""

  override StyleList styles := StyleList([,])

  override protected ListListener[] listeners() { [,] }

}