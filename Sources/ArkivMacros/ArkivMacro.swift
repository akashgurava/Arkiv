import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ArkivMacro: MemberMacro, ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        let sendableExtension: DeclSyntax =
            """
            extension \(type.trimmed): Table {}
            """

        guard let extensionDecl = sendableExtension.as(ExtensionDeclSyntax.self) else {
            return []
        }

        return [extensionDecl]
    }

    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        let declarationSyntax = declaration.as(ClassDeclSyntax.self)

        var idColType = ""
        for field in declarationSyntax!.memberBlock.members {
            if let varDeclaration = field.decl.as(VariableDeclSyntax.self) {
                for varBind in varDeclaration.bindings {
                    if let identifier = varBind.pattern.as(IdentifierPatternSyntax.self) {
                        if identifier.identifier.text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "id" {
                            idColType = varBind.typeAnnotation!.type.as(IdentifierTypeSyntax.self)!.name.text
                        }
                    }
                }
            }
        }

        return ["""

        typealias K = \(raw: idColType)
        """]
    }
}

@main
struct ArkivPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ArkivMacro.self,
    ]
}
