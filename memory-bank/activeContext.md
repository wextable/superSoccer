# Active Context

## Current Work Focus
The SuperSoccer project has completed major architectural milestones including **comprehensive InteractorFactory pattern implementation**, **async TestHooks pattern implementation**, comprehensive UI redesign work, and comprehensive unit testing infrastructure. **All core features now use the InteractorFactory pattern for dependency injection** and have complete SSTheme integration and dark mode support. The core data layer, navigation system, feature coordinators, retro-themed UI, and comprehensive testing infrastructure are fully implemented and working.

## Recent Major Changes

### ✅ Completed: Async TestHooks Pattern Implementation (MAJOR TESTING MILESTONE)
- **BaseFeatureCoordinator Enhanced**: Added `testOnChildCoordinatorAdded` callback mechanism
  - Triggers when `startChild()` creates child coordinators, enabling real event-based testing
  - Test-only callback system using `#if DEBUG` compilation flags
  - Eliminates arbitrary delays in favor of deterministic async testing
- **TestHooks Async Helpers**: Added comprehensive async testing support to all coordinators
  - `waitForChildCoordinator()`: Standalone method for waiting on child coordinator creation
  - `executeAndWaitForChildCoordinator()`: Combined action + wait pattern for test efficiency
  - Uses `await withCheckedContinuation` with real events instead of `DispatchQueue.main.asyncAfter`
- **Tests Updated to Use New Pattern**: Eliminated flaky timing-based tests
  - **MainMenuFeatureCoordinatorTests**: `testInteractorNewGameSelection` now uses deterministic async pattern
  - **NewGameFeatureCoordinatorTests**: `testTeamSelectionCoordinatorLifecycle` now uses deterministic async pattern
  - **Testing Performance**: Tests are now faster (no 10ms+ delays) and more reliable
  - **Pattern Established**: Template for all future async coordinator testing
- **Benefits Achieved**:
  - **Deterministic**: Tests wait for actual events, not arbitrary timeouts
  - **Fast**: No more artificial delays in test execution
  - **Reliable**: Tests pass consistently without race conditions
  - **Maintainable**: Clear pattern for future coordinator async testing

### ✅ Completed: MainMenu Feature Architecture Update (NEW PATTERN APPLIED)
- **MainMenuInteractor Protocol Separation**: Applied NewGame's excellent architecture patterns
  - `MainMenuBusinessLogic`: For coordinator communication via delegate pattern
  - `MainMenuViewPresenter`: For view communication via direct function calls  
  - Clean separation of concerns between coordinator and view interfaces
- **EventBus Elimination**: Removed EventBus pattern in favor of direct delegate function calls
  - Replaced event-based communication with dedicated protocol methods
  - Direct function call interface through `MainMenuViewPresenter`
  - Maintained clean separation: `MainMenuBusinessLogic` for coordinator, `MainMenuViewPresenter` for view
- **Navigation Integration**: Updated NavigationRouter and ViewFactory
  - `NavigationRouter.Screen.mainMenu(presenter: MainMenuViewPresenter)` - uses presenter protocol
  - ViewFactory takes `MainMenuViewPresenter` parameter, not full interactor
  - Consistent with NewGame pattern for proper architectural separation
- **Testing Excellence**: All MainMenu tests updated and passing
  - Updated to use new async TestHooks pattern (no arbitrary delays)
  - Proper verification using TestHooks for child coordinator creation
  - All coordinator tests pass consistently with new architecture

### ✅ Completed: InteractorFactory Pattern Implementation
- **InteractorFactory Architecture**: Implemented comprehensive factory pattern for all features
  - Created `InteractorFactoryProtocol` with factory methods for all interactors
  - Production `InteractorFactory` implementation with DataManager dependency injection
  - Complete `MockInteractorFactory` for testing with pre-configured mocks
  - **Parameterized Factory Support**: Handles both simple and parameterized interactor creation
    - Simple: `makeNewGameInteractor()`, `makeMainMenuInteractor()`, `makeTeamSelectInteractor()`
    - Parameterized: `makeTeamInteractor(userTeamId: String)` for context-specific initialization
