using gfx
using fwt
using stylish
using stylishCss
using stylishMath
using stylishScene
using stylishNotice

@Js
class OverviewRuler : Ruler, ListListener
{

  Void add(Marker marker)
  {
    if (text == null) markers.add(marker)
    else attachMarker(marker)
  }

  Void remove(Marker marker)
  {
    if (text == null) markers.remove(marker)
    else detachMarker(marker)
  }

  Void replace(Marker[] markers)
  {
    clear()
    this.markers = markers
    if (text != null) update()
  }

  Void clear()
  {
    markers = [,]
    views.each { it.detach }
    views = [:]
    cache.each { it.detach }
    cache = [,]
  }

  private Int attachMarker(Marker marker)
  {
    pos := markerPos(marker)
    view := views[pos]
    if (view == null)
    {
      view = getNewMarker()
      views[pos] = view
      view.node.pos = Point(2, pos)    
    }
    view.attachMarker(marker)
    return pos
  }

  private Void detachMarker(Marker marker)
  {
    pos := markerPos(marker)
    view := views[pos]
    if (view != null && view.detachMarker(marker))
    {
      cache.add(view)
    }
  }

  private MarkerView getNewMarker()
  {
    if (cache.size > 0)
      return cache.removeAt(cache.size - 1)
    view := MarkerView(text)
    node.add(view.node)
    return view
  }

  private Int markerPos(Marker marker)
  {
    (marker.range.start.row * (size.h - 5)) / text.source.size
  }

  override Void fire(ListNotice notice) { update() }

  override protected Void onResize(Size s) { update() }

  private Void update()
  {
    keys := Int[,]
    views.each |val, key|
    {
      markers.addAll(val.clear)
      keys.add(key)
    }
    markers.each { keys.remove(attachMarker(it)) }
    keys.each { views.remove(it).detach }
    markers = [,]
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
    clear()
  }

  override Group node := Group()

  private Marker[] markers := [,]
  private MarkerView[] cache := [,]
  private Int:MarkerView views := [:]

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

  Marker? marker
  Group node
  MouseListener listener
  TextEdit text

  Marker[] stock := [,]

  new make(TextEdit text)
  {
    this.text = text
    node = Group
    {
      it.size = Size(9, 5)
      it.add(Group
      {
        it.pos = Point(1, 1)
        it.size = Size(7, 3)
      })
    }
    listener = MouseListener
    {
      it.node = this.node
      onClick = |Bool down|
      {
        if (down && marker != null)
        {
          text.selection.range = marker.range
          text.selection.reveal
        }
      }
    }
  }

  Marker[] clear()
  {
    markers := [,]
    markers.addAll(stock)
    stock = [,]
    if (marker != null)
    {
      markers.add(marker)
      marker = null
    }
    return markers
  }

  Void attachMarker(Marker marker)
  {
    if (this.marker != null)
    {
      stock.add(this.marker)
    }
    this.marker = marker
    node.style = BgStyle(marker.color) + CursorStyle(Cursor.pointer)
    node.tooltip = marker.tooltip
    node.kids[0].style = BgStyle(lighter(marker.color))
  }

  ** return true if empty
  Bool detachMarker(Marker marker)
  {
    if (this.marker == marker)
    {
      this.marker = null
      if (stock.size > 0)
      {
        attachMarker(stock.removeAt(stock.size - 1))
        return false
      }
      else
      {
        node.pos = Point(2, -100)
        return true
      }
    }
    stock.remove(marker)
    return false
  }

  Void detach()
  {
    listener.detach
    node.parent.remove(node)
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
