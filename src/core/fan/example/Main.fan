using stylishMath
using stylishCss
using fwt

@Js
class Main
{

  static Void main()
  {
    view := StrListView()
    view.style = FontStyle.monospace + PropertyStyle(["hello":"world"])
    view.insert(Region(0, 1000))

    Container(view).open
  }

}
