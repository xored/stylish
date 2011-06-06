fan.kawhyScene.ZNode = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.ZNode.prototype.$ctor = function() {}

fan.kawhyScene.ZNode.prototype.m_pos = null
fan.kawhyScene.ZNode.prototype.pos   = function() { return this.m_pos }
fan.kawhyScene.ZNode.prototype.pos$  = function(pos)
{
  this.m_pos = pos;
  with (this.m_elem)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
}

fan.kawhyScene.ZNode.prototype.m_size = null;
fan.kawhyScene.ZNode.prototype.size   = function()
{
  var w = this.m_elem.offsetWidth;
  var h = this.m_elem.offsetHeight;
  return fan.gfx.Size.make(w, h);
}

fan.kawhyScene.ZNode.prototype.bounds = function()
{
  return fan.gfx.Rect.makePosSize(this.pos(), this.size());
}

fan.kawhyScene.ZNode.prototype.m_parent = null;
fan.kawhyScene.ZNode.prototype.parent = function() { return this.m_parent; }

fan.kawhyScene.ZNode.prototype.m_style = null
fan.kawhyScene.ZNode.prototype.style   = function() { return this.m_style }
fan.kawhyScene.ZNode.prototype.style$  = function(style)
{
  this.m_pos = pos;
  with (this.m_elem)
  {
    left = pos.m_x + "px";
    top  = pos.m_y + "px";
  }
}

fan.kawhyScene.ZNode.prototype.scene = function()
{
  //no supported
}

fan.kawhyScene.ZNode.prototype.init = function()
{
  this.m_elem = this.create();
  with (this.m_elem.style)
  {
    position = "relative";
    top  = "0px";
    left = "0px";
  }
  this.m_pos = fan.gfx.Point.m_defVal;
}

fan.kawhyScene.ZNode.prototype.create = function()
{
  return document.createElement("div");
}

fan.kawhyScene.ZNode.prototype.m_elem = null;
