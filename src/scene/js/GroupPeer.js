fan.kawhyScene.GroupPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.GroupPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.GroupPeer.prototype.add = function(self, kid)
{
  if (this.m_kids == null)
    this.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);

  this.m_kids.add(kid);
  var elem = kid.peer.m_elem;
  this.content().appendChild(elem);
  kid.peer.attach(kid, this);

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

fan.kawhyScene.GroupPeer.prototype.remove = function(self, kid)
{
  if (this.m_kids == null) return;
  this.content().removeChild(kid.peer.m_elem);
  this.m_kids.remove(kid);
  kid.peer.detach(kid, this);
}

fan.kawhyScene.GroupPeer.prototype.removeAll = function(self)
{
  this.content().innerHTML = "";
  this.m_kids = null;
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

fan.kawhyScene.GroupPeer.prototype.kidAbsPos = function(kid)
{
  return kid.m_pos.translate(this.absPos());
}
fan.kawhyScene.GroupPeer.prototype.m_kids = null;

fan.kawhyScene.GroupPeer.prototype.resetAbsPos = function()
{
  if (fan.kawhyScene.NodePeer.prototype.resetAbsPos.call(this))
  {
    this.resetKidsAbsPos();
    return true;
  }
  return false;
}

fan.kawhyScene.GroupPeer.prototype.resetKidsAbsPos = function()
{
  if (this.m_kids != null)
    for (var i = 0; i < this.m_kids.size(); i++)
      this.m_kids.get(i).peer.resetAbsPos();
}
