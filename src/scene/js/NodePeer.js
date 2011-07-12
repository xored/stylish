fan.kawhyScene.NodePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.NodePeer.prototype.$ctor = function(self) {}

fan.kawhyScene.NodePeer.prototype.m_parent = null;
fan.kawhyScene.NodePeer.prototype.m_scene  = null;
fan.kawhyScene.NodePeer.prototype.parent   = function(self) { return this.m_parent; }
fan.kawhyScene.NodePeer.prototype.scene    = function(self) { return this.m_scene;  }

fan.kawhyScene.NodePeer.prototype.attach   = function(self, parent)
{
  this.m_parent = parent;
  this.m_scene = parent.scene();
}

fan.kawhyScene.NodePeer.prototype.detach   = function(self, parent)
{
  if (this.m_hover) this.hover$(self, false);
  //TODO actually need to remove native listeners
  self.m_listeners.clear();
  this.m_parent = null;
  this.m_scene = null;
}

fan.kawhyScene.NodePeer.prototype.m_pos = fan.gfx.Point.m_defVal;
fan.kawhyScene.NodePeer.prototype.pos   = function(self) { return this.m_pos; }
fan.kawhyScene.NodePeer.prototype.pos$  = function(self, pos)
{
  if (this.m_pos.equals(pos)) return;
  this.m_pos = pos;
  with (this.m_elem.style)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
}

fan.kawhyScene.NodePeer.prototype.posOnParent = function(self)
{
  if (this.m_parent == null) return this.m_pos;
  var p = this.m_parent.peer.m_elem;
  var op = this.m_elem;
  var x = 0, y = 0;
  do
  {
    x += op.offsetLeft - op.scrollLeft;
    y += op.offsetTop - op.scrollTop;
  }
  while(op != p && (op = op.offsetParent) != null);
  return fan.gfx.Point.make(x, y);
}

fan.kawhyScene.NodePeer.prototype.posOnScene = function(self)
{
  if (this.m_parent == null) return this.m_pos;
  var pp = this.posOnParent(self);
  var ps = this.m_parent.posOnScene();
  return pp.translate(ps);
}

fan.kawhyScene.NodePeer.prototype.posOnScreen = function(self)
{
  if (this.m_scene == null) return this.posOnScene(self);
  return this.posOnScene(self).translate(this.m_scene.posOnScreen());
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
fan.kawhyScene.NodePeer.prototype.m_mouseOut = false;
fan.kawhyScene.NodePeer.prototype.hover   = function(self) { return this.m_hover; }
fan.kawhyScene.NodePeer.prototype.hover$  = function(self, hover)
{
  if (this.m_hover != hover)
  {
    this.m_hover = hover;
    self.notify(fan.kawhyScene.Node.$type.slot("hover"), hover);
  }
}
fan.kawhyScene.NodePeer.prototype.mouseIn = function(self)
{
  this.m_mouseOut = false;
  if (this.m_parent) this.m_parent.peer.mouseIn(this.m_parent);
  this.hover$(self, true);
}
fan.kawhyScene.NodePeer.prototype.mousePreOut = function()
{
  this.m_mouseOut = true;
  if (this.m_parent) this.m_parent.peer.mousePreOut();
}
fan.kawhyScene.NodePeer.prototype.mousePostOut = function(self)
{
  if (this.m_mouseOut) this.hover$(self, false);
  if (this.m_parent) this.m_parent.peer.mousePostOut(this.m_parent);
}

fan.kawhyScene.NodePeer.prototype.init = function(self)
{
  this.m_elem = this.create();
  this.initStyle();
  this.m_elem.addEventListener("mouseover", function(e)
  {
  	self.peer.mouseIn(self);
    e.stopPropagation();
  }, false);
  this.m_elem.addEventListener("mouseout",  function(e)
  {
    self.peer.mousePreOut();
    setTimeout(function() { self.peer.mousePostOut(self); }, 0);
    e.stopPropagation();
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
