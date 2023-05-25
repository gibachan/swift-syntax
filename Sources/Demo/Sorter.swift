// https://qiita.com/Ryu0118/items/5e8344e589054862b04d?utm_campaign=post_article&utm_medium=twitter&utm_source=twitter_share

import Foundation
import SwiftParser
import SwiftSyntax

func testEnumSortRewriter() {
    let enum1 =
    """
    enum E1 {
        case b
        case a
        case j
        case h
        case i
        case e
        case d
        case g
        case f
        case c
    }
    """
    let syntax1 = Parser.parse(source: enum1)
    let formatted1 = EnumSortRewriter().visit(syntax1)
    print(formatted1.description)

    let enum2 =
    """
    enum E2 {
        case b, d, a, c
    }
    """
    let syntax2 = Parser.parse(source: enum2)
    let formatted2 = EnumSortRewriter().visit(syntax2)
    print(formatted2.description)

}

final class EnumSortRewriter: SyntaxRewriter {
    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        var members = node.memberBlock.members
        var enumCases = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        var elementLists = enumCases.map(\.elements)
        if let elementList = elementLists.first,
           elementLists.count == 1 {
            // enum E1 {
            //    case c1, c2, c3
            // }
            let sortedList = sortElementList(elementList)
            elementLists = [sortedList]
        } else {
            // Enum E1 {
            //     case c1
            //     case c2
            //     case c3
            // }
            elementLists = sortElementLists(elementLists)
        }

        enumCases = zip(enumCases, elementLists).map {
            $0.with(\.elements, $1)
        }

        members = MemberDeclListSyntax(
            zip(members, enumCases).map {
                $0.with(\.decl, $1.cast(DeclSyntax.self))
            }
        )

        return super.visit(node.with(\.memberBlock.members, members))
    }

    private func sortElementLists(_ elementLists: [EnumCaseElementListSyntax]) -> [EnumCaseElementListSyntax] {
        elementLists.sorted {
            let firstText = $0.first?.identifier.text ?? ""
            let secondText = $1.first?.identifier.text ?? ""
            return firstText.localizedStandardCompare(secondText) == .orderedAscending
        }
    }

    private func sortElementList(_ elementList: EnumCaseElementListSyntax) -> EnumCaseElementListSyntax {
        let elements = elementList
            .sorted {
                $0.identifier.text.localizedStandardCompare($1.identifier.text) == .orderedAscending
            }
            .enumerated()
            .map { index, element in
                var element = element
                if index == elementList.count - 1 {
                    element.trailingComma = nil
                } else {
                    element.trailingComma = .commaToken(trailingTrivia: .space)
                }
                return element
            }
        return EnumCaseElementListSyntax(elements)
    }
}
