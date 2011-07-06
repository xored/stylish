using fwt

@Js
class FwtInt
{

  static Void main()
  {
    Window()
    {
      content = ScenePane(Scene
      {
        root = TextNode { it.text = "Hello world" }
      })
    }.open
  }

}
