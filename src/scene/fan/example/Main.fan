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
    add("left", scene.mouse.left)
    add("right", scene.mouse.right)
    add("middle", scene.mouse.middle)

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

  static Void test1()
  {
    text := ""
    size := 0
    n1 := DateTime.now()
    for(i := 0; i < 50000; i++)
    {
      text += "add"
      size += 3
      text = text.getRange(0..-2)
      size -= 1
    }
    n2 := DateTime.now()
    echo(size.toStr + " for " + (n2 - n1))
  }

  static Void test2()
  {
    text := TextNotifier()
    l := TextListener()
    text.listen(l)
    n1 := DateTime.now()
    for(i := 0; i < 50000; i++)
    {
      text.add("add")
      text.remove(1)
    }
    n2 := DateTime.now()
    echo(l.size.toStr + " for " + (n2 - n1))
  }

  static Void add(Str name, MouseButton button)
  {
    button.on(MouseButton#down).add
    {
      echo("$name: $button.down $button.clicks")
    }
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
