fan.stylishScene.ClipboardPeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.stylishScene.ClipboardPeer.prototype.$ctor = function(self) {}

fan.stylishScene.ClipboardPeer.prototype.m_textSource = null;
fan.stylishScene.ClipboardPeer.prototype.textSource = function(self) { return this.m_textSource; }
fan.stylishScene.ClipboardPeer.prototype.textSource$ = function(self, source)
{
  this.m_textSource = source;
  this.onSourceChange();
}

fan.stylishScene.ClipboardPeer.prototype.onSourceChange = function() {}
