using gfx
using kawhyCss

@Js
class Node
{

  native Point pos

  native Size size

  native Style? style

  Str:Obj data := [:]

}
