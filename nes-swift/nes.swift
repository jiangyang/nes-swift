let CPU_FREQUENCY = 1789773.0

class NES {
  var ram: RAM!
  var cpu: CPU!
  var ppu: PPU!
  var apu: APU!
  var c1, c2 : Controller!
  
  init? (path: String) {
    do {
      let c = try Cartridge(path: path)
      c1 = Controller()
      c2 = Controller()
      cpu = CPU()
      ppu = PPU()
      apu = APU(out: AudioOut(), sampleRate: 0)
      ram = RAM(cpu: cpu, ppu: ppu, apu: apu, cartridge: c, controller1: c1, controller2: c2)
      cpu.PC = ram.read2Byte(atAddr:0xfffc)
    } catch NESFileError.FileNotLoaded {
      print("file not loaded")
      return nil
    } catch NESFileError.NotNESFile {
      print("not an nes file")
      return nil
    } catch NESFileError.TooFewPRGROM {
      print("too few prg roms")
      return nil
    } catch NESFileError.MapperNotImplemented(let t) {
      print("mapper type \(t) not implemented")
      return nil
    } catch let err {
      print("oh snap \(err)")
      return nil
    }
  }
  
  func step() -> Int {
    let cyclesDelta = cpu.step(ram:ram)
    for _ in 0..<(cyclesDelta * 3) {
      ppu.step(cpu: cpu, ram: ram)
    }
    for _ in 0..<cyclesDelta {
      apu.step(ram:ram)
    }
    return cyclesDelta
  }
  
  func stepDt (dt: Double) {
    var cyclesToRun = Int(CPU_FREQUENCY * dt)
    while cyclesToRun > 0 {
      let consumed = self.step()
      cyclesToRun -= consumed
    }
  }
}


// dummy audio device
class AudioOut {}
infix operator <-
func <- (lhs: AudioOut, rhs: Float32) {}

