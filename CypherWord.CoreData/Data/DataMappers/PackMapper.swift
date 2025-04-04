class PackMapper {
    static func toFileDefinition(mo: PackMO) -> PackDefinition {
        PackDefinition(id: mo.id, packNumber: Int(mo.number))
    }

    static func toFileDefinitions(mos: [PackMO]) -> [PackDefinition] {
        mos.map(toFileDefinition)
    }
}
