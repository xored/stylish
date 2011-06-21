using kawhyCss

@Js
mixin TextNode : Node
{

  abstract Str text

}

@Js
mixin TextStroke : Node
{

  abstract TextNode[] kids

}

@Js
const class StyleText
{

  const Style style
  const Str text

  new make(Style style, Str text)
  {
    this.style = style
    this.text = text
  }

  override Bool equals(Obj? that)
  {
    c := that as StyleText
    if (c == null) return false
    return c.style == style && c.text == text
  }

  override Int hash()
  {
    prime := 31
    result := 1
    result = prime * result + style.hash
    result = prime * result + text.hash
    return result;
  }

  override Str toStr() { "$style $text" }

}