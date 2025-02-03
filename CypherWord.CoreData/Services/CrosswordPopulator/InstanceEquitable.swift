protocol InstanceEquatable: AnyObject, Equatable {}

extension InstanceEquatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
}
