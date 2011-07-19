fan.kawhyScene.ScenePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.ScenePeer.prototype.$ctor = function()
{
  this.m_elem = document.createElement("div");
  this.m_elem.id = "scene";
  this.m_elem.style.position = "absolute";
  with (this.m_elem.style)
  {
    position = "absolute";
    left = "0";
    top  = "0";
  }
  this.m_mouse = fan.kawhyScene.Mouse.make();
  this.m_keyboard = fan.kawhyScene.Keyboard.make();
  this.m_clipboard = fan.kawhyScene.Clipboard.make();
  var $this = this;
  this.m_clipboard.peer.onSourceChange = function() { $this.handleTextSource(); }
}

fan.kawhyScene.ScenePeer.prototype.mouse     = function(self) { return this.m_mouse;     }
fan.kawhyScene.ScenePeer.prototype.keyboard  = function(self) { return this.m_keyboard;  }
fan.kawhyScene.ScenePeer.prototype.clipboard = function(self) { return this.m_clipboard; }

fan.kawhyScene.ScenePeer.prototype.attach = function(elem)
{
  elem.appendChild(this.m_elem);
  this.m_focusArea = fan.kawhyScene.ScenePeer.createFocusArea();
  document.body.appendChild(this.m_focusArea);
  this.attachFocus();
  this.attachMouse();
  this.attachKeyboard();
  this.attachClipboard();
  this.focus();
}

fan.kawhyScene.ScenePeer.prototype.detach = function()
{
  document.body.removeChild(this.m_focusArea);
  this.m_elem.parentNode.removeChild(this.m_elem);
  this.removeListeners();
}

/////////////////////////
// Mouse
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.attachMouse = function()
{
  var $this = this;
  this.addListener(window, "mousemove", function(e) { return $this.handleMove(e); });
  this.addListener(window, "mousedown", function(e) { return $this.handleDown(e); });
  this.addListener(window, "mouseup",   function(e) { return $this.handleUp(e);   });
}

fan.kawhyScene.ScenePeer.prototype.handleMove = function(e)
{
  this.m_mouse.pos$(fan.gfx.Point.make(e.clientX, e.clientY));
  return this.preventDefault(e);
}

fan.kawhyScene.ScenePeer.prototype.handleDown = function(e)
{
  this.handleClick(e, true);
  return this.preventDefault(e);
}

fan.kawhyScene.ScenePeer.prototype.handleUp = function(e)
{
  this.handleClick(e, false);
  return this.preventDefault(e);
}

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

fan.kawhyScene.ScenePeer.prototype.m_lastClickTime = null;
fan.kawhyScene.ScenePeer.prototype.m_lastClickButton = null;

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
// Focus
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.focus = function()
{
  var area = this.m_focusArea;
  if (area != null && area !== document.activeElement) area.focus();
}

fan.kawhyScene.ScenePeer.prototype.attachFocus = function()
{
  var area = this.m_focusArea;
  var $this = this;
  this.addListener(area, "focus", function() { return $this.handleFocus(true);  });
  this.addListener(area, "blur",  function() { return $this.handleFocus(false); });
}

fan.kawhyScene.ScenePeer.prototype.handleFocus = function(focus)
{
  //do nothing for now
  return true;
}

/////////////////////////
// Keyboard
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.attachKeyboard = function()
{
  var area = this.m_focusArea;
  var $this = this;
  this.addListener(area, "keydown",  function(e) { return $this.handleKeyDown(e);  });
  this.addListener(area, "keyup",    function(e) { return $this.handleKeyUp(e);    });
  this.addListener(area, "keypress", function(e) { return $this.handleKeyPress(e); });
}

fan.kawhyScene.ScenePeer.prototype.handleKeyDown = function(e)
{
  this.m_modifiers = fan.kawhyScene.ScenePeer.modifiers(e);
  this.m_key = fan.kawhyScene.ScenePeer.key(e);
  return this.m_keyboard.onKey(this.m_modifiers.plus(this.m_key));
}

