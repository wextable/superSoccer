# Technical Context

## Technology Stack

### Core Technologies
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Database**: SwiftData (iOS 17+)
- **Reactive Programming**: Combine
- **Platform**: iOS 17.0+
- **IDE**: Xcode 15+

### Architecture Frameworks
- **Dependency Injection**: Custom DependencyContainer
- **Navigation**: Custom Coordinator Pattern
- **Event System**: Custom EventBus implementation
- **Testing**: XCTest with custom Mock implementations

## Project Structure

### Main Directories
```
SuperSoccer/
├── Sources/
│   ├── App/                    # App entry point
│   ├── DataManager/            # Data orchestration layer
│   ├── DataModels/             # Client and SwiftData models
│   ├── Dependency/             # Dependency injection
│   ├── Features/               # Feature modules
│   ├── Navigation/             # Navigation coordination
│   └── Shared/                 # Shared utilities
├── Resources/                  # Assets and resources
└── Info.plist                 # App configuration
```

### Test Structure
```
SuperSoccerTests/               # Unit tests
SuperSoccerUITests/             # UI tests
```

## Development Environment

### Build Configuration
- **Minimum iOS Version**: 17.0
- **Swift Language Version**: 5.9
- **Xcode Version**: 15.0+
- **SwiftLint**: Configured with custom rules

### Dependencies
- **No External Dependencies**: Pure Swift/SwiftUI implementation
- **SwiftData**: For local persistence
- **Combine**: For reactive programming

## Code Quality Tools

### SwiftLint Configuration
```yaml
# Key rules from .swiftlint.yml
line_length: 120
force_unwrapping: error
empty_count: warning
```

### Testing Strategy
- **Unit Tests**: All business logic and data operations
- **Mock Implementations**: Every protocol has a mock version
- **UI Tests**: Critical user flows
- **Test Coverage**: Focus on core business logic

## Data Persistence

### SwiftData Models
- **Naming Convention**: Prefixed with `SD` (SDTeam, SDPlayer, etc.)
- **Relationships**: Direct object references for persistence
- **Migrations**: Handled automatically by SwiftData

### Client Models
- **Immutable Structs**: All properties are `let`
- **Protocol Conformance**: Identifiable, Hashable, Equatable
- **ID-Based Relationships**: String IDs to prevent circular dependencies

## Navigation Architecture

### Coordinator Pattern Implementation
- **BaseFeatureCoordinator<Result>**: Generic base class
- **NavigationCoordinator**: Handles actual navigation operations
- **Child Management**: Automatic lifecycle management

### Navigation Flow
```
RootCoordinator
├── MainMenuFeatureCoordinator
├── NewGameFeatureCoordinator
│   └── TeamSelectFeatureCoordinator
├── TeamFeatureCoordinator
└── InGameCoordinator
```

## Feature Architecture

### Standard Feature Structure
```
Features/[FeatureName]/
├── [FeatureName]FeatureCoordinator.swift
├── [FeatureName]Interactor.swift
├── [FeatureName]View.swift
├── [FeatureName]ViewModel.swift (if needed)
└── [FeatureName]LocalDataSource.swift (if needed)
```

### Implemented Features
- **MainMenu**: Career management entry point
- **NewGame**: Coach setup and team selection
- **TeamSelect**: Team selection interface
- **Team**: Team overview and roster management

### Planned Features
- **League**: League standings and schedule
- **PreMatch**: Match preparation and tactics
- **GameSimulation**: Real-time match simulation
- **PostMatch**: Match results and statistics
- **Stats**: Comprehensive statistics view
- **TransferMarket**: Player transfers and scouting

## Data Flow Architecture

### Three-Layer Data Architecture
1. **SwiftDataStorage**: Pure persistence operations
2. **DataManager**: Business logic orchestration
3. **Transformers**: Model conversion layer

### Request/Result Pattern
```swift
CreateNewCareerRequest → DataManager → CreateNewCareerResult
```

### Reactive Updates
```swift
DataManager.careerPublisher → UI automatic updates
```

## Development Patterns

### Naming Conventions
- **Feature Coordinators**: `[FeatureName]FeatureCoordinator`
- **Interactors**: `[FeatureName]Interactor`
- **Views**: `[FeatureName]View`
- **Client Models**: Domain names (Team, Player, etc.)
- **SwiftData Models**: `SD` prefix (SDTeam, SDPlayer, etc.)
- **Protocols**: End with `Protocol`
- **Mocks**: `Mock` prefix (MockDataManager, etc.)

### Error Handling
- **Swift Error Handling**: Use throws/async throws
- **Specific Error Types**: Create custom errors when needed
- **Layer-Appropriate Handling**: Handle errors at correct abstraction level

### Memory Management
- **Weak References**: For delegates and parent coordinators
- **Combine Cancellables**: Proper cleanup in deinit
- **Child Coordinator Management**: Automatic through BaseFeatureCoordinator

## Performance Considerations

### Data Loading
- **Lazy Loading**: For large datasets
- **Caching**: Implemented in DataManager layer
- **Reactive Updates**: Minimize unnecessary data fetches

### UI Performance
- **SwiftUI Best Practices**: Efficient view updates
- **ViewModel Pattern**: Separate presentation state
- **Publisher Subscriptions**: Clean cancellable management

## Build and Deployment

### Xcode Project Configuration
- **Workspace**: `supersoccer.code-workspace`
- **Project File**: `SuperSoccer.xcodeproj`
- **Schemes**: SuperSoccer (main app)

### Asset Management
- **Assets.xcassets**: App icons, colors, images
- **Launch Screen**: Custom SuperSoccer launch image
- **Preview Content**: SwiftUI preview assets

## Future Technical Considerations

### Scalability
- **Modular Architecture**: Easy to add new features
- **Protocol-Based Design**: Flexible implementations
- **Clean Separation**: Clear layer boundaries

### Maintainability
- **Comprehensive Testing**: Unit and UI tests
- **Documentation**: Inline and architectural docs
- **Code Quality**: SwiftLint enforcement

### Extensibility
- **Plugin Architecture**: Easy to add new game modes
- **Data Model Flexibility**: Support for new entity types
- **UI Component Reusability**: Shared SwiftUI components

This technical foundation provides a robust, maintainable, and scalable platform for the SuperSoccer application.
