using kawhyMath

@Js
class Main
{

  static Void main()
  {
    view := StrListView()
    view.insert(Region(0, 1000))
    fwt::Window()
    {
      content = ControlPane
      {
        it.control = view
      }
    }.open
  }
}
