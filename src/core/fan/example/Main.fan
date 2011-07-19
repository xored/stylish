using kawhyMath
using kawhyCss
using fwt

@Js
class Main
{

  static Void main()
  {
    view := StrListView()
    view.style = FontStyle.monospace
    view.insert(Region(0, 1000))
    Container(view).open
  }

}
