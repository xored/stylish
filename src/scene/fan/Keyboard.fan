using fwt
using kawhyUtil
using kawhyNotice

@Js
class Keyboard : Notifier
{

  Key key := KeyUtil.none { private set }

  Int? char := null { private set }

  internal Bool onKey(Key key)
  {
    this.key = key
    notify(#key, key)
    echo("key: $key")
    return true
  }

  internal Bool onChar(Int? char)
  {
    this.char = char
    notify(#char, char)
    echo("char: $char")
    return true
  }

  internal Bool onKeyChar(Key key, Int? char)
  {
    this.key = key
    this.char = char
    notify(#char, char)
    notify(#key, key)
    echo("char: $char key: $key")
    return true
  }

  override protected ListenerStorage listeners := ListenerStorage()

}
