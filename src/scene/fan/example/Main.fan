using fwt
using gfx
using stylishCss

@Js
class Main
{

  static Void main()
  {
    scene := Scene()
    scene.mouse.onPos.watch |val| { echo(val) }
    scene.mouse.onRight.watch |val| { echo("right: $val")  }
    scene.mouse.onMiddle.watch |val| { echo("middle: $val")  }
    scene.mouse.onWheel.watch |val| { echo("wheel: $val")  }

    v := StaticVisualizer(scene)

    total := TextNode()
    total.text = "Total elements: $v.sum"
    v.onSumChange = |Int sum| { total.text = "Total elements: $sum" }

    checkbox := CheckBox()
    checkbox.text = "Filter timestamps"
    checkbox.style = BoxStyle { padding = Insets(5, 0, 5, 0) }
    checkbox.onClick = |Bool check| { v.filtered = check }

    shape := Shape()
    shape.size = Size(100, 100)
    shape.figures = 
    [
      Polyline { points = [Point(50, 30), Point(60, 0), Point(70, 30)]; brush = Color.blue },
      Polygon  { points = [Point(10, 10), Point(40, 10), Point(40, 40), Point(10, 40)]; brush = Color.red }
    ]

    scene.mouse.onLeft.watch |val|
    {
      echo("left: $val")
      fs := shape.figures
      shape.figures = fs
    }

    g := Group()
    g.position = Position.vertical
    g.add(total)
    g.add(checkbox)
    g.add(shape)
    g.add(v.scroll)
    g.style = BoxStyle { padding = Insets(10) }
    scene.root = g

    Window()
    {
      content = ScenePane(scene)
    }.open
  }

  static Group create(Scene scene)
  {
    Group
    {
      for(i := 0; i < 10; i++) it.add(TextNode { it.text = "Text" + i })
    }
  }

}
