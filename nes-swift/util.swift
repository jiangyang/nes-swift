extension UInt8 {
  func setBit(value: Bool, at: Int) -> UInt8 {
    switch at {
    case 0,1,2,3,4,5,6,7:
      return value ? UInt8(1 << at) | self : UInt8((1 << at)^0xff) & self
    default:
      return self
    }
  }
  
  func getBit(at: Int) -> Bool {
    switch at {
    case  0,1,2,3,4,5,6,7:
      return (self >> UInt8(at)) & 1 == 1
    default:
      return false
    }
  }
  
  var hex: String {
    return String(format: "%02X", self)
  }
}

extension UInt16 {
  var hex: String {
    return String(format: "%04X", self)
  }
}

extension UInt32 {
  var hex: String {
    return String(format: "%08X", self)
  }
}

extension Int {
  var hex: String {
    return String(format: "%04X", self)
  }
}