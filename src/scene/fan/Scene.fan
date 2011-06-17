
@Js
mixin Scene
{

  abstract TextNode text()

  abstract Group group()

  abstract ScrollArea scroll()

  abstract FixedNode fixed()

  abstract Checkbox checkbox()

  abstract Link link()

  abstract Node copy(Node node)

  abstract Node? root

}
