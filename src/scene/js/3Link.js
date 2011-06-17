fan.kawhyScene.KYLink = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.KYLink.prototype.$ctor = function() {}

fan.kawhyScene.KYLink.prototype.create = function()
{
  var a = document.createElement("a");
  this.m_text = document.createTextNode("");
  a.appendChild(this.m_text);
  return a;
}

fan.kawhyScene.KYLink.prototype.link = function()
{
  return this.m_elem.href;
}

fan.kawhyScene.KYLink.prototype.link$ = function(link)
{
  this.m_elem.href = link;
}

fan.kawhyScene.KYLink.prototype.text = function()
{
  return this.m_text.nodeValue;
}

fan.kawhyScene.KYLink.prototype.text$ = function(text)
{
  this.m_text.nodeValue = text;
}

fan.kawhyScene.KYLink.prototype.m_text = null;
