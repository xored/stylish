fan.kawhyScene.ScenePanePeer = fan.sys.Obj.$extend(fan.fwt.PanePeer);
fan.kawhyScene.ScenePanePeer.prototype.$ctor = function(self) {}

fan.kawhyScene.ScenePanePeer.prototype.attachTo = function(self, elem)
{
  fan.fwt.WidgetPeer.prototype.attachTo.call(this, self, elem);
  self.m_scene.peer.attach(this.elem);
  self.m_scene.peer.posOnScreen = function(s) { return self.posOnDisplay(); }
  this.relayout = function(s, e)
  {
    s.m_onAttach.call();
    // let's use small JS trick
    s.peer.relayout = fan.fwt.PanePeer.prototype.relayout;
    s.peer.relayout(s, e);
  }
}
