macro objc_allocator(name, _as)
    def self.{{_as}} (*args)
        method = LibObjC.sel_registerName({{name}})
        id = LibObjC.objc_msgSend(@@cls, method, *args)
        instance = allocate
        instance.initialize(id)
        instance
    end
end

macro objc_static(name, _as)
    def self.{{_as}} (*args)
        method = LibObjC.sel_registerName({{name}})
        LibObjC.objc_msgSend(@@cls, method, *args)
        nil
    end
end

macro objc_initializer(name, _as)
    def self.{{_as}} (*args)
        alloc = LibObjC.sel_registerName("alloc")
        method = LibObjC.sel_registerName({{name}})
        id = LibObjC.objc_msgSend(@@cls, alloc, *args)
        LibObjC.objc_msgSend(id, method, *args)
        instance = allocate
        instance.initialize(id)
        instance
    end
end

macro objc_method(name, _as)
    def {{_as}}(*args)
        method = LibObjC.sel_registerName({{name}})
        LibObjC.objc_msgSend(@id, method, *args)
    end
end

macro import_class(name)
    class {{name}}
        include LibObjC_Object
        @@cls = LibObjC.objc_getClass("{{name}}")

        macro method_missing(call)
            %meth = LibObjC.sel_registerName(\{{call.name.id.stringify.gsub(/_/, ": ")}}.strip) # strip to avoid a bug with "Error: unterminated quoted symbol"
            \{% if call.args.size > 0 %}
                LibObjC.objc_msgSend(@id, %meth, \{{*call.args}})
            \{% else %}
                LibObjC.objc_msgSend(@id, %meth)
            \{% end %}
        end
    end
end

module LibCocoa
  VERSION = "0.1.0"

  module LibObjC_Object
      def initialize(@id : LibObjC::ID)
      end

      def initialize()
          alloc = LibObjC.sel_registerName("alloc")
          initialize = LibObjC.sel_registerName("init")
          @id = LibObjC.objc_msgSend(@@cls, alloc)
          LibObjC.objc_msgSend(@id, initialize)
      end

      def finalize()
          dealloc = LibObjC.sel_registerName("dealloc")
          LibObjC.objc_msgSend(@id, dealloc);
      end

      def to_unsafe
          @id
      end
  end

  module NS
      def self.log(str : LibObjC_Object)
          LibObjC.NSLog(str)
      end

      def self.makeRect(x : Float64, y : Float64, width : Float64, height : Float64)
          origin = LibObjC::CGPoint.new
          origin.x = x
          origin.y = y
          size = LibObjC::CGSize.new
          size.width = width
          size.height = height
          rect = LibObjC::NSRect.new
          rect.origin = origin
          rect.size = size
          rect
      end
  end

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
  end

  import_class NSRunLoop

  class NSRunLoop
    objc_allocator "currentRunLoop", currentRunLoop
  end

  import_class NSApplication

  class NSApplication
    objc_allocator "sharedApplication", sharedApplication
  end
end
