
@Js
mixin Notifier
{

  Listeners on(Obj key) { listeners.on(key) }

  Bool notify(Obj key, Obj? val) { listeners.notify(key, val) }

  abstract protected ListenerStorage listeners()

}

@Js
mixin Listeners
{

  abstract Void add(|Obj?->Bool| f)

  abstract Void remove(|Obj?->Bool| f)

}
