using kawhy
using kawhyScene

@Js
class TextEdit : Control
{

  new make(TextDoc source)
  {
    this.source = source
  }

  TextDoc source

}
