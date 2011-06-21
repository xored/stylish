
@Js
mixin Scene
{

  abstract TextNode text()

  abstract Group group()

  abstract Node? root

  abstract Mouse mouse()

  //
  // TRASH
  //
  abstract ScrollArea scroll()

  abstract Checkbox checkbox()

  abstract Link link()

  abstract FixedNode fixed()

}
