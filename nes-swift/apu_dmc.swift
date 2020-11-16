// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go
// DMC

let DMC_TABLE: [UInt8] = [
  214, 190, 170, 160, 143, 127, 113, 107, 95, 80, 71, 64, 53, 42, 36, 27
]

class DMC {
  // registers
  var CNTRL, VALUE, ADDRRESS, LENGTH: UInt8
  
  var irq: Bool {
    return CNTRL & 0x80 == 0x80
  }
  
  var loop: Bool {
    return CNTRL & 0x40 == 0x40
  }
  
  var frequency: Int {
    return Int(CNTRL & 0x0f)
  }
  
  var sampleAddress: UInt16 {
    // Sample address = %11AAAAAA.AA000000
    return 0xC000 | (UInt16(ADDRRESS) << 6)
  }
  
  var sampleLength: UInt16 {
    // Sample length = %0000LLLL.LLLL0001
    return (UInt16(LENGTH) << 4) | 1
  }
  
  var enabled: Bool
  var tickPeriod, tickValue, shiftRegister, bitCount: UInt8
  var currentAddress, currentLength: UInt16
  
  init() {
    CNTRL = 0
    VALUE = 0
    ADDRRESS = 0
    LENGTH = 0
    
    enabled = false
    tickPeriod = 0
    tickValue = 0
    shiftRegister = 0
    bitCount = 0
    
    currentAddress = 0
    currentLength = 0
  }
  
  deinit {
    print("DMC deinit")
  }
  
  func restart() {
    currentAddress = sampleAddress
    currentLength = sampleLength
  }
  
  func stepTimer(ram: RAM) {
    if !enabled {
      return
    }
    stepReader(ram:ram)
    if tickValue == 0 {
      tickValue = tickPeriod
      stepShifter()
    } else {
      tickValue-=1
    }
  }
  
  func stepReader(ram: RAM) {
    if currentLength > 0 && bitCount == 0 {
      ram.cpu.suspend += 4
        shiftRegister = ram.readByte(addr:currentAddress)
      bitCount = 8
      currentAddress+=1
      if currentAddress == 0 {
        currentAddress = 0x8000
      }
      currentLength-=1
      if currentLength == 0 && loop {
        restart()
      }
    }
  }
  
  func stepShifter() {
    if bitCount == 0 {
      return
    }
    if shiftRegister&1 == 1 {
      if VALUE <= 125 {
        VALUE += 2
      }
    } else {
      if VALUE >= 2 {
        VALUE -= 2
      }
    }
    shiftRegister >>= 1
    bitCount-=1
  }
  
  func output() -> UInt8 {
    return VALUE
  }
  
}
