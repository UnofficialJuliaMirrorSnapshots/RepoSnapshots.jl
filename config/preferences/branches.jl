const INCLUDE_BRANCHES = Regex[
    r"^dev$"i,
    r"^develop$"i,
    r"^latest$"i,
    r"^master$"i,
    r"^production$"i,
    r"^stable$"i,
    r"^trunk$"i,
    r"^unstable$"i,
    ]

const EXCLUDE_BRANCHES = Regex[
    r"^gh-pages$"i,
    ]
