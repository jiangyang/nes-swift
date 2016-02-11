// status registers status bits
enum StatusBit: UInt8 {
  case C = 1 // carry flag
  case Z = 2 // zero flag
  case I = 4 // interrupt disabled flag
  case D = 8 // decimal mode flag
  case B = 16 // break command flg
  case U = 32 // UNUSED
  case V = 64 // overflow flag
  case N = 128 // negative flag
}

// interrupt types
enum Interrupt: UInt8 {
  case NONE = 0 // no interrupt
  case IRQ = 1 // normal interrupt, may be ignored if cpu status I bit is set
  case NMI = 2 // non-maskable interrupt, will always handle
  case RST = 3 // reset
}

class CPU {
  let STARTPC: UInt16 = 0xc000
  // registers
  var A: UInt8 // accumulator
  var X: UInt8 // register x
  var Y: UInt8 // register y
  var P: UInt8 // status register, 8 bit, each bit a StatusBit
  var SP: UInt8 // stack pointer
  var PC: UInt16 // program counter

  var interrupt: Interrupt
  
  // state
  var cycleCount: UInt64
  var suspend: Int // suspend for x cycles
  
  init() {
    A = 0
    X = 0
    Y = 0
    P = StatusBit.I.rawValue | StatusBit.U.rawValue
    // why 0xfd though? the stack is from 0x01ff to 0x0100, the SP is 0xff to 0x00, so why 0xfd?
    // see http://superuser.com/a/606770
    SP = 0xfd
    PC = STARTPC
    
    interrupt = Interrupt.NONE
    
    cycleCount = 0
    suspend = 0
  }
  
  deinit {
    print("CPU deinit")
  }
  
  // carry bit
  func getStatusC() -> Bool {
    return self.P & StatusBit.C.rawValue == StatusBit.C.rawValue
  }
  
  func setStatusC(should: Bool) {
    self.P = should ? self.P | StatusBit.C.rawValue : self.P & 0xfe
  }
  // zero bit
  func getStatusZ() -> Bool {
    return self.P & StatusBit.Z.rawValue == StatusBit.Z.rawValue
  }
  
  func setStatusZ(should: Bool) {
    self.P = should ? self.P | StatusBit.Z.rawValue : self.P & 0xfd
  }
  // interrupt disabled bit
  func getStatusI() -> Bool {
    return self.P & StatusBit.I.rawValue == StatusBit.I.rawValue
  }
  
  func setStatusI(should: Bool) {
    self.P = should ? self.P | StatusBit.I.rawValue : self.P & 0xfb
  }
  // decimal mode bit
  func getStatusD() -> Bool {
    return self.P & StatusBit.D.rawValue == StatusBit.D.rawValue
  }
  
  func setStatusD(should: Bool) {
    self.P = should ? self.P | StatusBit.D.rawValue : self.P & 0xf7
  }
  // break command bit
  func getStatusB() -> Bool {
    return self.P & StatusBit.B.rawValue == StatusBit.B.rawValue
  }
  
  func setStatusB(should: Bool) {
    self.P = should ? self.P | StatusBit.B.rawValue : self.P & 0xef
  }
  // overflow bit
  func getStatusV() -> Bool {
    return self.P & StatusBit.V.rawValue == StatusBit.V.rawValue
  }
  
  func setStatusV(should: Bool) {
    self.P = should ? self.P | StatusBit.V.rawValue : self.P & 0xbf
  }
  // negative bit
  func getStatusN() -> Bool {
    return self.P & StatusBit.N.rawValue == StatusBit.N.rawValue
  }
  
  func setStatusN(should: Bool) {
    self.P = should ? self.P | StatusBit.N.rawValue : self.P & 0x7f
  }
  // stack ops
  func pushByte(value: UInt8, ram: RAM) {
    ram.writeByte(UInt16(SP) | 0x0100, value: value)
    SP = SP &- 1
  }
  
  func popByte(ram:RAM) -> UInt8 {
    SP = SP &+ 1
    return ram.readByte(UInt16(SP) | 0x0100)
  }
  
  func push2Byte(value: UInt16, ram:RAM) {
    let hi8 = UInt8(value >> 8)
    let lo8 = UInt8(value & 0xff)
    pushByte(hi8, ram: ram)
    pushByte(lo8, ram: ram)
  }
  
  func pop2Byte(ram:RAM) -> UInt16 {
    let lo8 = popByte(ram)
    let hi8 = popByte(ram)
    return (UInt16(hi8) << 8) | UInt16(lo8)
  }
  
  func nmi(ram:RAM) -> Int {
    push2Byte(PC, ram:ram)
    pushByte(P | StatusBit.B.rawValue | StatusBit.U.rawValue, ram:ram)
    PC = ram.read2Byte(0xfffa)
    setStatusI(true)
    return 7
  }
  
  func irq(ram:RAM) -> Int {
    push2Byte(PC, ram:ram)
    pushByte(P | StatusBit.B.rawValue | StatusBit.U.rawValue, ram:ram)
    PC = ram.read2Byte(0xfffe)
    setStatusI(true)
    return 7
  }
  
  func step(ram: RAM) -> Int {
    guard suspend == 0 else {
      suspend--
      return 1
    }
    
    var cycleDelta = 0
    switch(interrupt) {
    case .NMI:
      cycleDelta += nmi(ram)
    case .IRQ:
      if !getStatusI() {
        cycleDelta += irq(ram)
      }
    case .RST:
      fallthrough
    case.NONE:
      break
    }
    interrupt = Interrupt.NONE
    
    let opCode = ram.readByte(PC)
    let op = OPTable[Int(opCode)]
    cycleDelta += op.exec(self, ram: ram)
    cycleCount = cycleCount &+ UInt64(cycleDelta)
    return cycleDelta
  }
  
}
