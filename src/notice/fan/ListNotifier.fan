using kawhyMath

@Js
mixin ListNotifier
{

  protected Void fire(ListNotice notice)
  {
    listeners().each { it.fire(notice) }
  }

  virtual Void listen(ListListener l) { listeners.add(l) }

  virtual Void discard(ListListener l) { listeners.remove(l) }

  abstract protected ListListener[] listeners()

}
