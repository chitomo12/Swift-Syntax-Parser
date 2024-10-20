//
//  VariableInfo.swift
//  SwiftSyntaxParser
//
//  Created by 福田正知 on 2024/10/21.
//

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
