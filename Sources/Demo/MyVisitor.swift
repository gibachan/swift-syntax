//
//  MyVisitor.swift
//  
//
//  Created by Tatsuyuki Kobayashi on 2023/05/20.
//

import SwiftSyntax

class MyVisitor: SyntaxAnyVisitor {
  init() {
    super.init(viewMode: .sourceAccurate)
  }

//  override func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
//    print("<\(type(of: node.asProtocol(SyntaxProtocol.self)))>", terminator: "")
//    return .visitChildren
//  }
//  override func visitAnyPost(_ node: Syntax) {
//    print("</\(type(of: node.asProtocol(SyntaxProtocol.self)))>", terminator: "")
//  }
//  override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
//    print("### Node: \(token.tokenKind), previousToken=\(token.previousToken(viewMode: .fixedUp))")
//    return .visitChildren
//  }

  override func visit(_ node: CodeBlockItemSyntax) -> SyntaxVisitorContinueKind {
    print(node.leadingTrivia.debugDescription)
    print(node.trailingTrivia.debugDescription)
    return .visitChildren
  }
}

func myVisitSyntaxTree(_ tree: SyntaxProtocol) {
  let printer = MyVisitor()
  printer.walk(tree)
}
