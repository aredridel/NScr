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
