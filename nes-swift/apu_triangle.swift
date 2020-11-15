// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go
// Triangle

let TRIANGEL_TABLE: [UInt8] = [
  15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
]

class Triangle {
  // registers
  var CNTRL, TIMERLOW, TIMERHIGH: UInt8
  
  var lengthEnabled: Bool {
    return (CNTRL >> 7) & 1 == 0
  }
  
  var counterPeriod: UInt8 {
    return CNTRL & 0x7f
  }
  
  var timerPeriod: UInt16 {
    get {
      return (UInt16(TIMERHIGH) & 7 << 8) | UInt16(TIMERLOW)
    }
    
    set(newTimer) {
      TIMERLOW = UInt8(newTimer & 0xff)
      TIMERHIGH = TIMERHIGH & (0b11111000 | UInt8((newTimer >> 8) & 7))
    }
  }
  
  var lengthCounter: Int {
    return Int(TIMERHIGH >> 3)
  }
  
  var enabled: Bool
  var counterReload: Bool
  var lengthValue, dutyValue, counterValue: UInt8
  var timerValue: UInt16
  
  init() {
    CNTRL = 0
    TIMERLOW = 0
    TIMERHIGH = 0
    enabled = false
    counterReload = false
    lengthValue = 0
    dutyValue = 0
    counterValue = 0
    timerValue = 0
  }
  
  deinit {
    print("Triangle deinit")
  }
  
  func stepTimer() {
    if timerValue == 0 {
      timerValue = timerPeriod
      if lengthValue > 0 && counterValue > 0 {
        dutyValue = (dutyValue + 1) % 32
      }
    } else {
      timerValue-=1
    }
  }
  
  func stepLength() {
    if lengthEnabled && lengthValue > 0 {
      lengthValue-=1
    }
  }
  
  func stepCounter() {
    if counterReload {
      counterValue = counterPeriod
    } else if counterValue > 0 {
      counterValue-=1
    }
    if lengthEnabled {
      counterReload = false
    }
  }
  
  func output() -> UInt8 {
    if !enabled || lengthValue == 0 || counterValue == 0 {
      return 0
    }
    return TRIANGEL_TABLE[Int(dutyValue)]
  }
  
}
