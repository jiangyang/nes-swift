// sketchy frame buffer
import Foundation

class FrameBuffer {
  var pix: UnsafeMutablePointer<UInt8>
  let stride: Int = 256 * 4
  let w: Int = 256
  let h: Int = 240
  
  init() {
    pix = UnsafeMutablePointer<UInt8>(malloc(stride * h * sizeof(UInt8)))
    for i in 0..<(stride * h) {
      if i % 4 == 3 {
        pix[i] = 0xff
      } else {
        pix[i] = 0
      }
    }
  }
  
  func set(x x: Int, y: Int, color: UInt32) {
    guard x >= 0 && x < 256 && y >= 0 && y < 240 else {
      return
    }
    
    let offset = y * stride + x * 4
    pix[offset] = UInt8(color >> 24)
    pix[offset + 1] = UInt8((color >> 16) & 0xff)
    pix[offset + 2] = UInt8((color >> 8) & 0xff)
  }
}