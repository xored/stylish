using gfx
using stylish
using stylishText
using stylishNotice
using stylishScene
using stylishCss

@Js
class ScrollRuler : Ruler, ListListener
{

  override Void attach()
  {
    super.attach()
    notice = text.onScroll.handle |Point p|
    {
      if (node.val != text.scroll.y)
        node.val = text.scroll.y
    }
    node.onScroll = |val|
    {
      if (text.scroll.y != val)
      {
        text.scroll = Point(text.scroll.x, val)
      }
    }
    text.source.listen(this)
    width = node.size.w
  }

  override Void detach()
  {
    text.source.discard(this)
    notice?.discard
  }

  override Void fire(ListNotice notice) { sync() }

  protected Void sync()
  {
    node.max = text.itemSize * text.source.size
    node.thumb = text.clientArea.h
  }

  override protected Void onResize(Size s) { sync() }

  private Notice? notice

  override ScrollBar node := ScrollBar(Orientation.vertical)

}
