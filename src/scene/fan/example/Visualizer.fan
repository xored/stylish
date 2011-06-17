using gfx
using kawhyCss

@Js
abstract class Visualizer
{

  new make(Scene scene)
  {
    this.scene = scene
    scroll = scene.scroll()
    scroll.position = Position.absolute
    scroll.style = FontStyle(FontStyle.monospace.name, 16)
    scroll.size = Size(scrollWidth, scrollHeight)
    scroll.onScroll = |Point s|
    {
      updateVisible()
      onSumChange(sum)
    }

    content = scene.fixed()
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
    group := scene.group
    group.position = Position.horizontal

    text0 := scene.text
    text0.text = "$line".justl(6)
    text0.style = TextStyle { color = Color(0x808080) }
    group.add(text0)

    if ((line + 1) % 10 == 0)
    {
      link := scene.link()
      link.link = "http://google.com"
      link.text = "ssr-server2:"
      text1 := scene.text
      text1.text = " "
      group.add(link)
      group.add(text1)
    }
    else
    {
      text1 := scene.text
      text1.text = "ssr-server2: "
      text1.style = TextStyle { color = Color.orange }
      group.add(text1)
    }

    if (!filtered)
    {
      text2 := scene.text
      text2.text = " 2009-09-22T06:59:28: "
      text2.style = TextStyle { color = Color.blue }
      group.add(text2)
    }

    text3 := scene.text
    text3.text = "%autoeasy-5-NOTICE: %[pname=TRP--mode,linenum=1]: *** testbed-AAA-IOU-SSR2-con.log.00001 ***"
    group.add(text3)

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

  private FixedNode content { private set }

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
