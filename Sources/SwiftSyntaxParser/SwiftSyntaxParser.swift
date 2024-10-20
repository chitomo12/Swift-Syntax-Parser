// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftSyntax

// 変数情報を保持するための構造体
struct VariableInfo {
    let name: String            // 変数名
    let type: String            // 型情報（配列やオプショナルも含む）
    let isOptional: Bool        // オプショナル型かどうか
    let isArray: Bool           // 配列型かどうか
    let initialValue: String?   // 初期値（存在しない場合はnil）
    let attributes: [String]    // 属性リスト (e.g., @State, @Published)

    init(name: String, type: String, isOptional: Bool, isArray: Bool, initialValue: String?, attributes: [String]) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
        self.isArray = isArray
        self.initialValue = initialValue
        self.attributes = attributes
    }
}

class DeclarationParser {
    
    init () {}
    
    static func parse (_ declaration: DeclGroupSyntax) -> DeclSyntaxObject {
        // parse here
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
        
        return DeclSyntaxObject(
            name: declarationName,
            variables: vars,
            functions: funcs
        )
    }
}

struct DeclSyntaxObject {
    var name: String?
    var variables: [VariableInfo]
    var functions: [String]
}
