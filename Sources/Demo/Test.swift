import SwiftParser
import SwiftSyntax
import SwiftParserDiagnostics

@main
struct Test {
  static func main() {
    // labeledExprList node について、 requiresIndent が true を返すために不要なインデントが発生
    // closureExpr node となるべきかも？
    let source = """
          myFunc({
              return true
          })
          """

    var parser = Parser(source)
    let tree = SourceFileSyntax.parse(from: &parser)
    let formatted = tree.formatted()
    print(tree.description)
    print(formatted.description)
    print(tree.description == formatted.description)
  }
}
