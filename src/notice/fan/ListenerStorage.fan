
@Js
class ListenerStorage
{

  Listeners on(Obj key)
  {
    storage.getOrAdd(key) { PlainListeners() }
  }

  Bool notify(Obj key, Obj? val)
  {
    storage[key]?.notify(val) ?: false
  }

  Void clear() { storage = [:] }

  private Obj:PlainListeners storage := [:]

}

@Js
internal class PlainListeners : Listeners
{

  override Void add(|Obj?->Bool| f) { list.add(f) }

  override Void remove(|Obj?->Bool| f) { list.remove(f) }

  Bool notify(Obj o)
  {
    res := false
    list.each { res = it(o) || res }
    return res
  }

  private |Obj?->Bool|[] list := [,]

}
