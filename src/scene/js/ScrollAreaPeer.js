fan.stylishScene.ScrollAreaPeer = fan.sys.Obj.$extend(fan.stylishScene.GroupPeer);
fan.stylishScene.ScrollAreaPeer.prototype.$ctor = function(self) { this.init(self); }

fan.stylishScene.ScrollAreaPeer.prototype.create = function(self)
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

fan.stylishScene.ScrollAreaPeer.prototype.isScrollArea = function(self, x, y)
{
  var pos = this.posOnScreen(self);
  var size = this.size(self);
  var area = this.clientArea(self);
  var xpos = x - pos.m_x;
  var ypos = y - pos.m_y;
  return (xpos >= area.m_w && xpos <= size.m_w) || (ypos >= area.m_h && ypos <= size.m_h);
}

fan.stylishScene.ScrollAreaPeer.prototype.scroll = function(self)
{
  var x = this.m_elem.scrollLeft;
  var y = this.m_elem.scrollTop;
  return fan.gfx.Point.make(x, y);
}

fan.stylishScene.ScrollAreaPeer.prototype.scroll$ = function(self, scroll)
{
  this.m_elem.scrollLeft = scroll.m_x;
  this.m_elem.scrollTop = scroll.m_y;
}

fan.stylishScene.ScrollAreaPeer.prototype.clientArea = function(self)
{
  var w = this.m_elem.clientWidth;
  var h = this.m_elem.clientHeight;
  return fan.gfx.Size.make(w, h);
}

fan.stylishScene.ScrollAreaPeer.prototype.onScroll$ = function(self, f)
{
  this.m_onScroll = f;
}
fan.stylishScene.ScrollAreaPeer.prototype.m_onScroll = null;

fan.stylishScene.ScrollAreaPeer.prototype.initStyle = function(self)
{
  fan.stylishScene.NodePeer.prototype.initStyle.call(this, self);
  var size = this.size();
  with (this.m_elem.style)
  {
    width     = size.m_w + "px";
    height    = size.m_h + "px";
    overflowX = self.m_horizontal ? "scroll" : "hidden";
    overflowY = self.m_vertical ? "scroll" : "hidden";
  }
}
