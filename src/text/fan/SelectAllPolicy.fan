using fwt
using kawhy
using kawhyScene

@Js
class SelectAllPolicy : Policy
{

  new make(TextEdit control)
  {
    this.control = control
    onKey = |val->Bool|
    {
      key := val as Key
      if (Key.ctrl + Key.a == key)
      {
        control.selection.all()
        return true
      }
      return false
    }
    control.keyboard.on(Keyboard#key).add(onKey)
  }

  override Void dispose()
  {
    control.keyboard.on(Keyboard#key).remove(onKey)
  }

  private |Obj?->Bool| onKey

  override TextEdit control

}
