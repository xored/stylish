using gfx

class StyleListTest : Test
{

  Void testReplace()
  {
    a := BgStyle(Color.red)
    b := BgStyle(Color.blue)
    c := BgStyle(Color.green)
    d := BgStyle(Color.white)
    list := StyleList([StyleRange(a, 1..2), StyleRange(b, 5..7), StyleRange(c, 10..10)])
    echo(list.replace(0, 0, 0, null))
    echo(list.replace(2, 5, 2, d))
    echo(list.replace(1, 2, 0, null))
    echo(list.replace(5, 3, 3, null))
    echo(list.replace(0, 11, 5, d))
  }

}
