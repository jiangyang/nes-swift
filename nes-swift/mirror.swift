let MirrorLookup: [[Int]] = [
  [0, 0, 1, 1],
  [0, 1, 0, 1],
  [0, 0, 0, 0],
  [1, 1, 1, 1],
  [0, 1, 2, 3]
]

func mirrorAddress(mode: Int, addr: UInt16) -> Int {
  let a = (addr - 0x2000) % 0x1000
  let table = Int(a / 0x0400)
  let offset = Int(a % 0x0400)
  return 0x2000 + MirrorLookup[mode][table] * 0x0400 + offset
}