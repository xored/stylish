fan.kawhyScene.ScenePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.ScenePeer.prototype.$ctor = function()
{
  var $this = this;
  window.addEventListener("mousemove", function(e) { $this.handleMove(e); }, false);
  window.addEventListener("mousedown", function(e) { $this.handleDown(e); }, false);
  window.addEventListener("mouseup",   function(e) { $this.handleUp(e);   }, false);
  this.m_mouse = fan.kawhyScene.Mouse.make();
}

/////////////////////////
// Events
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.mouse = function(self)
{
  return this.m_mouse;
}

fan.kawhyScene.ScenePeer.prototype.handleMove = function(e)
{
  this.m_mouse.pos$(fan.gfx.Point.make(e.clientX, e.clientY));
}

fan.kawhyScene.ScenePeer.prototype.handleDown = function(e) { this.handleClick(e, true); }

fan.kawhyScene.ScenePeer.prototype.handleUp = function(e) { this.handleClick(e, false); }

fan.kawhyScene.ScenePeer.prototype.handleClick = function(e, down)
{
  if (this.clicks == null)
  {
    this.clicks =
    {
      time:   new Date().getTime(),
      pos:    this.m_mouse.m_pos,
      count:  1,
      button: e.button
    };
  }
  else if (down)
  {
    var now = new Date().getTime();
    var diff = now - this.clicks.time;
    this.clicks.time = now;
    if (diff < 600 && this.m_mouse.m_pos.equals(this.clicks.pos) && e.button == this.clicks.button)
    {
      this.clicks.count++;
    }
    else
    {
      this.clicks.count  = 1;
      this.clicks.button = e.button;
      this.clicks.pos = this.m_mouse.m_pos;
    }
  }
  var slot = fan.kawhyScene.ScenePeer.buttonSlot(e);
  var button = slot.get(this.m_mouse);
  button.onClick(down, this.clicks.count);
}

fan.kawhyScene.ScenePeer.buttonSlot = function(e)
{
  switch (e.button)
  {
    case 0: return fan.kawhyScene.Mouse.$type.field("left");
    case 1: return fan.kawhyScene.Mouse.$type.field("middle");
    case 2: return fan.kawhyScene.Mouse.$type.field("right");
  }
  return null;
}

/////////////////////////
// Fields
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.root = function(self) { return this.m_root; }
fan.kawhyScene.ScenePeer.prototype.root$ = function(self, root)
{
  if (this.m_root)
    document.body.removeChild(this.m_root.peer.m_elem);
  this.m_root = root;
  document.body.appendChild(root.peer.m_elem);
}
fan.kawhyScene.ScenePeer.prototype.m_root = null;

fan.kawhyScene.ScenePeer.prototype.m_lastClickTime = null;
fan.kawhyScene.ScenePeer.prototype.m_lastClickButton = null;