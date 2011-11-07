fan.stylishScene.ShapePeer = fan.sys.Obj.$extend(fan.stylishScene.NodePeer);
fan.stylishScene.ShapePeer.prototype.$ctor = function(self) { this.init(self); }

fan.stylishScene.ShapePeer.prototype.create = function()
{
  return document.createElement("canvas");
}

fan.stylishScene.ShapePeer.prototype.figures = function(self)
{
  if (this.m_figures == null)
    this.m_figures = fan.sys.List.make(fan.stylishScene.Figure.$type);
  return this.m_figures;
}

fan.stylishScene.ShapePeer.prototype.figures$ = function(self, figures)
{
  this.m_figures = figures;
  this.draw();
}
fan.stylishScene.ShapePeer.prototype.m_figures = null;

fan.stylishScene.ShapePeer.prototype.draw = function()
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

fan.stylishScene.ShapePeer.prototype.size$ = function(self, size)
{
  fan.stylishScene.NodePeer.prototype.size$.call(this, self, size);
  this.m_elem.width = size.m_w;
  this.m_elem.height = size.m_h;
}
