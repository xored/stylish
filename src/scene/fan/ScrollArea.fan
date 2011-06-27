using gfx

@Js
mixin ScrollArea : Group
{

  abstract Point scroll

  abstract |Point| onScroll

  abstract Size clientArea()

}
