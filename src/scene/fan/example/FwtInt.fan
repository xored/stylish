using fwt

@Js
class FwtInt
{

  static Void main()
  {
    Window()
    {
      content = ScenePane
      {
        it.scene = Scene
        {
          root = TextNode { it.text = "Hello world" }
        }
      }
    }.open
  }

}
