//
//  Parser.swift
//  QBasicSwift
//
//  Created by Stavik, Vojta on 06/01/17.
//  Copyright © 2017 VojtaStavik. All rights reserved.
//

import Foundation

struct QBasicParser {
    // Program is an array of blocks
    func program() -> StringParser<[Block]> {
        return (many(block()) <<< eof)()
    }
}

// MARK: - Block & Statements
extension QBasicParser {

    // Each block has its label and statements
    func block(_ scope: SubName? = nil) -> () -> StringParser<Block> {
        return {
            return (optionMaybe(self.label) >>- { label_ in
                print("Block label: \(label_)")
                return self.statements(scope) >>- {
                    create(Block(label: label_ ?? Label.main,
                                 statements: $0.flatMap{$0} ))
                }
            })()
        }
    }
}

// MARK: - Statements
extension QBasicParser {
    
    func statements(_ scope: SubName? = nil) -> () -> StringParser<[Statement]> {
        return {
            return (attempt(many1(self.statement(scope))) >>- {
                create($0.flatMap{$0})
            })()
        }
    }
    
    func statement(_ scope: SubName? = nil) -> () -> StringParser<Statement?> {
        return {
            return (
                attempt(self.comment)
                    <|> attempt(self.printCommand(scope))
                    <|> attempt(self.declaration(scope))
                    <|> attempt(self.forLoop(scope))
                    <|> attempt(self.ifStatement(scope))
                    <|> attempt(self.clsCommand)
                    <|> attempt(self.goto)
                    <|> attempt(self.inputCommand(scope))
                    <|> attempt(self.subDeclaration)
                    <|> attempt(self.subImplementation)
                    <|> attempt(self.subInvocation(scope))
                    <|> attempt(self.assignment(scope))
                    <|> attempt(self.emptyLine)
                )()
        }
    }
    
    // Empty line or line with only spaces
    func emptyLine() -> StringParser<Statement?> {
        return (spaces >>> endOfLine >>- { _ in create(nil) })()
    }
}

// MARK: - Labels
extension QBasicParser {

    // Line number or label
    func label() -> StringParser<Label> {
        return attempt(many(endOfLine >>> spaces) >>> (attempt(lineNumber) <|> attempt(namedLabel)) >>- {
            return create($0)
        })()
    }
    
    // 10 CLS
    func lineNumber() -> StringParser<Label> {
        return (spaces >>> many1(digit) >>- { digits in
            create(Label(name: String(digits)))
            })()
    }
    
    // sayHi: PRINT "Hi"
    func namedLabel() -> StringParser<Label> {
        return (spaces >>> labelIdentifier <<< char(":") >>- { name in
            create(Label(name: String(name)))
            })()
    }
    
    func labelIdentifier() -> StringParser<String> {
        return (many1(alphaNum) >>- { create(String($0)) })()
    }
}


// MARK: - IF statement
extension QBasicParser {
    
    func ifStatement(_ scope: SubName? = nil) -> () -> StringParser<Statement?> {
        return {
            return (attempt(self.ifStatementSimple(scope)) <|> attempt(self.ifStatementFull(scope)))()
        }
    }
    
    //IF 5 < 2 THEN
    //  PRINT "5 Is Less Than 2"
    //END IF
    func ifStatementFull(_ scope: SubName? = nil) -> () -> StringParser<Statement?> {
        return {
            return (spaces >>> Keyword.IF >>> spaces >>> self.expression(scope) <<< spaces <<< Keyword.THEN <<< endOfLine >>- { exp in
                self.statements(scope) >>- { ifBlock in
                    // ELSE block
                    attempt((optionMaybe(attempt(spaces >>> Keyword.ELSE) >>> endOfLine >>> spaces >>> self.statements(scope)) >>- { elseBlock in
                        spaces >>> Keyword.ENDIF >>- { _ in
                            create(.if_(expression: exp, block: ifBlock, elseBlock: elseBlock, elseIf: nil))
                        }
                    })) <|>
                    // ELSEIF
                        // This consumes the 'ELSE' part of ELSEIF, the IF part is consumed by isStatement parser
                    (attempt(spaces >>> Keyword.ELSE) >>> self.ifStatement(scope) >>- { elseIf in
                        create(.if_(expression: exp, block: ifBlock, elseBlock: nil, elseIf: elseIf))
                    })
                }
            })()
        }
    }
    
