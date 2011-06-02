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

fan.kawhyScene.NativeScene.prototype.root = function() { }
fan.kawhyScene.NativeScene.prototype.root$ = function(root)
{
  document.body.appendChild(root.m_elem);
}

fan.kawhyScene.NativeScene.prototype.copy = function() { }
