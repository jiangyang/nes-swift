// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go
// Pulse

let DUTY_TABLE: [[UInt8]] = [
  [0, 1, 0, 0, 0, 0, 0, 0],
  [0, 1, 1, 0, 0, 0, 0, 0],
  [0, 1, 1, 1, 1, 0, 0, 0],
  [1, 0, 0, 1, 1, 1, 1, 1]
]

class Pulse {
  // registers
  var CNTRL: UInt8 // 4000/4004
  var SWEEP: UInt8 // 4001/4005
  var TIMERLOW: UInt8 //4002/4006
  var TIMERHIGH: UInt8 //4003/4007
  // CNTRL
  var dutyMode: UInt8 {
    return (CNTRL >> 6) & 3
  }
  
  var lengthEnabled: Bool {
    return (CNTRL >> 5) & 1 == 0
  }
  
  var envelopeLoop: Bool {
    return !lengthEnabled
  }
  
  var envelopeEnabled: Bool {
    return (CNTRL >> 4) & 1 == 0
  }
  
  var envelopePeriod: UInt8 {
    return CNTRL & 15
  }
  
  var constantVolume: UInt8 {
    return CNTRL & 15
  }
  // SWEEP
  var sweepEnabled: Bool {
    return (SWEEP >> 7) & 1 == 1
  }
  
  var sweepPeriod: UInt8 {
    return (SWEEP >> 4) & 7
  }
  
  var sweepNegate: Bool {
    return (SWEEP >> 3) & 1 == 1
  }
  
  var sweepShift: UInt8 {
    return SWEEP & 7
  }
  // TIMERLOW and TIMERHIGH
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
  
  let channelNumber : Int
  var enabled: Bool
  var lengthValue, dutyValue, sweepValue, envelopeValue, envelopeVolume : UInt8
  var timerValue: UInt16
  
  var envelopeStart, sweepReload: Bool
  
  init (number: Int) {
    CNTRL = 0
    SWEEP = 0
    TIMERLOW = 0
    TIMERHIGH = 0
    
    channelNumber = number

    enabled = false
    sweepReload = false
    envelopeStart = false
    
    lengthValue = 0
    dutyValue = 0
    sweepValue = 0
    envelopeValue = 0
    envelopeVolume = 0
    
    timerValue = 0
  }
  
  deinit {
    print("Pulse deinit")
  }
  
  func stepTimer() {
    if timerValue == 0 {
      timerValue = timerPeriod
      dutyValue = (dutyValue + 1) % 8
    } else {
      timerValue-=1
    }
  }
  
  func stepEnvelope() {
    if envelopeStart {
      envelopeVolume = 15
      envelopeValue = envelopePeriod
      envelopeStart = false
    } else if envelopeValue > 0 {
      envelopeValue-=1
    } else {
      if envelopeVolume > 0 {
        envelopeVolume-=1
      } else if envelopeLoop {
        envelopeVolume = 15
      }
      envelopeValue = envelopePeriod
    }
  }
  
  func stepSweep() {
    if sweepReload {
      if sweepEnabled && sweepValue == 0 {
        sweep()
      }
      sweepValue = sweepPeriod
      sweepReload = false
    } else if sweepValue > 0 {
      sweepValue-=1
    } else {
      if sweepEnabled {
        sweep()
      }
      sweepValue = sweepPeriod
    }
  }
  
  func stepLength() {
    if lengthEnabled && lengthValue > 0 {
      lengthValue-=1
    }
  }
  
  func sweep() {
    let delta = timerPeriod >> UInt16(sweepShift)
    if sweepNegate {
      timerPeriod -= delta
      if channelNumber == 1 {
        timerPeriod-=1
      }
    } else {
      timerPeriod += delta
    }
  }
  
  func output() -> UInt8 {
    if !enabled || lengthValue == 0 || DUTY_TABLE[Int(dutyMode)][Int(dutyValue)] == 0
    || (timerPeriod < 8 || timerPeriod > 0x07ff) {
      return 0
    }

    if envelopeEnabled {
      return envelopeVolume
    } else {
      return constantVolume
    }
  }
}
