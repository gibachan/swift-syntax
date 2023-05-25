import SwiftSyntax

class MyRewriter: SyntaxRewriter {
  override func visit(_ node: CodeBlockItemSyntax) -> CodeBlockItemSyntax {
    var modifiedNode = node
//    modifiedNode = node.with(\.leadingTrivia, node.leadingTrivia) // なぜこれでOK?
    modifiedNode[keyPath: \.trailingTrivia] = modifiedNode[keyPath: \.trailingTrivia]
    return modifiedNode
  }

  public static func write(tree: any SyntaxProtocol) -> Syntax {
    let applier = MyRewriter()
    return applier.rewrite(Syntax(tree))
  }
}
