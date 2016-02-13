import Foundation

class PPU {
  // storage
  var palette, nameTable, oam: UnsafeMutablePointer<UInt8>
  var frontBuffer, backBuffer: FrameBuffer
  // registers
  // OAMDATA is emulated using read/write funcs into oam above
  var PPUCTRL, PPUMASK, PPUSTATUS, OAMADDR, PPUSCROLL, PPUDATA: UInt8
  // state
  var cycleCount, scanLineCount: Int
  var frameCount : UInt
  var frameCountEven: Bool
  var write: Bool // write toggle
  // emulated PPUADDR
  var vramAddr: UInt16
  var tempAddr: UInt16
  
  // background
  var nameTableByte: UInt8
  var tileData: UInt64
  var attributeTableByte: UInt8
  var lowTileByte: UInt8
  var highTileByte: UInt8
  
  // sprite
  var spriteCount: Int
  var spritePatterns: UnsafeMutablePointer<UInt32>
  var spritePositions, spritePriorities, spriteIndexes : UnsafeMutablePointer<UInt8>
  
  // nmi
  var nmiDelay: Int
  var nmiPrev: Bool
  
  // use ivar instead of calculated prop for perf :(
  // PPUCTRL
  var baseNameTableAddr: Int
  var vramIncrement: Bool
  var spritePatternTable: Bool
  var backgroundPatternTable: Bool
  var spriteSize: Bool
  var nmiEnabled: Bool
  // PPUMASK
  var showBackground: Bool
  var showSprites: Bool
  var showBackgroundInLeft8Pixel: Bool
  var showSpriteInLeft8Pixel : Bool
  
  // 0 0x2000, 1 0x2400, 2 0x2800, 3 0x2c00
  var baseNameTableAddrCalculated: Int {
    return Int(PPUCTRL & 3)
  }
  
  // false: +1, true: +32
  var vramIncrementCaluculated: Bool {
    return PPUCTRL.getBit(2)
  }
  // false: 0, true: 0x1000
  var spritePatternTableCalculated: Bool {
    return PPUCTRL.getBit(3)
  }
  // false: 0, true: 0x1000
  var backgroundPatternTableCalculated: Bool {
    return PPUCTRL.getBit(4)
  }
  
  var spriteSizeCalculated: Bool {
    return PPUCTRL.getBit(5)
  }
  
  var nmiEnabledCalculated: Bool {
    return PPUCTRL.getBit(7)
  }
  
  var grayscale: Bool {
    return PPUMASK.getBit(0)
  }
  
  var showBackgroundInLeft8PixelCalculated: Bool {
    return PPUMASK.getBit(1)
  }
  
  var showSpriteInLeft8PixelCalculated: Bool {
    return PPUMASK.getBit(2)
  }
  
  var showBackgroundCalculated: Bool {
    return PPUMASK.getBit(3)
  }
  
  var showSpritesCalculated: Bool {
    return PPUMASK.getBit(4)
  }
  
  var emphasizeRed: Bool {
    return PPUMASK.getBit(5)
  }
  
  var emphasizeGreen: Bool {
    return PPUMASK.getBit(6)
  }
  
  var emphasizeBlue: Bool {
    return PPUMASK.getBit(7)
  }
  
  var spriteOverflow: Bool {
    get {
      return PPUSTATUS.getBit(5)
    }
    
    set(newOverflow) {
      PPUSTATUS = PPUSTATUS.setBit(newOverflow, at: 5)
    }
  }
  
  var spriteZeroHit: Bool {
    get {
      return PPUSTATUS.getBit(6)
    }
    
    set(newZeroHit) {
      PPUSTATUS = PPUSTATUS.setBit(newZeroHit, at: 6)
    }
  }
  
  var vblankStarted: Bool {
    get {
      return PPUSTATUS.getBit(7)
    }
    
    set(newVblankStarted) {
      PPUSTATUS = PPUSTATUS.setBit(newVblankStarted, at: 7)
    }
  }
  
