import Foundation
import SwiftSyntax

public class DeclarationParser {
    
    init () {}
    
    public static func parse (_ declaration: some DeclGroupSyntax) -> DeclarationSyntaxObject {
        
        var declarationName: String?
        
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            declarationName = classDecl.name.text
        }
        
        var vars: [VariableInfo] = []
        var funcs: [String] = []

        let members = declaration.memberBlock.members
        for member in members {
            let decl = member.decl

            // VariableDeclを解析してVariableInfoを作成
            if let varDecl = decl.as(VariableDeclSyntax.self) {
                // 属性を取得
                let attributes = varDecl.attributes.flatMap { attribute in
                    attribute.tokens(viewMode: .sourceAccurate).map{ $0.text }
                }

                for binding in varDecl.bindings {
                    if let identifier = binding.pattern.as(IdentifierPatternSyntax.self) {
                        let varName = identifier.identifier.text

                        // 型情報の取得
                        let typeDescription = binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown"
                        
                        // オプショナル型の判定
                        let isOptional = typeDescription.hasSuffix("?")
                        
                        // 配列型の判定
                        let isArray = typeDescription.hasPrefix("[") && typeDescription.hasSuffix("]")

                        // 初期値の取得
                        let initialValue = binding.initializer?.value.description.trimmingCharacters(in: .whitespacesAndNewlines)

                        // VariableInfoを作成して追加
                        vars.append(VariableInfo(
                            name: varName,
                            type: typeDescription,
                            isOptional: isOptional,
                            isArray: isArray,
                            initialValue: initialValue,
                            attributes: attributes
                        ))
                    }
                }
            }

            // FunctionDeclを解析して関数名を追加
            if let funcDecl = decl.as(FunctionDeclSyntax.self) {
                funcs.append(funcDecl.name.text)
            }
        
        }
        
        return DeclarationSyntaxObject(
            name: declarationName,
            variables: vars,
            functions: funcs
        )
    }
}