    //IF 5 < 2 THEN PRINT "5 Is Less Than 2"
    func ifStatementSimple(_ scope: SubName? = nil) -> () -> StringParser<Statement?> {
        return {
            return (spaces >>> Keyword.IF >>> spaces >>> self.expression(scope) <<< spaces <<< Keyword.THEN >>- { exp in
                spaces >>> self.statement(scope) <<< spaces <<< endOfLine >>- { com in
                    create(Statement.if_(expression: exp, block: [com!], elseBlock: [], elseIf: nil))
                }
            })()
        }
    }
}


// MARK: - Variables
extension QBasicParser {
    
    // PRINT >>>text$<<<
    func variable(definedBy: Variable.DefinitionType?, scope: SubName?) -> () -> StringParser<Variable> {
        return {
            return attempt(self.variableName >>- { name in
                let type: Variable.VarType?
                switch name.characters.last! {
                case "$":
                    type = .string
                case "%":
                    type = .integer
                case "&":
                    type = .long
                case "!":
                    type = .single
                case "#":
                    type = .double
                default:
                    // Unknown type
                    type = nil
                }
            
                return create(Variable(name: name,
                                       type: type,
                                       definedBy: definedBy,
                                       scope: scope))
            })()
        }
    }
    
    // PRINT >>>text<<<$
    func variableName() -> StringParser<String> {
        return attempt(letter >>- { firstLetter in
            attempt(many(alphaNum) <<< notFollowedBy(char(":"))) >>- { nextChars in
                option("", self.variableTypeString) >>- { varTypeString in
                    let variableName = String([firstLetter] + nextChars) + varTypeString
                    if Keyword.all.contains(variableName) {
                        return fail("Reserved keyword")
                    }
                    
                    return create(String(variableName))
                }
            }
        })()
    }
    
    func variableTypeString() -> StringParser<String> {
        return (oneOf("$%&!#") >>- { create(String($0)) })()
    }
}

// MARK: - Commands
extension QBasicParser {
    
    //FOR x = 1 TO 10 STEP 1
    //    PRINT "SchoolFreeware"
    //NEXT x
    func forLoop(_ scope: SubName?) -> () -> StringParser<Statement?> {
        return {
            return (spaces >>> Keyword.FOR >>> spaces >>> self.variable(definedBy: .system, scope: scope) <<< spaces >>- { var_ in
                string("=") >>> spaces >>> self.expression(scope) <<< spaces >>- { start in
                    Keyword.TO >>> spaces >>> self.expression(scope) <<< spaces >>- { end in
                        option(Expression.literals([.numberInt("1")]), Keyword.STEP >>> spaces >>> self.expression(scope))
                            <<< endOfLine >>- { step in
                                self.statements(scope) >>- { block in
                                    spaces >>> Keyword.NEXT >>> spaces >>> string(var_.name) >>- { _ in
                                        create(.forLoop(index: var_,
                                                        start: start,
                                                        end: end,
                                                        step: step,
                                                        block: block))
                                    }
                                }
                        }
                    }
                }
            })()
        }
    }
    
    // CLS
    func clsCommand() -> StringParser<Statement?> {
        return (spaces >>> Keyword.CLS <<< spaces <<< endOfLine >>- { _ in return create(.cls) })()
    }
    
