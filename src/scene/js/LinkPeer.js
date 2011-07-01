fan.kawhyScene.LinkPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.LinkPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.LinkPeer.prototype.create = function()
{
  var a = document.createElement("a");
  this.m_text = document.createTextNode("");
  a.appendChild(this.m_text);
  return a;
}

fan.kawhyScene.LinkPeer.prototype.link = function(self)
{
  return this.m_elem.href;
}

fan.kawhyScene.LinkPeer.prototype.link$ = function(self, link)
{
  this.m_elem.href = link;
}

fan.kawhyScene.LinkPeer.prototype.text = function(self)
{
  return this.m_text.nodeValue;
}

fan.kawhyScene.LinkPeer.prototype.text$ = function(self, text)
{
  this.m_text.nodeValue = text;
}

fan.kawhyScene.LinkPeer.prototype.m_text = null;
