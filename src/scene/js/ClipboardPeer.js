fan.kawhyScene.ClipboardPeer = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.ClipboardPeer.prototype.$ctor = function(self) {}

fan.kawhyScene.ClipboardPeer.prototype.m_textSource = null;
fan.kawhyScene.ClipboardPeer.prototype.textSource = function(self) { return this.m_textSource; }
fan.kawhyScene.ClipboardPeer.prototype.textSource$ = function(self, source)
{
  this.m_textSource = source;
  this.onSourceChange();
}

fan.kawhyScene.ClipboardPeer.prototype.onSourceChange = function() {}
