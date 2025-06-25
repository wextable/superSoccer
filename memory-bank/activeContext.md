# Active Context

## Current Work Focus
The SuperSoccer project has completed major architectural milestones, comprehensive UI redesign work, and comprehensive Team feature unit testing. **All core features now have complete SSTheme integration and dark mode support.** The core data layer, navigation system, feature coordinators, retro-themed UI, and Team feature testing infrastructure are fully implemented and working.

## Recent Major Changes

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
- **TeamFeatureCoordinatorTests**: Complete coordinator testing
  - Initialization tests verifying proper coordinator setup
  - Start tests confirming navigation to team screen
  - Player interaction tests validating user action handling
  - Navigation integration tests confirming proper coordinator usage
  - Data manager integration tests verifying dependency injection
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
- **MainMenu**: Career management entry point with retro-themed UI and SSPrimaryButton styling
- **NewGame**: Coach profile creation and team selection with comprehensive retro design
  - Custom text field styling with cyan borders
  - Integrated team selector with proper state management
  - Clean view architecture with computed properties
- **TeamSelect**: Team selection interface with complete SSTheme integration
  - NavigationStack wrapper for proper sheet navigation
  - SSTheme integration with environment-based theming
  - Enhanced TeamThumbnailView with SSTitle typography
  - Navigation bar with "Select team" title and proper toolbar styling
  - Complete dark mode support and theme responsiveness
- **Team**: Basic team overview showing roster and team information
  - PlayerRowView with enhanced SSTheme styling
  - Team header display with stats
  - Event bus communication pattern
  - Comprehensive unit test coverage
- **Data Layer**: Complete 3-layer architecture with transformers
- **Navigation**: Coordinator pattern with BaseFeatureCoordinator and child management
- **Tab Navigation**: Complete tab-based navigation system for in-game features
- **InGame Flow**: Full career creation to in-game team management flow
- **Design System**: Complete SuperSoccer Design System with retro-inspired theming
  - Starbyte Super Soccer inspired color palette
  - Typography system with SF Mono headers
  - Button components (Primary, Secondary, Text)
  - Text components (Titles, Labels with hierarchy)
  - Form components (SSTextFieldStyle for consistent input styling)
  - Theme system with proper light/dark mode support
  - SSThemeProvider for automatic color scheme detection and centralized theme management
  - Environment-based theme distribution architecture
  - **All Features Themed**: Complete SSTheme integration across all screens
- **Testing Infrastructure**: Comprehensive unit testing for Team feature
  - Protocol-based mock implementations
  - Swift Testing framework integration
  - Async testing patterns with confirmation blocks
  - Memory management testing
  - Event bus and delegate testing patterns

#### 🔄 Current Focus: Expand Unit Testing Coverage
- **TeamSelectInteractorTests**: Apply Team testing patterns to complete TeamSelect unit testing
  - Selection logic testing for team picker functionality
  - Event bus testing for team selection events
  - Delegate forwarding tests for coordinator communication
  - Data loading tests for team list presentation
  - Memory management and lifecycle testing
- **Other Feature Tests**: Apply Team testing patterns to MainMenu and NewGame features
- **UI Component Tests**: Test all design system components
- **Navigation Tests**: Test coordinators and navigation flows
- **Integration Tests**: Test complete feature workflows

## Next Immediate Steps

