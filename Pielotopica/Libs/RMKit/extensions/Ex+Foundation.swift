import Foundation

func measure(_ block:()->Void){
    print("Start Mesurement")
    let start = Date()
    block()
    print(Date().timeIntervalSince(start))
}

// MARK: - String Extesions in Foundation
extension String{
    public func removed(by charset:CharacterSet) -> String{
        return self.components(separatedBy: charset).filter {!$0.isEmpty}.joined()
    }
}
// MARK: - A NotificationCenter Extesion
extension NotificationCenter{
    /// For Easy Use.
    @discardableResult
    public func addObserver(forName name: NSNotification.Name, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return self.addObserver(forName: name, object: nil, queue: .main, using: block)
    }
}
extension URL {
    public var paramators:[String: String?] {
        get{
            guard let component = URLComponents(url: self, resolvingAgainstBaseURL: true) else {return [:]}
            
            return component.paramators
        }
        set{
            guard var component = URLComponents(url: self, resolvingAgainstBaseURL: true) else {return}
            
            component.paramators = newValue
            
            self = component.url!
        }
    }
}

// MARK: - URLComponents Extensions
extension URLComponents{
    
    /// UrlParamators converted to Dictionary type.
    public var paramators:[String: String?] {
        get{
            return self.queryItems?.reduce(into: [String:String?]()){$0[$1.name] = $1.value} ?? [:]
        }
        set{
            self.queryItems = newValue.map{URLQueryItem(name: $0, value: $1)}
        }
    }
}

extension NSObject{
    public func hasProperty(for name:String) -> Bool{
        let checkSelector = NSSelectorFromString(name)
        return self.responds(to: checkSelector)
    }
}
