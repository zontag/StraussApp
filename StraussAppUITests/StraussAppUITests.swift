import XCTest

final class StraussAppUITests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testScrolling() {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Tracks screen on top"
        attachment.lifetime = .keepAlways
        add(attachment)

        let collectionView = app.collectionViews.firstMatch

        XCTAssert(app.staticTexts["Richard Strauss".uppercased()].exists)
        XCTAssertTrue(collectionView.cells.count > 0)

        collectionView.swipeUp(velocity: .fast)
        collectionView.swipeDown(velocity: .fast)

        let attachment2 = XCTAttachment(screenshot: app.screenshot())
        attachment2.name = "Tracks screen on top after scroll"
        attachment2.lifetime = .keepAlways
        add(attachment2)
    }

    func testNavigationToDetail() {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Tracks screen on top"
        attachment.lifetime = .keepAlways
        add(attachment)

        let collectionView = app.collectionViews.firstMatch

        XCTAssertTrue(collectionView.cells.count > 0)

        collectionView.cells.firstMatch.tap()

        XCTAssert(app.staticTexts["Track"].exists)
        XCTAssert(app.staticTexts["Artist"].exists)
        XCTAssert(app.staticTexts["Collection"].exists)
        XCTAssert(app.staticTexts["Price"].exists)

        let attachment2 = XCTAttachment(screenshot: app.screenshot())
        attachment2.name = "Track detail screen after navigation"
        attachment2.lifetime = .keepAlways
        add(attachment2)
    }
}
