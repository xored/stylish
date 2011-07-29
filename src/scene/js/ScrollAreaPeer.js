fan.kawhyScene.ScrollAreaPeer = fan.sys.Obj.$extend(fan.kawhyScene.GroupPeer);
fan.kawhyScene.ScrollAreaPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.ScrollAreaPeer.prototype.create = function(self)
{
  var scrollDiv = document.createElement("div");
  var t = this;
  scrollDiv.onscroll = function(event)
  {
    var scroll = t.scroll();
    t.m_onScroll.call(scroll);
  }
  scrollDiv.addEventListener("mousedown", function(e)
  {
    if (t.isScrollArea(self, e.clientX, e.clientY))
    {
      e.stopPropagation();
      e.preventDefault();
    }
  }, false);
  return scrollDiv;
}

fan.kawhyScene.ScrollAreaPeer.prototype.isScrollArea = function(self, x, y)
{
  var pos = this.posOnScreen(self);
  var size = this.size(self);
  var area = this.clientArea(self);
  var xpos = x - pos.m_x;
  var ypos = y - pos.m_y;
  return (xpos >= area.m_w && xpos <= size.m_w) || (ypos >= area.m_h && ypos <= size.m_h);
}

fan.kawhyScene.ScrollAreaPeer.prototype.scroll = function(self)
{
  var x = this.m_elem.scrollLeft;
  var y = this.m_elem.scrollTop;
  return fan.gfx.Point.make(x, y);
}

fan.kawhyScene.ScrollAreaPeer.prototype.scroll$ = function(self, scroll)
{
  this.m_elem.scrollLeft = scroll.m_x;
  this.m_elem.scrollTop = scroll.m_y;
}

fan.kawhyScene.ScrollAreaPeer.prototype.clientArea = function(self)
{
  var w = this.m_elem.clientWidth;
  var h = this.m_elem.clientHeight;
  return fan.gfx.Size.make(w, h);
}

fan.kawhyScene.ScrollAreaPeer.prototype.onScroll$ = function(self, f)
{
  this.m_onScroll = f;
}
fan.kawhyScene.ScrollAreaPeer.prototype.m_onScroll = null;

fan.kawhyScene.ScrollAreaPeer.prototype.initStyle = function()
{
  fan.kawhyScene.NodePeer.prototype.initStyle.call(this);
  var size = this.size();
  with (this.m_elem.style)
  {
    width     = size.m_w + "px";
    height    = size.m_h + "px";
    overflow = "scroll";
  }
}
