using fwt

@Js
class KeyUtil
{

  static Bool isMod1(Key key) { key.isDown(mod1) }

  static const Key mod1 := Desktop.isMac ? Key.command : Key.ctrl

  static const Key none := Key.alt.primary

  static Bool isMod4(Key k) { Desktop.isMac && k.isCtrl }

  static Bool isWordChar(Int c) { c.isAlphaNum || c == '_' }

  static const Bool isGTK := "gtk".equals(Desktop.platform)

  static Key remove(Key from, Key key)
  {
    if (from == none) return none
    keys := from.list
    i := keys.index(key)
    if (i == null) return from
    keys.removeAt(i)
    if (keys.size == 0) return none
    res := keys[0]
    for(j := 1; j < keys.size; j++) res += keys[j]
    return res
  }

}
