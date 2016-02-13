class Mapper0 : Mapper {
  var numPRGBanks: Int
  var bank0Offset: Int
  var bank1Offset: Int
  
  init(c: Cartridge) {
    numPRGBanks = c.prgBytes / 0x4000
    bank0Offset = 0
    bank1Offset = numPRGBanks - 1
  }
  
  func read(addr: UInt16, c:Cartridge) -> UInt8 {
    if addr < 0x2000 {
      // PPU - CHRROM
      return c.CHRROM[Int(addr)]
    } else if addr >= 0x6000 && addr <= 0x7fff {
      // CPU SRAM
      return c.SRAM[Int(addr - 0x6000)]
    } else if addr <= 0xbfff {
      // CPU PRG ROM
      let i = bank0Offset * 0x4000 + Int(addr - 0x8000)
      return c.PRGROM[i]
    } else {
      // CPU PRG ROM
      let i = bank1Offset * 0x4000 + Int(addr - 0xc000)
      return c.PRGROM[i]
    }
  }
  
  func write(addr: UInt16, value: UInt8, c: Cartridge) {
    if addr < 0x2000 {
      // PPU CHRROM
      c.CHRROM[Int(addr)] = value
    } else if addr >= 0x6000 && addr <= 0x7fff {
      // CPU SRAM
      c.SRAM[Int(addr - 0x6000)] = value
    } else {
      // CPU PRGROM
      bank0Offset = Int(value) % numPRGBanks
    }
  }
}