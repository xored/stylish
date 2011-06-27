
@Js
const class StrNotice : ListNotice
{

  new make(Int index, Int remove, Str insert)
  {
    this.index = index
    this.remove = remove
    this.insert = insert
  }

  override const Int index

  override const Int remove

  override Int add() { insert.size }

  const Str insert

}