  var xPPUSCROLL: Int {
    return Int(PPUSCROLL & 7)
  }

  
  init() {
    palette = UnsafeMutablePointer<UInt8>(malloc(32 * sizeof(UInt8)))
    nameTable = UnsafeMutablePointer<UInt8>(malloc(2048 * sizeof(UInt8)))
    oam = UnsafeMutablePointer<UInt8>(malloc(256 * sizeof(UInt8)))
    frontBuffer = FrameBuffer()
    backBuffer = FrameBuffer()
    
    PPUCTRL = 0
    PPUMASK = 0
    PPUSTATUS = 0
    OAMADDR = 0
    PPUSCROLL = 0
    PPUDATA = 0
    
    cycleCount = 340
    scanLineCount = 240
    frameCount = 0
    frameCountEven = true
    write = false
    vramAddr = 0
    tempAddr = 0
    
    nameTableByte = 0
    tileData = 0
    attributeTableByte = 0
    lowTileByte = 0
    highTileByte = 0
    
    spriteCount = 0
    spritePatterns = UnsafeMutablePointer<UInt32>(malloc(8 * sizeof(UInt32)))
    spritePositions = UnsafeMutablePointer<UInt8>(malloc(8 * sizeof(UInt8)))
    spritePriorities = UnsafeMutablePointer<UInt8>(malloc(8 * sizeof(UInt8)))
    spriteIndexes = UnsafeMutablePointer<UInt8>(malloc(8 * sizeof(UInt8)))
    
    nmiDelay = 0
    nmiPrev = false
    
    baseNameTableAddr = 0
    vramIncrement = false
    spritePatternTable = false
    backgroundPatternTable = false
    spriteSize = false
    nmiEnabled = false
    
    showBackground = false
    showSprites = false
    showBackgroundInLeft8Pixel = false
    showSpriteInLeft8Pixel = false
  }
  
  func readByte(addr: UInt16, c: Cartridge) -> UInt8 {
    let a = addr % 0x4000
    if a < 0x2000 {
      return c.mapper.read(a, c: c)
    } else if a < 0x3f00 {
      let mirrorMode = Int(c.mirrorMode)
      return nameTable[mirrorAddress(mirrorMode, addr: a) % 2048]
    } else if a < 0x4000 {
      return readPalette(a % 32)
    } else {
      return 0
    }
  }
  
  func writeByte(addr: UInt16, value: UInt8, c: Cartridge) {
    let a = addr % 0x4000
    if a < 0x2000 {
      c.mapper.write(a, value: value, c: c)
    } else if a < 0x3f00 {
      let mirrorMode = Int(c.mirrorMode)
      nameTable[mirrorAddress(mirrorMode, addr: a) % 2048] = value
    } else if a < 0x4000 {
      writePalette(a % 32, value: value)
    }
  }
  
  func readRegister(addr: UInt16, ram: RAM) -> UInt8 {
    switch addr {
    case 0x2002:
      let o = PPUSTATUS
      vblankStarted = false
      nmiChange()
      write = false
      return o
    case 0x2004:
      return oam[Int(OAMADDR)]
    case 0x2007:
      return readPPUDATA(ram.cartridge)
    default:
      return 0
    }
  }
  
  func readPPUDATA(c: Cartridge) -> UInt8 {
    var value = readByte(vramAddr, c: c)
    if vramAddr % 0x4000 < 0x3f00 {
      (PPUDATA, value) = (value, PPUDATA)
    } else {
      PPUDATA = readByte(vramAddr &- 0x1000, c: c)
    }
    
    if !vramIncrement {
      vramAddr = vramAddr &+ 1
    } else {
      vramAddr = vramAddr &+ 32
    }
    return value
  }
  
