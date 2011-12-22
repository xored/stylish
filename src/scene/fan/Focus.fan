using stylishNotice

@Js
class Focus : Notifier
{
  private Scene scene  
  
  internal new make(Scene scene) {
    this.scene = scene
  }
  
  Bool focused := false { private set }
  
  Void set() { scene.setFocus }
  
  internal Bool onFocus(Bool focused) {
    this.focused = focused
    return notify(#focused, this.focused)
  }
   
  override protected ListenerStorage listeners := ListenerStorage()

}
