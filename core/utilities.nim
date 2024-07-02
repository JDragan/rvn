proc split_last*(input: string, splitter: char, last = false): string =

  var last_index = 0
  for idx, character in input:
    if character == splitter:
      last_index = idx

  if last:
    return input[last_index+1..^1]
  return input[0..last_index]

when isMainModule:
  echo split_last("aaa/bbb/ccc", '/')
  echo split_last("aaa/bbb/ccc", '/', true)


  # import strutils
  # echo "aabbba".contains "b"
  # echo "aabbba".contains "s"


  proc test(id: int, name: string, amount: float) = echo name, id, amount

  test 3, "asdasd", 0.042