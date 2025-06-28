//
//  TeamHeaderView.swift
//  SuperSoccer
//
//  Created by Wesley on 7/8/24.
//

import SwiftUI

struct TeamHeaderViewModel {
    var teamName: String = ""
    var teamLogo: String = "" // For now, we'll use team initials or a simple identifier
    var starRating: Double = 0 // Calculated from team performance
    var leagueStanding: String = "" // e.g., "3rd Place"
    var teamRecord: String = "" // e.g., "15W-3L-4D"
    var coachName: String = ""
}

struct TeamHeaderView: View {
    @Environment(\.ssTheme) private var theme
    
    let viewModel: TeamHeaderViewModel
    
    var body: some View {
        VStack(spacing: theme.spacing.large) {
            teamInfo
            statsRow
        }
        .padding(theme.spacing.large)
        .background(theme.colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.large)
                .stroke(theme.colors.primaryCyan, lineWidth: 2)
        )
    }
    
    private var teamInfo: some View {
        HStack(spacing: theme.spacing.medium) {
            teamLogo
            
            VStack(alignment: .leading, spacing: theme.spacing.small) {
                SSTitle.largeTitle(viewModel.teamName)
                    .fontWeight(.bold)
                
                starRating
                
                SSLabel.caption("Coach: \(viewModel.coachName)")
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
        }
    }
    
    private var teamLogo: some View {
        ZStack {
            Circle()
                .fill(theme.colors.primaryCyan)
                .frame(width: 60, height: 60)
            
            Text(viewModel.teamLogo)
                .font(theme.fonts.title2)
                .foregroundColor(theme.colors.background)
                .fontWeight(.bold)
        }
    }
    
    private var starRating: some View {
        HStack(spacing: theme.spacing.extraSmall) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= Int(viewModel.starRating.rounded()) ? "star.fill" : "star")
                    .foregroundColor(theme.colors.primaryYellow)
                    .font(.caption)
            }
            
            SSLabel.callout(String(format: "%.1f", viewModel.starRating))
                .foregroundColor(theme.colors.textSecondary)
        }
    }
    
    private var statsRow: some View {
        HStack {
            statCard(title: "Standing", value: viewModel.leagueStanding, color: theme.colors.primaryBlue)
            
            Spacer()
            
            statCard(title: "Record", value: viewModel.teamRecord, color: theme.colors.primaryGreen)
        }
    }
    
    private func statCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: theme.spacing.extraSmall) {
            SSLabel.caption(title.uppercased())
                .foregroundColor(theme.colors.textSecondary)
            
            SSLabel.subheadline(value)
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
        .padding(theme.spacing.small)
        .background(theme.colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .stroke(color, lineWidth: 1)
        )
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamHeaderViewModel {
    static func make(
        teamName: String = "Mock Team",
        teamLogo: String = "MT",
        starRating: Double = 4.2,
        leagueStanding: String = "3rd Place",
        teamRecord: String = "15W-3L-4D",
        coachName: String = "John Smith"
    ) -> TeamHeaderViewModel {
        TeamHeaderViewModel(
            teamName: teamName,
            teamLogo: teamLogo,
            starRating: starRating,
            leagueStanding: leagueStanding,
            teamRecord: teamRecord,
            coachName: coachName
        )
    }
}

struct TeamHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SSThemeProvider {
            TeamHeaderView(viewModel: .make())
                .padding()
        }
    }
}
#endif 
