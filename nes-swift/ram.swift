import Foundation
// mapped memory access
// nes has 16 bit addressing for 64k memory
// but a lot of address space is just mirrors for previous addresses
// in addition, large space are mapped in ram to access registers of other chips and/or devices
// for details see the memory map on nesdev
class RAM {
  // the actual ram space that we need to allocate
  // the ram that is not mapped to other devices is from 0x0000 - 0x1fff (8k addresses)
  // within this, 0x0800 - 0x1fff is just repeated mirrors to 0x0000 - 0x07ff
  // so in essence, we only need physical space for 0x0000 - 0x07ff (2k addresses)
  let RAM_SIZE = 2048
  var ram : UnsafeMutablePointer<UInt8>
  // ppu registers
  // apu registers
  // io, game pak and controllers etc
  var cartridge: Cartridge
  var controller1: Controller
  var controller2: Controller
  var cpu: CPU
  var ppu: PPU
  var apu: APU
  
  static func pageXAt(addr1: UInt16, fromAddr: UInt16) -> Bool {
    return addr1 & 0xff00 != fromAddr & 0xff00
  }
  
  init(cpu: CPU, ppu: PPU, apu: APU, cartridge: Cartridge, controller1: Controller, controller2: Controller) {
    ram = UnsafeMutablePointer<UInt8>.allocate(capacity: RAM_SIZE)
    self.cpu = cpu
    self.ppu = ppu
    self.apu = apu
    self.cartridge = cartridge
    self.controller1 = controller1
    self.controller2 = controller2
  }

//  it is prob clearer to write it like this but somehow everything related to range or interval is way slower
//  func readByte2(addr: UInt16) -> UInt8 {
//    switch UInt32(addr) {
//    case 0..<0x2000:
//      return ram[Int(addr % 0x0800)]
//    case 0x2000...0x3fff:
//      let o = ppu.readRegister(0x2000 + addr % 8, ram: self)
//      return o
//    case 0x4014:
//      let o = ppu.readRegister(addr, ram: self)
//      return o
//    case 0x4015:
//      return apu.readRegister(addr)
//    case 0x4016:
//      return controller1.read()
//    case 0x4017:
//      return controller2.read()
//    case 0x6000...0xffff:
//      let m = cartridge.mapper!
//      return m.read(addr, c: cartridge)
//    default:
//      return 0
//    }
//  }
  
  func readByte(addr: UInt16) -> UInt8 {
    if addr < 0x2000 {
      return ram[Int(addr % 0x0800)]
    } else if addr <= 0x3fff {
        let o = ppu.readRegister(addr:0x2000 + addr % 8, ram: self)
      return o
    } else if addr == 0x4014 {
        let o = ppu.readRegister(addr: addr, ram: self)
      return o
    } else if addr == 0x4015 {
        return apu.readRegister(addr: addr)
    } else if addr == 0x4016 {
      return controller1.read()
    } else if addr == 0x4017 {
      return controller2.read()
    } else if addr >= 0x6000 && addr <= 0xffff {
      let m = cartridge.mapper
        return m!.read(addr: addr, c: cartridge)
    } else {
      return 0
    }
  }
  
  func writeByte(addr: UInt16, value: UInt8) {
    if addr <= 0x1fff {
      ram[Int(addr % 0x0800)] = value
    } else if addr <= 0x3fff {
        ppu.writeRegister(addr:0x2000 + addr % 8, value: value, ram: self)
    } else if addr >= 0x4000 && addr <= 0x4013 {
        apu.writeRegister(addr: addr, value: value)
    } else if addr == 0x4014 {
      ppu.writeRegister(addr: addr, value: value, ram: self)
    } else if addr ==  0x4015 {
      apu.writeRegister(addr: addr, value: value)
    } else if addr == 0x4016 {
      controller1.write(value: value)
      controller2.write(value: value)
    } else if addr == 0x4017 {
      apu.writeRegister(addr: addr, value: value)
    } else if addr >= 0x6000 {
      let m = cartridge.mapper
      m!.write(addr: addr, value: value, c: cartridge)
    }
  }
  
  func read2Byte(atAddr: UInt16) -> UInt16 {
    // little endian
    let lo8 = self.readByte(addr:atAddr)
    let hi8 = self.readByte(addr:atAddr + 1)
    return UInt16(hi8) << 8 | UInt16(lo8)
  }
  
  func read2ByteBug(atAddr: UInt16) -> UInt16 {
    // emulates a 6502 chip bug where the low byte wraps without carry to the high byte
    // so here the hi8 address is no longer atAddr + 1 but
    //.............|the high byte|.......|the low byte|........
    let hi8Addr = (atAddr & 0xff00) | UInt16(UInt8(atAddr & 0xff) &+ 1)
    
    let lo8 = self.readByte(addr:atAddr)
    let hi8 = self.readByte(addr:hi8Addr)
    return UInt16(hi8) << 8 | UInt16(lo8)
  }
  
}
