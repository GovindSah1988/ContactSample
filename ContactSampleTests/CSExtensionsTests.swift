//
//  CSExtensionsTests.swift
//  ContactSampleTests
//
//  Created by Govind Sah on 09/07/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import XCTest
import ContactSample

class CSExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_app_tint_green_color() {
        let testColor = UIColor.appGreenColor
        XCTAssert(!testColor.isEqual(UIColor.green))
    }
    
    func test_title_color() {
        let testColor = UIColor.titleColor
        XCTAssert(!testColor.isEqual(UIColor.black))
        
        let components = testColor.cgColor.components
        XCTAssert(true == components?.elementsEqual([0.0, 0.0, 0.0, 1.0]))
    }
    
    func test_gradient_Top_color() {
        let testColor = UIColor.gradientTopColor
        XCTAssert(!testColor.isEqual(UIColor.white))
    }
    
    func test_gradient_Bottom_color() {
        let testColor = UIColor.gradientBottomColor
        XCTAssert(!testColor.isEqual(UIColor.blue))
    }

    func test_class_name() {
        XCTAssertEqual(CSDetailFieldTableViewCell.className, "CSDetailFieldTableViewCell")
        XCTAssertEqual(CSDetailFieldTableViewCell().className, "CSDetailFieldTableViewCell")
    }
    
    func test_align_text_button() {
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize.init(width: 100, height: 44)))
        button.setTitle("Test", for: UIControl.State.normal)
        button.alignTextBelow(spacing: 10)
        XCTAssert(true == button.titleLabel?.text?.elementsEqual("Test"))
    }
    
    func test_navigation_push_pop() {
        var vc = UIViewController()
        let navCon = UINavigationController(rootViewController: vc)
        XCTAssert(1 == navCon.viewControllers.count)
        
        vc = UIViewController()
        navCon.pushFromBottomToTop(vc)
        XCTAssert(2 == navCon.viewControllers.count)
        
        navCon.popFromTopToBottom()
        XCTAssert(1 == navCon.viewControllers.count)
    }
    
    func test_is_valid_email() {
        var testEmail = "test"
        XCTAssert(false == testEmail.isValidEmail())
        
        testEmail = "Teast@asd"
        XCTAssert(false == testEmail.isValidEmail())

        testEmail = "Teast@asd.c"
        XCTAssert(false == testEmail.isValidEmail())

        testEmail = "Teast@asd.co"
        XCTAssert(testEmail.isValidEmail())
    }
    
    func test_is_valid_phone_number() {
        var testPhoneNumber = "1234"
        XCTAssert(false == testPhoneNumber.isValidPhoneNumber())
        
        testPhoneNumber = "-1234567890"
        XCTAssert(false == testPhoneNumber.isValidPhoneNumber())
        
        testPhoneNumber = "123456 7890"
        XCTAssert(false == testPhoneNumber.isValidPhoneNumber())
        
        testPhoneNumber = "+123456"
        XCTAssert(false == testPhoneNumber.isValidPhoneNumber())
        
        testPhoneNumber = "+123456789"
        XCTAssert(false == testPhoneNumber.isValidPhoneNumber())

        testPhoneNumber = "+1234567890"
        XCTAssert(testPhoneNumber.isValidPhoneNumber())

        testPhoneNumber = "1234567890"
        XCTAssert(testPhoneNumber.isValidPhoneNumber())
    }
    
    func test_remove_space_hyphen_character() {
        var testString = " 1234 "
        var resultString = testString.removeSpaceAndSpecialCharacter()
        XCTAssertEqual(resultString, "1234")

        testString = "1-234-"
        resultString = testString.removeSpaceAndSpecialCharacter()
        XCTAssertEqual(resultString, "1234")

        testString = "  -  1 - 234  "
        resultString = testString.removeSpaceAndSpecialCharacter()
        XCTAssertEqual(resultString, "1234")
    }
    
    func test_append_next_word() {
        var firstName = "First"
        var lastName = "Last"
        var name = firstName.appendNextWord(lastName)
        XCTAssertEqual(name, "First Last")
        
        firstName = ""
        lastName = "Last"
        name = firstName.appendNextWord(lastName)
        XCTAssertEqual(name, "Last")
        
        firstName = "First"
        lastName = ""
        name = firstName.appendNextWord(lastName)
        XCTAssertEqual(name, "First")
    }
    
    func test_storyboard() {
        let mainStoryboard = UIStoryboard.mainStoryboard()
        XCTAssert(nil != (mainStoryboard.instantiateInitialViewController() as? UINavigationController))
    }
}
