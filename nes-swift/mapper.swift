protocol Mapper {
  func read(addr:UInt16, c:Cartridge) -> UInt8
  func write(addr: UInt16, value: UInt8, c:Cartridge)
}