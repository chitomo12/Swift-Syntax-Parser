//
//  VariableInfo.swift
//  SwiftSyntaxParser
//
//  Created by 福田正知 on 2024/10/21.
//

public struct VariableInfo {
    public let name: String            // 変数名
    public let type: String            // 型情報（配列やオプショナルも含む）
    public let isOptional: Bool        // オプショナル型かどうか
    public let isArray: Bool           // 配列型かどうか
    public let initialValue: String?   // 初期値（存在しない場合はnil）
    public let attributes: [String]    // 属性リスト (e.g., @State, @Published)

    init(name: String, type: String, isOptional: Bool, isArray: Bool, initialValue: String?, attributes: [String]) {
        self.name = name
        self.type = type
        self.isOptional = isOptional
        self.isArray = isArray
        self.initialValue = initialValue
        self.attributes = attributes
    }
}
