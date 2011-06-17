using gfx

@Js
mixin ScrollArea : FixedNode
{

  abstract Point scroll

  abstract |Point| onScroll

  abstract Size clientArea()

}
