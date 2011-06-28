using kawhyNotice
using kawhyMath
using kawhyUtil

@Js
class TextNotifier : ListNotifier
{

  Str text := "" { private set }

  Void add(Str text)
  {
    if (text.size == 0) return
    this.text += text
    fire(StrNotice(this.text.size - text.size, 0, text))
  }

  Void remove(Int size)
  {
    text = text.getRange(0..-size-1)
    fire(StrNotice(text.size, size, ""))
  }

  override Int size() { text.size }

  override protected ListListener[] listeners := [,]

}

@Js
class TextListener : ListListener
{

  Int size := 0

  override Void onAdd(Int index, Int size) { this.size += size }

  override Void onRemove(Int index, Int size) { this.size -= size }

}