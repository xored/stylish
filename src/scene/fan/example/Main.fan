using fwt
using gfx
using kawhyCss

@Js
class Main
{

  static Void main()
  {
    scene := Scene()
    scene.mouse.on(Mouse#pos).add |Obj? val->Bool| { echo(val); return true }
    add("left", scene.mouse.left)
    add("right", scene.mouse.right)
    add("middle", scene.mouse.middle)

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

  static Void add(Str name, MouseButton button)
  {
    button.on(MouseButton#down).add |Obj? val->Bool|
    {
      echo("$name: $button.down $button.clicks")
      return true
    }
  }

  static Group create(Scene scene)
  {
    Group
    {
      for(i := 0; i < 10; i++) it.add(TextNode { it.text = "Text" + i })
    }
  }

}
