
@Js
class BaseScene : Scene
{

  override TextNode text() { BaseTextNode() }

  override Group group() { BaseGroup() }

  override Node? root

  override Mouse mouse := Mouse() { private set }

  //
  // TRASH
  //
  override ScrollArea scroll() { throw UnsupportedErr("no scroll") }

  override Checkbox checkbox() { throw UnsupportedErr("no scroll") }

  override Link link() { throw UnsupportedErr("no scroll") }

}
