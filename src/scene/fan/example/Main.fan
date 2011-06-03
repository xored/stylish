using fwt
using gfx

@Js
class Main
{
  static Void main()
  {
    scene := NativeScene()
    text := scene.text
    text.font = Desktop.sysFontMonospace()
    text.text = "Some Text"
    echo(text.size)
    group := scene.group
    group.add(text)
    scene.root = group
  }
}
