using kawhyMath
using fwt

@Js
class Main
{

  static Void main()
  {
    view := StrListView()
    view.insert(Region(0, 1000))
    Container(view).open
  }
}