    // PRINT "Hey"
    func printCommand(_ scope: SubName?) -> () -> StringParser<Statement?> {
        return {
            return attempt(spaces >>> Keyword.PRINT >>> spaces >>> many(attempt(self.printExpression(scope))) >>- { prExp in
                (optionMaybe(attempt(self.lineTerminator())) <<< spaces <<< endOfLine >>- { term in
                    create(.print(prExp, terminator: term ?? .newLine))
                })
            })()
        }
    }

    // PRINT >>>"Somenting "; 5*(6+7); " something else." <<<
    func printExpression(_ scope: SubName?) -> () -> StringParser<(Operator?, Expression)> {
        return {
            return (optionMaybe(attempt(self.textFormattingOperator)) >>- { op in
                attempt(self.expression(scope)) >>- { exp in
                    return create((op, exp))
                }
            })()
        }
    }

    func lineTerminator() -> () -> StringParser<Statement.Terminator> {
        return {
            return (attempt(self.textFormattingOperator <<< notFollowedBy(self.expression(nil))) >>- { op in
                if op == .comma {
                    return create(.tab)
                } else {
                    return create(.none)
                }
            })()
        }
    }
    
    // INPUT "Whats your name? ", name$
    func inputCommand(_ scope: SubName?) -> () -> StringParser<Statement?> {
        return {
            return attempt(spaces >>> Keyword.INPUT >>> spaces >>> optionMaybe(attempt(self.expression(scope))) >>- { exp in
                spaces >>> optionMaybe(attempt(self.textFormattingOperator)) >>- { term in
                    self.variable(definedBy: .user, scope: scope) >>- { var_ in
                        create(.input(text: exp, terminator: term, variable: var_))
                    }
                }
            })()
        }
    }
    
    // GOTO 10
    func goto() -> StringParser<Statement?> {
        return (spaces >>> Keyword.GOTO >>> spaces >>> labelIdentifier <<< spaces >>- { labelId in
            create( .goto(label: Label(name: labelId)))
            })()
    }
    
    // DIM Num1 AS INTEGER
    // DIM Num2 AS LONG
    // DIM Num3 AS SINGLE
    // DIM Num4 AS DOUBLE
    // DIM Header AS STRING
    func declaration(_ scope: SubName? = nil) -> () -> StringParser<Statement?> {
        return {
            return (spaces >>> Keyword.DIM >>> spaces >>> self.declaredVariable(definedBy: .user, scope) >>- { var_ in
                    create(.declaration(var_))
            })()
        }
    }
    
    // Num1 AS INTEGER
    // Num%
    func declaredVariable(definedBy: Variable.DefinitionType, _ scope: SubName? = nil) -> () -> StringParser<Variable> {
        return {
            return (spaces >>> self.variableName <<< spaces >>- { varName in
                // Explicitly Typed variable
                attempt(Keyword.AS >>> space >>- { _ in
                    attempt(Keyword.INTEGER) <<< spaces >>- { _ in
                        return create(Variable(name: varName, type: .integer, definedBy: definedBy, scope: scope))
                        }
                        <|> attempt(Keyword.LONG <<< spaces ) >>- { _ in
                            return create(Variable(name: varName, type: .long, definedBy: definedBy, scope: scope))
                        }
                        <|> attempt(Keyword.SINGLE <<< spaces ) >>- { _ in
                            return create(Variable(name: varName, type: .single, definedBy: definedBy, scope: scope))
                        }
                        <|> attempt(Keyword.DOUBLE <<< spaces ) >>- { _ in
                            return create(Variable(name: varName, type: .double, definedBy: definedBy, scope: scope))
                        }
                        <|> attempt(Keyword.STRING <<< spaces ) >>- { _ in
                            return create(Variable(name: varName, type: .string, definedBy: definedBy, scope: scope))
                    }
                })
                <|>
                // Automaticaly cast variable
                (self.variable(definedBy: definedBy, scope: scope))
            })()
        }
    }
}

// MARK: - Subs
extension QBasicParser {
    
