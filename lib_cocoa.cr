@[Link(framework: "Cocoa")]
lib CocoaFramework
    type ID = Void*
    type SEL = Void*
    type CLS = Void*
    fun objc_msgSend(obj : ID, message : SEL, ...): ID
    fun objc_getClass(cls : LibC::Char*): ID
    fun class_createInstance(cls : CLS, extraBytes : LibC::SizeT): ID
    fun NSLog(str : ID)
    fun sel_registerName(name : LibC::Char*): SEL
end

class Cocoa
    def getClass(cls : String): CocoaFramework::ID
        CocoaFramework.objc_getClass(cls.check_no_null_byte)
    end

    def msgSend(obj : CocoaFramework::ID, message : CocoaFramework::SEL, *args) CocoaFramework::ID
        CocoaFramework.objc_msgSend(obj, message, *args)
    end

    def msgSend(obj : CocoaFramework::ID, message : String, *args) CocoaFramework::ID
        sel = CocoaFramework.sel_registerName(message.check_no_null_byte)
        CocoaFramework.objc_msgSend(obj, sel, *args)
    end

    def createInstance(cls : CLS): ID
        CocoaFramework.class_createInstance(cls, 0)
    end

    def log(str : CocoaFramework::ID)
        CocoaFramework.NSLog(str)
    end
end
