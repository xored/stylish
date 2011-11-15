fan.stylishScene.ScrollBarPeer = fan.sys.Obj.$extend(fan.stylishScene.NodePeer);
fan.stylishScene.ScrollBarPeer.prototype.$ctor = function(self) { this.init(self); }

fan.stylishScene.ScrollBarPeer.prototype.val   = function(self) { return this.m_val; }
fan.stylishScene.ScrollBarPeer.prototype.val$  = function(self, val)
{
  if (val < 0) val = 0;
  if (val > this.m_max) val = this.m_max;
  this.m_val = val;
  this.sync(self);
}
fan.stylishScene.ScrollBarPeer.prototype.m_val = 0;

fan.stylishScene.ScrollBarPeer.prototype.max   = function(self) { return this.m_max; }
fan.stylishScene.ScrollBarPeer.prototype.max$  = function(self, val) 
{ 
  if (val < 0) return;
  this.m_max = val;
  this.sync(self);
}
fan.stylishScene.ScrollBarPeer.prototype.m_max = 100;

fan.stylishScene.ScrollBarPeer.prototype.thumb  = function(self) { return this.m_thumb; }
fan.stylishScene.ScrollBarPeer.prototype.thumb$ = function(self, val)
{
  this.m_thumb = val;
  this.sync(self);
}
fan.stylishScene.ScrollBarPeer.prototype.m_thumb = 10;

fan.stylishScene.ScrollBarPeer.prototype.m_enabled = true;
fan.stylishScene.ScrollBarPeer.prototype.enabled = function(self) { return this.m_enabled; }
fan.stylishScene.ScrollBarPeer.prototype.enabled$ = function(self, val)
{
  this.m_enabled = val;
  this.sync(self);
}

fan.stylishScene.ScrollBarPeer.prototype.m_orientation = fan.gfx.Orientation.m_horizontal;
fan.stylishScene.ScrollBarPeer.prototype.orientation = function(self) { return this.m_orientation; }
fan.stylishScene.ScrollBarPeer.prototype.orientation$ = function(self, val)
{
  this.m_orientation = val;
}

fan.stylishScene.ScrollBarPeer.prototype.attach = function(self, parent)
{
  fan.stylishScene.NodePeer.prototype.attach.call(this, self, parent);
  this.m_attached = true;
  this.sync(self);
}

fan.stylishScene.ScrollBarPeer.prototype.m_attached = false;

fan.stylishScene.ScrollBarPeer.prototype.create = function(self)
{
  var scrollDiv = document.createElement("div");
  scrollDiv.style.padding = "0px";       
  var scrollContent = document.createElement("div");
  scrollDiv.appendChild(scrollContent);

  scrollDiv.onscroll = function(event)
  { 
    var scrollIndent = 0;
    var scrollSize = 0;
    var peer = self.peer;
    if (peer.m_orientation == fan.gfx.Orientation.m_vertical)
    {
      scrollSize = scrollDiv.scrollHeight - scrollDiv.clientHeight;
      scrollIndent = scrollDiv.scrollTop;
    }  
    else
    {
      scrollSize = scrollDiv.scrollWidth - scrollDiv.clientWidth;
      scrollIndent = scrollDiv.scrollLeft;
    }
    var newVal = Math.round(scrollIndent * (peer.m_max - peer.m_thumb) / scrollSize);
    if (peer.m_val == newVal)
      return

    peer.m_val = newVal;
    self.m_onScroll.call(newVal);
  }

  return scrollDiv;
}

fan.stylishScene.ScrollBarPeer.prototype.size$  = function(self, size)
{
  fan.stylishScene.NodePeer.prototype.size$.call(this, self, size);
  this.m_size = size;
}

fan.stylishScene.ScrollBarPeer.prototype.m_size = fan.gfx.Size.defVal;

fan.stylishScene.ScrollBarPeer.prototype.initStyle = function(self)
{
  fan.stylishScene.NodePeer.prototype.initStyle.call(this, self);
}

fan.stylishScene.ScrollBarPeer.prototype.prefSize = function(self, hints)
{
  var thickness = fan.stylishScene.ScrollBarPeer.thickness();
  if (this.m_orientation == fan.gfx.Orientation.m_vertical)
    return fan.gfx.Size.make(thickness, hints.m_h);
  else
    return fan.gfx.Size.make(hints.m_w, thickness);
}

fan.stylishScene.ScrollBarPeer.prototype.doInit = function(self)
{
  this.size$(self, this.prefSize(self, fan.gfx.Size.make(100, 100)));
  this.sync(self);
}

fan.stylishScene.ScrollBarPeer.prototype.sync = function(self)
{
  fan.stylishScene.NodePeer.prototype.sizeChanged.call(this, self);
  var vert = this.m_orientation == fan.gfx.Orientation.m_vertical;
  var size = this.m_size;
  var w = size.m_w;
  var h = size.m_h;
  var scrollDiv = this.m_elem;
  var scrollContent = scrollDiv.firstChild;

  var maxRatio = this.m_max / this.m_thumb;
  var valRatio = this.m_val / this.m_thumb;

  var vertical = this.m_orientation == fan.gfx.Orientation.m_vertical;
  if (vert)
  {
    scrollDiv.style.width = fan.stylishScene.ScrollBarPeer.thickness() + "px";
    scrollDiv.style.overflowX = "hidden";
    scrollDiv.style.overflowY = "scroll";
    scrollContent.style.width = "1px";
    scrollDiv.style.height = h + "px";
    if (this.m_enabled)
    {
      scrollContent.style.height = Math.round(h * maxRatio) + "px";
      scrollDiv.scrollTop = Math.round(h * valRatio);
    }
    else
    {
      scrollDiv.scrollTop = 0;
      scrollContent.style.height = "0px";
    }
  }
  else
  {
    scrollDiv.style.height = fan.stylishScene.ScrollBarPeer.thickness() + "px";
    scrollDiv.style.overflowX = "scroll";
    scrollDiv.style.overflowY = "hidden";
    scrollContent.style.height = "1px";
    scrollDiv.style.width = w + "px";
    if (this.m_enabled)
    {
      scrollContent.style.width = Math.round(w * maxRatio) + "px";
      scrollDiv.scrollLeft = Math.round(w * valRatio);
    }
    else
    {
      scrollDiv.scrollLeft = 0;
      scrollContent.style.width = "0px";
    }
  }
}

//////////////////////////////////////////////////////////////////////////
// Utils
//////////////////////////////////////////////////////////////////////////

fan.stylishScene.ScrollBarPeer.thickness = function()
{
  if (fan.stylishScene.ScrollBarPeer.m_thickness == 0)
  {
    var inner = document.createElement('div');
    inner.style.height = "100px";

    var outer = document.createElement('div');
    with (outer.style)
    {
      width = "50px"; height = "50px";
      overflow = "hidden"; position = "absolute";
      visibility = "hidden";
    }
    outer.appendChild(inner);

    document.body.appendChild(outer);
    var w1 = inner.offsetWidth;
    outer.style.overflow = 'scroll';
    var w2 = inner.offsetWidth;
    if (w1 == w2) w2 = outer.clientWidth;
    document.body.removeChild(outer);

    fan.stylishScene.ScrollBarPeer.m_thickness = (w1 - w2);
  }
  return fan.stylishScene.ScrollBarPeer.m_thickness;
}

fan.stylishScene.ScrollBarPeer.m_thickness = 0;