  func writeRegister(addr: UInt16, value: UInt8, ram: RAM) {
    // set lower 5 bits into PPUSTATUS
    PPUSTATUS = (PPUSTATUS & 0b11100000) | (value & 0x1f)
    switch addr {
    case 0x2000:
      PPUCTRL = value
      baseNameTableAddr = baseNameTableAddrCalculated
      vramIncrement = vramIncrementCaluculated
      spritePatternTable = spritePatternTableCalculated
      backgroundPatternTable = backgroundPatternTableCalculated
      spriteSize = spriteSizeCalculated
      nmiEnabled = nmiEnabledCalculated
      nmiChange()
      tempAddr = (tempAddr & 0xf3ff) | ((UInt16(value) & 0x03) << 10)
    case 0x2001:
      PPUMASK = value
      showBackground = showBackgroundCalculated
      showSprites = showSpritesCalculated
      showBackgroundInLeft8Pixel = showBackgroundInLeft8PixelCalculated
      showSpriteInLeft8Pixel = showSpriteInLeft8PixelCalculated
    case 0x2003:
      OAMADDR = value
    case 0x2004:
      oam[Int(OAMADDR)] = value
      OAMADDR = OAMADDR &+ 1
    case 0x2005:
      if !write {
        tempAddr = (tempAddr & 0xffe0) | (UInt16(value) >> 3)
        PPUSCROLL = value
        write = true
      } else {
        tempAddr = (tempAddr & 0x8fff) | ((UInt16(value) & 0x07) << 12)
        tempAddr = (tempAddr & 0xfc1f) | ((UInt16(value) & 0xf8) << 2)
        write = false
      }
    case 0x2006:
      if !write {
        tempAddr = (tempAddr & 0x80ff) | ((UInt16(value) & 0x3f) << 8)
        write = true
      } else {
        tempAddr = (tempAddr & 0xff00) | UInt16(value)
        vramAddr = tempAddr
        write = false
      }
    case 0x2007:
      writePPUDATA(value, c: ram.cartridge)
    case 0x4014:
      writeDMA(value, ram: ram)
    default:
      break
    }
  }
  
  func writePPUDATA(value: UInt8, c: Cartridge) {
    writeByte(vramAddr, value: value, c: c)
    if !vramIncrement {
      vramAddr = vramAddr &+ 1
    } else {
      vramAddr = vramAddr &+ 32
    }
  }
  
  func writeDMA(value: UInt8, ram: RAM) {
    var addr = UInt16(value) << 8
    for _ in 0..<256 {
      oam[Int(OAMADDR)] = ram.readByte(addr)
      OAMADDR = OAMADDR &+ 1
      addr = addr &+ 1
    }
    ram.cpu.suspend += ram.cpu.cycleCount % 2 == 1 ? 514 : 513
  }
  
  func step(cpu cpu: CPU, ram:RAM) {
    let rendering = showBackground || showSprites
    if nmiDelay > 0 {
      nmiDelay--
      if nmiDelay == 0 && nmiEnabled && vblankStarted {
        cpu.interrupt = Interrupt.NMI
      }
    }
    
    if self.cycleCount == 339 && self.scanLineCount == 261 && !self.frameCountEven && rendering {
      self.cycleCount = 0
      scanLineCount = 0
      frameCount = frameCount &+ 1
      frameCountEven = !frameCountEven
    } else {
      self.cycleCount = self.cycleCount &+ 1
      if self.cycleCount > 340 {
        self.cycleCount = 0
        scanLineCount = scanLineCount &+ 1
        if scanLineCount > 261 {
          scanLineCount = 0
          frameCount = frameCount &+ 1
          frameCountEven = !frameCountEven
        }
      }
    }
    
    let cycleCount = self.cycleCount
    let preLine = scanLineCount == 261
    let visibleLine = scanLineCount < 240
    let renderLine = preLine || visibleLine
    let preFetchCycle = cycleCount >= 321 && cycleCount <= 336
    let visibleCycle = cycleCount >= 1 && cycleCount <= 256
    let fetchCycle = preFetchCycle || visibleCycle
    
    if rendering {
      // background
      if visibleLine && visibleCycle {
        renderPixel()
      }
      
      if renderLine && fetchCycle {
        tileData <<= 4
        switch cycleCount % 8 {
        case 0:
          writeTileData()
        case 1:
          readNameTableByte(ram.cartridge)
        case 3:
          readAttributeTableByte(ram.cartridge)
        case 5:
          readLowTileByte(ram.cartridge)
        case 7:
          readHighTileByte(ram.cartridge)
        default:
          break
        }
      }
      
      if preLine && cycleCount >= 280 && cycleCount <= 304 {
        copyY()
      }
      
      if renderLine {
        if fetchCycle && cycleCount % 8 == 0 {
          incrementX()
        }
        
        if cycleCount == 256 {
          incrementY()
        }
        
        if cycleCount == 257 {
          copyX()
        }
      }
      
      // sprites
      if cycleCount == 257 {
        if visibleLine {
          evaluateSprites(ram.cartridge)
        } else {
          spriteCount = 0
        }
      }
    }
    
    if scanLineCount == 241 && cycleCount == 1 {
      startVblank(cpu)
    }
    
    if preLine && cycleCount == 1 {
      completeVblank()
      spriteZeroHit = false
      spriteOverflow = false
    }
    
  }
  
