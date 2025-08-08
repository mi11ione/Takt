import Foundation
import SwiftData

@Model
final class Chain {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorName: String
    var createdAt: Date
    var archivedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \ChainItem.chain)
    var items: [ChainItem]

    init(id: UUID = UUID(), name: String, colorName: String = "blue", createdAt: Date = .now, archivedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.colorName = colorName
        self.createdAt = createdAt
        self.archivedAt = archivedAt
        items = []
    }
}

@Model
final class ChainItem {
    @Attribute(.unique) var id: UUID
    var order: Int
    @Relationship(deleteRule: .noAction) var habit: Habit?
    @Relationship(deleteRule: .noAction) var chain: Chain?

    init(id: UUID = UUID(), order: Int, habit: Habit? = nil, chain: Chain? = nil) {
        self.id = id
        self.order = order
        self.habit = habit
        self.chain = chain
    }
}
