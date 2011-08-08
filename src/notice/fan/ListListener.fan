using kawhyMath

@Js
mixin ListListener : Listener
{

  virtual Void fire(ListNotice n)
  {
    if (n.remove > 0) onRemove(n.index, n.remove)
    if (n.add > 0) onAdd(n.index, n.add)
  }

  virtual Void onAdd(Int index, Int size) {}

  virtual Void onRemove(Int index, Int size) {}

}

@Js
mixin Listener
{

  virtual Void onBatch(|->| f) { f() }

}
