fan.kawhyScene.ShapePeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.ShapePeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.ShapePeer.prototype.create = function()
{
  return document.createElement("canvas");
}

fan.kawhyScene.ShapePeer.prototype.figures = function(self)
{
  if (this.m_figures == null)
    this.m_figures = fan.sys.List.make(fan.kawhyScene.Figure.$type);
  return this.m_figures;
}

fan.kawhyScene.ShapePeer.prototype.figures$ = function(self, figures)
{
  this.m_figures = figures;
  this.draw();
}
fan.kawhyScene.ShapePeer.prototype.m_figures = null;

fan.kawhyScene.ShapePeer.prototype.draw = function()
{
  var g = new fan.fwt.Graphics();
  var figures = this.figures();
  var bounds = fan.gfx.Rect.makePosSize(fan.gfx.Point.m_defVal, this.size());
  g.paint(this.m_elem, bounds, function()
  {
    for(var i = 0; i < figures.size(); i++)
    {
      g.push();
      figures.get(i).draw(g);
      g.pop();
    }
  });
}

fan.kawhyScene.ShapePeer.prototype.size$ = function(self, size)
{
  fan.kawhyScene.NodePeer.prototype.size$.call(this, self, size);
  this.m_elem.width = size.m_w;
  this.m_elem.height = size.m_h;
}
