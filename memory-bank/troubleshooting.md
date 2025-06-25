# Troubleshooting Guide

## Common Issues & Solutions

### Build Issues

#### SwiftData Import Errors
**Problem**: `Cannot find 'SDTeam' in scope` or similar SwiftData model errors

**Solution**: 
1. Check import statements - SwiftData models should only be imported in DataManager layer
2. Verify model separation - Client models should never reference SwiftData models directly
3. Use transformers for conversion between model types

```swift
// ❌ Wrong - Client code importing SwiftData
import SwiftData
let team: SDTeam = // This breaks model separation

// ✅ Correct - Use Client models
let team: Team = dataManager.fetchTeam(id: "team1")
```

#### Circular Dependency Errors
**Problem**: Build fails with circular dependency warnings

**Solution**:
1. Use protocol abstractions for dependencies
2. Inject dependencies through initializers, not as singletons
3. Check for strong reference cycles in coordinator relationships

```swift
// ❌ Wrong - Direct dependency
class FeatureA {
    let featureB = FeatureB()
}

// ✅ Correct - Protocol-based dependency
class FeatureA {
    private let featureB: FeatureBProtocol
    
    init(featureB: FeatureBProtocol) {
        self.featureB = featureB
    }
}
```

### Navigation Issues

#### Sheet Presentation Not Working
**Problem**: Sheets don't present or navigation bar doesn't appear in sheets

**Solution**: Wrap sheet content in NavigationStack
```swift
// ❌ Wrong - Missing NavigationStack
.sheet(isPresented: $showSheet) {
    FeatureView()
}

// ✅ Correct - Wrapped in NavigationStack  
.sheet(isPresented: $showSheet) {
    NavigationStack {
        FeatureView()
    }
}
```

#### Navigation Bar Theming Issues
**Problem**: Navigation bar doesn't use SSTheme colors

**Solution**: Apply toolbar styling
```swift
.navigationTitle("Title")
.toolbarBackground(theme.colors.background, for: .navigationBar)
.toolbarColorScheme(.dark, for: .navigationBar)
```

#### Child Coordinator Memory Leaks
**Problem**: Child coordinators not being deallocated

**Solution**: Use weak references and proper cleanup
```swift
// ✅ Correct pattern
startChild(childCoordinator) { [weak self] result in
    // Handle result
    // Automatic cleanup happens in BaseFeatureCoordinator
}
```

### Testing Issues

#### Async Test Failures
**Problem**: Tests fail intermittently or don't wait for async operations

**Solution**: Use proper async testing patterns
```swift
// ✅ Correct async testing
@Test("Async operation completes")
func testAsyncOperation() async {
    // Arrange
    let interactor = createInteractor()
    
    // Act
    interactor.eventBus.send(.loadData)
    
    // Wait for processing
    await withCheckedContinuation { continuation in
        DispatchQueue.main.async {
            continuation.resume()
        }
    }
    
    // Assert
    #expect(interactor.viewModel.loaded == true)
}
```

#### Mock Not Being Called
**Problem**: Mock tracking properties remain false

**Solution**: Check subscription setup and thread handling
```swift
// Verify event bus subscriptions are active
// Ensure main queue operations complete before assertions
await MainActor.run {
    // Assertions here
}
```

#### Memory Leak Test Failures
**Problem**: Tests detect memory leaks in coordinators or interactors

**Solution**: Check for strong reference cycles
```swift
// ✅ Correct - weak delegate reference
private weak var delegate: FeatureInteractorDelegate?

// ✅ Correct - weak self in closures
.sink { [weak self] event in
    self?.handleEvent(event)
}
```

### Theme & UI Issues

#### Dark Mode Not Working
**Problem**: UI doesn't respond to dark mode changes

**Solution**: Ensure SSThemeProvider is at root level
```swift
// ✅ Correct - SSThemeProvider at ViewFactory level
SSThemeProvider {
    FeatureView()
}
```

