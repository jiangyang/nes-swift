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
  var keys: [Bool] = [Bool](repeating: false, count: 8)
  
  var time: Double = CACurrentMediaTime()
  
  var vertex_buffer: MTLBuffer!
  var renderPipeline: MTLRenderPipelineState!
  var sampler: MTLSamplerState!
  
  override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
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
    vertex_buffer = device!.makeBuffer(bytes: vertex_data, length:vertex_data.count * MemoryLayout<Vertex>.stride, options:[])
    // pipeline, shaders etc
    let lib = device!.makeDefaultLibrary()
    guard let _ = lib else {
      Swift.print("no default library")
      return
    }
    let pd = MTLRenderPipelineDescriptor()
    pd.vertexFunction = lib!.makeFunction(name: "vertex_shader")
    pd.fragmentFunction = lib!.makeFunction(name: "fragment_shader")
    pd.colorAttachments[0].pixelFormat = .bgra8Unorm
    do {
        try renderPipeline = device!.makeRenderPipelineState(descriptor: pd)
    } catch let err {
      Swift.print("nose \(err)")
    }
    // sampler
    let sd = MTLSamplerDescriptor()
    sd.minFilter = MTLSamplerMinMagFilter.nearest
    sd.magFilter = MTLSamplerMinMagFilter.nearest
    sd.sAddressMode = MTLSamplerAddressMode.repeat
    sd.tAddressMode = MTLSamplerAddressMode.repeat
    sd.normalizedCoordinates = true
    sampler = device!.makeSamplerState(descriptor: sd)
    
    // nes
    nes = NES(path: ROM_PATH)
    guard let _ = nes else {
      Swift.print("not initialized")
      return
    }
    time = CACurrentMediaTime()
  }
  
    override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    if let _ = device {
      if let _ = self.nes {
        let now = CACurrentMediaTime()
        let dt = now - time
        update(dt: dt)
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
    nes!.c1.set(input: keys)
    nes!.stepDt(dt: dt)
  }
  
  override func keyDown(with: NSEvent) {
    setKeys(code: with.keyCode, down: true)
  }
  
  override func keyUp(with: NSEvent) {
    setKeys(code: with.keyCode, down: false)
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
    let texture = textureFromBuffer(buffer: nes!.ppu.frontBuffer.pix, width: 256, height: 240)
    render(texture: texture)
  }
  
  func textureFromBuffer(buffer: UnsafeMutablePointer<UInt8>, width: Int, height: Int) -> MTLTexture {
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: width, height: height, mipmapped: false)
    let texture = device!.makeTexture(descriptor: texDescriptor)
    
    let region = MTLRegionMake2D(0, 0, width, height)
    texture!.replace(region: region, mipmapLevel: 0, withBytes: buffer, bytesPerRow: bytesPerRow)
    return texture!
  }
  
  func renderError() {
    let texture = textureTestPattern()
    render(texture: texture)
  }
  
  func textureTestPattern() -> MTLTexture {
    let image = NSImage(contentsOfFile: Bundle.main.path(forResource: "color_pattern", ofType: "png")!)!
    let imageRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * imageRef.width
    let bitsPerComponent = 8
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    let context = CGContext(data: nil, width: imageRef.width, height: imageRef.height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bounds = CGRect(x: 0, y: 0, width: Int(imageRef.width), height: Int(imageRef.height))
    context!.clear(bounds)
    context!.draw(imageRef, in: bounds)
    
    let texDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: MTLPixelFormat.rgba8Unorm, width: Int(imageRef.width), height: Int(imageRef.height), mipmapped: false)
    let texture = device!.makeTexture(descriptor: texDescriptor)
    
    let pixelsData = context!.data!
    let region = MTLRegionMake2D(0, 0, Int(imageRef.width), Int(imageRef.height))
    texture!.replace(region: region, mipmapLevel: 0, withBytes: pixelsData, bytesPerRow: bytesPerRow)
    
    return texture!
  }
  
  func render(texture: MTLTexture) {
    if let rpd = currentRenderPassDescriptor, let drawable = currentDrawable {
      rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        rpd.colorAttachments[0].loadAction = .clear
        rpd.colorAttachments[0].storeAction = .store
      let command_buffer = device!.makeCommandQueue()!.makeCommandBuffer()
        let command_encoder = command_buffer!.makeRenderCommandEncoder(descriptor: rpd)
        command_encoder!.setCullMode(MTLCullMode.front)
      command_encoder!.setRenderPipelineState(renderPipeline)
        command_encoder!.setVertexBuffer(vertex_buffer, offset: 0, index: 0)
        command_encoder!.setFragmentTexture(texture, index: 0)
        command_encoder!.setFragmentSamplerState(sampler, index: 0)
        command_encoder!.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
      command_encoder!.endEncoding()
        command_buffer!.present(drawable)
      command_buffer!.commit()
    }
  }
}
