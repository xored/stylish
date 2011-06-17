
@Js
mixin Group : Node
{

  abstract Void add(Node kid)

  abstract Void remove(Node kid)

  abstract Void removeAll()

  abstract Position position

}

@Js
enum class Position
{
  horizontal,
  vertical,
  absolute
}