#### Theme Colors Not Applying
**Problem**: Components don't use SSTheme colors

**Solution**: Access theme through environment
```swift
struct MyView: View {
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Text("Title")
            .foregroundColor(theme.colors.primary) // ✅ Uses theme
            .background(theme.colors.background)
    }
}
```

#### List Styling Issues
**Problem**: List backgrounds don't match theme

**Solution**: Apply proper list styling
```swift
List {
    // content
}
.listStyle(.plain)
.background(theme.colors.background)
.scrollContentBackground(.hidden)
```

### Data Layer Issues

#### Transformation Errors
**Problem**: Model transformation fails between Client and SwiftData models

**Solution**: Check transformer implementations and handle optional relationships
```swift
// ✅ Proper error handling in transformers
guard let sdModel = try? ClientToSwiftDataTransformer.transform(clientModel) else {
    throw TransformationError.conversionFailed
}
```

#### Publisher Not Updating UI
**Problem**: UI doesn't update when data changes

**Solution**: Verify publisher subscriptions and @Published properties
```swift
// ✅ Correct reactive setup
@Published var viewModel: FeatureViewModel

// ✅ Subscribe to data changes
dataManager.teamPublisher
    .sink { [weak self] teams in
        self?.updateViewModel(teams)
    }
    .store(in: &cancellables)
```

#### SwiftData Context Issues
**Problem**: SwiftData save operations fail or data inconsistencies

**Solution**: Use proper transaction management
```swift
// ✅ Correct transaction handling
do {
    try await storage.save()
} catch {
    await storage.rollback()
    throw error
}
```

### Performance Issues

#### Slow List Rendering
**Problem**: Large lists lag when scrolling

**Solution**: Optimize view creation and use lazy loading
```swift
// ✅ Optimized list items
LazyVStack {
    ForEach(items) { item in
        ItemView(item: item)
    }
}
```

#### Memory Usage Growing
**Problem**: App memory usage increases over time

**Solution**: Check for retained cancellables and coordinator cleanup
```swift
// ✅ Proper cleanup
deinit {
    cancellables.removeAll()
}
```

### Architecture Violations

#### Model Boundary Violations
**Problem**: SwiftData models appearing in UI layer

**Solution**: Maintain strict layer boundaries
```swift
// ❌ Wrong - SwiftData in UI
func displayTeam(_ sdTeam: SDTeam) { }

// ✅ Correct - Client models in UI  
func displayTeam(_ team: Team) { }
```

#### Direct Navigation from Views
**Problem**: Views performing navigation directly

**Solution**: Use event bus to communicate with interactors
```swift
// ❌ Wrong - Direct navigation
Button("Next") {
    navigationCoordinator.push(.nextScreen)
}

// ✅ Correct - Event bus communication
Button("Next") {
    interactor.eventBus.send(.nextRequested)
}
```

## Debugging Tips

### Enable Debug Logging
Add logging to track data flow and navigation:
```swift
#if DEBUG
print("🔄 Loading team data for ID: \(teamId)")
print("🎯 Event received: \(event)")
print("📱 Coordinator started: \(type(of: self))")
#endif
```

### Verify Dependency Injection
Check that mocks are being used in tests:
```swift
#if DEBUG
print("📦 Using DataManager: \(type(of: dataManager))")
#endif
```

### Memory Debugging
Use weak references and check for leaks:
```swift
#if DEBUG
deinit {
    print("♻️ \(type(of: self)) deallocated")
}
#endif
```

## Prevention Best Practices

1. **Always use protocols** for dependencies
2. **Wrap sheets in NavigationStack** for proper navigation
3. **Apply SSTheme consistently** using environment
4. **Use weak references** for delegates and parents
5. **Test async operations properly** with continuation patterns
6. **Maintain model boundaries** strictly between layers
7. **Clean up subscriptions** in deinit or coordinator cleanup
8. **Use event bus** instead of direct navigation from views

Following these patterns will prevent most common issues in the SuperSoccer architecture. 