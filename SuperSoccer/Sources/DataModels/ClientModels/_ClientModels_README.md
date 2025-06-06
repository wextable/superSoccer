# Client Models

This directory contains the core domain models used throughout the SuperSoccer application for business logic, game simulation, and data flow between the UI and data persistence layers.

## Design Principles

### 1. Immutable Value Types
All client models are implemented as immutable `struct` types with `let` properties, conforming to `Identifiable`, `Hashable`, and `Equatable`.

### 2. ID-Based Relationships
Instead of direct object references, models use String IDs to reference related entities. This approach:
- Prevents circular dependencies
- Simplifies serialization/deserialization
- Enables lazy loading
- Makes equality and hashing straightforward
- Supports partial data loading

### 3. Separation of Concerns
Models are organized into logical categories:
- **Core Domain Models**: Basic business entities
- **Stats Models**: Performance and statistical data
- **Ratings Models**: Player attributes for simulation

## Core Domain Models

### Player
Represents a soccer player with basic information and team association.
- Properties: `id`, `firstName`, `lastName`, `age`, `position`, `teamId`
- Relationships: Belongs to a Team (via `teamId`)

### Coach
Represents a team coach with basic information.
- Properties: `id`, `firstName`, `lastName`

### TeamInfo
Contains team identification and branding information.
- Properties: `id`, `city`, `teamName`

### Team
Represents a soccer team with its coach, info, and players.
- Properties: `id`, `coachId`, `info`, `playerIds`, `leagueId`
- Relationships: Has a Coach, belongs to a League, contains Players

### League
Represents a soccer league containing multiple teams.
- Properties: `id`, `name`, `teamIds`
- Relationships: Contains Teams

### Season
Represents a time-bound competition period within a league.
- Properties: `id`, `seasonNumber`, `year`, `isCompleted`, `leagueId`, `careerId`, `matchIds`
- Relationships: Belongs to a League and Career, contains Matches

### Career
Represents the player's career progression and game state.
- Properties: `id`, `coachId`, `userTeamId`, `currentSeasonId`, `seasonIds`
- Relationships: Has a Coach, user Team, current Season, and historical Seasons

### Match
Represents an individual soccer match between two teams.
- Properties: `id`, `date`, `seasonNumber`, `isCompleted`, `homeTeamId`, `awayTeamId`, `seasonId`
- Relationships: Between two Teams, belongs to a Season

### Contract
Represents a player-team contractual relationship.
- Properties: `id`, `startDate`, `endDate`, `salary`, `isActive`, `playerId`, `teamId`
- Relationships: Between a Player and Team

## Stats Models

### PlayerStats
Three levels of player performance statistics:
- **PlayerCareerStats**: Lifetime totals (`totalGames`, `totalGoals`)
- **PlayerSeasonStats**: Season-specific performance (`games`, `goals`)
- **PlayerMatchStats**: Individual match performance (`goals`, `minutesPlayed`)

### TeamStats
Three levels of team performance statistics:
- **TeamCareerStats**: Lifetime record (`totalGames`, `totalWins`, `totalDraws`, `totalLosses`)
- **TeamSeasonStats**: Season standings (`games`, `wins`, `draws`, `losses`, `points`)
- **TeamMatchStats**: Match performance (`goals`, `possession`, `shots`, `shotsOnTarget`)

## Ratings Models

### PlayerRatings
Player attributes used for match simulation and gameplay:
- **Core Ratings**: `overall`, `pace`, `shooting`, `passing`, `defending`, `physicality`
- **Specialized Ratings**: `finishing`, `crossing`, `tackling`, `positioning`

## Usage Patterns

### ID Resolution
When you need to work with related entities, use the DataManager to resolve IDs:

```swift
// Instead of: player.team.name
// Use: dataManager.getTeam(id: player.teamId).name
```

### Aggregate Operations
For complex operations involving multiple related entities, use Result models from the DataManager that pre-resolve relationships.

## Future Extensions

This foundation supports the planned Request/Result model architecture:
- **Request Models**: Input to DataManager operations (suffix: `Request`)
- **Result Models**: Output from DataManager operations (suffix: `Result`)
- **Transform Protocols**: Generic interfaces for SwiftData translation
