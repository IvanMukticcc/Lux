import SwiftUI

enum CategoryType: Int, CaseIterable, RawRepresentable {
    case fun = 0
    case hobby = 1
    case family = 2
    case job = 3
    
    var categoryColor: Color {
        switch self {
        case .fun:
            return .red
        case .hobby:
            return .yellow
        case .family:
            return .orange
        case .job:
            return .red
        }
    }
    
    var categoryName: String {
        switch self {
        case .fun:
            return "Fun"
        case .hobby:
            return "Hobby"
        case .family:
            return "Family"
        case .job:
            return "Job"
        }
    }
    
    var categoryImage: String {
        switch self {
        case .fun:
            return "theatermasks"
        case .hobby:
            return "figure.strengthtraining.traditional"
        case .job:
            return "briefcase"
        case .family:
            return "figure.2.and.child.holdinghands"
        }
    }
}
