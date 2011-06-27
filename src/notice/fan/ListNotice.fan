
@Js
mixin ListNotice
{

  abstract Int index()

  abstract Int remove()

  abstract Int add()

}

@Js
const class AddNotice : ListNotice
{

  override const Int index

  const Int size

  new make(Int index, Int size) { this.index = index; this.size = size }

  override Int remove() { 0 }

  override Int add() { size }
}

@Js
const class RemoveNotice : ListNotice
{
  override const Int index

  const Int size

  new make(Int index, Int size) { this.index = index; this.size = size }

  override Int remove() { size }

  override Int add() { 0 }
}
