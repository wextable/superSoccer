# Quick Reference

## Key Commands & Patterns

### Creating a New Feature
Follow this exact structure and pattern:

#### 1. Create Feature Directory
```
Features/[FeatureName]/
├── [FeatureName]FeatureCoordinator.swift
├── [FeatureName]Interactor.swift
├── [FeatureName]View.swift
├── [FeatureName]LocalDataSource.swift (if needed)
└── Supporting files (ViewModels, etc.)
```

#### 2. Feature Coordinator Template
```swift
enum [FeatureName]CoordinatorResult: CoordinatorResult {
    case completed(SomeData)
    case cancelled
}

class [FeatureName]FeatureCoordinator: BaseFeatureCoordinator<[FeatureName]CoordinatorResult> {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        let interactor = [FeatureName]Interactor(
            dataManager: dataManager,
            delegate: self
        )
        
        let screen = NavigationRouter.Screen.[featureName](interactor: interactor)
        Task { @MainActor in
            self.navigationCoordinator.presentSheet(screen)
        }
    }
}

extension [FeatureName]FeatureCoordinator: [FeatureName]InteractorDelegate {
    func [featureName]Completed(with data: SomeData) {
        finish(with: .completed(data))
    }
}

#if DEBUG
class Mock[FeatureName]FeatureCoordinator: [FeatureName]FeatureCoordinator {
    var startCalled = false
    
    override func start() {
        startCalled = true
    }
}
#endif
```

#### 3. Interactor Template
```swift
typealias [FeatureName]EventBus = PassthroughSubject<[FeatureName]Event, Never>

enum [FeatureName]Event: BusEvent {
    case loadData
    case actionPerformed(String)
}

protocol [FeatureName]InteractorDelegate: AnyObject {
    func [featureName]Completed(with data: SomeData)
}

protocol [FeatureName]InteractorProtocol: AnyObject {
    var viewModel: [FeatureName]ViewModel { get }
    var eventBus: [FeatureName]EventBus { get }
}

class [FeatureName]Interactor: [FeatureName]InteractorProtocol {
    @Published var viewModel: [FeatureName]ViewModel
    let eventBus = [FeatureName]EventBus()
    
    private let dataManager: DataManagerProtocol
    private weak var delegate: [FeatureName]InteractorDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: DataManagerProtocol,
         delegate: [FeatureName]InteractorDelegate) {
        self.dataManager = dataManager
        self.delegate = delegate
        
        self.viewModel = [FeatureName]ViewModel(/* initial state */)
        
        setupSubscriptions()
        loadData()
    }
    
    private func setupSubscriptions() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .loadData:
                    self?.loadData()
                case .actionPerformed(let data):
                    self?.handleAction(data)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        // Load and process data
        // Update viewModel
    }
    
    private func handleAction(_ data: String) {
        delegate?.[featureName]Completed(with: data)
    }
}

#if DEBUG
class Mock[FeatureName]Interactor: [FeatureName]InteractorProtocol {
    @Published var viewModel: [FeatureName]ViewModel
    let eventBus = [FeatureName]EventBus()
    
    init() {
        self.viewModel = .make()
    }
}

class Mock[FeatureName]InteractorDelegate: [FeatureName]InteractorDelegate {
    var completedCalled = false
    var lastCompletedData: SomeData?
    var onCompleted: (() -> Void)?
    
    func [featureName]Completed(with data: SomeData) {
        completedCalled = true
        lastCompletedData = data
        onCompleted?()
    }
}
#endif
```

#### 4. View Template
```swift
struct [FeatureName]ViewModel {
    let title: String
    let items: [ItemViewModel]
}

struct [FeatureName]View: View {
    let interactor: any [FeatureName]InteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.medium) {
            SSTitle(interactor.viewModel.title)
            
            // Feature content here
            
            SSPrimaryButton("Action") {
                interactor.eventBus.send(.actionPerformed("data"))
            }
        }
        .padding(theme.spacing.large)
        .background(theme.colors.background)
        .navigationTitle(interactor.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#if DEBUG
extension [FeatureName]ViewModel {
    static func make(
        title: String = "Default Title",
        items: [ItemViewModel] = [.make()]
    ) -> Self {
        self.init(title: title, items: items)
    }
}
#endif
```

### Adding Unit Tests (Following Team Template)