- **Feature Coordinator Updates**: All coordinators now use InteractorFactory instead of direct instantiation
  - `NewGameFeatureCoordinator`: ✅ Updated to use `interactorFactory.makeNewGameInteractor()`
  - `MainMenuFeatureCoordinator`: ✅ Updated to use `interactorFactory.makeMainMenuInteractor()`
  - `TeamSelectFeatureCoordinator`: ✅ Updated to use `interactorFactory.makeTeamSelectInteractor()`
  - `TeamFeatureCoordinator`: ✅ Updated to use `interactorFactory.makeTeamInteractor(userTeamId:)`
- **Protocol Consistency**: All InteractorProtocols now specify consistent `delegate` property
  - `var delegate: [Feature]InteractorDelegate? { get set }` pattern across all protocols
  - Simplified coordinator-interactor communication through common delegate pattern
- **Testing Infrastructure Improvements**: MockDependencyContainer pattern for all tests
  - `MockDependencyContainer` provides unified testing interface
  - Helper methods: `makeTeamCoordinator(userTeamId:)`, `makeMainMenuCoordinator()`, etc.
  - Simplified test setup: `let container = MockDependencyContainer(); let coordinator = container.makeTeamCoordinator(userTeamId:)`
  - Eliminated manual mock object creation in favor of factory-provided mocks

### ✅ Completed: Complete Unit Test Infrastructure with Factory Pattern
- **TeamFeatureCoordinatorTests**: Updated to use MockDependencyContainer pattern
  - All 11 tests passing with new factory-based dependency injection
  - Simplified test setup using `container.makeTeamCoordinator(userTeamId: "team1")`
  - Enhanced test coverage for InteractorFactory integration
  - Proper verification of parameterized interactor creation
- **MainMenuFeatureCoordinatorTests**: Updated to use MockDependencyContainer pattern
  - Simplified mock setup and dependency injection through factory
  - All tests passing with new architecture
- **TeamSelectFeatureCoordinatorTests**: Updated to use MockDependencyContainer pattern
  - Factory-based coordinator creation and mock management
  - Consistent testing patterns across all feature coordinators
- **Testing Pattern Established**: Template for all future feature tests
  - `MockDependencyContainer` provides all required mocks and coordinators
  - Consistent setup pattern: `let container = MockDependencyContainer()`
  - Type-safe factory methods for coordinator creation
  - Automatic mock interactor injection and configuration

### ✅ Completed: TeamSelectView Theming (Final Screen)
- **Complete SSTheme Integration**: TeamSelectView now fully themed with design system
  - Added `@Environment(\.ssTheme)` for proper theme access
  - Applied consistent background colors and list styling
  - Integrated navigation bar theming with toolbar styling
  - Enhanced TeamThumbnailView with SSTitle typography
  - Proper spacing and padding using theme spacing system
- **Navigation Stack Implementation**: Fixed sheet presentation issue
  - Wrapped TeamSelectView in NavigationStack within ViewFactory
  - Added SSThemeProvider to ensure proper theme distribution in sheet
  - Navigation title "Select team" now displays correctly in presented sheet
  - Proper toolbar theming with dark color scheme
- **Dark Mode Support**: Complete dark mode functionality
  - SSThemeProvider automatically detects color scheme changes
  - Theme updates propagate through environment to all components
  - Consistent light/dark mode behavior across all features
- **All Features Now Themed**: TeamSelectView was the final screen requiring theming
  - MainMenu: ✅ Fully themed with SSPrimaryButton and proper backgrounds
  - NewGame: ✅ Fully themed with SSTitle, SSTextFieldStyle, TeamSelectorView
  - TeamSelect: ✅ Now fully themed with NavigationStack and SSTheme integration
  - Team: ✅ Enhanced with SSTheme styling and PlayerRowView updates

