
@Js
mixin Notifier
{

  Listeners on(Slot s) { listeners.on(s) }

  Void notify(Slot s, Obj? val) { listeners.notify(s, val) }

  abstract protected ListenerStorage listeners()

}

@Js
mixin Listeners
{

  abstract Void add(|Obj?->Void| f)

  abstract Void remove(|Obj?->Void| f)

}
