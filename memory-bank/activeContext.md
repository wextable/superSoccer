# Active Context

## Current Work Focus
The SuperSoccer project has completed major architectural milestones including **comprehensive InteractorFactory pattern implementation**, **async TestHooks pattern implementation**, comprehensive UI redesign work, and comprehensive unit testing infrastructure. **All core features now use the InteractorFactory pattern for dependency injection** and have complete SSTheme integration and dark mode support. The core data layer, navigation system, feature coordinators, retro-themed UI, and comprehensive testing infrastructure are fully implemented and working.

## Recent Major Changes

### ✅ Completed: TeamSelect Feature Architecture Update (NEWGAME EXCELLENCE APPLIED)
- **TeamSelectInteractor Protocol Separation**: Successfully applied NewGame's excellent architecture patterns
  - `TeamSelectBusinessLogic`: For coordinator communication via delegate pattern
  - `TeamSelectViewPresenter`: For view communication via direct function calls  
  - Clean separation of concerns between coordinator and view interfaces
- **EventBus Elimination**: Removed EventBus pattern in favor of direct delegate function calls
  - Replaced `eventBus.send(.teamSelected(teamInfoId:))` with `presenter.teamSelected(teamInfoId:)`
  - Direct function call interface through `TeamSelectViewPresenter`
  - Maintained clean separation: `TeamSelectBusinessLogic` for coordinator, `TeamSelectViewPresenter` for view
- **Navigation Integration**: Updated NavigationRouter and ViewFactory
  - `NavigationRouter.Screen.teamSelect(presenter: TeamSelectViewPresenter)` - uses presenter protocol
  - ViewFactory takes `TeamSelectViewPresenter` parameter, not full interactor
  - Consistent with NewGame pattern for proper architectural separation
- **Testing Excellence**: All TeamSelect tests updated to follow NewGame testing patterns
  - Applied `createMocks()` helper for isolated mock dependencies
  - Implemented reliable async testing with `withCheckedContinuation` and delegate callbacks
  - Eliminated EventBus tests in favor of direct function call testing
  - Testing actual effects (delegate calls) rather than derived reactive state
  - All test files updated to use new `teamSelect(presenter:)` pattern
- **Benefits Achieved**:
  - **Separation of Concerns**: Views only see what they need (presenter methods)
  - **Clear Dependencies**: Coordinator interface is separate from view interface
  - **Testability**: Can mock each protocol independently
  - **Consistency**: Same excellent pattern as NewGame and MainMenu
  - **Reliable Testing**: No more flaky EventBus-based tests

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

#### ✅ Features with NEW ARCHITECTURE PATTERN APPLIED
- **NewGame**: ✅ **COMPLETE** - Exemplary architecture with protocol separation (BusinessLogic + Presenter), EventBus elimination, excellent testing patterns
- **MainMenu**: ✅ **COMPLETE** - Updated to NewGame architecture patterns (BusinessLogic + Presenter), EventBus elimination, async TestHooks
- **TeamSelect**: ✅ **COMPLETE** - Applied NewGame excellence (BusinessLogic + Presenter), EventBus elimination, excellent testing patterns

#### 🔄 Remaining Features for Architecture Update
- **Team**: Apply NewGame architecture excellence
  - Remove EventBus pattern, implement protocol separation (TeamBusinessLogic + TeamViewPresenter)
  - Update NavigationRouter to use presenter protocol
  - Apply NewGame testing excellence patterns

## Next Steps

### 1. **Apply NewGame Architecture Excellence to Team Feature** (Current Priority)
**TeamInteractor Refactoring:**
- Remove EventBus pattern in favor of direct function calls
- Implement protocol separation: `TeamBusinessLogic` (coordinator) + `TeamViewPresenter` (view)
- Update NavigationRouter to use Presenter protocol instead of full interactor
- Apply reliable async testing patterns from NewGameInteractorTests

**Benefits Expected:**
- **Consistency**: All features will follow the same excellent architecture
- **Testability**: Direct function call testing instead of EventBus
- **Clean Separation**: Clear coordinator vs view interface boundaries
- **Reliable Testing**: Async patterns with delegate callbacks

