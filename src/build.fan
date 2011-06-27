using build

class Build : BuildGroup
{

  new make()
  {
    childrenScripts =
    [
      `math/build.fan`,
      `util/build.fan`,
      `notice/build.fan`,
      `css/build.fan`,
      `scene/build.fan`,
      `core/build.fan`,
      `text/build.fan`,
    ]
  }

}