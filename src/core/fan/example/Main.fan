@Js
class Main
{
  static Void main()
  {
    fwt::Window()
    {
      content = ControlPane
      {
        it.control = Label { text = "Some text here" }
      }
    }.open
  }
}
