fan.kawhyScene.TextNodePeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.TextNodePeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.TextNodePeer.prototype.create = function()
{
  var span = document.createElement("span");
  return span;
}

fan.kawhyScene.TextNodePeer.prototype.text = function(self) { return this.m_text; }
fan.kawhyScene.TextNodePeer.prototype.text$ = function(self, text)
{
  this.m_text = text;
  this.fillContent();
}
fan.kawhyScene.TextNodePeer.prototype.m_text = "";

fan.kawhyScene.TextNodePeer.prototype.styles = function(self) { return this.m_styles.dup(); }
fan.kawhyScene.TextNodePeer.prototype.styles$ = function(self, styles)
{
  this.m_styles = styles;
  this.fillContent();
}
fan.kawhyScene.TextNodePeer.prototype.m_styles = fan.sys.List.make(fan.kawhyCss.StyleRange.$type);

fan.kawhyScene.TextNodePeer.prototype.fillContent = function()
{
  this.m_elem.innerHTML = "";
  var textSize = this.m_text.length;
  if (textSize == 0) return
  var offset = 0;
  for(var i = 0; i < this.m_styles.size(); i++)
  {
    var style = this.m_styles.get(i);
    var region = fan.kawhyMath.Region.fromRange(style.m_range, textSize);
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
      var linkStyle = style.m_style.findStyle(fan.kawhyCss.LinkStyle.$type);
      var wrapper;
      if (linkStyle)
      {
        wrapper = document.createElement("a");
        wrapper.href = linkStyle.m_href.toStr();
        if (linkStyle.m_target == fan.kawhyCss.LinkTarget.m_blank)
        {
          wrapper.target = "_blank";
        }
      }
      else
      {
        wrapper = document.createElement("span");
      }
      wrapper.appendChild(document.createTextNode(val));
      fan.kawhyScene.NodePeer.setStyle(wrapper, style.m_style);
      this.m_elem.appendChild(wrapper);
      offset = region.m_start + size;
    }
  }
  if (offset < textSize)
  {
    var val = this.m_text.substring(offset);
    this.m_elem.appendChild(document.createTextNode(val));
  }
}

fan.kawhyScene.TextNodePeer.prototype.initStyle = function()
{
  fan.kawhyScene.NodePeer.prototype.initStyle.call(this);
  with (this.m_elem.style)
  {
    whiteSpace = "pre"
    cursor = "inherit"
  }
}

fan.kawhyScene.TextNodePeer.prototype.offsetAt = function(self, pos)
{
  //TODO only for monospace fonts without tabs for now
  var offset = Math.floor(pos / this.charWidth());
  if (offset >= this.m_text.length) return null;
  return offset;
}

fan.kawhyScene.TextNodePeer.prototype.charRegion = function(self, index)
{
  if (index >= this.m_text.length)
    throw new ArgErr("invalid index: " + index);
  var width = this.charWidth();
  var start = Math.round(index * width);
  var end = Math.round((index + 1) * width);
  return fan.kawhyMath.Region.make(start, end - start);
}

fan.kawhyScene.TextNodePeer.prototype.charWidth = function()
{
  return this.m_elem.offsetWidth / this.m_text.length;
}

fan.kawhyScene.TextNodePeer.prototype.textWidth = function(str)
{
  // use global var to store a context for computing string width
  if (fan.kawhyScene.TextNodePeer.fontCx == null)
  {
    fan.kawhyScene.TextNodePeer.fontCx = document.createElement("canvas").getContext("2d");
  }

  fan.fwt.FwtEnvPeer.fontCx.font = this.calcFont();
  return Math.round(fan.fwt.FwtEnvPeer.fontCx.measureText(str).width);
}

fan.kawhyScene.TextNodePeer.prototype.calcFont = function()
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

fan.kawhyScene.TextNodePeer.fontToCss = function(font)
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
fan.kawhyScene.TextNodePeer.fontCx = null;
