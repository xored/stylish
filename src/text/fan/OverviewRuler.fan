using gfx
using fwt
using kawhy
using kawhyCss
using kawhyMath
using kawhyScene
using kawhyNotice

@Js
class OverviewRuler : Ruler, ListListener
{

  Void add(Marker marker)
  {
    view := MarkerView(marker)
    index := views.binarySearch(view)
    if (index < 0) index = -index - 1
    views.insert(index, view)
    this.node.add(view.node)
    if (text != null)
    {
      view.updatePos(size.h, text)
    }
  }

  Void remove(Marker marker)
  {
    index := views.findIndex |view| { view.marker == marker }
    if (index != null)
    {
      view := views.removeAt(index)
      view.detach
    }
  }

  override Void fire(ListNotice notice) { update() }

  override protected Void onResize(Size s) { update() }

  private Void update()
  {
    views.each { it.updatePos(size.h, this.text) }
  }

  override Void attach()
  {
    super.attach()
    text.source.listen(this)
    width = 13
  }

  override Void detach()
  {
    text.source.discard(this)
    super.detach()
  }

  override Group node := Group()

  private MarkerView[] views := [,]

}

@Js
const class Marker
{

  const Str? tooltip

  const Color color := Color.blue

  const GridRange range := GridRange.defVal

  new make(|This| f) { f.call(this) }

  override Bool equals(Obj? o)
  {
    that := o as Marker
    if (that == null) return false
    return that.tooltip == tooltip && that.color == color && that.range == range
  }

  override Int compare(Obj that)
  {
    range.start <=> (that as Marker).range.start
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + ((tooltip == null) ? 0 : tooltip.hash)
    result = prime * result + color.hash
    result = prime * result + range.hash
    return result;
  }

  override Str toStr()
  {
    list := Str[,]
    list.add("range=$range")
    list.add("color=$color")
    if (tooltip != null) list.add("tooltip=$tooltip")
    return list.join(" ")
  }

}

@Js
internal class MarkerView
{

  Marker marker
  Node node
  MouseListener listener
  TextEdit? text

  new make(Marker marker)
  {
    this.marker = marker
    node = Group
    {
      it.style = BgStyle(marker.color) + CursorStyle(Cursor.pointer)
      it.tooltip = marker.tooltip
      it.size = Size(9, 5)
      it.add(Group
      {
        it.pos = Point(1, 1)
        it.style = BgStyle(lighter(marker.color))
        it.size = Size(7, 3)
      })
    }
    listener = MouseListener
    {
      it.node = this.node
      onClick = |Bool down|
      {
        if (down)
        {
          text.selection.range = marker.range
          text.selection.reveal
        }
      }
    }
  }

  Void detach()
  {
    listener.detach
    node.parent.remove(node)
    text = null
  }

  Void updatePos(Int h, TextEdit text)
  {
    this.text = text
    pos := (marker.range.start.row * (h - 5)) / text.source.size
    node.pos = Point(2, pos)
  }

  override Int compare(Obj that)
  {
    marker <=> (that as MarkerView).marker
  }

  private static Color lighter(Color c)
  {
    Color.makeRgb(255 - (255 - c.r) / 3, 255 - (255 - c.g) / 3, 255 - (255 - c.b) / 3)
  }

}
