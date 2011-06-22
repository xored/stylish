fan.kawhyScene.NativeScene = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.NativeScene.prototype.$ctor = function()
{
  var $this = this;
  window.addEventListener("mousemove", function(e) { $this.handleMove(e); }, false);
  window.addEventListener("mousedown", function(e) { $this.handleDown(e); }, false);
  window.addEventListener("mouseup",   function(e) { $this.handleUp(e);   }, false);
  this.m_mouse = fan.kawhyScene.Mouse.make();
}

fan.kawhyScene.NativeScene.make = function()
{
  return new fan.kawhyScene.NativeScene();
}

/////////////////////////
// Events
/////////////////////////

fan.kawhyScene.NativeScene.prototype.mouse = function()
{
  return this.m_mouse;
}

fan.kawhyScene.NativeScene.prototype.handleMove = function(e)
{
  this.m_mouse.pos$(fan.gfx.Point.make(e.clientX, e.clientY));
}

fan.kawhyScene.NativeScene.prototype.handleDown = function(e) { this.handleClick(e, true); }

fan.kawhyScene.NativeScene.prototype.handleUp = function(e) { this.handleClick(e, false); }

fan.kawhyScene.NativeScene.prototype.handleClick = function(e, down)
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
  var slot = fan.kawhyScene.NativeScene.buttonSlot(e);
  var button = slot.get(this.m_mouse);
  button.onClick(down, this.clicks.count);
}

fan.kawhyScene.NativeScene.buttonSlot = function(e)
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
// Factory
/////////////////////////

fan.kawhyScene.NativeScene.prototype.text = function()
{
  var node = new fan.kawhyScene.KYTextNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.group = function()
{
  var node = new fan.kawhyScene.DivNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.scroll = function()
{
  var node = new fan.kawhyScene.KYScrollArea();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.fixed = function()
{
  var node = new fan.kawhyScene.KYFixedNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.checkbox = function()
{
  var node = new fan.kawhyScene.KYCheckBox();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.link = function()
{
  var node = new fan.kawhyScene.KYLink();
  node.init();
  return node;
}

/////////////////////////
// Fields
/////////////////////////

fan.kawhyScene.NativeScene.prototype.root = function() { this.m_root = root; }
fan.kawhyScene.NativeScene.prototype.root$ = function(root)
{
  if (this.m_root)
    document.body.removeChild(this.m_root.m_elem);
  this.m_root = root;
  document.body.appendChild(root.m_elem);
}
fan.kawhyScene.NativeScene.prototype.m_root = null;

fan.kawhyScene.NativeScene.prototype.m_lastClickTime = null;
fan.kawhyScene.NativeScene.prototype.m_lastClickButton = null;