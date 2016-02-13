import Foundation

enum NESFileError : ErrorType {
  case FileNotLoaded
  case NotNESFile
  case TooFewPRGROM
  case MapperNotImplemented(UInt8)
}

let PRG_BANK_SIZE = 16384
let CHR_BANK_SIZE = 8192

class Cartridge {
  var mirrorMode: UInt8
  var battery: Bool
  var prgBytes, chrBytes: Int
  var SRAM: [UInt8]
  var PRGROM: UnsafeMutablePointer<UInt8>
  var CHRROM: UnsafeMutablePointer<UInt8>
  var mapper: Mapper!
  
  init(path: String) throws {
    SRAM = [UInt8](count: 2000, repeatedValue: 0)
    mirrorMode = 0
    battery = false
    prgBytes = 0
    chrBytes = 0
    PRGROM = UnsafeMutablePointer<UInt8>(malloc(32 * PRG_BANK_SIZE * sizeof(UInt8)))
    CHRROM = UnsafeMutablePointer<UInt8>(malloc(32 * CHR_BANK_SIZE * sizeof(UInt8)))
    
    if let content = NSData(contentsOfFile: path) {
      var header = [UInt8](count: 16, repeatedValue: 0)
      // read 16 byte header
      content.getBytes(&header, length: 16)
      if header.prefix(4) != [0x4e, 0x45, 0x53, 0x1a] {
        throw NESFileError.NotNESFile
      }
      // number of PRG block
      let prgs = Int(header[4])
      // number of CHR block
      let chrs = Int(header[5])
      // flags 6
      let flags6 = header[6]
      // flags 7
      let flags7 = header[7]
      // Size of PRG RAM in 8 KB units (Value 0 infers 8 KB for compatibility; see PRG RAM circuit)
      // not used
      // let prgrams = header[8]
      // tv mode stuff, not used
      // let tv1 = header[9]
      // let tv2 = header[10]
      // rest of the headers are just padding
      
      let mapperHi = flags7 >> 4
      let mapperLo = flags6 >> 4
      let mapperType = (mapperHi << 4) | mapperLo
      
      let mirrorHi = (flags6 >> 3) & 1
      let mirrorLo = flags6 & 1
      mirrorMode = (mirrorHi << 1) | mirrorLo
      
      battery = (flags6 >> 1) & 1 == 1
      
      var offset: Int = 16
      // 512 byte trainer presents, read past it
      if flags6 & 4 == 4 {
        offset += 512
      }
      
      if prgs < 1 {
        throw NESFileError.TooFewPRGROM
      }
      
      // read PRG-ROM
      content.getBytes(PRGROM, range: NSRange(location: offset, length: prgs * PRG_BANK_SIZE))
      offset += prgs * PRG_BANK_SIZE
      prgBytes = prgs * PRG_BANK_SIZE
      
      // read CHR-ROM
      if chrs < 1 {
        chrBytes = CHR_BANK_SIZE
      } else {
        content.getBytes(CHRROM, range: NSRange(location: offset, length: chrs * CHR_BANK_SIZE))
        offset += chrs * CHR_BANK_SIZE
        chrBytes = chrs * CHR_BANK_SIZE
      }
      // there may be playchoice rom stuff and title info at the end of the file, not considered now
      
      // mapper
      switch mapperType {
      case 0, 2:
        mapper = Mapper0(c: self)
      case 1:
        mapper = Mapper1(c: self)
      default:
        throw NESFileError.MapperNotImplemented(mapperType)
      }
      
    } else {
      throw NESFileError.FileNotLoaded
    }
  }
}