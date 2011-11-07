fan.stylishScene.ScenePeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.stylishScene.ScenePeer.prototype.$ctor = function()
{
  this.m_elem = document.createElement("div");
  this.m_elem.id = "scene";
  with (this.m_elem.style)
  {
    position = "absolute";
    cursor = "default";
    left = "0";
    top  = "0";
  }
  this.m_mouse = fan.stylishScene.Mouse.make();
  this.m_keyboard = fan.stylishScene.Keyboard.make();
  this.m_clipboard = fan.stylishScene.Clipboard.make();
  var $this = this;
  this.m_clipboard.peer.onSourceChange = function() { $this.handleTextSource(); }
}

fan.stylishScene.ScenePeer.prototype.mouse     = function(self) { return this.m_mouse;     }
fan.stylishScene.ScenePeer.prototype.keyboard  = function(self) { return this.m_keyboard;  }
fan.stylishScene.ScenePeer.prototype.clipboard = function(self) { return this.m_clipboard; }

fan.stylishScene.ScenePeer.prototype.attach = function(elem)
{
  elem.appendChild(this.m_elem);
  this.m_focusArea = fan.stylishScene.ScenePeer.createFocusArea();
  document.body.appendChild(this.m_focusArea);
  this.attachFocus();
  this.attachMouse();
  this.attachKeyboard();
  this.attachClipboard();
  this.focus();
}

fan.stylishScene.ScenePeer.prototype.detach = function()
{
  document.body.removeChild(this.m_focusArea);
  this.m_elem.parentNode.removeChild(this.m_elem);
  this.removeListeners();
}

/////////////////////////
// Mouse
/////////////////////////

fan.stylishScene.ScenePeer.prototype.attachMouse = function()
{
  var $this = this;
  this.addListener(window, "mousemove",  function(e) { return $this.handleMove(e);  });
  this.addListener(window, "mousedown",  function(e) { return $this.handleDown(e);  });
  this.addListener(window, "mouseup",    function(e) { return $this.handleUp(e);    });
  this.addListener(window, "mousewheel", function(e) { return $this.handleWheel(e); });
}

