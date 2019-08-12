import CoreGraphics

// MARK: - CoreGraphics Extensions

extension CGSize {
    /// CGSizeをCGPointに変換して返します。
    var point:CGPoint {
        return CGPoint(x: width, y: height)
    }
}
extension CGPoint {
    /// CGPointをCGSizeに変換して返します。
    var size:CGSize {
        return CGSize(width: x, height: y)
    }
}

extension CGSize {
    /// boundingSizeにアスペクトフィットするのに必要な変換レートを返します。
    func aspectFitRatio(to boundingSize: CGSize) -> CGFloat {
        let mW = boundingSize.width / self.width
        let mH = boundingSize.height / self.height
        
        if mH > mW {
            return boundingSize.width / self.width
        } else {
            return boundingSize.height / self.height
        }
    }
    
    /// minimumSizeにアスペクトフィルするのに必要な変換レートを返します。
    func aspectFillRatio(to minimumSize: CGSize) -> CGFloat {
        let mW = minimumSize.width / self.width
        let mH = minimumSize.height / self.height
        
        if mH < mW {
            return minimumSize.width / self.width
        } else {
            return minimumSize.height / self.height
        }
    }
}

// MARK: - Make initable with array

/** CGPoint,CGSize,CGRectの配列初期化用
 
 --Sample--
 ```
 let hogePoint:CGPoint = [100, 100] // CGPoint(100, 100)
 let fugaSize:CGSize = [200, 200] // CGSize(200, 200)
 let piyoRect:CGRect = [50, 50, 300, 300] // CGRect(50, 50, 300, 300)
 ```
 配列の要素数が足りなかった場合 Out of Index Error で落ちます。
 */
extension CGPoint: ExpressibleByArrayLiteral{
    
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(x: elements[0], y: elements[1])
    }
}

extension CGSize:ExpressibleByArrayLiteral{
    
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        self.init(width: elements[0], height: elements[1])
    }
}
extension CGRect: ExpressibleByArrayLiteral{
    
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 4)
        self.init(x: elements[0], y: elements[1], width: elements[2], height: elements[3])
    }
}

// MARK: - A CGRect Extension
extension CGRect{
    ///Center of the Rect
    public var center:CGPoint{
        let x = self.origin.x + self.size.width/2.0
        let y = self.origin.y + self.size.height/2.0
        
        return CGPoint(x: x, y: y)
    }
}


// ================================================================ //
// MARK: - CGSize Operators -
extension CGSize {
    public static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    public static func * <T:BinaryInteger>(lhs: CGSize, rhs: T) -> CGSize {
        return CGSize(width: lhs.width * CGFloat(rhs), height: lhs.height * CGFloat(rhs))
    }
    public static func / <T:BinaryInteger>(lhs: CGSize, rhs: T) -> CGSize {
        return CGSize(width: lhs.width / CGFloat(rhs), height: lhs.height / CGFloat(rhs))
    }
    
    public static func *= <T:BinaryInteger>(lhs: inout CGSize, rhs: T) {
        lhs.width = lhs.width * CGFloat(rhs)
        lhs.height = lhs.height * CGFloat(rhs)
    }
    public static func /= <T:BinaryInteger>(lhs: inout CGSize, rhs: T) {
        lhs.width = lhs.width / CGFloat(rhs)
        lhs.height = lhs.height / CGFloat(rhs)
    }
    
    public static prefix func - (lhs: CGSize) -> CGSize {
        return CGSize(width: -lhs.width, height: -lhs.height)
    }
}



// ================================================================ //
// MARK: - CGPoint Operators -

extension CGPoint {
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func * <T:BinaryInteger>(lhs: CGPoint, rhs: T) -> CGPoint {
        return CGPoint(x: lhs.x * CGFloat(rhs), y: lhs.y * CGFloat(rhs))
    }
    public static func / <T:BinaryInteger>(lhs: CGPoint, rhs: T) -> CGPoint {
        return CGPoint(x: lhs.x / CGFloat(rhs), y: lhs.y / CGFloat(rhs))
    }
    
    public static func *= <T:BinaryInteger>(lhs: inout CGPoint, rhs: T) {
        lhs.x = lhs.x * CGFloat(rhs)
        lhs.y = lhs.y * CGFloat(rhs)
    }
    public static func /= <T:BinaryInteger>(lhs: inout CGPoint, rhs: T) {
        lhs.x = lhs.x / CGFloat(rhs)
        lhs.y = lhs.y / CGFloat(rhs)
    }
    
    public static prefix func - (lhs: CGPoint) -> CGPoint {
        return CGPoint(x: -lhs.x, y: -lhs.y)
    }
}










