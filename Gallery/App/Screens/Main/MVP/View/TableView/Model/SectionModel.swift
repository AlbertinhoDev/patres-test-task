enum SectionType {
    case posts
}

enum RowType {
    case post
}

struct Section {
    let type: SectionType
    let rows: [RowType]
}
