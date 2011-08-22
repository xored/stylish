using kawhyMath

@Js
mixin ListNotifier
{

  abstract Int size()

  protected Void fire(ListNotice notice)
  {
    listeners.each { it.fire(notice) }
  }

  virtual Void listen(ListListener l)
  {
    listeners = listeners.dup.add(l)
  }

  virtual Void discard(ListListener l)
  {
    dup := listeners.dup
    dup.remove(l)
    listeners = dup
  }

  abstract protected ListListener[] listeners

}