fan.kawhyScene.ScenePeer.prototype.handleKeyPress = function(e)
{
  var mdfs = fan.kawhyScene.ScenePeer.modifiers(e);
  if (fan.fwt.DesktopPeer.$isMac)
  {
    if (!mdfs.isCtrl() && !mdfs.isAlt() && mdfs.isCommand()) return false;
  }
  else
  {
    if (!fan.sys.ObjUtil.equals(mdfs, fan.fwt.Key.m_shift) &&
        !fan.sys.ObjUtil.equals(mdfs, fan.fwt.Key.m_none) &&
        !(mdfs.isAlt() && mdfs.isCtrl())) return false
  }
  this.m_char = e.which;
  return this.m_keyboard.onChar(this.m_char);
}

fan.kawhyScene.ScenePeer.prototype.handleKeyUp = function(e)
{
  var modifiers = fan.kawhyScene.ScenePeer.modifiers(e);
  // on mac when we press command+<key> and then release <key> no key up event occur.
  // When command will be released we need to update key
  if (fan.fwt.DesktopPeer.$isMac && this.m_modifiers.isCommand() && !modifiers.isCommand())
  {
    this.m_modifiers = modifiers;
    this.m_key = fan.kawhyScene.ScenePeer.key(e);
    this.m_char = fan.kawhyScene.ScenePeer.char(e);
    return this.m_keyboard.onKeyChar(modifiers.plus(this.m_key), this.m_char);
  }
  // handle key modifier up
  var keyModifier = fan.kawhyScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) modifiers = fan.kawhyUtil.KeyUtil.remove(modifiers, keyModifier);
  if (!fan.sys.ObjUtil.equals(modifiers, this.m_modifiers))
  {
    // only modifiers was changed
    this.m_modifiers = modifiers;
    return this.m_keyboard.onKey(modifiers.plus(this.m_key));
  }
  // no changes in modifiers -> base key was released
  this.m_key = fan.fwt.Key.m_none;
  this.m_char = null;
  return this.m_keyboard.onKeyChar(modifiers.plus(this.m_key), null);
}

fan.kawhyScene.ScenePeer.key = function(e)
{
  var key = e.keyCode;
  if (!key) return fan.fwt.Key.m_none;

  // modifiers will be handled separately
  var keyModifier = fan.kawhyScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) return fan.fwt.Key.m_none;

  if (key >= 65 && key <= 90)
    return fan.fwt.Key.fromMask(e.keyCode + 32);

  switch (key)
  {
    case 8:  return fan.fwt.Key.m_backspace;
    // keys
    case 32: return fan.fwt.Key.m_space;
    case 33: return fan.fwt.Key.m_pageUp;
    case 34: return fan.fwt.Key.m_pageDown;
    case 35: return fan.fwt.Key.m_end;
    case 36: return fan.fwt.Key.m_home;
    case 37: return fan.fwt.Key.m_left;
    case 38: return fan.fwt.Key.m_up;
    case 39: return fan.fwt.Key.m_right;
    case 40: return fan.fwt.Key.m_down;
    case 45: return fan.fwt.Key.m_insert;
    case 46: return fan.fwt.Key.m_$delete;
    default: return fan.fwt.Key.fromMask(e.keyCode);
  }
}

fan.kawhyScene.ScenePeer.modifiers = function(e)
{
  var modifiers = fan.fwt.Key.m_none;
  if (e.shiftKey) modifiers = modifiers.plus(fan.fwt.Key.m_shift);
  if (e.ctrlKey)  modifiers = modifiers.plus(fan.fwt.Key.m_ctrl);
  if (e.altKey)   modifiers = modifiers.plus(fan.fwt.Key.m_alt);
  if (e.metaKey)  modifiers = modifiers.plus(fan.fwt.Key.m_command);

  var keyModifier = fan.kawhyScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) modifiers = modifiers.plus(keyModifier);
  return modifiers;
}

fan.kawhyScene.ScenePeer.keyModifier = function(e)
{
  var code = e.keyCode;
  var metaKeyHandler = fan.kawhyScene.ScenePeer.getMetaKeyHandler();

  if (metaKeyHandler(code)) return fan.fwt.Key.m_command;
  switch (code)
  {
    case 16: return fan.fwt.Key.m_shift;
    case 17: return fan.fwt.Key.m_ctrl;
    case 18: return fan.fwt.Key.m_alt;
    default: return null;
  }
}

