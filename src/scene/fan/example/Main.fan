
@Js
class Main
{
  static Void main()
  {
    scene := NativeScene()
    text := scene.text
    text.text = "Som Text"
    group := scene.group
    group.add(text);
    scene.root = group;
  }
}
