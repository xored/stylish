using kawhyNotice

@Js
class BaseTextDoc : TextDoc
{

  Str text := ""

  override TextLine get(Int index) { lines[index] }

  override Int size := 0

  private TextLine[] lines := [,]

  override protected ListListener[] listeners := [,]

}
