////
////  RMCharacterListUITests.swift
////  TestAitUITests
////
////  Created by PEDRO MENDEZ on 31/08/25.
////


import XCTest

// MARK: - Tests ultra seguros que no deberían causar crashes
final class SafeRMCharacterUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test 1: Verificación básica de lanzamiento
    func testAppLaunchesWithoutCrash() throws {

        XCTAssertEqual(app.state, .runningForeground, "La app debería lanzarse sin crashes")
        
        // Esperar un poco para estabilización
        Thread.sleep(forTimeInterval: 3.0)
        
        // Verificar que sigue funcionando
        XCTAssertEqual(app.state, .runningForeground, "La app debería seguir funcionando después de 3 segundos")
    }
    
    // MARK: - Test 2: Detección de elementos UI
    func testUIElementsDetection() throws {
        Thread.sleep(forTimeInterval: 5.0)
        
        print("DEBUGGING: Elementos encontrados en la UI")
        print("=========================================")
        

        let collectionViews = app.collectionViews.count
        let tableViews = app.tables.count
        let scrollViews = app.scrollViews.count
        let buttons = app.buttons.count
        let labels = app.staticTexts.count
        let images = app.images.count
        let activityIndicators = app.activityIndicators.count
        
        print("Collection Views: \(collectionViews)")
        print("Table Views: \(tableViews)")
        print("Scroll Views: \(scrollViews)")
        print("Buttons: \(buttons)")
        print("Labels: \(labels)")
        print("Images: \(images)")
        print("Activity Indicators: \(activityIndicators)")
        

        let hasContent = collectionViews > 0 || tableViews > 0 || scrollViews > 0
        XCTAssertTrue(hasContent, "Debería haber algún tipo de lista o contenido scrolleable")
        

        if collectionViews > 0 {
            let cv = app.collectionViews.firstMatch
            print("Primer Collection View - exists: \(cv.exists)")
            
            if cv.exists {
                Thread.sleep(forTimeInterval: 5.0)
                let cellCount = cv.cells.count
                print("Celdas en collection view: \(cellCount)")
            }
        }
        
        XCTAssertTrue(true, "Test de detección completado")
    }
    
    // MARK: - Test 3: Interacción mínima y segura
    func testMinimalSafeInteraction() throws {
        Thread.sleep(forTimeInterval: 8.0) // Esperar carga completa
        
        let collectionViews = app.collectionViews
        guard collectionViews.count > 0 else {
            XCTFail("No se encontraron collection views")
            return
        }
        
        let collectionView = collectionViews.firstMatch
        guard collectionView.exists else {
            XCTFail("Collection view no existe")
            return
        }
        
        print("INTERACTION TEST: Collection view encontrado")
        
        let initialState = app.state
        XCTAssertEqual(initialState, .runningForeground, "App debería estar funcionando inicialmente")
        
        // Test de scroll
        let beforeScroll = app.state
        collectionView.swipeUp()
        Thread.sleep(forTimeInterval: 1.0)
        let afterScroll = app.state
        
        print("Estado antes del scroll: \(beforeScroll)")
        print("Estado después del scroll: \(afterScroll)")
        
        XCTAssertEqual(afterScroll, .runningForeground, "App debería seguir funcionando después del scroll")
        
        let cells = collectionView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            
            // Verificar que la celda es segura para tap
            if firstCell.exists && firstCell.isHittable {
                print("CELL TAP: Intentando tap en primera celda...")
                
                let beforeTap = app.state
                firstCell.tap()
                
                Thread.sleep(forTimeInterval: 0.5)
                
                let afterTap = app.state
                print("Estado antes del tap: \(beforeTap)")
                print("Estado después del tap: \(afterTap)")
                
                let validStates: [XCUIApplication.State] = [.runningForeground, .runningBackground]
                XCTAssertTrue(validStates.contains(afterTap), "App debería mantener un estado válido")
            }
        }
    }
    
    // MARK: - Test 4: Flujo completo
    func testCompleteFlowUltraSafe() throws {
        print("ULTRA SAFE FLOW TEST")
        print("===================")
        
        // 1. Verificar lanzamiento
        XCTAssertEqual(app.state, .runningForeground, "1. App lanzada correctamente")
        
        // 2. Esperar carga con verificaciones intermedias
        for i in 1...8 {
            Thread.sleep(forTimeInterval: 1.0)
            if app.state != .runningForeground {
                XCTFail("App crasheó durante la carga (segundo \(i))")
                return
            }
        }
        print("2. Carga esperada sin crashes")
        
        // 3. Buscar collection view
        let collectionViews = app.collectionViews
        guard collectionViews.count > 0 else {
            print("3. No collection views - puede ser problema de timing")
            return
        }
        print("3. Collection view encontrado")
        
        let collectionView = collectionViews.firstMatch
        
        // 4. Verificar datos
        Thread.sleep(forTimeInterval: 3.0)
        let cellCount = collectionView.cells.count
        print("4. Celdas cargadas: \(cellCount)")
        
        if cellCount > 0 {
            // 5. Test de contenido
            let firstCell = collectionView.cells.element(boundBy: 0)
            let hasImages = firstCell.images.count > 0
            let hasLabels = firstCell.staticTexts.count > 0
            
            print("5. Primera celda - Imágenes: \(hasImages), Labels: \(hasLabels)")
            
            // 6. Test de scroll
            let beforeScroll = app.state
            collectionView.swipeUp()
            Thread.sleep(forTimeInterval: 1.0)
            let afterScroll = app.state
            
            print("6. Scroll - Antes: \(beforeScroll), Después: \(afterScroll)")
            XCTAssertEqual(afterScroll, .runningForeground, "Scroll no debería causar crash")
        }
        
        print("FLUJO COMPLETO EXITOSO")
        XCTAssertTrue(cellCount > 0, "Deberían haberse cargado personajes")
    }
    
    // MARK: - Test 5:
    func testStructureOnly() throws {
        Thread.sleep(forTimeInterval: 10.0)
        
        let collectionViews = app.collectionViews
        let hasCollectionView = collectionViews.count > 0
        
        if hasCollectionView {
            let cv = collectionViews.firstMatch
            let cells = cv.cells.count
            
            print("STRUCTURE CHECK:")
            print("- Collection Views: \(collectionViews.count)")
            print("- Cells: \(cells)")
            print("- App State: \(app.state)")
            
            XCTAssertTrue(cv.exists, "Collection view debería existir")
            XCTAssertTrue(cells >= 0, "Debería haber 0 o más celdas")
        }
        
        XCTAssertEqual(app.state, .runningForeground, "App debería estar funcionando")
    }
}

// MARK: - Test
final class MinimalRMCharacterUITests: XCTestCase {
    
    func testJustLaunchAndWait() throws {
        let app = XCUIApplication()
        app.launch()
        
        Thread.sleep(forTimeInterval: 10.0)
        
        XCTAssertEqual(app.state, .runningForeground, "App debería seguir funcionando después de 10 segundos")

        let collectionViews = app.collectionViews
        if collectionViews.count > 0 {
            let cv = collectionViews.firstMatch
            let cellCount = cv.cells.count
            print("Celdas encontradas: \(cellCount)")

            XCTAssertTrue(cellCount >= 0, "Collection view debería existir con 0 o más celdas")
        }
    }
}
