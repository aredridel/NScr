require "./spec_helper"
require "../lib_cocoa"

extend LibCocoa

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
    window.orderFront_(0)
    window.setTitle_(NSString.stringWithUTF8String("Hello!"))
    app.activateIgnoringOtherApps_(true)
    app.run
    window.close
  end
end
