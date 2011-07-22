using fwt
using gfx
using kawhyCss

@Js
class Main
{

  static Void main()
  {
    scene := Scene()
    scene.mouse.onPos.watch |val| { echo(val) }
    scene.mouse.onLeft.watch |val| { echo("left: $val")  }
    scene.mouse.onRight.watch |val| { echo("right: $val")  }
    scene.mouse.onMiddle.watch |val| { echo("middle: $val")  }

    v := StaticVisualizer(scene)

    total := TextNode()
    total.text = "Total elements: $v.sum"
    v.onSumChange = |Int sum| { total.text = "Total elements: $sum" }

    checkbox := CheckBox()
    checkbox.text = "Filter timestamps"
    checkbox.style = BoxStyle { padding = Insets(5, 0, 5, 0) }
    checkbox.onClick = |Bool check| { v.filtered = check }

    g := Group()
    g.position = Position.vertical
    g.add(total)
    g.add(checkbox)
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
