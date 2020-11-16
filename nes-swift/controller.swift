class Controller {
  // pressed button = true, unpressed = false
  var state: [Bool]
  // the read is sequential, as each read would get the status of next button state
  // index is used to keep track of where the read is at
  var index: Int
  // a flag written by the nes
  // if this flag is on, the subsequent reads return the state of button A only
  var strobe: Bool
  
  init() {
    state = [Bool](repeating: false, count: 8)
    index = 0
    strobe = false
  }
  
  deinit {
    print("Controller deinit")
  }
  
  func read() -> UInt8 {
    var o : UInt8 = 0
    if index < 8 {
      o = state[index] ? 1 : 0
    }
    index+=1
    index = strobe ? 0 : index
    return o
  }
  
  func write(value: UInt8) {
    strobe = value & 1 == 1 ? true : false
    index = strobe ? 0 : index
  }
  
  func set (input : [Bool]) {
    for i in 0...7 {
      if i < input.count {
        state[i] = input[i]
      }
    }
  }
}
