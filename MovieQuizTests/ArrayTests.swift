//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Владислав Соколов on 15.10.2024.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTest {
    func testGetValueRange() throws {
        // Given
        let array = [1,1,2,3,5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1,1,2,3,5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}

