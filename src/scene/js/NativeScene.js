fan.kawhyScene.NativeScene = fan.sys.Obj.$extend(fan.sys.Obj);
fan.kawhyScene.NativeScene.prototype.$ctor = function() {}

fan.kawhyScene.NativeScene.make = function()
{
  return new fan.kawhyScene.NativeScene();
}

fan.kawhyScene.NativeScene.prototype.text = function()
{
  var node = new fan.kawhyScene.KYTextNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.group = function()
{
  var node = new fan.kawhyScene.DivNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.scroll = function()
{
  var node = new fan.kawhyScene.KYScrollArea();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.fixed = function()
{
  var node = new fan.kawhyScene.KYFixedNode();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.checkbox = function()
{
  var node = new fan.kawhyScene.KYCheckBox();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.link = function()
{
  var node = new fan.kawhyScene.KYLink();
  node.init();
  return node;
}

fan.kawhyScene.NativeScene.prototype.root = function() { this.m_root = root; }
fan.kawhyScene.NativeScene.prototype.root$ = function(root)
{
  if (this.m_root)
    document.body.removeChild(this.m_root.m_elem);
  this.m_root = root;
  document.body.appendChild(root.m_elem);
}
fan.kawhyScene.NativeScene.prototype.m_root = null

fan.kawhyScene.NativeScene.prototype.copy = function() { }
