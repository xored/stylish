fan.kawhyScene.KYTextNode = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.KYTextNode.prototype.$ctor = function() {}

fan.kawhyScene.KYTextNode.prototype.create = function()
{
  var span = document.createElement("span");
  this.m_text = document.createTextNode("");
  span.appendChild(this.m_text);
  return span;
}

fan.kawhyScene.KYTextNode.prototype.text = function()
{
  return this.m_text.nodeValue;
}

fan.kawhyScene.KYTextNode.prototype.text$ = function(text)
{
  this.m_text.nodeValue = text;
}
fan.kawhyScene.KYTextNode.prototype.m_text = null;

fan.kawhyScene.KYTextNode.prototype.m_font = null;
fan.kawhyScene.KYTextNode.prototype.font = function() { return this.m_font; }
fan.kawhyScene.KYTextNode.prototype.font$ = function(font) { this.m_font = font; }

fan.kawhyScene.KYTextNode.prototype.m_color = null;
fan.kawhyScene.KYTextNode.prototype.color = function() { return this.m_color; }
fan.kawhyScene.KYTextNode.prototype.color$ = function(color) { this.m_color = color; }