### 1. Complete TeamSelectInteractorTests
- **TeamSelectInteractorTests Enhancement**: Current tests exist but are minimal (1.2KB vs Team's 9KB)
  - Add comprehensive event bus testing for team selection
  - Add data loading and view model creation tests
  - Add delegate interaction testing
  - Add memory management and lifecycle testing
  - Follow established Team testing patterns for consistency

### 2. Extend Unit Testing to Remaining Features
- **MainMenuInteractorTests**: Apply Team testing patterns to MainMenu feature
- **NewGameInteractorTests**: Comprehensive testing for NewGame business logic
- **FeatureCoordinatorTests**: Test all feature coordinators following Team pattern

### 3. Complete UI Testing Coverage
- **Design System Tests**: Test all theme components and styling
- **View Model Tests**: Test presentation logic and make() functions
- **Integration Tests**: Test complete redesigned feature flows

### 4. Implement Core Game Features
- **League Feature**: League standings, schedule, and match results
- **Match Simulation**: Basic match simulation engine
- **Player Management**: Enhanced player details and statistics

## Current Technical Decisions

### Testing Architecture
- **Swift Testing Framework**: Using @Test attributes and modern testing patterns
- **Mock Pattern**: Comprehensive mock implementations with tracking properties
- **Async Testing**: Using confirmation blocks and withCheckedContinuation patterns
- **Memory Management Testing**: Verifying no retain cycles or memory leaks
- **Protocol-Based Testing**: All dependencies use protocols with mock implementations

### Team Feature Patterns (Template for Other Features)
- **Event Bus Communication**: Views → Interactors via event bus, not direct calls
- **Delegate Pattern**: Interactors → Coordinators via delegate protocol
- **make() Functions**: Only used in previews and DEBUG tests, not production
- **View Model Extraction**: View models declared at file scope, not nested in views
- **Comprehensive Testing**: Every business logic class has complete unit test coverage

### UI/UX Architecture
- **Centralized Theming**: SSThemeProvider applied at ViewFactory level for consistent theme management
- **Environment-Based Distribution**: Theme distributed through SwiftUI Environment to all components
- **Component Reusability**: Shared components read theme from environment, ensuring consistency
- **Clean View Structure**: Views broken into computed properties for maintainability

### Architecture Patterns in Use
- **Clean Architecture**: 3-layer data architecture with strict boundaries
- **Coordinator Pattern**: Feature-based navigation with result types
- **Dependency Injection**: Protocol-based with mock implementations
- **Event-Driven**: EventBus for feature communication
- **Request/Result**: Structured operations for complex data flows
- **Tab Navigation**: Centralized tab management with coordinator integration

### Key Implementation Preferences
- **Immutable Client Models**: All Client models use `let` properties
- **ID-Based Relationships**: String IDs instead of object references in Client models
- **Protocol Abstractions**: Every service has a protocol with mock implementation
- **SwiftUI + Combine**: Reactive UI with publisher-based data flow
- **Comprehensive Testing**: All business logic must have unit test coverage

## Active Development Patterns

### Testing Development Flow (Established Template)
1. Create comprehensive InteractorTests covering all business logic
2. Create FeatureCoordinatorTests covering navigation and lifecycle
3. Create Mock delegates with tracking properties and callbacks
4. Use Swift Testing framework with @Test attributes
5. Follow async testing patterns with confirmation blocks
6. Test memory management and cleanup
7. Verify protocol-based dependency injection

### UI Development Flow
1. Apply SSThemeProvider at ViewFactory level for feature screens
2. Use @Environment(\.ssTheme) in components to access theme
3. Break complex views into computed properties for readability
4. Leverage existing design system components (SSPrimaryButton, SSTextFieldStyle, etc.)
5. Ensure proper dark mode support through theme system

### Feature Development Flow
1. Create FeatureCoordinator with Result enum
2. Implement Interactor with protocol and mock
3. Build Views with ViewModels for presentation state
4. Add comprehensive unit tests following Team feature pattern
5. Integrate with navigation system

### Data Operations Flow
1. Define Request/Result models for complex operations
2. Implement transformation logic in appropriate transformer
3. Add DataManager methods using transformers
4. Create reactive publishers for UI updates
5. Test with mock implementations

### Testing Strategy
1. **Protocol-Based Testing**: All dependencies use protocols with mock implementations
2. **Unit Test Coverage**: Every class with business logic must have unit tests
3. **Mock Implementations**: Every protocol has a mock version in #if DEBUG blocks
4. **Test Organization**: Test directories mirror source structure
5. **Integration Testing**: Test complete feature flows and data operations
6. **Swift Testing Framework**: Use modern @Test attributes and confirmation patterns

## Current Challenges and Considerations

### Testing Expansion Priorities
- **Feature Parity**: All features need same testing coverage as Team feature
- **Mock Consistency**: Ensure all mock implementations follow same patterns
- **Test Coverage**: Verify comprehensive coverage across all business logic

### UI Consistency Priorities
- **Remaining Screens**: TeamSelect, Team header improvements, and other screens need retro theming
- **Component Expansion**: May need additional design system components for complex layouts
- **Animation System**: Consider adding consistent animations and transitions

### Design Decisions Resolved
- **Testing Patterns**: Team feature testing patterns established as template
- **Event Bus vs Direct Calls**: Event bus pattern confirmed for view-interactor communication
- **Mock Delegate Pattern**: Comprehensive tracking and callback pattern established
- **Theme Architecture**: Centralized theme application through ViewFactory established
- **Component Reusability**: Environment-based theme distribution pattern confirmed
- **Visual Direction**: Retro aesthetic with cyan accents and proper dark mode support established

### Design Decisions Pending
- **Match Simulation Engine**: How detailed should the simulation be?
- **Player Statistics**: What statistics to track and display?
- **League Structure**: Number of teams, seasons, and competition format

## Project Insights and Learnings

### Testing Evolution
- **Swift Testing Framework**: Modern testing patterns with @Test attributes work excellently
- **Mock Pattern Consistency**: Tracking properties and callback patterns provide reliable testing
- **Async Testing**: Confirmation blocks handle event bus and delegate testing effectively
- **Memory Management**: Explicit memory leak testing prevents retain cycles
- **Protocol-Based Design**: Makes testing much easier with proper mock implementations

### UI/UX Evolution
- **Centralized Theming**: ViewFactory-level theme application provides clean separation of concerns
- **Environment Distribution**: SwiftUI Environment system works excellently for theme distribution
- **Component Architecture**: Extracting reusable components to DesignSystem improves maintainability
- **View Structure**: Breaking views into computed properties significantly improves readability

### Architecture Evolution
- **Simplification**: Moving from complex RequestProcessor to simple DataManager + Transformers improved maintainability
- **Clear Boundaries**: Strict model separation prevents architectural violations
- **Testability**: Protocol-based design makes testing much easier
- **Tab Navigation**: Centralized tab management improves navigation consistency
- **Event Bus Pattern**: Provides clean separation between views and business logic

### SwiftUI Patterns
- **ViewModel Usage**: ViewModels work well for presentation state but should not contain business logic
- **Coordinator Integration**: SwiftUI views work well with coordinator pattern when properly abstracted
- **Reactive Updates**: Combine publishers provide clean data flow to UI
- **Tab Integration**: TabContainerView provides clean separation between tab UI and navigation logic

### Development Workflow
- **Feature-First**: Building complete features with full testing before moving to next works well
- **Test-Driven**: Having comprehensive unit tests improves development speed and quality
- **Documentation**: Keeping architecture docs updated is crucial for complex projects
- **Pattern Consistency**: Establishing patterns in one feature makes other features easier

## Important Files to Monitor

### Testing Reference Files (Templates for Other Features)
- `SuperSoccerTests/Features/Team/TeamInteractorTests.swift` - Comprehensive interactor testing template
- `SuperSoccerTests/Features/Team/TeamFeatureCoordinatorTests.swift` - Complete coordinator testing template
- Mock delegate pattern examples throughout Team tests

### UI Architecture Files
- `SuperSoccer/Sources/Navigation/ViewFactory.swift` - Centralized theme application
- `SuperSoccer/Sources/DesignSystem/Components/Form/SSTextFieldStyle.swift` - Reusable text field styling
- `SuperSoccer/Sources/Features/TeamSelect/TeamSelectorView.swift` - Themed team selector component
- `SuperSoccer/Sources/Features/MainMenu/MainMenuView.swift` - Redesigned main menu
- `SuperSoccer/Sources/Features/NewGame/NewGameView.swift` - Comprehensive redesign example

### Core Architecture Files
- `SuperSoccer/Sources/DataManager/SwiftData/SwiftDataManager.swift`
- `SuperSoccer/Sources/DataModels/Transforms/SwiftData/ClientToSwiftDataTransformer.swift`
- `SuperSoccer/Sources/DataModels/Transforms/SwiftData/SwiftDataToClientTransformer.swift`
- `SuperSoccer/Sources/Navigation/BaseFeatureCoordinator.swift`

### Team Feature Files (Reference Implementation)
- `SuperSoccer/Sources/Features/Team/TeamInteractor.swift` - Event bus pattern implementation
- `SuperSoccer/Sources/Features/Team/PlayerRowView.swift` - SSTheme integration example
- `SuperSoccer/Sources/Features/Team/TeamView.swift` - Clean view structure example

This active context represents the current state of development and should be updated as work progresses and new decisions are made.
