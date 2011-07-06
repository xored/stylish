fan.kawhyScene.CheckBoxPeer = fan.sys.Obj.$extend(fan.kawhyScene.NodePeer);
fan.kawhyScene.CheckBoxPeer.prototype.$ctor = function(self) { this.init(self); }

fan.kawhyScene.CheckBoxPeer.prototype.create = function()
{
  this.m_check = document.createElement("input");
  this.m_check.type = "checkbox";

  var t = this;
  this.m_check.onclick = function()
  {
    t.m_onClick.call(t.checked());
  }

  this.m_text = document.createTextNode("");
  var span = document.createElement("div");
  span.appendChild(this.m_check);
  span.appendChild(this.m_text);

  return span;
}
fan.kawhyScene.CheckBoxPeer.prototype.m_check = null;

fan.kawhyScene.CheckBoxPeer.prototype.onClick$ = function(self, f)
{
  this.m_onClick = f;
}
fan.kawhyScene.CheckBoxPeer.prototype.m_onClick = null;

fan.kawhyScene.CheckBoxPeer.prototype.checked = function(self)
{
  return this.m_check.checked;
}
fan.kawhyScene.CheckBoxPeer.prototype.checked$ = function(self, checked)
{
  this.m_check.checked = checked;
}

fan.kawhyScene.CheckBoxPeer.prototype.text = function(self)
{
  return this.m_text.nodeValue;
}

fan.kawhyScene.CheckBoxPeer.prototype.text$ = function(self, text)
{
  this.m_text.nodeValue = text;
}