  func renderPixel() {
    let x = cycleCount - 1
    let y = scanLineCount
    var bg = backgroundPixel()
    var (index: idx, color: sprite) = spritePixel()
    if x < 8 && !showBackgroundInLeft8Pixel {
      bg = 0
    }
    
    if x < 8 && !showSpriteInLeft8Pixel {
      sprite = 0
    }
    let b = bg % 4 != 0
    let s = sprite % 4 != 0
    let color: UInt8
    if !b && !s {
      color = 0
    } else if !b && s {
      color = sprite | 0x10
    } else if b && !s {
      color = bg
    } else {
      if spriteIndexes[Int(idx)] == 0 && x < 255 {
        spriteZeroHit = true
      }
      if spritePriorities[Int(idx)] == 0 {
        color = sprite | 0x10
      } else {
        color = bg
      }
    }
    backBuffer.set(x: x, y: y, colorIndex: Int(readPalette(UInt16(color)) % 64))
  }
  
  func backgroundPixel() -> UInt8 {
    guard showBackground else {
      return 0
    }
    let data = readTileData() >> UInt32((7 - xPPUSCROLL) * 4)
    return UInt8(data & 0x0f)
  }
  
  func spritePixel() -> (index: UInt8,  color: UInt8){
    if !showSprites {
      return (index: 0, color: 0)
    }
    for i in 0..<spriteCount {
      var offset = cycleCount - 1 - Int(spritePositions[i])
      guard offset >= 0 && offset <= 7 else {
        continue
      }
      offset = 7 - offset
      let color = UInt8(spritePatterns[i] >> UInt32((offset * 4) & 0xff) & 0x0f)
      guard color % 4 != 0 else {
        continue
      }
      return (index: UInt8(i & 0xff), color: color)
    }
    return (index: 0, color: 0)
  }
  
  func readPalette(addr: UInt16) -> UInt8 {
    var a = addr
    if a >= 16 && a % 4 == 0 {
      a -= 16
    }
    return palette[Int(a)]
  }
  
  func writePalette(addr: UInt16, value: UInt8) {
    var a = addr
    if a >= 16 && a % 4 == 0 {
      a -= 16
    }
    palette[Int(a)] = value
  }
  
  func readTileData() -> UInt32 {
    return UInt32((tileData >> 32) & 0xffffffff)
  }
  
  func writeTileData() {
    var data: UInt32 = 0
    for _ in 0..<8 {
      let a = attributeTableByte
      let p1 = (lowTileByte & 0x80) >> 7
      let p2 = (highTileByte & 0x80) >> 6
      lowTileByte <<= 1
      highTileByte <<= 1
      data <<= 4
      data |= UInt32(a | p1 | p2)
    }
    tileData |= UInt64(data)
  }
  
  func readNameTableByte(c: Cartridge) {
    nameTableByte = readByte(0x2000 | (vramAddr & 0x0fff), c: c)
  }
  
  func readAttributeTableByte(c: Cartridge) {
    let a = 0x23c0 | (vramAddr & 0x0c00) | ((vramAddr >> 4) & 0x38) | ((vramAddr >> 2) & 0x07)
    let shift = UInt8(((vramAddr >> 4) & 4) | (vramAddr & 2))
    attributeTableByte = ((readByte(a, c: c) >> shift ) & 3) << 2
  }
  
  func readLowTileByte(c: Cartridge) {
    let fineY = (vramAddr >> 12) & 7
    let table: UInt16 = backgroundPatternTable ? 0x1000 : 0
    let tile = UInt16(nameTableByte)
    let a = table + tile * 16 + fineY
    lowTileByte = readByte(a, c: c)
  }
  
