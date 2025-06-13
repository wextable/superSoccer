# Project Brief

## Overview

Building an iOS app that is a soccer manager simulation game, where users can manage a team, players, and simulate matches in a league format.

## Core Features

- **MainMenu:** Can create a new career or continue an existing one.
- **NewGame:** Set coach details and select a team to manage.
- **TeamSelect:** Select a team to manage during career creation.
- **Team:** Team overview including team info, coach info, and player roster

## Future Features (not yet implemented)
- **League:** Manage league settings and view league standings and weekly results and schedules.
- **PreMatch:** Shows match details, player lineups, and tactics before a match starts.
- **GameSimulation:** Real-time match simulation and management.
- **PostMatch:** Displays match results, player performance, and statistics after a match.
- **Stats:** View team and player statistics, league standings, and match history.
- **Settings:** Configure app settings, and customize the user experience.
- **Career:** Manage the career progression, including seasons and achievements.
- **Player:** View player details, stats, and manage player transfers.
- **TransferMarket:** Manage player transfers, scout new players, and negotiate contracts.
- **Achievements:** Track achievements and milestones in the game.
- **Home:** Main menu and career overview.

## Aesthetics

### Look
The game should have a retro, nostalgic feel a la the original Nintendo era, reminiscent of classic soccer management games. The UI should be simple, intuitive, and visually appealing.

### Feel
The game should be simultaneously exceedingly realistic in terms of player and team ratings and statistics and game simulation, while also being exceedingly silly and whimsical in terms of player names, in-season 'events' that occur, and overall tone. The game should balance realism with humor, making it engaging and entertaining.

## Technical Preferences

- **Language:** Swift
- **UI:** SwiftUI
- **Database:** SwiftData for local storage
- **Operating System:** iOS

## Project Structure

- `/SuperSoccer`  (App target files)
- `/SuperSoccer/Sources`  (Main source code)
- `/SuperSoccer/Resources`  (Resources for the app)
- `/SuperSoccerTests` (Unit tests)
- `/SuperSoccerUITests` (Unit tests)

## Additional Information (optional)

Separation of concerns is crucial, with a focus on testability and maintainability. The architecture should allow for easy addition of new features without disrupting existing functionality.
### Layers
- **View:** SwiftUI views and their viewModels (viewModels only contain properties for displaying data and should never contain business logic).
- **Data:** SwiftData models and data managers deal only with SwiftData models (prefixed with "SD"). DataManager provides an interface for the rest of the app that uses ClientModels. There is translation between ClientModels and SD models using transformers. SwiftData should never be directly referenced outside of the Data layer.
- **Business Logic:** Interactors handle user interactions and business logic and interact with the DataManager. They should not directly reference SwiftData models. Interactors own a viewModel that views can reference.
- **Navigation:** FeatureCoordinators handle the logical flow control for each feature, managing the presentation of the feature's view and interactions between other feature coordinators. The actual navigation logic is handled by a NavigationCoordinator, which is injected into each FeatureCoordinator.
- **Dependency Injection:** Use a DependencyContainer to manage dependencies across the app, allowing for easy swapping of implementations for testing. Where possible, use protocol-based design to allow for mock implementations in tests.
