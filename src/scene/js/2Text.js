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

fan.kawhyScene.KYTextNode.prototype.textWidth = function(str)
{
  // use global var to store a context for computing string width
  if (fan.kawhyScene.KYTextNode.fontCx == null)
  {
    fan.kawhyScene.KYTextNode.fontCx = document.createElement("canvas").getContext("2d");
  }

  fan.fwt.FwtEnvPeer.fontCx.font = this.calcFont();
  return Math.round(fan.fwt.FwtEnvPeer.fontCx.measureText(str).width);
}

fan.kawhyScene.KYTextNode.prototype.calcFont = function()
{
  var font = null;
  var defView = document.defaultView;
  if (defView)
  {
    if (defView.getComputedStyle)
      font = defView.getComputedStyle(this.m_elem, null).getPropertyValue("font");
  }
  if (font == null)
    font = this.m_elem.style["font"];
  if (font == null && el.currentStyle)
    font = el.currentStyle["font"];
  return font;
}

fan.kawhyScene.KYTextNode.fontToCss = function(font)
{
  if (font == null) return "";
  var s = "";
  if (font.m_bold)   s += "bold ";
  if (font.m_italic) s += "italic ";
  s += font.m_size + "px ";
  s += font.m_$name;
  return s;
}

//global variable to store a CanvasRenderingContext2D
fan.kawhyScene.KYTextNode.fontCx = null;
