using stylishMath

@Js
abstract class ListNotifier
{

  abstract Int size()

  Void batch(|This| f)
  {
    batchStart()
    try {
      f(this)
    } finally {
      batchFinish()
    }
  }

  protected Void fire(ListNotice notice)
  {
    batchStart()
    try {
      listeners.each { it.fire(notice) }
    } finally {
      batchFinish()
    }
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

  private Void batchStart()
  {
    if (batchCount == 0) listeners.each { it.onBatchStart }
    batchCount++
  }

  private Void batchFinish()
  {
    batchCount--
    if (batchCount == 0) listeners.each { it.onBatchFinish }
  }

  private Int batchCount := 0

  protected ListListener[] listeners := [,]

}
