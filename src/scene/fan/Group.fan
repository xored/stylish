
@Js
enum class Position
{
  horizontal,
  vertical,
  absolute
}

@Js
class Group : Node
{

  native Void add(Node kid)

  native Void addAll(Node[] kids)

  native Void remove(Node kid)

  native Node kid(Int index)

  native Void removeAll()

  native Bool clip

  native Position position

}
