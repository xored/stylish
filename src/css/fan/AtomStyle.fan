
@Js
const abstract class AtomStyle: Style
{

  override AtomStyle[] atomize() { [this] }

  abstract AtomStyle mergeSame(AtomStyle s)

  protected abstract Int priority()

  override Int compare(Obj that)
  {
    diff := priority - (that as AtomStyle).priority
    if (diff != 0) return diff
    return typeof.name <=> that.typeof.name
  }

}
