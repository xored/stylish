using gfx
using kawhyCss
using kawhyNotice

@Js
class Node : Notifier
{

  native Group? parent()

  native Point pos

  native Size size

  native Style? style

  native Bool hover()

  native Point absPos()

  Str:Obj data := [:]

  Listeners onMouseMove() { listeners.on(#onMouseMove) }

  Listeners onHover() { listeners.on(#hover) }

  override protected ListenerStorage listeners := ListenerStorage()

}
