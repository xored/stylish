using gfx

@Js
class Shape : Node
{

  native Figure[] figures

}

@Js
const mixin Figure
{

  abstract Void draw(Graphics g)

}

@Js
abstract const class Points : Figure
{

  const Point[] points := [,]

  const Brush brush := Color.black

  new make(|This|? f := null) { f?.call(this) }

}

@Js
const class Polygon : Points
{

  new make(|This|? f := null) : super() { f?.call(this) }

  override Void draw(Graphics g)
  {
    g.brush = brush
    g.fillPolygon(points)
  }

}

@Js
const class Polyline : Points
{

  const Pen pen := Pen.defVal

  new make(|This|? f := null) : super() { f?.call(this) }

  override Void draw(Graphics g)
  {
    g.brush = brush
    g.pen = pen
    g.drawPolyline(points)
  }

}