### ✅ Completed: NewGame Feature EventBus Elimination & Testing Excellence
- **NewGameInteractor Refactoring**: Successfully eliminated EventBus pattern for direct function calls
  - Removed `NewGameEvent` enum and `NewGameEventBus` typealias
  - Replaced event-based communication with dedicated protocol methods: `submitTapped()` and `teamSelectorTapped()`
  - Updated `NewGameViewPresenter` protocol with direct function call interface
  - Maintained clean separation: `NewGameBusinessLogic` for coordinator, `NewGameViewPresenter` for view
- **NewGameInteractorTests**: **EXEMPLARY testing patterns** - model for all future tests
  - **Reliable Async Testing**: `withCheckedContinuation` with delegate callbacks (no more flaky `Task.sleep`)
  - **Direct Effect Testing**: Test local data source updates rather than binding getters
  - **Isolated Mock Dependencies**: `createMocks()` helper for fresh instances per test
  - **Comprehensive Coverage**: Binding tests, validation tests, delegate tests, async tests
  - **All 14 tests passing consistently** - no flaky timing issues
- **Testing Anti-Patterns Eliminated**: 
  - No more `await confirmation` with unreliable timing
  - No more `Task.sleep` delays that break under load
  - No more testing derived state instead of actual effects
  - No more shared mock state between tests

### ✅ Completed: Team Feature Unit Tests  
- **TeamInteractorTests**: Comprehensive test coverage for team business logic
  - Initialization tests verifying dependency injection
  - Event handling tests for event bus functionality (loadTeamData, playerRowTapped)
  - Data loading tests for team data retrieval and view model creation
  - Team header creation tests validating view model generation
  - Event bus tests confirming proper event publishing and subscription
  - Delegate tests ensuring interaction delegate forwarding
  - Data reactivity tests verifying reactive updates when data changes
  - Memory management tests ensuring no memory leaks
- **TeamFeatureCoordinatorTests**: Complete coordinator testing with InteractorFactory
  - Initialization tests verifying proper coordinator setup with factory
  - Start tests confirming navigation to team screen
  - Player interaction tests validating user action handling
  - Navigation integration tests confirming proper coordinator usage
  - InteractorFactory integration tests verifying factory-based interactor creation
  - Lifecycle tests covering complete coordinator flows
  - Memory management tests ensuring proper cleanup
- **MockTeamInteractorDelegate**: Comprehensive mock implementation
  - Tracking properties for test verification
  - Callback support for async testing patterns
  - Follows established project testing patterns

### ✅ Completed: Team Feature Consistency Improvements
- **Removed make() functions from production code**: Only kept for SwiftUI previews and DEBUG testing
- **Moved view models outside view declarations**: PlayerRowViewModel extracted to file scope
- **Implemented event bus pattern**: Views communicate with interactors via event bus instead of direct calls
- **Enhanced PlayerRowView styling**: Updated to use SSTheme and design system components
- **Added comprehensive make() functions**: All view models now have make() functions using other make() as defaults

### ✅ Completed: Comprehensive UI Redesign
- **NewGame Screen**: Complete retro-inspired redesign using the DesignSystem
  - Custom `SSTextFieldStyle` for consistent text input styling
  - Integrated `TeamSelectorView` with retro aesthetics
  - Proper dark mode support and theme integration
  - Clean view structure with computed properties
- **MainMenu Screen**: Redesigned with consistent retro theming
  - Replaced generic List with themed VStack layout
  - Uses SSPrimaryButton for menu items
  - Consistent navigation bar and background styling
- **Component Architecture**: Established reusable design system components
  - `SSTextFieldStyle` moved to DesignSystem for reusability
  - `TeamSelectorView` extracted as standalone, themed component
  - Centralized theme application through ViewFactory
- **Theme Integration**: Implemented consistent theming architecture
  - SSThemeProvider applied at ViewFactory level for centralized theme management
  - Environment-based theme distribution to all child components
  - Proper light/dark mode support across all redesigned screens

### ✅ Completed: Tab Navigation System
- **TabNavigationCoordinator**: Fully implemented with proper navigation delegation
- **TabContainerView**: Complete tab-based UI for in-game features
- **TabNavigationManager**: Centralized tab state management
- **Tab Configuration**: Flexible tab setup with icons and titles

