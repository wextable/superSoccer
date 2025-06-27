# Implementation Lessons

This file captures specific technical lessons, fixes, and implementation details discovered during development.

## Testing Fixes & Patterns

### MockLocalDataSource Reactive Testing Fix ⚠️ CRITICAL
**Problem**: Tests failing because `MockLocalDataSource` using `Just(data).eraseToAnyPublisher()` only emits initial value once and doesn't notify subscribers of data changes.

**Solution**: Use `CurrentValueSubject` instead:
```swift
class MockNewGameLocalDataSource: NewGameLocalDataSourceProtocol {
    private let dataSubject = CurrentValueSubject<NewGameLocalData, Never>(/* initial */)
    
    var dataPublisher: AnyPublisher<NewGameLocalData, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    
    func updateCoach(name: String) {
        // Update data
        dataSubject.send(updatedData) // ← Critical: notify subscribers
    }
}
```

**Impact**: Enables testing of reactive view model updates and data flow changes. Without this fix, tests checking view model updates after data changes will fail.

### Async TestHooks Implementation Details
**BaseFeatureCoordinator Enhancement**:
```swift
#if DEBUG
var testOnChildCoordinatorAdded: ((any BaseFeatureCoordinatorType) -> Void)?
#endif
```

**TestHooks Pattern**:
```swift
func executeAndWaitForChildCoordinator(_ action: @escaping () -> Void) async {
    await withCheckedContinuation { continuation in
        target.testOnChildCoordinatorAdded = { _ in
            continuation.resume()
        }
        action()
    }
}
```

**Critical**: Never use `DispatchQueue.main.asyncAfter` - always wait for real events.

## Architecture Implementation Specifics

### ViewModelTransform Constructor Injection Pattern
**All interactors must inject transform via constructor**:
```swift
class NewGameInteractor: NewGameInteractorProtocol {
    private let viewModelTransform: NewGameViewModelTransformProtocol
    
    init(dataManager: DataManagerProtocol,
         localDataSource: NewGameLocalDataSourceProtocol,
         viewModelTransform: NewGameViewModelTransformProtocol) { // ← Inject
        self.viewModelTransform = viewModelTransform
        // ...
    }
}
```

### InteractorFactory Enhancement for New Patterns
**Factory must provide all dependencies**:
```swift
func makeNewGameInteractor() -> NewGameInteractorProtocol {
    let localDataSource = NewGameLocalDataSource()
    let viewModelTransform = NewGameViewModelTransform() // ← Create transform
    
    return NewGameInteractor(
        dataManager: dataManager,
        localDataSource: localDataSource,
        viewModelTransform: viewModelTransform // ← Inject
    )
}
```

## Navigation Integration Specifics

### NavigationRouter.Screen Parameter Changes
**Old Pattern** (EventBus era):
```swift
case teamSelect(interactor: TeamSelectInteractorProtocol)
```

**New Pattern** (Presenter separation):
```swift
case teamSelect(presenter: TeamSelectViewPresenter)
```

**ViewFactory Updates Required**:
```swift
func makeTeamSelectView(presenter: TeamSelectViewPresenter) -> AnyView {
    AnyView(
        TeamSelectView(presenter: presenter)
            .environmentObject(theme)
    )
}
```

## Testing Achievement Metrics

### Feature Test Coverage Status
- **NewGame**: 45+ tests passing (complete template)
- **TeamSelect**: 12 tests passing (modern patterns)  
- **MainMenu**: Complete with async TestHooks
- **Team**: 11 tests passing (awaiting architecture upgrade)

### Critical Test Types Implemented
1. **ViewModelTransform Tests**: `NewGameViewModelTransformTests.swift`
2. **Real Interactor + Mock Dependencies**: Behavior testing
3. **Mock Interactor**: Integration testing
4. **Async Continuation Testing**: Eliminates flaky timing tests

## Known Issues & Solutions

### EventBus Elimination Checklist
When converting features from EventBus to direct calls:
1. ✅ Remove `[Feature]EventBus` and `[Feature]Event` enum
2. ✅ Split `[Feature]InteractorProtocol` → BusinessLogic + ViewPresenter  
3. ✅ Update NavigationRouter.Screen to use presenter parameter
4. ✅ Update ViewFactory to accept presenter parameter
5. ✅ Update all navigation test files
6. ✅ Convert view event calls to direct presenter calls
7. ✅ Update all tests to use direct function calls

### MockDependencyContainer Pattern
**Standard test setup**:
```swift
@Test func testFeatureBehavior() async throws {
    let container = MockDependencyContainer()
    let coordinator = container.makeFeatureCoordinator(/* params */)
    
    // Test with reliable mocks
}
```

## Future Implementation Notes

### For Team Feature Upgrade
Apply complete NewGame template:
1. Create `TeamViewModelTransformProtocol` + implementation
2. Enhance `TeamInteractorProtocol` design  
3. Implement nested ViewModels if applicable
4. Create comprehensive ViewModelTransform tests
5. Fix any MockLocalDataSource reactive issues
6. Update all navigation integration points

### For MainMenu/TeamSelect Enhancement  
Add missing NEW patterns:
1. ViewModelTransform Pattern
2. InteractorProtocol Pattern (enhanced)
3. Nested ViewModel Pattern (where applicable)
4. Dedicated ViewModelTransform tests 