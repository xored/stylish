
@Js
class ModTextView : SourceView
{

  new make() : super()
  {
    text = TextEdit
    {
      source = TestDoc(10)
    }
  }

  override protected Void attach()
  {
    super.attach()
    onMouseClick |down|
    {
      doc := text.source as TestDoc
      if (down) doc.addLines(10)
      else doc.clicks = doc.clicks + 1
    }
  }

}
