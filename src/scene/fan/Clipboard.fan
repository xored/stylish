
@Js
class Clipboard
{

  Void onPaste(|Str| f) { pasteListeners.add(f) }

  Void unPaste(|Str| f) { pasteListeners.remove(f) }

  native TextSource? textSource

  private |Str|[] pasteListeners := [,]

  internal Void paste(Str text)
  {
    pasteListeners.each { it(text) }
  }

}

@Js
mixin TextSource
{

  abstract |->|? onChange

  abstract Str text(Range range := 0..-1)

  abstract Int size()

  abstract Bool isEmpty()

}
