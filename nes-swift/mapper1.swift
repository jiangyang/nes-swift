class Mapper1 : Mapper {
  // registers
  // load register is emulated with function
  var shift: UInt8
  // 4bit0
  // -----
  // CPPMM
  // |||||
  // |||++- Mirroring (0: one-screen, lower bank; 1: one-screen, upper bank;
  // |||               2: vertical; 3: horizontal)
  // |++--- PRG ROM bank mode (0, 1: switch 32 KB at $8000, ignoring low bit of bank number;
  // |                         2: fix first bank at $8000 and switch 16 KB bank at $C000;
  // |                         3: fix last bank at $C000 and switch 16 KB bank at $8000)
  // +----- CHR ROM bank mode (0: switch 8 KB at a time; 1: switch two separate 4 KB banks)
  var control: UInt8
  var chrBank0: UInt8 // 5 bits
  var chrBank1: UInt8 // 5 bits
  var prgBank: UInt8 // 5 bits
  
  var cartridgePRGSize: Int
  var cartridgeCHRSize: Int
  var prgOffsets: [Int] // offsets for prg banks
  var chrOffsets: [Int] // offsets for chr banks
  
  // bit 4 of control register
  var CHRMode: Int {
    return Int((control >> 4) & 1)
  }
  // bit 2,3 of control register
  var PRGMode: Int {
    return Int((control >> 2) & 3)
  }
  // bit 0,1 of control register
  var mirrorMode: Int {
    return Int(control & 3)
  }
  
  static func prgBankOffset(index: Int, prgSize: Int) -> Int {
    var i = index
    if i >= 0x80 {
      i -= 0x100
    }
    i %= prgSize / 0x4000
    var offset = i * 0x4000
    if offset < 0 {
      offset += prgSize
    }
    return offset
  }
  
  static func chrBankOffset(index: Int, chrSize: Int) -> Int {
    var i = index
    if i >= 0x80 {
      i -= 0x100
    }
    i %= chrSize / 0x1000
    var offset = i * 0x1000
    if offset < 0 {
      offset += chrSize
    }
    return offset
  }
  
  init(c: Cartridge) {
    shift = 0x10
    control = 0
    chrBank0 = 0
    chrBank1 = 0
    prgBank = 0
    cartridgePRGSize = c.prgBytes
    cartridgeCHRSize = c.chrBytes
    prgOffsets = [0, 0]
    chrOffsets = [0, 0]
    prgOffsets[1] = Mapper1.prgBankOffset(-1, prgSize: cartridgePRGSize)
  }
  
  func read(addr: UInt16, c:Cartridge) -> UInt8 {
    switch UInt32(addr) {
    // PPU - CHRROM
    case 0...0x1fff:
      let bank = Int(addr / 0x1000)
      let offset = Int(addr % 0x1000)
      return c.CHRROM[chrOffsets[bank] + offset]
      
    // CPU
    // SRAM
    case 0x6000...0x7fff:
      return c.SRAM[Int(addr - 0x6000)]
    // PRG ROM
    case 0x8000...0xffff:
      let address = addr - 0x8000
      let bank = Int(address / 0x4000)
      let offset = Int(address % 0x4000)
      return c.PRGROM[prgOffsets[bank] + offset]
    default:
      return 0
    }
  }
  
  func write(addr: UInt16, value: UInt8, c: Cartridge) {
    switch UInt32(addr) {
    // PPU - CHRROM
    case 0...0x1fff:
      let bank = Int(addr / 0x1000)
      let offset = Int(addr % 0x1000)
      c.CHRROM[chrOffsets[bank] + offset] = value
      
    // CPU
    // SRAM
    case 0x6000...0x7fff:
      c.SRAM[Int(addr - 0x6000)] = value
    // PRG ROM
    case 0x8000...0xffff:
      self.updateLoad(addr, value: value, c: c)
    default:
      break
    }
  }
  
  func updateLoad(addr: UInt16, value: UInt8, c: Cartridge) {
    if value & 0x80 == 0x80 {
      shift = 0x10
      updateControl(control | 0x0c, c: c)
    } else {
      let done = shift & 1 == 1
      shift = shift >> 1
      shift = shift | ((value & 1) << 4)
      if done {
        updateRegisters(addr, value: shift, c: c)
        shift = 0x10
      }
    }
  }
  
  func updateRegisters(addr: UInt16, value: UInt8, c: Cartridge){
    switch UInt32(addr) {
    case 0x8000...0x9fff:
      updateControl(value, c: c)
    case 0xa000...0xbfff:
      chrBank0 = value
      updateOffsets()
    case 0xc000...0xdfff:
      chrBank1 = value
      updateOffsets()
    case 0xe000...0xffff:
      prgBank = value & 0x0f
      updateOffsets()
    default:
      break
    }
  }
  
  func updateControl(value: UInt8, c: Cartridge) {
    control = value
    c.mirrorMode = UInt8(mirrorMode)
    updateOffsets()
  }
  
  func updateOffsets() {
    switch CHRMode {
    case 0:
      chrOffsets[0] = Mapper1.chrBankOffset(Int(chrBank0 & 0xfe), chrSize: cartridgeCHRSize)
      chrOffsets[1] = Mapper1.chrBankOffset(Int(chrBank0 & 0x01), chrSize: cartridgeCHRSize)
    case 1:
      chrOffsets[0] = Mapper1.chrBankOffset(Int(chrBank0), chrSize: cartridgeCHRSize)
      chrOffsets[1] = Mapper1.chrBankOffset(Int(chrBank1), chrSize: cartridgeCHRSize)
    default:
      break
    }
    
    switch PRGMode {
    case 0...1:
      prgOffsets[0] = Mapper1.prgBankOffset(Int(prgBank & 0xfe), prgSize: cartridgePRGSize)
      prgOffsets[1] = Mapper1.prgBankOffset(Int(prgBank | 0x01), prgSize: cartridgePRGSize)
    case 2:
      prgOffsets[0] = 0
      prgOffsets[1] = Mapper1.prgBankOffset(Int(prgBank), prgSize: cartridgePRGSize)
    case 3:
      prgOffsets[0] = Mapper1.prgBankOffset(Int(prgBank), prgSize: cartridgePRGSize)
      prgOffsets[1] = Mapper1.prgBankOffset(-1, prgSize: cartridgePRGSize)
    default:
      break
    }
  }
  
}