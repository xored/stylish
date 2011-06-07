using fwt
using gfx
using kawhyCss

@Js
class Main
{

  static Void main()
  {
    scene := NativeScene()
    text := scene.text
    text.text = "Some Text"
    text.style = TextStyle { color = Color.yellow; italic = true } + BgStyle(Color.blue)
    echo(text.size)

    group := scene.group
    group.add(text)
    scene.root = group
    echo(text.size)
  }

}
