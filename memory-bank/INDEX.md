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

### 🔧 [Implementation Lessons](implementation-lessons.md)
**Technical knowledge** - Specific fixes, implementation details, code patterns, and critical technical lessons learned during development. Essential for avoiding repeated mistakes.

## Memory Bank Usage

### For New Sessions
1. **Always read ALL core files** - Memory resets completely between sessions
2. **Start with INDEX.md** - Quick overview and reference
3. **Read Project Brief** - Understand the foundation
4. **Review Active Context** - Understand current work focus
5. **Check Progress** - Know what's working and what needs work
6. **Review Implementation Lessons** - Learn from specific technical solutions

### For Updates
- **Active Context**: Update when work focus changes or new decisions are made
- **Progress**: Update when features are completed or status changes
- **System Patterns**: Update when architectural patterns evolve
- **Technical Context**: Update when technology stack or structure changes
- **Implementation Lessons**: Update when discovering critical fixes or patterns

## Enhanced Reference Files

### 🚀 [Quick Reference](quickReference.md)
**Practical templates** - Copy-paste ready code templates, patterns, and common snippets for rapid development. Includes feature creation templates, testing patterns, and UI component usage.

### 🔧 [Troubleshooting](troubleshooting.md)
**Common issues & solutions** - Build errors, navigation issues, testing problems, theme issues, and architecture violations with concrete solutions.

### 🗺️ [Codebase Map](codebase-map.md)
**Navigation guide** - File locations, entry points, dependency flows, and where to find/modify specific functionality. Essential for understanding project structure.

### File Hierarchy
```
projectbrief.md (Foundation)
├── productContext.md (Why)
├── systemPatterns.md (How - Architecture)
└── techContext.md (How - Technology)
    └── activeContext.md (Current State)
        ├── progress.md (Status)
        └── implementation-lessons.md (Technical Knowledge)
```

## Quick Reference

### Current Project Status
- **Architecture**: 🟢 Clean 3-layer architecture established
- **Design System**: 🟢 Complete SuperSoccer Design System with retro theming
- **Navigation**: 🟢 Complete tab navigation system with InGame coordinator
- **Features**: 🟡 Basic career creation flow working, game features needed
- **Testing**: 🟡 In progress - comprehensive unit testing focus
- **Technical Debt**: 🟢 Minimal - clean architecture ready for testing
- **Next Priority**: Complete unit testing coverage for all source code files

### Key Architecture Principles
- **3-Layer Data**: SwiftDataStorage → DataManager → Transformers
- **Coordinator Pattern**: Feature-based navigation with result types
- **Model Separation**: Client models never cross into SwiftData layer
- **Protocol-Based**: All dependencies have protocols and mocks
- **Tab Navigation**: Centralized tab management with coordinator integration

### Active Development Focus
- Comprehensive unit testing for all source code files with testable logic
- Data layer testing (transformers, data managers, storage)
- Navigation testing (coordinators, routers, navigation flows)
- Feature testing (interactors, view models, business logic)
- Design system testing (theme components and styling)
- Integration testing (complete feature flows)

### Important Files Currently
- `SuperSoccer/Sources/Navigation/TabNavigationCoordinator.swift` ✅ Complete
- `SuperSoccer/Sources/Features/InGame/InGameCoordinator.swift` ✅ Complete
- `SuperSoccer/Sources/DataManager/SwiftData/SwiftDataManager.swift` ✅ Complete
- `SuperSoccer/Sources/DataModels/Transforms/SwiftData/ClientToSwiftDataTransformer.swift` ✅ Complete
- `SuperSoccer/Sources/DataModels/Transforms/SwiftData/SwiftDataToClientTransformer.swift` ✅ Complete
- `SuperSoccerTests/` - All test directories for comprehensive testing

## Memory Bank Maintenance

### When to Update
- **After major architectural changes**
- **When user requests "update memory bank"**
- **When starting new features**
- **When completing milestones**
- **When making important decisions**
- **When discovering critical technical solutions**

### Update Process
1. Review ALL memory bank files
2. Update relevant sections based on changes
3. Ensure consistency across files
4. Focus on activeContext.md and progress.md for current state
5. Update systemPatterns.md for architectural changes
6. Update implementation-lessons.md for technical discoveries

### Critical Rules
- **Never assume previous knowledge** - Document everything needed for fresh start
- **Maintain file relationships** - Ensure files build upon each other logically
- **Keep current** - Active context and progress must reflect actual project state
- **Be specific** - Include file paths, code patterns, and concrete examples
- **Capture technical lessons** - Document specific fixes and implementation details

This memory bank serves as the complete knowledge base for the SuperSoccer project, enabling effective work continuation after any memory reset.
