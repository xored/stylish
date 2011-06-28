using gfx

@Js
class ScrollArea : Group
{

  native Point scroll

  native |Point| onScroll

  native Size clientArea()

}
