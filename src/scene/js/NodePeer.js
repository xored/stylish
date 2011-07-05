fan.kawhyScene.NodePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.NodePeer.prototype.$ctor = function(self) {}

fan.kawhyScene.NodePeer.prototype.m_parent = null
fan.kawhyScene.NodePeer.prototype.parent   = function(self) { return this.m_parent; }

fan.kawhyScene.NodePeer.prototype.scene    = function(self)
{
  if (this.m_parent == null) return null;
  return this.m_parent.scene();
}

fan.kawhyScene.NodePeer.prototype.attach   = function(self, parent)
{
  this.m_parent = parent;
  this.resetAbsPos();
}

fan.kawhyScene.NodePeer.prototype.detach   = function(self, parent)
{
  if (this.m_hover) this.hover$(self, false);
  //TODO actually need to remove native listeners
  self.m_listeners.clear();
  this.m_parent = null;
  this.m_absPos = null;
}

fan.kawhyScene.NodePeer.prototype.m_pos = fan.gfx.Point.m_defVal;
fan.kawhyScene.NodePeer.prototype.pos   = function(self) { return this.m_pos }
fan.kawhyScene.NodePeer.prototype.pos$  = function(self, pos)
{
  if (this.m_pos.equals(pos)) return;
  this.m_pos = pos;
  with (this.m_elem.style)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
  this.resetAbsPos();
}

fan.kawhyScene.NodePeer.prototype.m_posOnScene = null;
fan.kawhyScene.NodePeer.prototype.posOnScene   = function(self)
{
  if (this.m_posOnScene == null)
  {
    if (this.m_parent == null) return this.m_pos;
    var p = this.m_parent.m_elem;
    var op = this.m_elem;
    var x = 0, y = 0;
    do
    {
      x += op.offsetLeft - op.scrollLeft;
      y += op.offsetTop - op.scrollTop;
    }
    while(op != p && (op = op.offsetParent) != null)
    var pos = this.m_parent.posOnScene();
    this.m_posOnScene = fan.gfx.Point.make(pos.m_x + x, pos.m_y + y);
  }
  return this.m_posOnScene;
}
fan.kawhyScene.NodePeer.prototype.resetAbsPos = function()
{
  if (this.m_posOnScene != null)
  {
    this.m_posOnScene = null;
    return true;
  }
  return false;
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

fan.kawhyScene.NodePeer.prototype.m_style = null;
fan.kawhyScene.NodePeer.prototype.style   = function(self) { return this.m_style }
fan.kawhyScene.NodePeer.prototype.style$  = function(self, style)
{
  this.m_style = style;
  var str = fan.kawhyCss.StyleItem.toStyleString(style.toCss());
  this.m_elem.style.cssText = str;
  this.initStyle();
}

fan.kawhyScene.NodePeer.prototype.m_hover = false;
fan.kawhyScene.NodePeer.prototype.hover   = function(self) { return this.m_hover; }
fan.kawhyScene.NodePeer.prototype.hover$  = function(self, hover)
{
  this.m_hover = hover;
  self.notify(fan.kawhyScene.Node.$type.slot("hover"), hover);
}

fan.kawhyScene.NodePeer.prototype.init = function(self)
{
  this.m_elem = this.create();
  this.initStyle();
  this.m_elem.addEventListener("mouseover", function()
  {
  	self.peer.hover$(self, true);
  }, false);
  this.m_elem.addEventListener("mouseout",  function()
  {
    self.peer.hover$(self, false);
  }, false);
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
