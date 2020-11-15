// ported from https://github.com/fogleman/nes/blob/master/nes/apu.go
import Foundation


// First order filters are defined by the following parameters.
// y[n] = B0*x[n] + B1*x[n-1] - A1*y[n-1]
class FirstOrderFilter {
  let B0, B1, A1: Float32
  var prevX, prevY: Float32
  
  init(b0: Float32, b1: Float32, a1: Float32) {
    self.B0 = b0
    self.B1 = b1
    self.A1 = a1
    prevX = 0
    prevY = 0
  }
  
  deinit {
    print("Filter deinit")
  }
  
  func step(x: Float32) -> Float32 {
    let y = B0 * x +  B1 * prevX - A1 * prevY
    prevY = y
    prevX = x
    return y
  }
}


// sampleRate: samples per second
// cutoffFreq: oscillations per second
class LowPassFilter: FirstOrderFilter {
  init(sampleRate: Float32, cutoffFreq: Float32) {
    let c = sampleRate / Float32(Double.pi) / cutoffFreq
    let a0i = 1 / (1 + c)
    super.init(b0: a0i, b1: a0i, a1: (1 - c) * a0i)
  }
}

class HighPassFilter: FirstOrderFilter {
  init(sampleRate: Float32, cutoffFreq: Float32) {
    let c = sampleRate / Float32(Double.pi) / cutoffFreq
    let a0i = 1 / (1 + c)
    super.init(b0: c * a0i, b1: -c * a0i, a1: (1 - c) * a0i)
  }
}

struct FilterChain {
  var filters: [FirstOrderFilter]
  
  init(filters: [FirstOrderFilter]) {
    self.filters = filters
  }
  
  func step(x: inout Float32) -> Float32 {
    for f in filters {
      x = f.step(x:x)
    }
    return x
  }
}
