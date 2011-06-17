fan.kawhyScene.KYScrollArea = fan.sys.Obj.$extend(fan.kawhyScene.KYFixedNode);
fan.kawhyScene.KYScrollArea.prototype.$ctor = function() {}

fan.kawhyScene.KYScrollArea.prototype.create = function()
{
  var scrollDiv = document.createElement("div");
  var t = this;
  scrollDiv.onscroll = function(event)
  { 
    t.m_onScroll.call(t.scroll());
  }
  return scrollDiv;
}

fan.kawhyScene.KYScrollArea.prototype.scroll = function()
{
  var x = this.m_elem.scrollLeft;
  var y = this.m_elem.scrollTop;
  return fan.gfx.Point.make(x, y);
}

fan.kawhyScene.KYScrollArea.prototype.scroll$ = function(scroll)
{
  this.m_elem.scrollLeft = scroll.m_x;
  this.m_elem.scrollTop = scroll.m_y;
}

fan.kawhyScene.KYScrollArea.prototype.clientArea = function()
{
  var w = this.m_elem.clientWidth;
  var h = this.m_elem.clientHeight;
  return fan.gfx.Size.make(w, h);
}

fan.kawhyScene.KYScrollArea.prototype.onScroll$ = function(f)
{
  this.m_onScroll = f;
}
fan.kawhyScene.KYScrollArea.prototype.m_onScroll = null;

fan.kawhyScene.KYScrollArea.prototype.initStyle = function()
{
  fan.kawhyScene.ZNode.prototype.initStyle.call(this);
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
