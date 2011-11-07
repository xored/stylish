using fwt
using stylishUtil
using stylishNotice

@Js
class Keyboard : Notifier
{

  Key key := KeyUtil.none { private set }

  Int? char := null { private set }

  internal Bool onKey(Key key)
  {
    this.key = key
    return notify(#key, key)
  }

  internal Bool onChar(Int? char)
  {
    this.char = char
    return notify(#char, char)
  }

  internal Bool onKeyChar(Key key, Int? char)
  {
    this.key = key
    this.char = char
    res := false
    res = notify(#char, char) || res
    res = notify(#key, key) || res
    return res
  }

  override protected ListenerStorage listeners := ListenerStorage()

}
