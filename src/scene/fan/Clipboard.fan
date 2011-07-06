
@Js
class Clipboard
{

  Void onPaste(|Str| f) { pasteListeners.add(f) }

  Void rmPaste(|Str| f) { pasteListeners.remove(f) }

  StrSource? copySource

  private |Str|[] pasteListeners := [,]

  internal Void paste(Str text)
  {
    pasteListeners.each { it(text) }
  }

}

@Js
mixin StrSource
{

  abstract Str text(Range range := 0..-1)

  abstract Int size()

}