fan.stylishScene.ScenePeer.prototype.handleMove = function(e)
{
  var p = fan.gfx.Point.make(e.clientX, e.clientY);
  if (this.m_mouse.pushPos(p)) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.prototype.handleDown = function(e)
{
  if (this.handleClick(e, true)) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.prototype.handleUp = function(e)
{
  if (this.handleClick(e, false)) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.prototype.handleClick = function(e, down)
{
  var mouse = this.m_mouse;
  switch (e.button)
  {
    case 0: return mouse.pushLeft(down);
    case 1: return mouse.pushMiddle(down);
    case 2: return mouse.pushRight(down);
  }
  return false;
}

fan.stylishScene.ScenePeer.prototype.handleWheel = function(e)
{
  var p = fan.stylishScene.ScenePeer.toWheelDelta(e);
  if (this.m_mouse.m_onWheel.push(p)) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.toWheelDelta = function(e)
{
  var wx = 0;
  var wy = 0;

  if (e.wheelDeltaX != null)
  {
    // WebKit
    wx = -e.wheelDeltaX;
    wy = -e.wheelDeltaY;

    // Safari
    if (wx % 40 == 0) wx = wx / 40;
    if (wy % 40 == 0) wy = wy / 40;
  }
  else if (e.wheelDelta != null)
  {
    // IE
    wy = -e.wheelDelta;
    if (wy % 40 == 0) wy = wy / 40;
  }
  else if (e.detail != null)
  {
    // Firefox
    wx = e.axis == 1 ? e.detail : 0;
    wy = e.axis == 2 ? e.detail : 0;
  }

  // make sure we have ints and return
  wx = wx > 0 ? Math.ceil(wx) : Math.floor(wx);
  wy = wy > 0 ? Math.ceil(wy) : Math.floor(wy);
  return fan.gfx.Point.make(wx, wy);
}

/////////////////////////
// Focus
/////////////////////////

fan.stylishScene.ScenePeer.prototype.focus = function()
{
  var area = this.m_focusArea;
  if (area != null && area !== document.activeElement) area.focus();
}

fan.stylishScene.ScenePeer.prototype.attachFocus = function()
{
  var area = this.m_focusArea;
  var $this = this;
  this.addListener(area, "focus", function() { return $this.handleFocus(true);  });
  this.addListener(area, "blur",  function() { return $this.handleFocus(false); });
}

fan.stylishScene.ScenePeer.prototype.handleFocus = function(focus)
{
  //do nothing for now
  return true;
}

/////////////////////////
// Keyboard
/////////////////////////

fan.stylishScene.ScenePeer.prototype.attachKeyboard = function()
{
  var area = this.m_focusArea;
  var $this = this;
  this.addListener(area, "keydown",  function(e) { return $this.handleKeyDown(e);  });
  this.addListener(area, "keyup",    function(e) { return $this.handleKeyUp(e);    });
  this.addListener(area, "keypress", function(e) { return $this.handleKeyPress(e); });
}

fan.stylishScene.ScenePeer.prototype.handleKeyDown = function(e)
{
  this.m_modifiers = fan.stylishScene.ScenePeer.modifiers(e);
  this.m_key = fan.stylishScene.ScenePeer.key(e);
  if (this.m_keyboard.onKey(this.m_modifiers.plus(this.m_key))) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.prototype.handleKeyPress = function(e)
{
  var mdfs = fan.stylishScene.ScenePeer.modifiers(e);
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
  if (this.m_keyboard.onChar(this.m_char)) this.preventDefault(e);
}

fan.stylishScene.ScenePeer.prototype.handleKeyUp = function(e)
{
  var modifiers = fan.stylishScene.ScenePeer.modifiers(e);
  // on mac when we press command+<key> and then release <key> no key up event occur.
  // When command will be released we need to update key
  if (fan.fwt.DesktopPeer.$isMac && this.m_modifiers.isCommand() && !modifiers.isCommand())
  {
    this.m_modifiers = modifiers;
    this.m_key = fan.stylishScene.ScenePeer.key(e);
    this.m_char = fan.stylishScene.ScenePeer.char(e);
    return this.m_keyboard.onKeyChar(modifiers.plus(this.m_key), this.m_char);
  }
  // handle key modifier up
  var keyModifier = fan.stylishScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) modifiers = fan.stylishUtil.KeyUtil.remove(modifiers, keyModifier);
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

fan.stylishScene.ScenePeer.key = function(e)
{
  var key = e.keyCode;
  if (!key) return fan.fwt.Key.m_none;

  // modifiers will be handled separately
  var keyModifier = fan.stylishScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) return fan.fwt.Key.m_none;

  if (key >= 65 && key <= 90)
    return fan.fwt.Key.fromMask(e.keyCode + 32);

  switch (key)
  {
    case 8:  return fan.fwt.Key.m_backspace;
    case 9:  return fan.fwt.Key.m_tab;
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
    // F1-F12
    case 112: return fan.fwt.Key.m_f1;
    case 113: return fan.fwt.Key.m_f2;
    case 114: return fan.fwt.Key.m_f3;
    case 115: return fan.fwt.Key.m_f4;
    case 116: return fan.fwt.Key.m_f5;
    case 117: return fan.fwt.Key.m_f6;
    case 118: return fan.fwt.Key.m_f7;
    case 119: return fan.fwt.Key.m_f8;
    case 120: return fan.fwt.Key.m_f9;
    case 121: return fan.fwt.Key.m_f10;
    case 122: return fan.fwt.Key.m_f11;
    case 123: return fan.fwt.Key.m_f12;
    default: return fan.fwt.Key.fromMask(e.keyCode);
  }
}

fan.stylishScene.ScenePeer.modifiers = function(e)
{
  var modifiers = fan.fwt.Key.m_none;
  if (e.shiftKey) modifiers = modifiers.plus(fan.fwt.Key.m_shift);
  if (e.ctrlKey)  modifiers = modifiers.plus(fan.fwt.Key.m_ctrl);
  if (e.altKey)   modifiers = modifiers.plus(fan.fwt.Key.m_alt);
  if (e.metaKey)  modifiers = modifiers.plus(fan.fwt.Key.m_command);

  var keyModifier = fan.stylishScene.ScenePeer.keyModifier(e);
  if (keyModifier != null) modifiers = modifiers.plus(keyModifier);
  return modifiers;
}

fan.stylishScene.ScenePeer.keyModifier = function(e)
{
  var code = e.keyCode;
  var metaKeyHandler = fan.stylishScene.ScenePeer.getMetaKeyHandler();

  if (metaKeyHandler(code)) return fan.fwt.Key.m_command;
  switch (code)
  {
    case 16: return fan.fwt.Key.m_shift;
    case 17: return fan.fwt.Key.m_ctrl;
    case 18: return fan.fwt.Key.m_alt;
    default: return null;
  }
}

fan.stylishScene.ScenePeer.getMetaKeyHandler = function()
{
  var handler = fan.stylishScene.ScenePeer.metaKeyHandler;
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
    fan.stylishScene.ScenePeer.metaKeyHandler = handler;
  }
  return handler;
}

fan.stylishScene.ScenePeer.metaKeyHandler = null;
fan.stylishScene.ScenePeer.prototype.m_char      = null;
fan.stylishScene.ScenePeer.prototype.m_key       = fan.fwt.Key.m_none;
fan.stylishScene.ScenePeer.prototype.m_modifiers = fan.fwt.Key.m_none;

/////////////////////////
// Clipboard
/////////////////////////

fan.stylishScene.ScenePeer.prototype.attachClipboard = function()
{
  var $this = this;
  this.addListener(this.m_focusArea, "copy", function(e) { return $this.handleCopy(e);  });
}

fan.stylishScene.ScenePeer.prototype.handleTextSource = function()
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

fan.stylishScene.ScenePeer.prototype.m_textSource = null;

fan.stylishScene.ScenePeer.prototype.handleCopy = function(e)
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

fan.stylishScene.ScenePeer.prototype.root = function(self) { return this.m_root; }
fan.stylishScene.ScenePeer.prototype.root$ = function(self, root)
{
  this.m_root = root;
  this.m_elem.appendChild(root.peer.m_elem);
  root.peer.m_scene = self;
}
fan.stylishScene.ScenePeer.prototype.m_root = null;

fan.stylishScene.ScenePeer.prototype.posOnScreen = function(self)
{
  return fan.gfx.Point.m_defVal;
}

fan.stylishScene.ScenePeer.prototype.m_elem = null;
fan.stylishScene.ScenePeer.prototype.m_focusArea = null;

/////////////////////////
// Utils
/////////////////////////

fan.stylishScene.ScenePeer.prototype.preventDefault = function(e)
{
  e.stopPropagation();
  e.preventDefault();
}

fan.stylishScene.ScenePeer.prototype.addListener = function(t, e, f)
{
  var listener = { target: t, event: e, func: f };
  this.listeners.push(listener);
  t.addEventListener(e, f, false);
}

fan.stylishScene.ScenePeer.prototype.removeListeners = function()
{
  var listeners = this.listeners;
  while(listeners.length > 0)
  {
    var l = listeners.pop();
    l.t.removeEventListener(l.e, l.f, false);
  }
}

fan.stylishScene.ScenePeer.prototype.listeners = [];

fan.stylishScene.ScenePeer.createFocusArea = function()
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
