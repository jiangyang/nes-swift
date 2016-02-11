import MetalKit

let ROM_PATH = "your_rom_file"

let KEY_A : UInt16 = 38
let KEY_B : UInt16 = 40
let KEY_SELECT : UInt16 = 32
let KEY_START : UInt16 = 34
let KEY_UP : UInt16 = 13
let KEY_DOWN : UInt16 = 1
let KEY_LEFT : UInt16 = 0
let KEY_RIGHT : UInt16 = 2

class GameView: MTKView {
  override var acceptsFirstResponder: Bool {
    return true
  }
  
  var nes: NES?
  var keys: [Bool] = [Bool](count: 8, repeatedValue: false)
  
  var time: Double = CACurrentMediaTime()
  
  var vertex_buffer: MTLBuffer!
  var renderPipeline: MTLRenderPipelineState!
  var sampler: MTLSamplerState!
  
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    preferredFramesPerSecond = 60
    device = MTLCreateSystemDefaultDevice()
    guard let _ = device else {
      Swift.print("no device")
      return
    }
    // the rect
    let vertex_data = [
      Vertex(position: [-1.0,  1.0, 0.0, 1.0], texCoord: [0, 0]),
      Vertex(position: [-1.0, -1.0, 0.0, 1.0], texCoord: [0, 1]),
      Vertex(position: [ 1.0,  1.0, 0.0, 1.0], texCoord: [1, 0]),
      Vertex(position: [ 1.0, -1.0, 0.0, 1.0], texCoord: [1, 1])
    ]
    vertex_buffer = device!.newBufferWithBytes(vertex_data, length:  strideof(Vertex) * vertex_data.count, options:[])
    // pipeline, shaders etc
    let lib = device!.newDefaultLibrary()
    guard let _ = lib else {
      Swift.print("no default library")
      return
    }
    let pd = MTLRenderPipelineDescriptor()
    pd.vertexFunction = lib!.newFunctionWithName("vertex_shader")
    pd.fragmentFunction = lib!.newFunctionWithName("fragment_shader")
    pd.colorAttachments[0].pixelFormat = .BGRA8Unorm
    do {
      try renderPipeline = device!.newRenderPipelineStateWithDescriptor(pd)
    } catch let err {
      Swift.print("nose \(err)")
    }
    // sampler
    let sd = MTLSamplerDescriptor()
    sd.minFilter = MTLSamplerMinMagFilter.Nearest
    sd.magFilter = MTLSamplerMinMagFilter.Nearest
    sd.sAddressMode = MTLSamplerAddressMode.Repeat
    sd.tAddressMode = MTLSamplerAddressMode.Repeat
    sd.normalizedCoordinates = true
    sampler = device!.newSamplerStateWithDescriptor(sd)
    
    // nes
    nes = NES(path: ROM_PATH)
    guard let _ = nes else {
      Swift.print("not initialized")
      return
    }
    time = CACurrentMediaTime()
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    if let _ = device {
      if let _ = self.nes {
        let now = CACurrentMediaTime()
        let dt = now - time
        update(dt)
        renderNes()
        time = CACurrentMediaTime()
      } else {
        renderError()
      }
    } else {
      Swift.print("you need metal")
    }
  }
  
  func update(dt: Double) {
    guard dt < 1 else {
      return
    }
    nes!.c1.set(keys)
    nes!.stepDt(dt)
  }
  
  override func keyDown(theEvent: NSEvent) {
    setKeys(theEvent.keyCode, down: true)
  }
  
  override func keyUp(theEvent: NSEvent) {
    setKeys(theEvent.keyCode, down: false)
  }
  
  func setKeys(code: UInt16, down: Bool) {
    switch code {
    case KEY_A:
      keys[0] = down
    case KEY_B:
      keys[1] = down
    case KEY_SELECT:
      keys[2] = down
    case KEY_START:
      keys[3] = down
    case KEY_UP:
      keys[4] = down
    case KEY_DOWN:
      keys[5] = down
    case KEY_LEFT:
      keys[6] = down
    case KEY_RIGHT:
      keys[7] = down
    default:
      break
    }
  }
  
  func renderNes() {
    let texture = textureFromBuffer(nes!.ppu.frontBuffer.pix, width: 256, height: 240)
    render(texture)
  }
  
  func textureFromBuffer(buffer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> MTLTexture {
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.RGBA8Unorm, width: width, height: height, mipmapped: false)
    let texture = device!.newTextureWithDescriptor(texDescriptor)
    
    let region = MTLRegionMake2D(0, 0, width, height)
    texture.replaceRegion(region, mipmapLevel: 0, withBytes: buffer, bytesPerRow: bytesPerRow)
    return texture
  }
  
  func renderError() {
    let texture = textureTestPattern()
    render(texture)
  }
  
  func textureTestPattern() -> MTLTexture {
    let image = NSImage(contentsOfFile: NSBundle.mainBundle().pathForResource("color_pattern", ofType: "png")!)!
    let imageRef = image.CGImageForProposedRect(nil, context: .None, hints: .None)
    let (width, height) = (CGImageGetWidth(imageRef), CGImageGetHeight(imageRef))
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    let bitsPerComponent = 8
    let colorSpace = CGColorSpaceCreateDeviceRGB()!
    
    let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
    let bounds = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
    CGContextClearRect(context, bounds)
    CGContextDrawImage(context, bounds, imageRef)
    
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.RGBA8Unorm, width: Int(width), height: Int(height), mipmapped: false)
    let texture = device!.newTextureWithDescriptor(texDescriptor)
    
    let pixelsData = CGBitmapContextGetData(context)
    let region = MTLRegionMake2D(0, 0, Int(width), Int(height))
    texture.replaceRegion(region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: bytesPerRow)
    
    return texture
  }
  
  func render(texture: MTLTexture) {
    if let rpd = currentRenderPassDescriptor, drawable = currentDrawable {
      rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
      rpd.colorAttachments[0].loadAction = .Clear
      rpd.colorAttachments[0].storeAction = .Store
      let command_buffer = device!.newCommandQueue().commandBuffer()
      let command_encoder = command_buffer.renderCommandEncoderWithDescriptor(rpd)
      command_encoder.setCullMode(MTLCullMode.Front)
      command_encoder.setRenderPipelineState(renderPipeline)
      command_encoder.setVertexBuffer(vertex_buffer, offset: 0, atIndex: 0)
      command_encoder.setFragmentTexture(texture, atIndex: 0)
      command_encoder.setFragmentSamplerState(sampler, atIndex: 0)
      command_encoder.drawPrimitives(.TriangleStrip, vertexStart: 0, vertexCount: 4)
      command_encoder.endEncoding()
      command_buffer.presentDrawable(drawable)
      command_buffer.commit()
    }
  }
}