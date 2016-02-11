// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go

let FRAME_COUNTER_RATE = CPU_FREQUENCY / 240

let LENGTH_TABLE: [UInt8] = [
  10, 254, 20, 2, 40, 4, 80, 6, 160, 8, 60, 10, 14, 12, 26, 14,
  12, 16, 24, 18, 48, 20, 96, 22, 192, 24, 72, 26, 16, 28, 32, 30
]

let PULSE_TABLE: [Float32] = {
  () -> [Float32] in
  var t = [Float32](count: 31, repeatedValue: 0.0)
  for i in 0..<31 {
    t[i] = 95.52 / (8128.0 / Float32(i) + 100)
  }
  return t
}()

let TND_TABLE: [Float32] = {
  () -> [Float32] in
  var t = [Float32](count: 203, repeatedValue: 0.0)
  for i in 0..<203 {
    t[i] = 163.67 / (24329.0 / Float32(i) + 100)
  }
  return t
}()

class APU {
  let out: AudioOut
  let sampleRate: Double
  let pulse1, pulse2: Pulse
  let triangle: Triangle
  let noise: Noise
  let dmc: DMC
  var cycleCount: UInt64
  var framePeriod: UInt8
  var frameValue: UInt8
  var frameIRQ: Bool
  let filterChain: FilterChain?
  
  var STATUS_READ: UInt8 {
    var o: UInt8 = 0
    if pulse1.lengthValue > 0 {
      o |= 1
    }
    if pulse2.lengthValue > 0 {
      o |= 2
    }
    if triangle.lengthValue > 0 {
      o |= 4
    }
    if noise.lengthValue > 0 {
      o |= 8
    }
    if dmc.currentLength > 0 {
      o |= 16
    }
    return o
  }
  
  var STATUS: UInt8
  var enablePulse1: Bool {
    return STATUS.getBit(0)
  }
  var enablePulse2: Bool {
    return STATUS.getBit(1)
  }
  var enableTriangle: Bool {
    return STATUS.getBit(2)
  }
  var enableNoise: Bool {
    return STATUS.getBit(3)
  }
  var enableDMC: Bool {
    return STATUS.getBit(4)
  }
  
  init(out: AudioOut, sampleRate: Double) {
    self.out = out
    self.sampleRate = sampleRate
    STATUS = 0
    cycleCount = 0
    framePeriod = 0
    frameValue = 0
    frameIRQ = false
    
    pulse1 = Pulse(number: 1)
    pulse2 = Pulse(number: 2)
    triangle = Triangle()
    noise = Noise()
    dmc = DMC()
    if sampleRate != 0 {
      filterChain = FilterChain(filters: [
        HighPassFilter(sampleRate: Float32(sampleRate), cutoffFreq: 90),
        HighPassFilter (sampleRate: Float32(sampleRate), cutoffFreq: 440),
        LowPassFilter(sampleRate: Float32(sampleRate), cutoffFreq: 14000)
      ])
    } else {
      filterChain = .None
    }
  }
  
  deinit {
    print("APU deinit")
  }
  
  func readRegister(addr: UInt16) -> UInt8 {
    switch addr {
    case 0x4015:
      return STATUS_READ
    default:
      return 0
    }
  }
  
