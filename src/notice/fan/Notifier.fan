
@Js
mixin Notifier
{

  Listeners on(Obj key) { listeners.on(key) }

  Void notify(Obj key, Obj? val) { listeners.notify(key, val) }

  abstract protected ListenerStorage listeners()

}

@Js
mixin Listeners
{

  abstract Void add(|Obj?->Void| f)

  abstract Void remove(|Obj?->Void| f)

}
