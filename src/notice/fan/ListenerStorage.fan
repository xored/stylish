
@Js
class ListenerStorage
{

  Listeners on(Obj key)
  {
    storage.getOrAdd(key) { PlainListeners() }
  }

  Void notify(Obj key, Obj? val)
  {
    storage[key]?.notify(val)
  }

  Void clear() { storage = [:] }

  private Obj:PlainListeners storage := [:]

}

@Js
internal class PlainListeners : Listeners
{

  override Void add(|Obj?->Void| f) { list.add(f) }

  override Void remove(|Obj?->Void| f) { list.remove(f) }

  Void notify(Obj o)
  {
    list.each { it(o) }
  }

  private |Obj?->Void|[] list := [,]

}