fan.kawhyScene.ScenePeer.getMetaKeyHandler = function()
{
  var handler = fan.kawhyScene.ScenePeer.metaKeyHandler;
  if (handler == null)
  {
    if (!fan.fwt.DesktopPeer.$isMac)
      handler = function(k) { return false; };
    else
    {
      if (fan.fwt.DesktopPeer.$isFirefox)
        handler = function(k) { return k == 224 };
      else if (fan.fwt.DesktopPeer.$isOpera)
        handler = function(k) { return k == 17 };
      else
        handler = function(k) { return k == 91 || k == 93 };
    }
    fan.kawhyScene.ScenePeer.metaKeyHandler = handler;
  }
  return handler;
}

fan.kawhyScene.ScenePeer.metaKeyHandler = null;
fan.kawhyScene.ScenePeer.prototype.m_char      = null;
fan.kawhyScene.ScenePeer.prototype.m_key       = fan.fwt.Key.m_none;
fan.kawhyScene.ScenePeer.prototype.m_modifiers = fan.fwt.Key.m_none;

/////////////////////////
// Clipboard
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.attachClipboard = function()
{
  var $this = this;
  this.addListener(this.m_focusArea, "copy", function(e) { return $this.handleCopy(e);  });
}

fan.kawhyScene.ScenePeer.prototype.handleTextSource = function()
{
  if (this.m_textSource)
  {
    this.m_textSource.m_onChange = null;
    this.m_textSource = null;
  }
  var source = this.m_clipboard.textSource();
  if (source)
  {
    this.m_textSource = source;
    var $this = this;
    var f = function()
    {
      var area = $this.m_focusArea;
      if (!source.isEmpty())
      {
        area.value = "Copy to clipboard is not supported for this browser";
        area.select();
      }
      else area.value = "";
    }
    this.m_textSource.m_onChange = fan.sys.Func.make(fan.sys.List.make(fan.sys.Param.$type), fan.sys.Obj.$type.toNullable(), f);
  }
}

fan.kawhyScene.ScenePeer.prototype.m_textSource = null;

fan.kawhyScene.ScenePeer.prototype.handleCopy = function(e)
{
  var source = this.m_clipboard.textSource();
  if (source)
  {
    var area = this.m_focusArea;
    area.value = source.text();
    area.select();
  }
}

/////////////////////////
// Fields
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.root = function(self) { return this.m_root; }
fan.kawhyScene.ScenePeer.prototype.root$ = function(self, root)
{
  this.m_root = root;
  this.m_elem.appendChild(root.peer.m_elem);
  root.peer.m_scene = self;
}
fan.kawhyScene.ScenePeer.prototype.m_root = null;

fan.kawhyScene.ScenePeer.prototype.posOnScreen = function(self)
{
  return fan.gfx.Point.m_defVal;
}

fan.kawhyScene.ScenePeer.prototype.m_elem = null;
fan.kawhyScene.ScenePeer.prototype.m_focusArea = null;

/////////////////////////
// Utils
/////////////////////////

fan.kawhyScene.ScenePeer.prototype.preventDefault = function(e)
{
  // prevent bubbling
  e.stopPropagation();
  if (e.preventDefault) e.preventDefault();
  e.returnValue = false; //  IE
  return false;
}

fan.kawhyScene.ScenePeer.prototype.addListener = function(t, e, f)
{
  var listener = { target: t, event: e, func: f };
  this.listeners.push(listener);
  t.addEventListener(e, f, false);
}

fan.kawhyScene.ScenePeer.prototype.removeListeners = function()
{
  var listeners = this.listeners;
  while(listeners.length > 0)
  {
    var l = listeners.pop();
    l.t.removeEventListener(l.e, l.f, false);
  }
}

fan.kawhyScene.ScenePeer.prototype.listeners = [];

fan.kawhyScene.ScenePeer.createFocusArea = function()
{
  var elem = document.createElement("textarea");
  with (elem.style)
  {
    position = "absolute";
    zIndex = "-999";
    visible = "false";
    left = "-1000000px";
    top = "-1000000px";
  }
  elem.tabindex = -1;
  return elem;
}
