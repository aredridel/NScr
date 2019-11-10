require "./spec_helper"
require "../lib_cocoa"




describe LibCocoa do
  # TODO: Write tests

  it "works" do
    cocoa = Cocoa.new
    nsstring = cocoa.getClass("NSString")
    str = cocoa.msgSend(nsstring, "stringWithUTF8String:", "Hello World")
    cocoa.log(str)
  end
end
