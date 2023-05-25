//
//  File.swift
//  
//
//  Created by Tatsuyuki Kobayashi on 2023/05/16.
//

import SwiftSyntax
import SwiftDiagnostics

class FixItApplier: SyntaxRewriter {
  var changes: [FixIt.Change]

  init(diagnostics: [Diagnostic], withMessages messages: [String]?) {
    self.changes =
      diagnostics
      .flatMap { $0.fixIts }
      .filter {
        if let messages {
          return messages.contains($0.message.message)
        } else {
          return true
        }
      }
      .flatMap { $0.changes }
  }

  public override func visitAny(_ node: Syntax) -> Syntax? {
    for change in changes {
      switch change {
      case .replace(oldNode: let oldNode, newNode: let newNode) where oldNode.id == node.id:
        return newNode
      default:
        break
      }
    }
    return nil
  }

  override func visit(_ node: TokenSyntax) -> TokenSyntax {
    var modifiedNode = node
    for change in changes {
      switch change {
      case .replaceLeadingTrivia(token: let changedNode, newTrivia: let newTrivia) where changedNode.id == node.id:
        modifiedNode = node.with(\.leadingTrivia, newTrivia)
      case .replaceTrailingTrivia(token: let changedNode, newTrivia: let newTrivia) where changedNode.id == node.id:
        modifiedNode = node.with(\.trailingTrivia, newTrivia)
      default:
        break
      }
    }
    return modifiedNode
  }

  /// If `messages` is `nil`, applies all Fix-Its in `diagnostics` to `tree` and returns the fixed syntax tree.
  /// If `messages` is not `nil`, applies only Fix-Its whose message is in `messages`.
  public static func applyFixes<T: SyntaxProtocol>(in diagnostics: [Diagnostic], withMessages messages: [String]?, to tree: T) -> Syntax {
    let applier = FixItApplier(diagnostics: diagnostics, withMessages: messages)
    return applier.visit(Syntax(tree))
  }
}
