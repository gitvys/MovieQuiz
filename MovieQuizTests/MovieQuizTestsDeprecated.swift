//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Владислав Соколов on 15.10.2024.
//

//import XCTest
//
//final class MovieQuizTests: XCTestCase {
    // синхронный тест
    //    struct ArithmeticOperations {
    //        func addition(num1: Int, num2: Int) -> Int {
    //            return num1 + num2
    //        }
    //
    //        func substraction(num1: Int, num2: Int) -> Int {
    //            return num1 - num2
    //        }
    //
    //        func multiplication(num1: Int, num2: Int) -> Int {
    //            return num1 * num2
    //        }
    //    }
    //    func testAddition () throws {
    //        // Дано
    //        let arithmeticOperations = ArithmeticOperations()
    //        let num1 = 1
    //        let num2 = 2
    //        // Когда (действие)
    //        let result = arithmeticOperations.addition(num1: num1, num2: num2)
    //        // Проверка действия
    //        XCTAssertEqual(result, 3)
    //    }
    
    // асинхронный тест
    //    struct ArithmeticOperations {
    //        func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
    //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //                handler(num1 + num2)
    //            }
    //        }
    //    }
    //
    //    func substraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //            handler(num1 - num2)
    //        }
    //    }
    //
    //    func multiplication(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //            handler(num1 * num2)
    //        }
    //    }
    //
    //    func testAddition() throws {
    //        let arithmeticOperations = ArithmeticOperations()
    //        let num1 = 1
    //        let num2 = 2
    //
    //        let expectation = expectation(description: "Addition function expectation")
    //
    //        arithmeticOperations.addition(num1: num1, num2: num2) { result in
    //            XCTAssertEqual(result, 3)
    //            // вот тут ожидание выполнено
    //            expectation.fulfill()
    //        }
    //        // ждем пока функция отдаст ответ
    //        waitForExpectations(timeout: 2)
    //    }
    //}
