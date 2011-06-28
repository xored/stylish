fan.kawhyScene.ScrollAreaPeer = fan.sys.Obj.$extend(fan.kawhyScene.GroupPeer);
fan.kawhyScene.ScrollAreaPeer.prototype.$ctor = function() { this.init(); }

fan.kawhyScene.ScrollAreaPeer.prototype.create = function()
{
  var scrollDiv = document.createElement("div");
  var t = this;
  scrollDiv.onscroll = function(event)
  { 
    t.m_onScroll.call(t.scroll());
  }
  return scrollDiv;
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
    whiteSpace = "pre"
    padding   = "0px";
    overflowX = "scroll";
    overflowY = "scroll";
  }
}
