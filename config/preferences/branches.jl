const INCLUDE_BRANCHES = Regex[
    r"^default$"i,
    r"^dev$"i,
    r"^develop$"i,
    r"^development$"i,
    r"^latest$"i,
    r"^main$"i,
    r"^master$"i,
    r"^production$"i,
    r"^stable$"i,
    r"^trunk$"i,
    r"^unstable$"i,
    ]

const EXCLUDE_BRANCHES = Regex[
    r"^gh-pages$"i,
    r"^gh-pages1$"i,
    ]
