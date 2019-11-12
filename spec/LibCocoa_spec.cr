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
    self.initWithContentRect_styleMask_backing_defer(frame, 15, 2, false)
  end
  objc_method "close", close
  objc_method "display", display
  objc_method "setTitle:", setTitle
  objc_method "orderFront:", orderFront
end

import_class NSRunLoop

class NSRunLoop
  objc_allocator "currentRunLoop", currentRunLoop
end

import_class NSApplication

class NSApplication
  objc_allocator "sharedApplication", sharedApplication
  objc_method "activateIgnoringOtherApps:", activateIgnoringOtherApps
end

describe LibCocoa do
  # TODO: Write tests

  it "works" do
    str = NSString.stringWithUTF8String("Hello World")
    NS.log(str)
  end

  it "can open a window" do
    app = NSApplication.sharedApplication
    frame = NS.makeRect(0, 0, 500, 500)
    window = NSWindow.initWithContentRect(frame)
    window.orderFront(nil)
    window.setTitle(NSString.stringWithUTF8String("Hello!"))
    app.activateIgnoringOtherApps(true)
    app.run
    window.close
  end
end
