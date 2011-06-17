fan.kawhyScene.KYCheckBox = fan.sys.Obj.$extend(fan.kawhyScene.ZNode);
fan.kawhyScene.KYCheckBox.prototype.$ctor = function() {}

fan.kawhyScene.KYCheckBox.prototype.create = function()
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
fan.kawhyScene.KYCheckBox.prototype.m_check = null;

fan.kawhyScene.KYCheckBox.prototype.onClick$ = function(f)
{
  this.m_onClick = f;
}
fan.kawhyScene.KYCheckBox.prototype.m_onClick = null;

fan.kawhyScene.KYCheckBox.prototype.checked = function()
{
  return this.m_check.checked;
}
fan.kawhyScene.KYCheckBox.prototype.checked$ = function(checked)
{
  this.m_check.checked = checked;
}

fan.kawhyScene.KYCheckBox.prototype.text = function()
{
  return this.m_text.nodeValue;
}

fan.kawhyScene.KYCheckBox.prototype.text$ = function(text)
{
  this.m_text.nodeValue = text;
}
