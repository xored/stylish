using fwt
using stylish
using stylishScene

@Js
class SelectAll : Policy
{

  override TextEdit control

  new make(|This| f) { f(this) }

  override Void attach()
  {
    control.keyboard.on(Keyboard#key).add(onKey)
  }

  override Void detach()
  {
    control.keyboard.on(Keyboard#key).remove(onKey)
  }

  private |Obj?->Bool| onKey := |val->Bool|
  {
    key := val as Key
    if (Key.ctrl + Key.a == key)
    {
      control.selection.all()
      return true
    }
    return false
  }

}
