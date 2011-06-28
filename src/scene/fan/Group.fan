
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

  native Void remove(Node kid)

  native Void removeAll()

  native Position position

}
