fan.stylishScene.LinkPeer = fan.sys.Obj.$extend(fan.stylishScene.NodePeer);
fan.stylishScene.LinkPeer.prototype.$ctor = function(self) { this.init(self); }

fan.stylishScene.LinkPeer.prototype.create = function()
{
  var a = document.createElement("a");
  this.m_text = document.createTextNode("");
  a.appendChild(this.m_text);
  return a;
}

fan.stylishScene.LinkPeer.prototype.link = function(self)
{
  return this.m_elem.href;
}

fan.stylishScene.LinkPeer.prototype.link$ = function(self, link)
{
  this.m_elem.href = link;
}

fan.stylishScene.LinkPeer.prototype.text = function(self)
{
  return this.m_text.nodeValue;
}

fan.stylishScene.LinkPeer.prototype.text$ = function(self, text)
{
  this.m_text.nodeValue = text;
}

fan.stylishScene.LinkPeer.prototype.m_text = null;
