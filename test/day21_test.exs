defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.{Day21, TestUtils}

  @input test_file()

  test "part1", do: assert part1(@input) == 2078

  test "part2", do: assert part2(@input) == "lmcqt,kcddk,npxrdnd,cfb,ldkt,fqpt,jtfmtpd,tsch"
end