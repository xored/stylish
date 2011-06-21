using fwt
using gfx
using kawhyCss

@Js
class Main
{

  static Void main()
  {
    scene := NativeScene()
    scene.mouse.on(Mouse#pos).add    { echo(it) }
    scene.mouse.left.on(MouseButton#down).add   { echo("left: $it") }
    scene.mouse.right.on(MouseButton#down).add  { echo("right: $it") }
    scene.mouse.middle.on(MouseButton#down).add { echo("middle: $it") }

    v := StaticVisualizer(scene)

    total := scene.text
    total.text = "Total elements: $v.sum"
    v.onSumChange = |Int sum| { total.text = "Total elements: $sum" }

    checkbox := scene.checkbox()
    checkbox.text = "Filter timestamps"
    checkbox.style = BoxStyle { padding = Insets(5, 0, 5, 0) }
    checkbox.onClick = |Bool check| { v.filtered = check }

    g := scene.group
    g.position = Position.vertical
    g.add(total)
    g.add(checkbox)
    g.add(v.scroll)
    g.style = BoxStyle { padding = Insets(10) }
    scene.root = g
  }

  static Group create(Scene scene)
  {
    group := scene.group
    for(i := 0; i < 10; i++)
    {
      text := scene.text
      text.text = "Text" + i
      group.add(text)
    }
    return group
  }

}