### ✅ Completed: InGame Coordinator
- **InGameCoordinator**: Full implementation with career result handling
- **Tab Integration**: Proper integration with tab navigation system
- **Child Coordinator Management**: Automatic lifecycle management for team tab
- **Result Handling**: Proper handling of team coordinator results

### ✅ Completed: Data Manager Integration
- **SwiftDataManager**: Complete transformer injection and integration
- **SwiftDataManagerFactory**: Proper factory pattern with transformer dependencies
- **3-Layer Architecture**: Fully functional SwiftDataStorage → DataManager → Transformers
- **Reactive Publishers**: All publishers working with transformer layer

### Current Implementation Status

#### ✅ Completed Features
- **InteractorFactory Pattern**: Type-safe dependency injection for all features
  - Production factory with DataManager integration
  - Mock factory for comprehensive testing support
  - Parameterized factory methods for context-specific interactors
  - Consistent delegate protocol pattern across all interactors
- **MainMenu**: Career management entry point with retro-themed UI and InteractorFactory integration
- **NewGame**: Coach profile creation and team selection with comprehensive retro design and factory pattern
- **TeamSelect**: Team selection interface with complete SSTheme integration and InteractorFactory
- **Team**: Basic team overview with InteractorFactory parameterized creation (`userTeamId` support)
- **Data Layer**: Complete 3-layer architecture with transformers
- **Navigation**: Coordinator pattern with BaseFeatureCoordinator and child management
- **Tab Navigation**: Complete tab-based navigation system for in-game features
- **InGame Flow**: Full career creation to in-game team management flow
- **Design System**: Complete SuperSoccer Design System with retro-inspired theming
- **Testing Infrastructure**: Comprehensive unit testing with InteractorFactory pattern
  - MockDependencyContainer for unified test setup
  - Factory-based mock creation and management
  - Consistent testing patterns across all features
  - Protocol-based mock implementations with complete coverage

#### 🔄 Next Focus: Apply NewGame Patterns to Remaining Features
- **Eliminate EventBus Pattern**: Apply NewGame's direct function call approach to remaining interactors
  - **MainMenu**: ✅ **COMPLETED** - Replaced EventBus with direct delegate function calls
  - **TeamSelect**: Replace EventBus with direct delegate function calls  
  - **Team**: Replace EventBus with direct delegate function calls (keep existing tests as reference)
- **Protocol Separation Pattern**: Apply NewGame's two-protocol architecture to remaining features
  - **MainMenu**: ✅ **COMPLETED** - BusinessLogic + Presenter protocols implemented
  - **TeamSelect**: Add BusinessLogic Protocol (coordinator) + Presenter Protocol (view)
  - **Team**: Add BusinessLogic Protocol (coordinator) + Presenter Protocol (view)
  - **NavigationRouter.Screen Updates**: Update remaining screens to use Presenter protocols
  - **View Initialization**: Ensure all views are initialized with Presenter protocols
  - Maintain clean separation of concerns between coordinator and view interfaces
- **Apply NewGameInteractorTests Patterns**: Use as template for testing excellence on remaining features
  - **withCheckedContinuation**: For reliable async testing without flaky delays
  - **Direct Effect Testing**: Test actual side effects, not derived reactive state
  - **Isolated Mock Dependencies**: Fresh mock instances per test via helper functions
  - **Comprehensive Coverage**: All interaction paths with consistent, reliable patterns

## Next Immediate Steps

### 1. Apply NewGame Architecture Patterns to Remaining Features
- **MainMenuInteractor**: ✅ **COMPLETED** - EventBus removed, protocol separation implemented (BusinessLogic + Presenter)
- **TeamSelectInteractor**: Remove EventBus, add protocol separation (BusinessLogic + Presenter)
- **TeamInteractor**: Remove EventBus, add protocol separation (BusinessLogic + Presenter)
- **NavigationRouter Updates**: Update Screen cases to use Presenter protocols instead of Interactor protocols
- **View Layer Updates**: Update Views to be initialized with Presenter protocols, not InteractorProtocol
- **Apply Testing Excellence**: Use NewGameInteractorTests as template for all feature interactor tests

