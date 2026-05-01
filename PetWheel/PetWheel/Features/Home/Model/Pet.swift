import Foundation

enum PetType: String, Codable, CaseIterable, Identifiable {
    case dog, cat, rabbit, hamster, bird, fish, reptile, other

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .dog: return "🐕"
        case .cat: return "🐈"
        case .rabbit: return "🐇"
        case .hamster: return "🐹"
        case .bird: return "🦜"
        case .fish: return "🐠"
        case .reptile: return "🦎"
        case .other: return "🐾"
        }
    }

    var displayName: String { rawValue.capitalized }
}

struct Pet: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var type: PetType
    var birthday: Date?
    var notes: String
    var activityHistory: [PetActivity]

    init(id: UUID = UUID(), name: String, type: PetType, birthday: Date? = nil, notes: String = "") {
        self.id = id
        self.name = name
        self.type = type
        self.birthday = birthday
        self.notes = notes
        self.activityHistory = []
    }

    var age: String? {
        guard let birthday else { return nil }
        let components = Calendar.current.dateComponents([.year, .month], from: birthday, to: Date())
        if let years = components.year, years > 0 {
            return "\(years) yr\(years == 1 ? "" : "s")"
        }
        if let months = components.month, months > 0 {
            return "\(months) mo"
        }
        return "< 1 mo"
    }
}

struct PetActivity: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
    let date: Date

    init(id: UUID = UUID(), name: String, emoji: String, date: Date = Date()) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.date = date
    }
}

extension PetActivity {
    static let all: [PetActivity] = [
        PetActivity(name: "Walk", emoji: "🚶"),
        PetActivity(name: "Play Fetch", emoji: "🎾"),
        PetActivity(name: "Bath Time", emoji: "🛁"),
        PetActivity(name: "Training", emoji: "🎓"),
        PetActivity(name: "Vet Visit", emoji: "🏥"),
        PetActivity(name: "Cuddle Time", emoji: "🤗"),
        PetActivity(name: "Grooming", emoji: "✂️"),
        PetActivity(name: "Playtime", emoji: "🎮"),
        PetActivity(name: "Feeding", emoji: "🍖"),
        PetActivity(name: "Nap Time", emoji: "😴"),
        PetActivity(name: "Run", emoji: "🏃"),
        PetActivity(name: "Swim", emoji: "🏊"),
        PetActivity(name: "Photo Session", emoji: "📸"),
        PetActivity(name: "Socialization", emoji: "👥"),
        PetActivity(name: "Trick Practice", emoji: "⭐️"),
        PetActivity(name: "Adventure Walk", emoji: "🗺️")
    ]
}
