// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go
// Noise

let NOISE_TABLE: [UInt16] = [
  4, 8, 16, 32, 64, 96, 128, 160, 202, 254, 380, 508, 762, 1016, 2034, 4068
]

class Noise {
  // registers
  var CNTRL, PERIOD, LENGTH: UInt8
  
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
  
  var mode: Bool {
    return PERIOD & 0x80 == 0x80
  }
  
  var noisePeriodCounter: Int {
    return Int(PERIOD & 0x0f)
  }
  
  var lengthCounter: Int {
    return Int(LENGTH >> 3)
  }
  
  var enabled, envelopeStart: Bool
  var timerPeriod, timerValue, shiftRegister: UInt16
  var lengthValue, envelopeValue, envelopeVolume: UInt8
  
  init() {
    CNTRL = 0
    PERIOD = 0
    LENGTH = 0
    
    enabled = false
    envelopeStart = false
    
    timerPeriod = 0
    timerValue = 0
    shiftRegister = 1
    
    lengthValue = 0
    envelopeValue = 0
    envelopeVolume = 0
  }
  
  deinit {
    print("Noise deinit")
  }
  
  func stepTimer() {
    if timerValue == 0 {
      timerValue = timerPeriod
      var shift: UInt8 = 0
      if mode {
        shift = 6
      } else {
        shift = 1
      }
      let b1 = shiftRegister & 1
      let b2 = (shiftRegister >> UInt16(shift)) & 1
      shiftRegister >>= 1
      shiftRegister |= (b1 ^ b2) << 14
    } else {
      timerValue--
    }
  }
  
  func stepEnvelope() {
    if envelopeStart {
      envelopeVolume = 15
      envelopeValue = envelopePeriod
      envelopeStart = false
    } else if envelopeValue > 0 {
      envelopeValue--
    } else {
      if envelopeVolume > 0 {
        envelopeVolume--
      } else if envelopeLoop {
        envelopeVolume = 15
      }
      envelopeValue = envelopePeriod
    }
  }
  
  func stepLength() {
    if lengthEnabled && lengthValue > 0 {
      lengthValue--
    }
  }
  
  func output() -> UInt8 {
    if !enabled || lengthValue == 0 || shiftRegister & 1 == 1 {
      return 0
    }

    if envelopeEnabled {
      return envelopeVolume
    } else {
      return constantVolume
    }
  }
}