    // DECLARE SUB sub1 (text$)
    func subDeclaration() -> StringParser<Statement?> {
        return (
            spaces >>> Keyword.DECLARE >>> spaces >>> Keyword.SUB >>> spaces >>> self.subNameLiteral <<< spaces >>- { subName in
                guard case .subName(let name) = subName else {
                    return fail("Not a sub name")
                }
                
                let sub = Sub(name: name, blocks: nil)
                
                return (
                    skipMany(self.leftBracket) >>> spaces
                    >>> sepBy(self.declaredVariable(definedBy: .parameter, name), self.comma)
                    <<< spaces <<< skipMany(self.rightBracket) >>- { vars in
                        create(.subDeclaration(sub, parameters: vars))
                    })
            })()
    }

    // SUB sub1 (text$)
    //  PRINT "Sub1", text$
    // END SUB
    func subImplementation() -> StringParser<Statement?> {
        return (
            spaces >>> Keyword.SUB >>> spaces >>> self.subNameLiteral <<< spaces >>- { subName in
                guard case .subName(let name) = subName else {
                    return fail("Not a sub name")
                }
                
                return (
                    skipMany1(self.leftBracket) >>> spaces
                    >>> sepBy(self.declaredVariable(definedBy: .parameter, name), self.comma)
                    <<< spaces <<< skipMany1(self.rightBracket) >>- { vars in

                    many(attempt(self.block(name))) <<< spaces <<< Keyword.ENDSUB >>- { blocks in
                        let sub = Sub(name: name, blocks: blocks)
                        return create(.subImplementation(sub))
                    }
                })
        })()
    }
    
    // sub1 "Hey"
    func subInvocation(_ scope: SubName?) -> () -> StringParser<Statement?> {
        return {
            return (spaces >>> self.subNameLiteral <<< spaces >>- { subName in
                guard case .subName(let name) = subName else {
                    return fail("Not a sub name")
                }
                
                guard let sub = Sub.existing(withName: name) else {
                    return fail("Not a sub name")
                }
                
                return
                    skipMany(self.leftBracket) >>> spaces >>> attempt(sepBy(self.expression(scope), self.comma))
                        <<< spaces <<< skipMany(self.rightBracket) <<< endOfLine >>- { params in
                        return create(.subInvocation(sub, parameters: params))
                    }
            })()
        }
    }
}


// MARK: - Literals
extension QBasicParser {
    func literals() -> StringParser<[Literal]> {
        return (
            many1(
                attempt(floatNumberLiteral)
                    <|> attempt(intNumberLiteral)
                    <|> attempt(stringLiteral)
                    <|> attempt(variableLiteral)
                    <|> attempt(subNameLiteral)
                    <|> attempt(operatorLiteral)
                )
                >>- { create($0) }
            )()
    }
    
    func stringLiteral() -> StringParser<Literal> {
        return (between(quote, quote, (many1(noneOf("\"")))) >>- { create(.string(String($0))) })()
    }
    
    func quote() -> StringParser<Character> {
        return (char("\""))()
    }
    
    func variableLiteral() -> StringParser<Literal> {
        return (variableName >>- { create(.vaiableName(String($0))) })()
    }

    func subNameLiteral() -> StringParser<Literal> {
        return (variableName >>- { create(.subName(String($0))) })()
    }
    
    func intNumberLiteral() -> StringParser<Literal> {
        return (many1(digit) >>- { create(.numberInt(String($0))) })()
    }
    
    func floatNumberLiteral() -> StringParser<Literal> {
        return (intNumberLiteral <<< char(".") >>- { intLiteral in
            many1(digit) >>- { fractional in
                guard case .numberInt(let intString) = intLiteral else { fatalError()}
                return create(.numberFloat(String(intString) + "." + String(fractional)))
            }
            })()
    }

