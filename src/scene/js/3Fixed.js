fan.kawhyScene.KYFixedNode = fan.sys.Obj.$extend(fan.kawhyScene.DivNode);
fan.kawhyScene.KYFixedNode.prototype.$ctor = function() {}

fan.kawhyScene.KYFixedNode.prototype.create = function()
{
  return document.createElement("div");
}

fan.kawhyScene.KYFixedNode.prototype.size$  = function(size)
{
  this.m_elem.style.width  = size.m_w + "px";
  this.m_elem.style.height = size.m_h + "px";
}
