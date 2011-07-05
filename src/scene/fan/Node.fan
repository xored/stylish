using gfx
using kawhyCss
using kawhyNotice

@Js
class Node : Notifier
{

  native Group? parent()

  native Scene? scene()

  native Point pos

  native Size size

  native Style? style

  native Bool hover()

  native Point posOnScene()

  Point posOnScreen()
  {
    posOnScene.translate(scene?.posOnScreen ?: Point.defVal)
  }

  Str:Obj data := [:]

  Listeners onMouseMove() { listeners.on(#onMouseMove) }

  Listeners onHover() { listeners.on(#hover) }

  override protected ListenerStorage listeners := ListenerStorage()

}
