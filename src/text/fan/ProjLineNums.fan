**
** Ruler with line numbers, that works in respect to `kawhyText:rojDoc`.
** It may be attached only to source view, which text model inherits `kawhyText:rojDoc`,
** otherwise an error will occur during attaching.
**
@Js
class ProjLineNums : LineNums
{

  private ProjDoc? doc

  new make(|This|? f := null) : super(f) {}

  override protected Int lineNum(Int index) { doc != null ? doc.toMasterLine(index) + 1 : super.lineNum(index) }

  override Void attach()
  {
    super.attach
    if (text.source as ProjDoc == null)
      throw Err("Unable to attach to text edit without ProjDoc.")
    doc = (ProjDoc)text.source
  }

}