  func readHighTileByte(c: Cartridge) {
    let fineY = (vramAddr >> 12) & 7
    let table: UInt16 = backgroundPatternTable ? 0x1000 : 0
    let tile = UInt16(nameTableByte)
    let a = table + tile * 16 + fineY
    highTileByte = readByte(a &+ 8, c: c)
  }
  
  func copyX() {
    vramAddr = (vramAddr & 0xfbe0) | (tempAddr & 0x041f)
  }
  
  func copyY() {
    vramAddr = (vramAddr & 0x841f) | (tempAddr & 0x7be0)
  }
  
  func incrementX() {
    if vramAddr & 0x001f == 31 {
      vramAddr &= 0xffe0
      vramAddr ^= 0x0400
    } else {
      vramAddr = vramAddr &+ 1
    }
  }
  
  func incrementY() {
    if vramAddr & 0x7000 != 0x7000 {
      vramAddr = vramAddr &+ 0x1000
    } else {
      vramAddr &= 0x8fff
      var y = (vramAddr & 0x03e0) >> 5
      switch y {
      case 29:
        y = 0
        vramAddr ^= 0x0800
      case 31:
        y = 0
      default:
        y++
      }
      vramAddr = (vramAddr & 0xfc1f) | (y << 5)
    }
  }
  
  func evaluateSprites(c: Cartridge) {
    let h: Int = spriteSize ? 16 : 8
    var count = 0
    for i in 0..<64 {
      let y = oam[i * 4 + 0]
      let a = oam[i * 4 + 2]
      let x = oam[i * 4 + 3]
      let row = scanLineCount - Int(y)
      guard row >= 0 && row < h else {
        continue
      }
      if count < 8 {
        spritePatterns[count] = readSpritePattern(i, row: row, c: c)
        spritePositions[count] = x
        spritePriorities[count] = (a >> 5) & 1
        spriteIndexes[count] = UInt8(i)
      }
      count++
    }
    
    if count > 8 {
      count = 8
      spriteOverflow = true
    }
    spriteCount = count
  }
  
  func readSpritePattern(i: Int, var row: Int, c: Cartridge) -> UInt32 {
    var tile = UInt16(oam[i * 4 + 1])
    let attrs = oam[i * 4 + 2]
    var addr: UInt16
    
    if !spriteSize {
      if attrs & 0x80 == 0x80 {
        row = 7-row
      }
      let table: UInt16 = spritePatternTable ? 0x1000 : 0
      addr = table + tile * 16 + UInt16(row)
    } else {
      if attrs & 0x80 == 0x80 {
        row = 15 - row
      }
      let table: UInt16 = 0x1000 * (tile & 1)
      tile &= 0xfe
      if row > 7 {
        tile++
        row -= 8
      }
      addr = table + tile * 16 + UInt16(row)
    }
    
    let a = (attrs & 3) << 2
    lowTileByte = readByte(addr, c: c)
    highTileByte = readByte(addr &+ 8, c: c)
    var data: UInt32 = 0
    for _ in 0..<8 {
      let p1,p2 : UInt8
      if attrs & 0x40 == 0x40 {
        p1 = (lowTileByte & 1) << 0
        p2 = (highTileByte & 1) << 1
        lowTileByte >>= 1
        highTileByte >>= 1
      } else {
        p1 = (lowTileByte & 0x80) >> 7
        p2 = (highTileByte & 0x80) >> 6
        lowTileByte <<= 1
        highTileByte <<= 1
      }
      data <<= 4
      data |= UInt32(a | p1 | p2)
    }
    return data
  }
  
  func startVblank(cpu: CPU) {
    (frontBuffer, backBuffer) = (backBuffer, frontBuffer)
    vblankStarted = true
    nmiChange()
  }
  
  func completeVblank() {
    vblankStarted = false
    nmiChange()
  }
  
  func nmiChange() {
    let nmi = nmiEnabled && vblankStarted
    if nmi && !nmiPrev {
      // TODO: this fixes some games but the delay shouldn't have to be so
      // long, so the timings are off somewhere
      nmiDelay = 15
    }
    nmiPrev = nmi
  }
  
}