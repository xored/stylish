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
  self.m_onHover.discard();
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

fan.kawhyScene.NodePeer.prototype.id   = function(self) { return this.m_elem.id; }
fan.kawhyScene.NodePeer.prototype.id$  = function(self, id)
{
  this.m_elem.id = id;
}

fan.kawhyScene.NodePeer.prototype.tooltip = function(self) { return m_tooltip; }
fan.kawhyScene.NodePeer.prototype.tooltip$ = function(self, tooltip)
{
  this.m_tooltip = tooltip;
  if (tooltip == null) tooltip = "";
  this.m_elem.title = tooltip;
}
fan.kawhyScene.NodePeer.prototype.m_tooltip = null;

fan.kawhyScene.NodePeer.prototype.posOnParent = function(self)
{
  if (this.m_parent == null) return this.m_pos;
  var parent = this.m_parent.peer.m_elem;
  var current = this.m_elem;
  var x = 0, y = 0;
  do
  {
    x += current.offsetLeft;
    y += current.offsetTop;
    current = current.offsetParent;
  }
  while(current != parent && current != null);
  return fan.gfx.Point.make(x, y);
}

fan.kawhyScene.NodePeer.prototype.posOnScene = function(self)
{
  if (this.m_parent == null) return this.m_pos;
  var pp = this.posOnParent(self);
  var ps = this.m_parent.posOnScene(self);
  var pe = this.m_parent.peer.m_elem;
  var x = pp.m_x + ps.m_x - pe.scrollLeft;
  var y = pp.m_y + ps.m_y - pe.scrollTop;
  return fan.gfx.Point.make(x, y);
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
  this.m_size = size;
  this.m_elem.style.width  = size.m_w + "px";
  this.m_elem.style.height = size.m_h + "px";
}

fan.kawhyScene.NodePeer.prototype.m_size = null;

fan.kawhyScene.NodePeer.prototype.m_style = null;
fan.kawhyScene.NodePeer.prototype.style   = function(self) { return this.m_style }
fan.kawhyScene.NodePeer.prototype.style$  = function(self, style)
{
  this.m_style = style;
  fan.kawhyScene.NodePeer.setStyle(this.m_elem, style);
  this.initStyle(self);
}

fan.kawhyScene.NodePeer.setStyle = function(elem, style)
{
  if (style != null)
  {
    elem.style.cssText = fan.kawhyCss.StyleItem.toStyleString(style.toCss());
    var property = style.findStyle(fan.kawhyCss.PropertyStyle.$type);
    if (property != null)
    {
      property.m_properties.each(fan.sys.Func.make(
        fan.sys.List.make(fan.sys.Param.$type, [new fan.sys.Param("val","sys::Str",false), new fan.sys.Param("key","sys::Str",false)]),
        fan.sys.Void.$type,
        function(val, key)
        {
          var event = fan.kawhyScene.NodePeer.asEvent(key);
          if (event)
          {
            elem.addEventListener(event, function(e) { return eval(val); }, false);
          } else elem[key] = val;
          return;
        }));
    }
  }
  else
  {
    elem.style.cssText = "";
  }
}

fan.kawhyScene.NodePeer.asEvent = function(name)
{
  if (name.length > 2 && name.slice(0, 2) == "on")
  {
    var index = fan.kawhyScene.NodePeer.events.indexOf(name.slice(2));
    if (index >= 0) return fan.kawhyScene.NodePeer.events[index];
  }
  return null;
}

fan.kawhyScene.NodePeer.events = ["mouseover", "mousemove", "mouseout"];

fan.kawhyScene.NodePeer.prototype.m_thru = false;
fan.kawhyScene.NodePeer.prototype.thru   = function(self) { return this.m_thru; }
fan.kawhyScene.NodePeer.prototype.thru$  = function(self, thru)
{
  this.m_thru = thru;
  this.m_elem.style.pointerEvents = thru ? "none" : "auto";
}

fan.kawhyScene.NodePeer.prototype.m_hover = false;
fan.kawhyScene.NodePeer.prototype.m_mouseOut = false;
fan.kawhyScene.NodePeer.prototype.hover   = function(self) { return this.m_hover; }
fan.kawhyScene.NodePeer.prototype.hover$  = function(self, hover)
{
  if (this.m_hover != hover)
  {
    this.m_hover = hover;
    self.m_onHover.push(hover);
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
  this.m_elem = this.create(self);
  this.initStyle(self);
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

fan.kawhyScene.NodePeer.prototype.initStyle = function(self)
{
  with (this.m_elem.style)
  {
    position = "absolute";
    left     = this.m_pos.m_x + "px";
    top      = this.m_pos.m_y + "px";
    if (this.m_size != null)
    {
      width  = this.m_size.m_w + "px";
      height = this.m_size.m_h + "px";
    }
  }
}

fan.kawhyScene.NodePeer.prototype.create = function(self)
{
  return document.createElement("span");
}

fan.kawhyScene.NodePeer.prototype.m_elem = null;
