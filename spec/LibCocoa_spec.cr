require "./spec_helper"
require "../lib_cocoa"


import_class NSString

class NSString
  objc_allocator "stringWithUTF8String:", stringWithUTF8String
end

import_class NSWindow

class NSWindow
  objc_initializer "initWithContentRect:styleMask:backing:defer:", initWithContentRect_styleMask_backing_defer
  def self.initWithContentRect(frame : LibObjC::NSRect)
    self.initWithContentRect_styleMask_backing_defer(frame, nil, nil, false)
  end
end

describe LibCocoa do
  # TODO: Write tests

  it "works" do
    str = NSString.stringWithUTF8String("Hello World")
    NS.log(str)
  end

  it "can open a window" do
    frame = NS.makeRect(0, 0, 500, 500)
    NSWindow.initWithContentRect(frame)
  end
end
