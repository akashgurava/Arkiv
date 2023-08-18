// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol Table {
    associatedtype K

    var id: K { get }
}

extension Table {
    func get(_ key: K) -> Self {
        fatalError("Reading not yet implemented")
    }

    /// Save a table object.
    func save() throws {}
}

@attached(extension, conformances: Table)
@attached(member, names: named(K))
public macro Arkiv() = #externalMacro(module: "ArkivMacros", type: "ArkivMacro")
