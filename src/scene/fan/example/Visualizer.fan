using gfx
using kawhyCss

@Js
abstract class Visualizer
{

  new make(Scene scene)
  {
    this.scene = scene
    scroll = ScrollArea()
    scroll.position = Position.absolute
    scroll.style = FontStyle(FontStyle.monospace.name, 16)
    scroll.size = Size(scrollWidth, scrollHeight)
    scroll.onScroll = |Point s|
    {
      updateVisible()
      onSumChange(sum)
    }

    content = Group()
    content.size = Size(600, lineCount * lineSize)
    content.position = Position.absolute
    scroll.add(content)

    createElements(0..(scrollHeight / lineSize - 1))
  }

  Bool filtered := false
  {
    set
    {
      &filtered = it
      recreate()
      onSumChange(sum)
    }
  }

  abstract Void recreate()

  protected Void updateVisible()
  {
    firstLine := scroll.scroll.y / lineSize
    lineCount := scroll.clientArea.h / lineSize
    createElements(firstLine..firstLine+lineCount)
  }

  abstract Void createElements(Range lines)

  protected Void removeAll()
  {
    sum = 0
    content.removeAll()
  }

  protected Void remove(Node kid)
  {
    sum--
    content.remove(kid)
  }

  protected Node createElement(Int line)
  {
    sum++
    group := Group()
    group.position = Position.horizontal

    styles := StyleRange[,]
    text := "$line".justl(6)
    offset := 6
    styles.add(StyleRange(TextStyle { color = Color(0x808080) }, 0..5))

    if ((line + 1) % 10 == 0)
    {
      group.add(TextNode() { it.text = text; it.styles = styles })
      group.add(Link() { link = "http://google.com"; it.text = "ssr-server2:" })
      text = ""
      styles = [,]
      offset = 0
    }
    else
    {
      text += "ssr-server2:"
      styles.add(StyleRange(TextStyle { color = Color.orange }, offset..<text.size))
      offset = text.size
    }

    if (!filtered)
    {
      text += " 2009-09-22T06:59:28: "
      styles.add(StyleRange(TextStyle { color = Color.blue }, offset..<text.size))
      offset = text.size
    }
    text += "%autoeasy-5-NOTICE: %[pname=TRP--mode,linenum=1]: *** testbed-AAA-IOU-SSR2-con.log.00001 ***"
    group.add(TextNode() { it.text = text; it.styles = styles })
    group.pos = Point(0, line * lineSize)
    content.add(group)
    return group
  }

  protected Int lineSize := 18
  protected Int lineCount := 30000
  protected Int scrollHeight := 800
  protected Int scrollWidth := 1600

  Int sum := 0 { private set }

  ScrollArea scroll { private set }

  |Int| onSumChange := |Int sum| {}

  private Group content { private set }

  private Scene scene

}

@Js
class DynamicVisualizer : Visualizer
{

  new make(Scene scene) : super(scene) {}

  override Void createElements(Range lines)
  {
    lines = lines.start..lines.end.min(lineCount - 1)
    removeAll()
    lines.each { kids.add(createElement(it)) }
  }

  override Void recreate()
  {
    updateVisible()
  }

  protected Node[] kids := [,]

}

@Js
class StaticVisualizer : Visualizer
{

  new make(Scene scene) : super(scene) { }

  override Void recreate()
  {
    for(i := 0; i < kids.size; i++)
    {
      kid := kids[i]
      if (kid != null)
      {
        remove(kid)
        kids[i] = createElement(i)
      }
    }
  }

  override Void createElements(Range lines)
  {
    lines = lines.start..lines.end.min(lineCount - 1)
    lines.each
    {
      if (kids[it] == null) kids[it] = createElement(it)
    }
  }

  private Node?[] kids := Node?[,] { fill(null, lineCount) }

}

@Js
class MixedVisualizer : Visualizer
{

  new make(Scene scene) : super(scene) { }

  override Void recreate()
  {
    removeAll()
    kids = Node?[,] { fill(null, lineCount) }
    updateVisible()
  }

  override Void createElements(Range lines)
  {
    lines = lines.start..lines.end.min(lineCount - 1)
    lines.each
    {
      if (kids[it] == null) kids[it] = createElement(it)
    }
  }

  private Node?[] kids := Node?[,] { fill(null, lineCount) }

}
