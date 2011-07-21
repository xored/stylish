using kawhy
using kawhyNotice

@Js
abstract class Ruler : Control
{

  Int width { protected set { &width = it; onWidth.push(it) } }

  Notice onWidth := Notice()

  override Void attach()
  {
    text = (parent as SourceView).text
  }

  protected TextEdit? text

}
