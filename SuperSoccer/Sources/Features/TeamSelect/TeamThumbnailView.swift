//
//  TeamThumbnailView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import SwiftUI

struct TeamThumbnailViewModel: Identifiable {
    var id: String { teamInfoId }
    let teamInfoId: String
    let text: String
}

struct TeamThumbnailView: View {
    let viewModel: TeamThumbnailViewModel
    
    var body: some View {
        Text(viewModel.text)
    }
}

#Preview {
    TeamThumbnailView(viewModel: .init(teamInfoId: "1", text: "San Fransisco 49ers"))
}
