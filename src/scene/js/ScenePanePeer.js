fan.kawhyScene.ScenePanePeer = fan.sys.Obj.$extend(fan.fwt.PanePeer);
fan.kawhyScene.ScenePanePeer.prototype.$ctor = function(self) {}

fan.kawhyScene.ScenePanePeer.prototype.m_scene = null;
fan.kawhyScene.ScenePanePeer.prototype.scene = function(self) { return this.m_scene; }
fan.kawhyScene.ScenePanePeer.prototype.scene$ = function(self, scene) { this.m_scene = scene; }

fan.kawhyScene.ScenePanePeer.prototype.attachTo = function(self, elem)
{
  fan.fwt.WidgetPeer.prototype.attachTo.call(this, self, elem);
  if (this.m_scene != null)
  {
    var root = this.m_scene.root();
    if (root != null)
    {
      this.elem.appendChild(root.peer.m_elem);
      this.relayout = function(s, e)
      {
        s.m_onAttach.call();
        // let's use small JS trick
        s.peer.relayout = fan.fwt.PanePeer.prototype.relayout;
        s.peer.relayout(s, e);
      }
    }
  }
}