#### Test File Template
```swift
import Combine
import Foundation
@testable import SuperSoccer
import Testing

struct [FeatureName]InteractorTests {
    
    // MARK: - Initialization Tests
    
    @Test("[FeatureName]Interactor initializes with correct dependencies")
    func testInitializationWithCorrectDependencies() {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = Mock[FeatureName]InteractorDelegate()
        
        // Act
        let interactor = [FeatureName]Interactor(
            dataManager: mockDataManager,
            delegate: mockDelegate
        )
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Event Handling Tests
    
    @Test("[FeatureName]Interactor handles events correctly")
    func testEventHandling() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = Mock[FeatureName]InteractorDelegate()
        let interactor = [FeatureName]Interactor(
            dataManager: mockDataManager,
            delegate: mockDelegate
        )
        
        // Act
        interactor.eventBus.send(.actionPerformed("test"))
        
        // Wait for processing
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
        
        // Assert
        #expect(mockDelegate.completedCalled == true)
        #expect(mockDelegate.lastCompletedData == "test")
    }
    
    // MARK: - Data Loading Tests
    
    @Test("[FeatureName]Interactor loads data correctly")
    func testLoadDataCorrectly() async {
        // Arrange & Act & Assert pattern
        // Follow Team testing examples
    }
    
    // MARK: - Memory Management Tests
    
    @Test("[FeatureName]Interactor cleans up properly")
    func testMemoryManagement() {
        // Test for retain cycles and proper cleanup
    }
}
```

## UI Components & Design System

### SSTheme Usage
```swift
struct MyView: View {
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.medium) {
            // Colors
            Text("Title")
                .foregroundColor(theme.colors.primary)
                .background(theme.colors.background)
            
            // Typography
            SSTitle("Main Title")
            SSLabel("Subtitle", style: .body)
            
            // Buttons
            SSPrimaryButton("Primary Action") { /* action */ }
            SSSecondaryButton("Secondary") { /* action */ }
            SSTextButton("Text Only") { /* action */ }
            
            // Form Elements
            TextField("Input", text: $text)
                .textFieldStyle(SSTextFieldStyle())
        }
        .padding(theme.spacing.large)
        .cornerRadius(theme.cornerRadius.medium)
    }
}
```

### Theme Provider Setup
```swift
// In ViewFactory or root view
SSThemeProvider {
    YourContentView()
}
```

### Navigation Patterns
```swift
// Sheet presentation
Task { @MainActor in
    self.navigationCoordinator.presentSheet(screen)
}

// Stack navigation
Task { @MainActor in
    self.navigationCoordinator.push(screen)
}

// Replace entire stack
Task { @MainActor in
    self.navigationCoordinator.replaceStackWith(screen)
}
```

## Data Layer Patterns

### Request/Result Pattern
```swift
// Request
struct CreateNewFeatureRequest {
    let name: String
    let configuration: FeatureConfig
}

// Result
struct CreateNewFeatureResult {
    let feature: Feature
    let success: Bool
}

// Usage in DataManager
func createFeature(_ request: CreateNewFeatureRequest) async throws -> CreateNewFeatureResult {
    // Implementation
}
```

### Transformer Pattern
```swift
// Client to SwiftData
let sdModel = try ClientToSwiftDataTransformer.transform(clientModel)

// SwiftData to Client
let clientModel = SwiftDataToClientTransformer.transform(sdModel)
```

### Publisher Subscriptions
```swift
// In Interactor
dataManager.teamPublisher
    .combineLatest(dataManager.playerPublisher)
    .sink { [weak self] teams, players in
        self?.updateViewModel(teams: teams, players: players)
    }
    .store(in: &cancellables)
```

## Common Code Snippets

### Async Testing Pattern
```swift
await withCheckedContinuation { continuation in
    DispatchQueue.main.async {
        continuation.resume()
    }
}
```

### Mock with Callbacks
```swift
class MockService: ServiceProtocol {
    var methodCalled = false
    var lastParameter: String?
    var onMethodCalled: (() -> Void)?
    
    func method(parameter: String) {
        methodCalled = true
        lastParameter = parameter
        onMethodCalled?()
    }
}
```

### Event Bus Subscription
```swift
eventBus
    .sink { [weak self] event in
        switch event {
        case .action1:
            self?.handleAction1()
        case .action2(let data):
            self?.handleAction2(data)
        }
    }
    .store(in: &cancellables)
```

### Child Coordinator Management
```swift
let childCoordinator = TeamSelectFeatureCoordinator(/* params */)
startChild(childCoordinator) { [weak self] result in
    switch result {
    case .teamSelected(let team):
        self?.handleTeamSelected(team)
    case .cancelled:
        self?.handleCancellation()
    }
}
```

## File Templates

### Quick Feature Creation Checklist
1. ✅ Create coordinator with Result enum
2. ✅ Create interactor with protocol and delegate
3. ✅ Create view with SSTheme integration
4. ✅ Add to NavigationRouter.Screen enum
5. ✅ Create mock implementations in #if DEBUG
6. ✅ Add comprehensive unit tests
7. ✅ Update ViewFactory if needed
8. ✅ Add to parent coordinator navigation

### Required Imports
```swift
// Feature Coordinator
import Foundation

// Interactor
import Foundation
import Combine

// View
import SwiftUI

// Tests
import Combine
import Foundation
@testable import SuperSoccer
import Testing
```

This quick reference provides copy-paste ready templates and patterns that match the established SuperSoccer architecture and coding standards. 