    // T$ = "Test"
    func assignment(_ scope: SubName?) -> () -> StringParser<Statement?> {
        return {
            return ((spaces >>> attempt(self.variable(definedBy: .user, scope: scope)) <<< spaces <<< string("=") <<< spaces) >>- { var_ in
                self.expression(scope) <<< endOfLine >>- { exp in
                    create(.assignment(var_, exp))
                }
            })()
        }
    }
    
    func comment() -> StringParser<Statement?> {
        return(attempt(remComment) <|> attempt(shorthandComment))()
    }
    
    // REM Comment
    func remComment() -> StringParser<Statement?> {
        return (spaces >>> Keyword.REM >>> manyTill(anyChar, endOfLine) >>- {
            create(.comment(String($0)))
        })()
    }
    
    // ' another style of comment
    func shorthandComment() -> StringParser<Statement?> {
        return (spaces >>> char("'") >>> manyTill(anyToken, endOfLine) >>- {
            create(.comment(String($0)))
        })()
    }
}

// MARK: - Epressions
extension QBasicParser {

    func expression(_ scope: SubName? = nil) -> () -> StringParser<Expression> {
        return {
            return (
                attempt(self.literals) >>- { create(.literals($0)) }
                    <|> attempt(self.variable(definedBy: nil, scope: scope)) >>- { create(.variable($0))}
                )()
        }
    }
}

// MARK: - Operators
extension QBasicParser {

    func operatorLiteral() -> StringParser<Literal> {
        return (
            attempt(equalOperator)
                <|> attempt(plusOperator)
                <|> attempt(minusOperator)
                <|> attempt(leftBracket)
                <|> attempt(rightBracket)
                <|> attempt(lessThan)
                <|> attempt(greaterThan)
                <|> attempt(modulo)
                <|> attempt(multiplication)
                <|> attempt(division)
            )()
    }
    
    func equalOperator() -> StringParser<Literal> {
        return (spaces >>> char("=") <<< spaces >>- { _ in create(.op(.equal))})()
    }
    
    func plusOperator() -> StringParser<Literal> {
        return (spaces >>> char("+") <<< spaces >>- { _ in create(.op(.plus))})()
    }
    
    func minusOperator() -> StringParser<Literal> {
        return (spaces >>> char("-") <<< spaces >>- { _ in create(.op(.minus))})()
    }
    
    func leftBracket() -> StringParser<Literal> {
        return (spaces >>> char("(") <<< spaces >>- { _ in create(.op(.leftBracket))})()
    }
    
    func rightBracket() -> StringParser<Literal> {
        return (spaces >>> char(")") <<< spaces >>- { _ in create(.op(.rightBracket))})()
    }
    
    func lessThan() -> StringParser<Literal> {
        return (spaces >>> char("<") <<< spaces >>- { _ in create(.op(.lessThan))})()
    }
    
    func greaterThan() -> StringParser<Literal> {
        return (spaces >>> char(">") <<< spaces >>- { _ in create(.op(.greaterThan))})()
    }
    
    func modulo() -> StringParser<Literal> {
        return (spaces >>> string("MOD") <<< spaces >>- { _ in create(.op(.modulo))})()
    }
    
    func multiplication() -> StringParser<Literal> {
        return (spaces >>> char("*") <<< spaces >>- { _ in create(.op(.multiplication))})()
    }
    
    func division() -> StringParser<Literal> {
        return (spaces >>> char("/") <<< spaces >>- { _ in create(.op(.division))})()
    }
    
    // ; OR ,
    
    func textFormattingOperator() -> StringParser<Operator> {
        return (
            attempt(comma) <|> attempt(semicolon)
        )()
    }
    
    func comma() -> StringParser<Operator> {
        return (spaces >>> char(",") <<< spaces >>- { _ in create(.comma)})()
    }
    
    func semicolon() -> StringParser<Operator> {
        return (spaces >>> char(";") <<< spaces >>- { _ in create(.semicolon)})()
    }
}
