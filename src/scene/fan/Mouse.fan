using gfx
using kawhyNotice

@Js
class Mouse : Notifier
{

  Point pos := Point.defVal { internal set { &pos = it; notify(#pos, it) } }

  MouseButton left   := MouseButton() { private set }

  MouseButton right  := MouseButton() { private set }

  MouseButton middle := MouseButton() { private set }

  override protected ListenerStorage listeners := ListenerStorage()

}

@Js
class MouseButton : Notifier
{

  Bool down { private set }

  Int clicks { private set }

  internal Bool onClick(Bool down, Int clicks)
  {
    this.clicks = clicks
    this.down = down
    return notify(#down, down)
  }

  override protected ListenerStorage listeners := ListenerStorage()

}
