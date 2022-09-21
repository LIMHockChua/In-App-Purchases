/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import StoreKitTest
@testable import GreenBar

class GreenBarTests: XCTestCase {
  func testSubscription() throws {
    let session = try SKTestSession(configurationFileNamed: "Subscriptions")
    session.resetToDefaultState()
    session.disableDialogs = true
    session.clearTransactions()

    let identifier = GreenBarContent.greenTimes
    let expectation = XCTestExpectation(description: "Buy Content")

    GreenBarContent.store.requestProductsAndBuy(
      productIdentifier: identifier
    ) { _ in
      let contentAvailable = GreenBarContent.store.receiptContains(identifier)
      var contentSaved = GreenBarContent.store.isProductPurchased(identifier)

      XCTAssertTrue(
        contentAvailable,
        "Expected \(identifier) is present in receipt")
      XCTAssertTrue(
        contentSaved,
        "Expected \(identifier) is stored in PurchasedProducts")

      var hasExpired = GreenBarContent.store.checkSubscriptionExpiry(identifier)

      XCTAssertFalse(hasExpired, "Expected \(identifier) has not expired")

      try? session.expireSubscription(productIdentifier: identifier)

      hasExpired = GreenBarContent.store.checkSubscriptionExpiry(identifier)
      contentSaved = GreenBarContent.store.isProductPurchased(identifier)

      XCTAssertTrue(hasExpired, "Expected \(identifier) has expired")
      XCTAssertFalse(
        contentSaved,
        "Expected \(identifier) is not stored in PurchasedProducts")

      expectation.fulfill()
    }

    wait(for: [expectation], timeout: 90.0)
  }

//  func testInterruptedPurchase() throws {
//    let session = try SKTestSession(configurationFileNamed: "RecipesAndCoins")
//    session.resetToDefaultState()
//    session.disableDialogs = true
//
//    session.interruptedPurchasesEnabled = true
//    session.clearTransactions()
//
//    let identifier = GreenBarContent.healthyTacoSalad
//    let expectation = XCTestExpectation(description: "Buy Content")
//
//    GreenBarContent.store.requestProductsAndBuy(
//      productIdentifier: identifier
//    ) { _ in
//      let contentAvailable = GreenBarContent.store.receiptContains(identifier)
//      let contentSaved = GreenBarContent.store.isProductPurchased(identifier)
//
//      XCTAssertFalse(
//        contentAvailable,
//        "Expected \(identifier) is not present in receipt")
//      XCTAssertFalse(
//        contentSaved,
//        "Expected \(identifier) is not stored in PurchasedProducts")
//
//      expectation.fulfill()
//    }
//
//    wait(for: [expectation], timeout: 60.0)
//  }

//  func testNonConsumablePurchase() throws {
//    let session = try SKTestSession(configurationFileNamed: "RecipesAndCoins")
//    session.resetToDefaultState()
//    session.disableDialogs = true
//    session.clearTransactions()
//
//    let identifier = GreenBarContent.caesarSalad
//    let expectation = XCTestExpectation(description: "Buy Content")
//
//    GreenBarContent.store.requestProductsAndBuy(
//      productIdentifier: identifier
//    ) { _ in
//      let contentAvailable = GreenBarContent.store.receiptContains(identifier)
//      let contentSaved = GreenBarContent.store.isProductPurchased(identifier)
//
//      XCTAssertTrue(
//        contentAvailable,
//        "Expected \(identifier) is present in receipt")
//      XCTAssertTrue(
//        contentSaved,
//        "Expected \(identifier) is stored in PurchasedProducts")
//
//      expectation.fulfill()
//    }
//
//    wait(for: [expectation], timeout: 60.0)
//  }

//  func testReceiptValidation() throws {
//    let session = try SKTestSession(configurationFileNamed: "RecipesAndCoins")
//    session.resetToDefaultState()
//    session.disableDialogs = true
//
//    let identifier = GreenBarContent.tartCherrySalad
//    let expectation = XCTestExpectation(description: "Buy Content")
//
//    GreenBarContent.store.requestProductsAndBuy(
//      productIdentifier: identifier
//    ) { _ in
//      let receipt = Receipt()
//      if let receiptStatus = receipt.receiptStatus {
//        let validationSucceeded = receiptStatus == .validationSuccess
//        XCTAssertTrue(validationSucceeded)
//      } else {
//        XCTFail("Recipt Validation failed")
//      }
//
//      expectation.fulfill()
//    }
//
//    wait(for: [expectation], timeout: 60.0)
//  }
}
