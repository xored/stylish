fan.kawhyScene.ScrollBarPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.ScrollBarPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.ScrollBarPeer.prototype.val   = function(self) { return this.m_val; }
fan.kawhyScene.ScrollBarPeer.prototype.val$  = function(self, val)
{
  if (val < 0) val = 0;
  if (val > this.m_max) val = this.m_max;
  this.m_val = val;
  this.sync(self);
}
fan.kawhyScene.ScrollBarPeer.prototype.m_val = 0;

fan.kawhyScene.ScrollBarPeer.prototype.max   = function(self) { return this.m_max; }
fan.kawhyScene.ScrollBarPeer.prototype.max$  = function(self, val) 
{ 
  if (val < 0) return;
  this.m_max = val;
  this.sync(self);
}
fan.kawhyScene.ScrollBarPeer.prototype.m_max = 100;

fan.kawhyScene.ScrollBarPeer.prototype.thumb  = function(self) { return this.m_thumb; }
fan.kawhyScene.ScrollBarPeer.prototype.thumb$ = function(self, val)
{
  this.m_thumb = val;
  this.sync(self);
}
fan.kawhyScene.ScrollBarPeer.prototype.m_thumb = 10;

fan.kawhyScene.ScrollBarPeer.prototype.m_enabled = true;
fan.kawhyScene.ScrollBarPeer.prototype.enabled = function(self) { return this.m_enabled; }
fan.kawhyScene.ScrollBarPeer.prototype.enabled$ = function(self, val)
{
  this.m_enabled = val;
  this.sync(self);
}

fan.kawhyScene.ScrollBarPeer.prototype.m_orientation = fan.gfx.Orientation.m_horizontal;
fan.kawhyScene.ScrollBarPeer.prototype.orientation = function(self) { return this.m_orientation; }
fan.kawhyScene.ScrollBarPeer.prototype.orientation$ = function(self, val)
{
  this.m_orientation = val;
}

fan.kawhyScene.ScrollBarPeer.prototype.attach = function(self, parent)
{
  fan.kawhyScene.NodePeer.prototype.attach.call(this, self, parent);
  this.m_attached = true;
  this.sync(self);
}

fan.kawhyScene.ScrollBarPeer.prototype.m_attached = false;

fan.kawhyScene.ScrollBarPeer.prototype.create = function(self)
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

fan.kawhyScene.ScrollBarPeer.prototype.size$  = function(self, size)
{
  fan.kawhyScene.NodePeer.prototype.size$.call(this, self, size);
  this.m_size = size;
}

fan.kawhyScene.ScrollBarPeer.prototype.m_size = fan.gfx.Size.defVal;

fan.kawhyScene.ScrollBarPeer.prototype.initStyle = function(self)
{
  fan.kawhyScene.NodePeer.prototype.initStyle.call(this, self);
}

fan.kawhyScene.ScrollBarPeer.prototype.prefSize = function(self, hints)
{
  var thickness = fan.kawhyScene.ScrollBarPeer.thickness();
  if (this.m_orientation == fan.gfx.Orientation.m_vertical)
    return fan.gfx.Size.make(thickness, hints.m_h);
  else
    return fan.gfx.Size.make(hints.m_w, thickness);
}

fan.kawhyScene.ScrollBarPeer.prototype.doInit = function(self)
{
  this.size$(self, this.prefSize(self, fan.gfx.Size.make(100, 100)));
  this.sync(self);
}

fan.kawhyScene.ScrollBarPeer.prototype.sync = function(self)
{
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
    scrollDiv.style.width = fan.kawhyScene.ScrollBarPeer.thickness() + "px";
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
    scrollDiv.style.height = fan.kawhyScene.ScrollBarPeer.thickness() + "px";
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

fan.kawhyScene.ScrollBarPeer.thickness = function()
{
  if (fan.kawhyScene.ScrollBarPeer.m_thickness == 0)
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

    fan.kawhyScene.ScrollBarPeer.m_thickness = (w1 - w2);
  }
  return fan.kawhyScene.ScrollBarPeer.m_thickness;
}

fan.kawhyScene.ScrollBarPeer.m_thickness = 0;
