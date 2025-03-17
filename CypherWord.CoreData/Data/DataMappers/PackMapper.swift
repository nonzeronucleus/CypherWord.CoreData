class PackMapper {
    static func toFileDefinition(mo: PackMO) -> PlayableLevelFileDefinition {
        PlayableLevelFileDefinition(packNumber: Int(mo.number), id: mo.id)
    }

    static func toFileDefinitions(mos: [PackMO]) -> [PlayableLevelFileDefinition] {
        mos.map(toFileDefinition)
    }
}
