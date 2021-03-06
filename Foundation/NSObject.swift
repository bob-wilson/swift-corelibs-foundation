// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//


import CoreFoundation

public protocol NSObjectProtocol: class {
    
    func isEqual(_ object: AnyObject?) -> Bool
    var hash: Int { get }
    
    func `self`() -> Self
    
    func isProxy() -> Bool

    var description: String { get }
    
    var debugDescription: String { get }
}

extension NSObjectProtocol {
    public var debugDescription: String {
        return description
    }
}

public struct NSZone : ExpressibleByNilLiteral {
    public init() {
        
    }
    
    public init(nilLiteral: ()) {
        
    }
}

public protocol NSCopying {
    
    func copy(with zone: NSZone?) -> Any
}

extension NSCopying {
    public func copy() -> Any {
        return copy(with: nil)
    }
}

public protocol NSMutableCopying {
    
    func mutableCopy(with zone: NSZone?) -> Any
}

extension NSMutableCopying {
    public func mutableCopy() -> Any {
        return mutableCopy(with: nil)
    }
}

open class NSObject : NSObjectProtocol, Equatable, Hashable {
    // Important: add no ivars here. It will subvert the careful layout of subclasses that bridge into CF.    
    
    public init() {
        
    }
    
    open func copy() -> Any {
        if let copyable = self as? NSCopying {
            return copyable.copy(with: nil)
        }
        return self
    }
    
    open func mutableCopy() -> Any {
        if let copyable = self as? NSMutableCopying {
            return copyable.mutableCopy(with: nil)
        }
        return self
    }
    
    open func isEqual(_ object: AnyObject?) -> Bool {
        return object === self
    }
    
    open var hash: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    open func `self`() -> Self {
        return self
    }
    
    open func isProxy() -> Bool {
        return false
    }
    
    open var description: String {
        return "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
    }
    
    open var debugDescription: String {
        return description
    }
    
    open var _cfTypeID: CFTypeID {
        return 0
    }
    
    // TODO move these back into extensions once extension methods can be overriden
    open var classForCoder: AnyClass {
        return type(of: self)
    }
 
    open func replacementObjectForCoder(_ aCoder: NSCoder) -> AnyObject? {
        return self
    }

    // TODO: Could perhaps be an extension of NSCoding instead. The reason it is an extension of NSObject is the lack of default implementations on protocols in Objective-C.
    open var classForKeyedArchiver: AnyClass? {
        return self.classForCoder
    }
    
    // Implemented by classes to substitute a new class for instances during
    // encoding.  The object will be encoded as if it were a member of the
    // returned class.  The results of this method are overridden by the archiver
    // class and instance name<->class encoding tables.  If nil is returned,
    // then the null object is encoded.  This method returns the result of
    // [self classForArchiver] by default, NOT -classForCoder as might be
    // expected.  This is a concession to source compatibility.
    
    open func replacementObjectForKeyedArchiver(_ archiver: NSKeyedArchiver) -> AnyObject? {
        return self.replacementObjectForCoder(archiver)
    }
    
    // Implemented by classes to substitute new instances for the receiving
    // instance during encoding.  The returned object will be encoded instead
    // of the receiver (if different).  This method is called only if no
    // replacement mapping for the object has been set up in the archiver yet
    // (for example, due to a previous call of replacementObjectForKeyedArchiver:
    // to that object).  This method returns the result of
    // [self replacementObjectForArchiver:nil] by default, NOT
    // -replacementObjectForCoder: as might be expected.  This is a concession
    // to source compatibility.
    
    open class func classFallbacksForKeyedArchiver() -> [String] {
        return []
    }

    open class func classForKeyedUnarchiver() -> AnyClass {
        return self
    }

    open var hashValue: Int {
        return hash
    }
}

public func ==(lhs: NSObject, rhs: NSObject) -> Bool {
    return lhs.isEqual(rhs)
}

extension NSObject : CustomDebugStringConvertible {
}

extension NSObject : CustomStringConvertible {
}
