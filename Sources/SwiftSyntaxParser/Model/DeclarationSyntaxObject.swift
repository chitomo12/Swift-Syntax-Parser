//
//  DeclarationSyntaxObject.swift
//  SwiftSyntaxParser
//
//  Created by 福田正知 on 2024/10/21.
//

public struct DeclarationSyntaxObject {
    public var name: String?
    public var variables: [VariableInfo]
    public var functions: [String]
}
