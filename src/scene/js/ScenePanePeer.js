fan.stylishScene.ScenePanePeer = fan.sys.Obj.$extend(fan.fwt.PanePeer);
fan.stylishScene.ScenePanePeer.prototype.$ctor = function(self) {}

fan.stylishScene.ScenePanePeer.prototype.doAttach = function(self)
{
  self.m_scene.peer.attach(this.elem);
  self.m_scene.peer.posOnScreen = function(s) { return self.posOnDisplay(); }
}
