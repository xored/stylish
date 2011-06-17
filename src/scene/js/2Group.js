fan.kawhyScene.DivNode = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.DivNode.prototype.$ctor = function()
{
}

fan.kawhyScene.DivNode.prototype.add = function(kid)
{
  if (this.m_kids == null)
    this.m_kids = fan.sys.List.make(fan.kawhyScene.Node.$type);

  this.m_kids.add(kid);
  this.content().appendChild(kid.m_elem);
  if (this.m_position == fan.kawhyScene.Position.m_horizontal)
  {
    kid.m_elem.style.display = "inline";
    kid.m_elem.style.position = "relative";
  }
  else
  {
    kid.m_elem.style.display = "block";
    if (this.m_position == fan.kawhyScene.Position.m_vertical)
    {
      kid.m_elem.style.position = "relative";
    }
    else
    {
      kid.m_elem.style.position = "absolute";
    }
  }
}

fan.kawhyScene.DivNode.prototype.remove = function(kid)
{
  if (this.m_kids == null) return;
  this.content().removeChild(kid.m_elem);
  this.m_kids.remove(kid);
}

fan.kawhyScene.DivNode.prototype.removeAll = function(kid)
{
  this.content().innerHTML = "";
  this.m_kids = null;
}

fan.kawhyScene.DivNode.prototype.content = function() { return this.m_elem; }

fan.kawhyScene.DivNode.prototype.m_position = fan.kawhyScene.Position.m_horizontal
fan.kawhyScene.DivNode.prototype.position   = function() { return this.m_position }
fan.kawhyScene.DivNode.prototype.position$  = function(position)
{
  this.m_position = position;
  var kids = this.m_kids;
  if (kids != null)
  {
    var inline = position == fan.kawhyScene.Position.m_horizontal;
    var absolute = position == fan.kawhyScene.Position.m_absolute;
    for (var i = 0; i < kids.size(); i++)
    {
      var kid = kids.get(i);
      kid.m_elem.style.display = inline ? "inline" : "block";
      kid.m_elem.style.position = absolute ? "absolute" : "relative";
    }
  }
}

fan.kawhyScene.DivNode.prototype.m_kids = null;
