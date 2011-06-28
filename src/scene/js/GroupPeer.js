fan.kawhyScene.GroupPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.GroupPeer.prototype.$ctor = function() { this.init(); }

fan.kawhyScene.GroupPeer.prototype.add = function(self, kid)
{
  if (this.m_kids == null)
    this.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);

  this.m_kids.add(kid);
  var elem = kid.peer.m_elem;
  this.content().appendChild(elem);
  if (this.m_position == fan.kawhyScene.Position.m_horizontal)
  {
    elem.style.display = "inline";
    elem.style.position = "relative";
  }
  else
  {
    elem.style.display = "block";
    if (this.m_position == fan.kawhyScene.Position.m_vertical)
    {
      elem.style.position = "relative";
    }
    else
    {
      elem.style.position = "absolute";
    }
  }
}

fan.kawhyScene.GroupPeer.prototype.remove = function(self, kid)
{
  if (this.m_kids == null) return;
  this.content().removeChild(kid.peer.m_elem);
  this.m_kids.remove(kid);
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

fan.kawhyScene.GroupPeer.prototype.m_kids = null;