  func writeRegister(addr: UInt16, value: UInt8) {
    switch addr {
    case 0x4000:
      pulse1.CNTRL = value
      pulse1.envelopeStart = true
    case 0x4001:
      pulse1.CNTRL = value
      pulse1.envelopeStart = true
    case 0x4002:
      pulse1.TIMERLOW = value
    case 0x4003:
      pulse1.TIMERHIGH = value
      pulse1.lengthValue = LENGTH_TABLE[pulse1.lengthCounter]
      pulse1.envelopeStart = true
      pulse1.dutyValue = 0
    case 0x4004:
      pulse2.CNTRL = value
      pulse2.envelopeStart = true
    case 0x4005:
      pulse2.CNTRL = value
      pulse2.envelopeStart = true
    case 0x4006:
      pulse2.TIMERLOW = value
    case 0x4007:
      pulse2.TIMERHIGH = value
      pulse2.lengthValue = LENGTH_TABLE[pulse2.lengthCounter]
      pulse2.envelopeStart = true
      pulse2.dutyValue = 0
    case 0x4008:
      triangle.CNTRL = value
    case 0x4009:
      break
    case 0x4010:
      dmc.CNTRL = value
      dmc.tickPeriod = DMC_TABLE[dmc.frequency]
    case 0x4011:
      dmc.VALUE = value & 0x7f
    case 0x4012:
      dmc.ADDRRESS = value
    case 0x4013:
      dmc.LENGTH = value
    case 0x400A:
      triangle.TIMERLOW = value
    case 0x400B:
      triangle.TIMERHIGH = value
      triangle.lengthValue = LENGTH_TABLE[triangle.lengthCounter]
      triangle.timerValue = triangle.timerPeriod
      triangle.counterReload = true
    case 0x400C:
      noise.CNTRL = value
      noise.envelopeStart = true
    case 0x400D:
      break
    case 0x400E:
      noise.PERIOD = value
      noise.timerPeriod = NOISE_TABLE[noise.noisePeriodCounter]
    case 0x400F:
      noise.LENGTH = value
      noise.lengthValue = LENGTH_TABLE[noise.lengthCounter]
      noise.envelopeStart = true
    case 0x4015:
      // write status
      STATUS = value
      pulse1.enabled = enablePulse1
      if !enablePulse1 {
        pulse1.lengthValue = 0
      }
      pulse2.enabled = enablePulse2
      if !enablePulse2 {
        pulse2.lengthValue = 0
      }
      triangle.enabled = enableTriangle
      if !enableTriangle {
        triangle.lengthValue = 0
      }
      noise.enabled = enableNoise
      if !enableNoise {
        noise.lengthValue = 0
      }
      dmc.enabled = enableDMC
      if !enableDMC {
        dmc.currentLength = 0
      } else if dmc.currentLength == 0{
        dmc.restart()
      }
    case 0x4017:
      framePeriod = 4 + (value >> 7) & 1
      frameIRQ = (value >> 6) & 1 == 0
    default:
      break
    }
  }
  
  func step(ram: RAM) {
    let cycle1 = cycleCount
    cycleCount++
    let cycle2 = cycleCount
    stepTimer(ram)
    let f1 = Int(Double(cycle1) / Double(FRAME_COUNTER_RATE))
    let f2 = Int(Double(cycle2) / Double(FRAME_COUNTER_RATE))
    if f1 != f2 {
      stepFrameCounter(ram)
    }
    if sampleRate != 0 {
      let s1 = Int(Double(cycle1) / sampleRate)
      let s2 = Int(Double(cycle2) / sampleRate)
      if s1 != s2 {
        sendSample()
      }
    }
  }
  
  func sendSample() {
    if let f = filterChain {
      out <- f.step(output())
    }
  }
  
  func output() -> Float32 {
    let p1 = pulse1.output()
    let p2 = pulse2.output()
    let t = triangle.output()
    let n = noise.output()
    let d = dmc.output()
    let pulseOut = PULSE_TABLE[Int(p1+p2)]
    let tndOut = TND_TABLE[Int(3 * t + 2 * n + d)]
    return pulseOut + tndOut
  }
  
  // mode 0:    mode 1:       function
  // ---------  -----------  -----------------------------
  //  - - - f    - - - - -    IRQ (if bit 6 is clear)
  //  - l - l    l - l - -    Length counter and sweep
  //  e e e e    e e e e -    Envelope and linear counter
  func stepFrameCounter(ram: RAM) {
    switch framePeriod {
    case 4:
      frameValue = (frameValue + 1) % 4
      switch frameValue {
      case 0, 2:
        stepEnvelope()
      case 1:
        stepEnvelope()
        stepSweep()
        stepLength()
      case 3:
        stepEnvelope()
        stepSweep()
        stepLength()
        fireIRQ(ram)
      default:
        break
      }
    case 5:
      frameValue = (frameValue + 1) % 5
      switch frameValue {
      case 1, 3:
        stepEnvelope()
      case 0, 2:
        stepEnvelope()
        stepSweep()
        stepLength()
      default:
        break
      }
    default:
      break
    }
  }
  
  func stepTimer(ram: RAM) {
    if cycleCount % 2 == 0 {
      pulse1.stepTimer()
      pulse2.stepTimer()
      noise.stepTimer()
      dmc.stepTimer(ram)
    }
    triangle.stepTimer()
  }
  
  func stepEnvelope() {
    pulse1.stepEnvelope()
    pulse2.stepEnvelope()
    triangle.stepCounter()
    noise.stepEnvelope()
  }
  
  func stepSweep() {
    pulse1.stepSweep()
    pulse2.stepSweep()
  }
  
  func stepLength() {
    pulse1.stepLength()
    pulse2.stepLength()
    triangle.stepLength()
    noise.stepLength()
  }
  
  func fireIRQ(ram: RAM) {
    if frameIRQ {
      ram.cpu.interrupt = .IRQ
    }
  }
  
}