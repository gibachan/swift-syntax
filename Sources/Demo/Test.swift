import SwiftParser
import SwiftSyntax
import SwiftParserDiagnostics

@main
struct Test {
  static func main() {
  // Might be no problem  
    var input = Parser("""
        foo(a: 1)
        """)
//    var input = Parser("""
//        foo(someClosure: { _ in
//            return 1
//        })
//        """)
    let call = ExprSyntax.parse(from: &input)
    print(call.description)
    let formatted = call.formatted()
    print(formatted.description)
  }
}
