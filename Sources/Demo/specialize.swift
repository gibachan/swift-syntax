import SwiftParser
import SwiftSyntax
import SwiftParserDiagnostics

func Specialize() {
  let sourceText =
  """
  @_specializeℹ️(e1️⃣
  """

  var parser = Parser(sourceText)
  let tree = SourceFileSyntax.parse(from: &parser)
  let diags = ParseDiagnosticsGenerator.diagnostics(for: tree)

  print("diags=\(diags)")

  let applyFixIts: [String]? = nil
  let fixedTree = FixItApplier.applyFixes(in: diags, withMessages: applyFixIts, to: tree)

  print("Source: \(sourceText)")
  print("Fixed : \(fixedTree.description)")

  dump(tree)
  dump(fixedTree)

}
