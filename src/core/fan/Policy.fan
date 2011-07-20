
@Js
abstract class Policy
{

  const Type[] before := [,]

  const Type[] after := [,]

  const Float gravity := 0.5f

  abstract Control control()

  abstract Void attach()

  abstract Void detach()

}
