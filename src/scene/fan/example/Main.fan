using fwt
using gfx

@Js
class Main
{

  static Void main()
  {
    scene := NativeScene()
    text := scene.text
    text.text = "Some Text"
    echo(text.size)
    group := scene.group
    group.add(text)
    scene.root = group
    echo(text.size)
  }

}
