import Foundation

class CrosswordTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        let crossword = value as! Crossword
        var result = ""
        
        for row in 0..<crossword.rows {
            for column in 0..<crossword.columns {
                result += String(crossword[row, column].letter ?? ".")
            }
            result += "|"
        }
        
        return result
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let strValue = value as? String {
            return Crossword(initString: strValue)
        }
        return nil
    }
}


extension NSValueTransformerName {
    static let crosswordTransformerName = NSValueTransformerName(rawValue: "CrosswordTransformer")
}
