using kawhyMath
using kawhyNotice
using kawhyScene

@Js
class StrListView : ListView
{

  override protected Void attach()
  {
    node.add(content)
    super.attach()
  }

  Void insert(Region r)
  {
    listContent.insert(r.start, r.size)
  }

  Void remove(Region r)
  {
    listContent.remove(r.start, r.size)
  }

  override protected ListNotifier source() { listContent }

  override protected Node createItem(Int i)
  {
    TextNode { text = "item num $i" }
  }

  private StrListViewContent listContent := StrListViewContent()

}

@Js
class StrListViewContent : ListNotifier
{

  Void insert(Int i, Int size)
  {
    this.size = this.size + size
    fire(AddNotice(i, size))
  }

  Void remove(Int i, Int size)
  {
    this.size = this.size - size
    fire(RemoveNotice(i, size))
  }

  override Int size { private set }

  override protected ListListener[] listeners := [,]

}
