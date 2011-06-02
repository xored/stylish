fan.kawhyScene.DivNode = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.DivNode.prototype.$ctor = function() {}

fan.kawhyScene.DivNode.prototype.add = function(kid)
{
  this.m_kids.add(kid);
  this.m_elem.appendChild(kid.m_elem);
}

fan.kawhyScene.DivNode.prototype.remove = function(kid)
{
  this.m_elem.removeChild(kid.m_elem);
  this.m_kids.remove(kid);
}

fan.kawhyScene.DivNode.prototype.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);
