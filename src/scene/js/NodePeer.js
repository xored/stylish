fan.kawhyScene.NodePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.NodePeer.prototype.$ctor = function() {}

fan.kawhyScene.NodePeer.prototype.m_pos = null
fan.kawhyScene.NodePeer.prototype.pos   = function(self) { return this.m_pos }
fan.kawhyScene.NodePeer.prototype.pos$  = function(self, pos)
{
  this.m_pos = pos;
  with (this.m_elem.style)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
}

fan.kawhyScene.NodePeer.prototype.size   = function(self)
{
  var w = this.m_elem.offsetWidth;
  var h = this.m_elem.offsetHeight;
  return fan.gfx.Size.make(w, h);
}

fan.kawhyScene.NodePeer.prototype.size$  = function(self, size)
{
  this.m_elem.style.width  = size.m_w + "px";
  this.m_elem.style.height = size.m_h + "px";
}

fan.kawhyScene.NodePeer.prototype.m_style = null
fan.kawhyScene.NodePeer.prototype.style   = function(self) { return this.m_style }
fan.kawhyScene.NodePeer.prototype.style$  = function(self, style)
{
  this.m_style = style;
  var str = fan.kawhyCss.StyleItem.toStyleString(style.toCss());
  this.m_elem.style.cssText = str;
  this.initStyle();
}

fan.kawhyScene.NodePeer.prototype.init = function()
{
  this.m_elem = this.create();
  this.m_pos = fan.gfx.Point.m_defVal;
  this.initStyle();
}

fan.kawhyScene.NodePeer.prototype.initStyle = function()
{
  with (this.m_elem.style)
  {
    position = "absolute";
    left = this.m_pos.m_x + "px";
    top  = this.m_pos.m_y + "px";
  }
}

fan.kawhyScene.NodePeer.prototype.create = function()
{
  return document.createElement("span");
}

fan.kawhyScene.NodePeer.prototype.m_elem = null;
