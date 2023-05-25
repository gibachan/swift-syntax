import SwiftParser
import SwiftSyntax
import SwiftParserDiagnostics

func example() {
  let name = "World"

  let sourceText =
  """
  func greeting(name: String) {
    print("Hello, \(name)!")
  }
  """

  // Parse the source code in sourceText into a syntax tree
  let sourceFile: SourceFileSyntax = Parser.parse(source: sourceText)

  // The "description" of the source tree is the source-accurate view of what was parsed.
  assert(sourceFile.description == sourceText)

  // Visualize the complete syntax tree.
  dump(sourceFile)
}

func example2() {
  let sourceText =
  """
  let a =
  """

  var parser = Parser(sourceText)
  let tree = SourceFileSyntax.parse(from: &parser)
  dump(tree)

  let diags = ParseDiagnosticsGenerator.diagnostics(for: tree)

  print("diags=\(diags)")
}
