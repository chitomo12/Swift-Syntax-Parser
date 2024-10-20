import XCTest
import SwiftParser
@testable import SwiftSyntaxParser
import SwiftSyntax

final class SwiftSyntaxParserTests: XCTestCase {
    
    func test_parse_class_syntax() throws {
        
        let expect = XCTestExpectation(description: "")
        
        // 例として`TestClass`のクラス宣言を解析
        let source = """
        class TestClass {
            var i: Int = 0
            func add() {
                i += 1
            }
        }
        """
        let sourceFile = Parser.parse(source: source)

        for statement in sourceFile.statements {
            // 各 `CodeBlockItemSyntax` を確認
            // CodeBlockItemSyntax が含む DeclSyntax を取得
            if let decl = statement.item.as(DeclSyntax.self) {
                // DeclSyntax を確認
                if let classDecl = decl.as(ClassDeclSyntax.self) {
                    print("Class Declaration Name: \(classDecl.name.text)")
                    let parsedClass = DeclarationParser.parse(classDecl)
                    XCTAssertEqual(parsedClass.name, "TestClass")
                    expect.fulfill()
                } else if let structDecl = decl.as(StructDeclSyntax.self) {
                    print("Struct Declaration Name: \(structDecl.name.text)")
                }
            }
        }
        
        wait(for: [expect])
    }
}
