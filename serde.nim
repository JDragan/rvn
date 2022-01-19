import tables, strutils
import json

proc serde*[T](query: string, target: T): T =

  var urlobj = initOrderedTable[string, string]()
  var ordered = initOrderedTable[string, JsonNode]()

  var urlparams = query.split("&")

  for u in urlparams:
    let s = u.split("=")
    if s.len() == 2:
      urlobj[s[0]] = s[1]
    else:
      echo "Malformed params: ", s

  for key, value in target.fieldPairs:

    if not urlobj.hasKey(key):
      echo "Error  : parameter ", key, " is missing from the urlparams."
      return

    var urlval = urlobj.getOrDefault(key, "") # if key doesnt exist

    if value.typeof   is string:
      ordered[key] = urlval.newJString

    elif value.typeof is SomeInteger:
      for c in urlval:
        if not {'0'..'9'}.contains c:
          echo "Warning: for ", $target.type, ": ", $key, " = ", urlval, " is not ", $key, ":SomeInteger"
          urlval = ""
          break
      if urlval == "": urlval = "0" # so parseInt could catch it
      ordered[key] = urlval.parseInt.newJInt

    elif value.typeof is SomeFloat:
      if ',' in urlval:
        urlval = urlval.replace(',', '.')
      ordered[key] = urlval.parseFloat.newJFloat
      # echo ordered[key]


  return (%ordered).to T


when isMainModule:

  type Targetz = object
    id: int32
    name: string
    price: float32

  echo serde("id=123,,iii&name=foo&price=123,456", Targetz())
  echo serde("id=123&name=foo&price=123,456", Targetz())