package fan.kawhyScene;

import fan.sys.*;

class NativeScene
{

  public static NativeScene make() {
    return new NativeScene();
  }

  public NativeScene() {
  }

  public TextNode text() {
    return null;
  }

  public Group group() {
    return null;
  }

  public Node group(Node node) {
    return node;
  }

  public Node root() {
    return null;
  }

  public void root(Node node) {
    
  }
}