### 2. Validate Pattern Consistency
- **Protocol Interfaces**: Ensure all interactors follow BusinessLogic + Presenter separation
- **Direct Function Calls**: Verify all view-interactor communication uses direct function calls
- **Testing Standards**: All interactor tests use withCheckedContinuation and direct effect testing
- **Mock Isolation**: All tests use isolated mock dependencies via helper functions

### 3. Complete Feature Testing with New Patterns
- **MainMenuInteractorTests**: Apply NewGame testing patterns after EventBus removal
- **TeamSelectInteractorTests**: Apply NewGame testing patterns after EventBus removal
- **Enhanced TeamInteractorTests**: Update existing tests to match NewGame excellence patterns
- **Integration Tests**: Test complete feature workflows with new direct function call patterns

## Current Technical Decisions

### InteractorFactory Architecture
- **Type-Safe Dependency Injection**: Protocol-based factory pattern for all interactor creation
- **Parameterized Support**: Factory methods support both simple and parameterized interactor creation
- **Consistent Patterns**: All features follow same factory integration pattern
- **Testing Integration**: MockDependencyContainer provides unified testing interface
- **Scalable Design**: Easy to extend for new features and interactor types

### Testing Architecture Excellence (NewGame Template)
- **MockDependencyContainer**: Centralized mock creation and coordinator factory methods
- **Unified Test Setup**: Consistent `container.make[Feature]Coordinator()` pattern
- **Factory-Based Mocks**: All mock interactors created through MockInteractorFactory
- **Type Safety**: Compile-time verification of dependencies and factory methods
- **Test Isolation**: Each test gets fresh mock instances through factory
- **NewGameInteractorTests Excellence Patterns**:
  - `withCheckedContinuation` for reliable async testing (no more flaky delays)
  - Direct effect testing (test actual side effects, not derived state)
  - `createMocks()` helper for isolated dependencies per test
  - Comprehensive coverage with consistent, reliable patterns

### Architecture Patterns in Use
- **InteractorFactory Pattern**: Type-safe dependency injection for all features
- **Clean Architecture**: 3-layer data architecture with strict boundaries
- **Coordinator Pattern**: Feature-based navigation with result types and factory integration
- **Protocol-Based Dependency Injection**: All dependencies use factory-provided instances
- **Event-Driven**: EventBus for feature communication with factory-created interactors

## Key Implementation Files
- **InteractorFactory**: `SuperSoccer/Sources/Dependency/InteractorFactory.swift`
  - InteractorFactoryProtocol, InteractorFactory, MockInteractorFactory
- **DependencyContainer**: `SuperSoccer/Sources/Dependency/DependencyContainer.swift`
  - MockDependencyContainer with coordinator factory methods
- **Feature Coordinators**: All updated to use InteractorFactory pattern
  - TeamFeatureCoordinator with parameterized factory support
  - Other coordinators with simple factory integration
- **Test Files**: All feature coordinator tests updated to use MockDependencyContainer pattern

## Important Code Patterns

### InteractorFactory Usage Pattern
```swift
// Production (in FeatureCoordinator)
init(navigationCoordinator: NavigationCoordinatorProtocol,
     interactorFactory: InteractorFactoryProtocol) {
    let interactor = interactorFactory.makeTeamInteractor(userTeamId: userTeamId)
    interactor.delegate = self
}

// Testing (in Tests)
let container = MockDependencyContainer()
let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
```

### Factory Interface Pattern
```swift
protocol InteractorFactoryProtocol {
    // Simple interactors
    func makeNewGameInteractor() -> NewGameInteractorProtocol
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    
    // Parameterized interactors
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol
}
```

This architecture provides type-safe, testable, and scalable dependency injection for all features while maintaining clean separation of concerns and comprehensive testing support.
