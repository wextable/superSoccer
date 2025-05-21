////
////  ContentView.swift
////  SuperSoccer
////
////  Created by Wesley on 4/4/25.
////
//
//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @StateObject private var dataManager: DataManager
//    
//    init(dataManager: DataManager) {
//        _dataManager = StateObject(wrappedValue: dataManager)
//    }
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(dataManager.teams) { team in
//                    NavigationLink {
//                        Text("Team at \(team.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(team.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteTeams)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addTeam) {
//                        Label("Add Team", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select a team")
//        }
//    }
//
//    private func addTeam() {
//        withAnimation {
//            dataManager.addNewTeam()
//        }
//    }
//
//    private func deleteTeams(offsets: IndexSet) {
//        withAnimation {
//            dataManager.deleteTeams(at: offsets)
//        }
//    }
//}
//
//#Preview {
//    let previewContainer = try! ModelContainer(
//        for: Team.self,
//        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//    )
//    let storage = SwiftDataStorage(modelContext: previewContainer.mainContext)
//    let dataManager = DataManager(storage: storage)
//    
//    // Add some sample data
//    storage.addTeam(Team(timestamp: Date()))
//    storage.addTeam(Team(timestamp: Date().addingTimeInterval(-86400))) // yesterday
//    try? previewContainer.mainContext.save()
//    
//    return ContentView(dataManager: dataManager)
//}
