# SwiftData Models Implementation

## Overview
This directory contains all SwiftData models for the SuperSoccer game, designed to support a comprehensive soccer management simulation with detailed statistics tracking across multiple seasons.

## Model Architecture

### Core Game Management
- **SDCareer**: Root entity representing a "game save" - contains coach, user team, current season, and historical seasons
- **SDCurrentSeason**: The active season with ongoing matches and stats
- **SDSeason**: Completed seasons stored for historical reference
- **SDLeague**: Container for teams and seasons

### Teams and Players
- **SDTeam**: Team entity with relationships to players, contracts, and stats
- **SDPlayer**: Player entity with age, position, and comprehensive stats tracking
- **SDContract**: Player contracts with salary, duration, and status
- **SDCoach**: Coach entity (existing, minimal changes)
- **SDTeamInfo**: Team identity information (existing, no changes)

### Match System
- **SDMatch**: Individual games between teams with date, completion status, and stats

### Statistics (Three-Tier System)
#### Player Stats
- **SDPlayerCareerStats**: All-time career totals for each player
- **SDPlayerSeasonStats**: Season-by-season performance
- **SDPlayerMatchStats**: Individual match performance

#### Team Stats
- **SDTeamCareerStats**: All-time team performance
- **SDTeamSeasonStats**: Season standings and performance
- **SDTeamMatchStats**: Team performance in individual matches

## Key Design Decisions

### 1. Temporal Separation
Stats are organized in three tiers (match → season → career) for optimal query performance:
- **Match Level**: Individual game data
- **Season Level**: Aggregated seasonal performance
- **Career Level**: All-time totals

### 2. Relationship Management
- Used `@Relationship(inverse:)` for bidirectional relationships
- Removed redundant ID fields in favor of direct relationships
- Proper optionality to handle creation order and business logic

### 3. User Team Handling
- User team is stored as a direct relationship in `SDCareer`
- Same team entity exists in both `career.userTeam` and `league.teams`
- Access league via `career.currentSeason.league` (preferred) or `career.userTeam.league`

## Creation Flow
To avoid circular dependencies, follow this order:

1. Create base entities: `SDCoach`, `SDTeamInfo`, `SDPlayer` (no relationships)
2. Create `SDTeam` (with coach, info, players)
3. Create `SDLeague` (with teams)
4. Set `team.league` back-references
5. Create `SDCurrentSeason` (with league)
6. Create `SDCareer` (with coach, userTeam, currentSeason)
7. Set `currentSeason.career` back-reference
8. Create stats entities and set relationships

## Model Relationships Summary

```
SDCareer (1) ←→ (1) SDCoach
SDCareer (1) ←→ (1) SDTeam [userTeam]
SDCareer (1) ←→ (1) SDCurrentSeason
SDCareer (1) ←→ (*) SDSeason [historical]

SDLeague (1) ←→ (*) SDTeam
SDLeague (1) ←→ (*) SDCurrentSeason
SDLeague (1) ←→ (*) SDSeason

SDTeam (1) ←→ (*) SDPlayer
SDTeam (1) ←→ (*) SDContract
SDTeam (1) ←→ (0..1) SDTeamCareerStats
SDTeam (1) ←→ (*) SDTeamSeasonStats
SDTeam (1) ←→ (*) SDTeamMatchStats

SDPlayer (1) ←→ (*) SDContract
SDPlayer (1) ←→ (0..1) SDPlayerCareerStats
SDPlayer (1) ←→ (*) SDPlayerSeasonStats
SDPlayer (1) ←→ (*) SDPlayerMatchStats

SDMatch (1) ←→ (*) SDPlayerMatchStats
SDMatch (1) ←→ (*) SDTeamMatchStats
SDMatch (*) ←→ (1) SDSeason
```

## Next Steps

1. **Build and Test**: Compile the project to ensure all relationships work correctly
2. **Add Attributes**: Expand each model with specific attributes as needed
3. **Domain Model Mapping**: Create transforms between SwiftData models and domain models
4. **Data Seeding**: Create initial data for testing
5. **Query Optimization**: Add indexes and optimize relationship queries as needed

## Notes

- All models include `#if DEBUG` make functions for testing
- The macro errors in VSCode are expected and will resolve when built in Xcode
- Models follow your existing naming and structure conventions
- Ready for expansion with additional attributes as your game requirements evolve

## Creation Sequence (to avoid circular dependencies):
1. Create base entities: SDCoach, SDTeamInfo, SDPlayer (no relationships)
2. Create SDTeam (with coach, info, players)
3. Create SDLeague (with teams)
4. Set team.league back-references
5. Create SDCurrentSeason (with league)
6. Create SDCareer (with coach, userTeam, currentSeason)
7. Set currentSeason.career back-reference
8. Create stats entities and set relationships