### 2. **Complete Unit Testing Coverage** (High Priority)
Expand the excellent testing patterns established for Team feature:

**Design System Testing:**
- Test all UI components (SSPrimaryButton, SSSecondaryButton, SSTextButton)
- Test theme components (SSColors, SSFonts, SSSpacing, SSTheme)
- Test form components (SSTextFieldStyle, SSLabel, SSTitle)

**Navigation Testing:**
- NavigationCoordinator integration tests with InteractorFactory
- BaseFeatureCoordinator lifecycle tests
- TabNavigationCoordinator functionality tests
- Router state management tests with factory integration

### 3. **Core Game Features Development** (Next Phase)
With architecture patterns fully consistent across all features:

**League Feature:**
- League standings display with InteractorFactory integration
- Match schedule and results interface
- Season progression management
- League statistics tracking

**Match Simulation Engine:**
- Basic match simulation with factory-created interactors
- Pre-match preparation interface  
- Real-time match events
- Post-match results and statistics

## Important Files Currently

### Architecture Pattern Files (Template for Remaining Features)
- `SuperSoccer/Sources/Features/NewGame/NewGameInteractor.swift` ✅ **EXEMPLARY** - Perfect template for protocol separation and direct function calls
- `SuperSoccer/Sources/Features/MainMenu/MainMenuInteractor.swift` ✅ **UPDATED** - Applied NewGame patterns successfully  
- `SuperSoccer/Sources/Features/TeamSelect/TeamSelectInteractor.swift` ✅ **UPDATED** - Applied NewGame patterns successfully
- `SuperSoccer/Sources/Features/Team/TeamInteractor.swift` 🔄 **NEEDS UPDATE** - Apply NewGame architecture patterns

### Testing Excellence Templates
- `SuperSoccerTests/Features/NewGame/NewGameInteractorTests.swift` ✅ **EXEMPLARY** - Perfect template for reliable async testing
- `SuperSoccerTests/Features/TeamSelect/TeamSelectInteractorTests.swift` ✅ **UPDATED** - Applied NewGame testing excellence
- `SuperSoccerTests/Features/Team/TeamInteractorTests.swift` 🔄 **READY FOR ENHANCEMENT** - Apply NewGame testing patterns

### Navigation Integration
- `SuperSoccer/Sources/Navigation/NavigationRouter.swift` ✅ **UPDATED** - Uses presenter protocols for NewGame, MainMenu, TeamSelect
- `SuperSoccer/Sources/Navigation/ViewFactory.swift` ✅ **UPDATED** - Uses presenter protocols consistently

## Active Learning and Insights

### Architecture Excellence Achieved
**Protocol Separation Pattern**: The two-protocol separation (BusinessLogic + Presenter) creates perfect separation of concerns:
- Coordinators only see what they need (BusinessLogic with delegate)
- Views only see what they need (Presenter with direct functions)
- Clean testability with protocol-specific mocks
- Clear architectural boundaries

**EventBus Elimination Benefits**: Direct function calls are superior to EventBus:
- **Testable**: Direct function call verification vs event emission testing
- **Reliable**: No async event timing issues in tests
- **Clear**: Explicit function calls vs implicit event handling
- **Maintainable**: Compiler catches breaking changes vs runtime event mismatches

**Testing Excellence**: NewGame testing patterns are superior:
- **`createMocks()` helper**: Isolated dependencies per test
- **`withCheckedContinuation`**: Reliable async testing with real callbacks
- **Direct effect testing**: Test actual side effects, not derived state
- **No flaky patterns**: Eliminated `Task.sleep`, `DispatchQueue.main.asyncAfter`, `await confirmation`

### Consistent Implementation Status
- 🟢 **NewGame**: Perfect template - protocol separation, direct function calls, excellent testing
- 🟢 **MainMenu**: Architecture updated - applied NewGame patterns successfully
- 🟢 **TeamSelect**: Architecture updated - applied NewGame patterns successfully  
- 🟡 **Team**: Ready for update - apply NewGame architecture excellence

**Next Milestone**: Complete Team feature architecture update to achieve 100% consistent excellent architecture across all features.
