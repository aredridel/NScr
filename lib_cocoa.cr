@[Link(framework: "Cocoa")]
lib LibObjC
    type ID = Void*
    type SEL = Void*
    fun objc_msgSend(obj : ID, message : SEL, ...): ID
    fun objc_getClass(cls : LibC::Char*): ID
    fun sel_registerName(name : LibC::Char*): SEL
    fun NSLog(str : ID)

    struct CGPoint
        x : Float64
        y : Float64
    end

    struct CGSize
        width : Float64 
        height : Float64
    end

    struct NSRect
        origin : CGPoint
        size : CGSize
    end
end

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
