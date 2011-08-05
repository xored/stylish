using gfx

@Js
class ScrollArea : Group
{

  const Bool horizontal := true

  const Bool vertical := true

  new make(|This|? f := null) { f?.call(this) }

  native Point scroll

  native |Point| onScroll

  native Size clientArea()

}
