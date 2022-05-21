// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "texlive",
    products: [
        .library(name: "texlive", targets: ["texlua53", "kpathsea", "luatex", "pdftex", "bibtex"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "texlua53",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/texlua53.xcframework.zip",
            checksum: "99e66932e5025a91496acd1228b6a0d03d19043db7585c2b608d0fc5f9eb5cff"
        ),
        .binaryTarget(
            name: "kpathsea",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/kpathsea.xcframework.zip",
            checksum: "2f04e8d8c589eecf3d022a34f71b57292a9271c88d48a7a767c68fdcfc937f23"
        ),
        .binaryTarget(
            name: "makeindex",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/makeindex.xcframework.zip",
            checksum: "91b7c0bcaf3f1cd75d550a3115f91d45a7e31e9752b82bc1eb46095aa77687ed"
        ),
        .binaryTarget(
            name: "luatex",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/luatex.xcframework.zip",
            checksum: "36beb9e8811a5d51f3a938b9fb057b4b769333cf1069247d19b5e82ed8a8e40a"
        ),
        .binaryTarget(
            name: "luahbtex",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/luahbtex.xcframework.zip",
            checksum: "fdda49fa86031e9d13d2e53485f5b3c9874d03c11a8b241598f64c28964a0eba"
        ),
        .binaryTarget(
            name: "pdftex",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/pdftex.xcframework.zip",
            checksum: "e98163dbe715f621c1d44e14eb8484ba4e906129c02b6e0cd3e8dcc206775bd7"
        ),
        .binaryTarget(
            name: "bibtex",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/bibtex.xcframework.zip",
            checksum: "70b0608f634e3f7cbac88b8623d28e98113d67c8d5052abefd26e92544c59b80"
        ),
        .binaryTarget(
            name: "kpsewhich",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/kpsewhich.xcframework.zip",
            checksum: "0908aeb72d34d47ab8f530cf5e822d366b060c2c9a7b7f2d4a799082775373c7"
        ),
        .binaryTarget(
            name: "texlua53A",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/texlua53A.xcframework.zip",
            checksum: "5bdcafed346a1bf713dd6a2cc2fefd8ebc70199c5df0a120d02be13ee58f9610"
        ),
        .binaryTarget(
            name: "kpathseaA",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/kpathseaA.xcframework.zip",
            checksum: "b304a4080eb3cfc1d90187a74b8327a32c400ba5b466e4fda1051e0d5d55194a"
        ),
        .binaryTarget(
            name: "luatexA",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/luatexA.xcframework.zip",
            checksum: "e572cf1ea77ed50f895a7a6f74d6996b46ef614b89435f4a7eaae95983748aac"
        ),
        .binaryTarget(
            name: "luahbtexA",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/luahbtexA.xcframework.zip",
            checksum: "71f7f4b17f77fe8ff67be4a3abce40ab8f3f360636d0f73edb5156bcc5e88da6"
        ),
        .binaryTarget(
            name: "pdftexA",
            url: "https://github.com/holzschu/texlive-source/releases/download/texlive-2022/pdftexA.xcframework.zip",
            checksum: "16130dd0486e8fb352be4bc461f382733436576a5ad5c0ecccec847f3db8c506"
        )
    ]
)

