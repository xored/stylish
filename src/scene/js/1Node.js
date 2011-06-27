fan.kawhyScene.ZNode = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.ZNode.prototype.$ctor = function() {}

fan.kawhyScene.ZNode.prototype.m_pos = null
fan.kawhyScene.ZNode.prototype.pos   = function() { return this.m_pos }
fan.kawhyScene.ZNode.prototype.pos$  = function(pos)
{
  this.m_pos = pos;
  with (this.m_elem.style)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
}

fan.kawhyScene.ZNode.prototype.size   = function()
{
  var w = this.m_elem.offsetWidth;
  var h = this.m_elem.offsetHeight;
  return fan.gfx.Size.make(w, h);
}

fan.kawhyScene.ZNode.prototype.size$  = function(size)
{
  this.m_elem.style.width  = size.m_w + "px";
  this.m_elem.style.height = size.m_h + "px";
}

fan.kawhyScene.ZNode.prototype.m_style = null
fan.kawhyScene.ZNode.prototype.style   = function() { return this.m_style }
fan.kawhyScene.ZNode.prototype.style$  = function(style)
{
  this.m_style = style;
  var str = fan.kawhyCss.StyleItem.toStyleString(style.toCss());
  this.m_elem.style.cssText = str;
  this.initStyle();
}

fan.kawhyScene.ZNode.prototype.init = function()
{
  this.m_elem = this.create();
  this.m_pos = fan.gfx.Point.m_defVal;
  this.initStyle();
}

fan.kawhyScene.ZNode.prototype.initStyle = function()
{
  with (this.m_elem.style)
  {
    position = "absolute";
    left = this.m_pos.m_x + "px";
    top  = this.m_pos.m_y + "px";
  }
}

fan.kawhyScene.ZNode.prototype.create = function()
{
  return document.createElement("span");
}

fan.kawhyScene.ZNode.prototype.m_elem = null;
