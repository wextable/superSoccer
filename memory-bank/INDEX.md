# Memory Bank Index

## Core Memory Bank Files

### 📋 [Project Brief](projectbrief.md)
**Foundation document** - Defines core requirements, features, aesthetics, and technical preferences for SuperSoccer. This is the source of truth for project scope and vision.

### 🎯 [Product Context](productContext.md)
**Why this exists** - Vision, problems solved, target experience, user journey, and success metrics. Explains the product's purpose and goals.

### 🏗️ [System Patterns](systemPatterns.md)
**Architecture blueprint** - Core architectural patterns, data flow, navigation patterns, and design principles. Critical for understanding how the system works.

### 💻 [Technical Context](techContext.md)
**Technology stack** - Technologies used, project structure, development environment, and technical implementation details.

### 🔄 [Active Context](activeContext.md)
**Current work focus** - Recent changes, implementation status, next steps, active decisions, and important files to monitor. Updated frequently.

### 📊 [Progress](progress.md)
**Status tracking** - What's working, what's left to build, current status, known issues, and project evolution. Comprehensive project health view.

## Memory Bank Usage

### For New Sessions
1. **Always read ALL core files** - Memory resets completely between sessions
2. **Start with Project Brief** - Understand the foundation
3. **Review Active Context** - Understand current work focus
4. **Check Progress** - Know what's working and what needs work

### For Updates
- **Active Context**: Update when work focus changes or new decisions are made
- **Progress**: Update when features are completed or status changes
- **System Patterns**: Update when architectural patterns evolve
- **Technical Context**: Update when technology stack or structure changes

### File Hierarchy
```
projectbrief.md (Foundation)
├── productContext.md (Why)
├── systemPatterns.md (How - Architecture)
└── techContext.md (How - Technology)
    └── activeContext.md (Current State)
        └── progress.md (Status)
```

## Quick Reference

### Current Project Status
- **Architecture**: 🟢 Clean 3-layer architecture established
- **Design System**: 🟢 Complete SuperSoccer Design System with retro theming
- **Features**: 🟡 Basic career creation flow working, game features needed
- **Technical Debt**: 🟡 Manageable, some cleanup needed
- **Next Priority**: Complete tab navigation and basic league feature

### Key Architecture Principles
- **3-Layer Data**: SwiftDataStorage → DataManager → Transformers
- **Coordinator Pattern**: Feature-based navigation with result types
- **Model Separation**: Client models never cross into SwiftData layer
- **Protocol-Based**: All dependencies have protocols and mocks

### Active Development Focus
- Tab navigation system completion
- Basic league and match simulation
- Testing new data architecture
- UI retro styling implementation

### Important Files Currently
- `SuperSoccer/Sources/Navigation/TabNavigationCoordinator.swift`
- `SuperSoccer/Sources/DataManager/SwiftData/SwiftDataManager.swift`
- `SuperSoccer/Sources/DataModels/Transforms/SwiftData/ClientToSwiftDataTransformer.swift`
- `SuperSoccer/Sources/Features/InGame/InGameCoordinator.swift`

## Memory Bank Maintenance

### When to Update
- **After major architectural changes**
- **When user requests "update memory bank"**
- **When starting new features**
- **When completing milestones**
- **When making important decisions**

### Update Process
1. Review ALL memory bank files
2. Update relevant sections based on changes
3. Ensure consistency across files
4. Focus on activeContext.md and progress.md for current state
5. Update systemPatterns.md for architectural changes

### Critical Rules
- **Never assume previous knowledge** - Document everything needed for fresh start
- **Maintain file relationships** - Ensure files build upon each other logically
- **Keep current** - Active context and progress must reflect actual project state
- **Be specific** - Include file paths, code patterns, and concrete examples

This memory bank serves as the complete knowledge base for the SuperSoccer project, enabling effective work continuation after any memory reset.
