fan.kawhyScene.KYTextNode = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.KYTextNode.prototype.$ctor = function() {}

fan.kawhyScene.KYTextNode.prototype.create = function()
{
  var span = document.createElement("span");
  return span;
}

fan.kawhyScene.KYTextNode.prototype.text = function() { return this.m_text; }
fan.kawhyScene.KYTextNode.prototype.text$ = function(text)
{
  this.m_text = text;
  this.fillContent();
}
fan.kawhyScene.KYTextNode.prototype.m_text = "";

fan.kawhyScene.KYTextNode.prototype.styles = function() { return this.m_styles.dup(); }
fan.kawhyScene.KYTextNode.prototype.styles$ = function(styles)
{
  this.m_styles = styles;
  this.fillContent();
}
fan.kawhyScene.KYTextNode.prototype.m_styles = fan.sys.List.make(fan.kawhyCss.StyleRange.$type);

fan.kawhyScene.KYTextNode.prototype.fillContent = function()
{
  this.m_elem.innerHTML = "";
  var textSize = this.m_text.length;
  var offset = 0;
  for(var i = 0; i < this.m_styles.size(); i++)
  {
    var style = this.m_styles.get(i);
    var region = fan.kawhyMath.Region.fromRange(style.m_range);
    if (region.m_start < offset)
      throw fan.sys.ArgErr.make("styles should be sorted and can't overlap: " + this.m_styles.toStr());
    if (region.m_start >= textSize) break;
    if (region.m_start > offset)
    {
      var val = this.m_text.substring(offset, region.m_start);
      this.m_elem.appendChild(document.createTextNode(val));
    }
    var size = region.m_size;
    if (region.m_start + size > textSize) size = textSize - region.m_start;
    if (size > 0)
    {
      var val = this.m_text.substring(region.m_start, region.m_start + size);
      var span = document.createElement("span");
      span.appendChild(document.createTextNode(val));
      var str = fan.kawhyCss.StyleItem.toStyleString(style.m_style.toCss());
      span.style.cssText = str;
      this.m_elem.appendChild(span);
      offset = region.m_start + size;
    }
  }
  if (offset < textSize)
  {
    var val = this.m_text.substring(offset);
    this.m_elem.appendChild(document.createTextNode(val));
  }
}

fan.kawhyScene.KYTextNode.prototype.initStyle = function()
{
  fan.kawhyScene.ZNode.prototype.initStyle.call(this);
  with (this.m_elem.style)
  {
    whiteSpace = "pre"
  }
}

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
