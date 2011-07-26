fan.kawhyScene.GroupPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.GroupPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.GroupPeer.prototype.add = function(self, kid)
{
  if (this.m_kids == null)
    this.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);

  this.m_kids.add(kid);
  var elem = kid.peer.m_elem;
  this.content().appendChild(elem);
  kid.peer.attach(kid, self);

  if (this.m_position == fan.kawhyScene.Position.m_horizontal)
  {
    elem.style.display = "inline";
    elem.style.position = "relative";
  }
  else
  {
    elem.style.display = "block";
    if (this.m_position == fan.kawhyScene.Position.m_vertical)
      elem.style.position = "relative";
    else
      elem.style.position = "absolute";
  }
}

fan.kawhyScene.GroupPeer.prototype.addAll = function(self, kids)
{
  if (kids.size == 0) return;
  if (this.m_kids == null)
    this.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);
  this.m_kids.addAll(kids);

  var fragment = document.createDocumentFragment();
  for(var i = 0; i < kids.size(); i++)
  {
    var kid = kids.get(i);
    var elem = kid.peer.m_elem;
    fragment.appendChild(elem);
    kid.peer.attach(kid, self);
    if (this.m_position == fan.kawhyScene.Position.m_horizontal)
    {
      elem.style.display = "inline";
      elem.style.position = "relative";
    }
    else
    {
      elem.style.display = "block";
      if (this.m_position == fan.kawhyScene.Position.m_vertical)
        elem.style.position = "relative";
      else
        elem.style.position = "absolute";
    }
  }
  this.content().appendChild(fragment);
}

fan.kawhyScene.GroupPeer.prototype.remove = function(self, kid)
{
  if (this.m_kids == null) return;
  this.content().removeChild(kid.peer.m_elem);
  this.m_kids.remove(kid);
  kid.peer.detach(kid, self);
}

fan.kawhyScene.GroupPeer.prototype.kid = function(self, index)
{
  return this.m_kids.get(index);
}

fan.kawhyScene.GroupPeer.prototype.removeAll = function(self)
{
  this.content().innerHTML = "";
  this.m_kids = null;
}

fan.kawhyScene.GroupPeer.prototype.attach = function(self, parent)
{
  fan.kawhyScene.NodePeer.prototype.attach.call(this, self, parent);
  var kids = this.m_kids;
  if (kids)
  {
    for(var i = 0; i < kids.size(); i++)
    {
      var kid = kids.get(i);
      kid.peer.attach(kid, self);
    }
  }
}

fan.kawhyScene.GroupPeer.prototype.content = function() { return this.m_elem; }

fan.kawhyScene.GroupPeer.prototype.m_position = fan.kawhyScene.Position.m_horizontal;
fan.kawhyScene.GroupPeer.prototype.position   = function(self) { return this.m_position }
fan.kawhyScene.GroupPeer.prototype.position$  = function(self, position)
{
  this.m_position = position;
  var kids = this.m_kids;
  if (kids != null)
  {
    var inline = position == fan.kawhyScene.Position.m_horizontal;
    var absolute = position == fan.kawhyScene.Position.m_absolute;
    for (var i = 0; i < kids.size(); i++)
    {
      var kid = kids.get(i).peer;
      kid.m_elem.style.display = inline ? "inline" : "block";
      kid.m_elem.style.position = absolute ? "absolute" : "relative";
    }
  }
}

fan.kawhyScene.GroupPeer.prototype.m_kids = null;

fan.kawhyScene.GroupPeer.prototype.m_clip = false;
fan.kawhyScene.GroupPeer.prototype.clip   = function(self) { return this.m_clip; }
fan.kawhyScene.GroupPeer.prototype.clip$  = function(self, clip)
{
  this.m_clip = clip;
  if (clip) this.syncClip();
  else this.m_elem.style.clip = "";
}

fan.kawhyScene.GroupPeer.prototype.size$  = function(self, size)
{
  fan.kawhyScene.NodePeer.prototype.size$.call(this, self, size);
  if (this.m_clip) this.syncClip();
}

fan.kawhyScene.GroupPeer.prototype.syncClip = function()
{
  var size = this.size();
  this.m_elem.style.clip = "rect(0px " + size.m_w + "px " + size.m_h + "px 0px)";
}
