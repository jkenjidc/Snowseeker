//
//  ContentView.swift
//  Snowseeker
//
//  Created by Kenji Dela Cruz on 8/28/24.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    enum FilterType {
        case defaultFilter
        case alphabeticalFilter
        case countryFilter
        
    }
    @State private var filter = FilterType.countryFilter
    @State private var searchText = ""
    @State private var favorites = Favorites()
    var filteredResorts:[Resort] {
        if searchText.isEmpty {
            resorts
        } else {
            resorts.filter { $0.name.localizedStandardContains(searchText)}
        }
    }
    func sortedResorts(lhs: Resort, rhs: Resort) -> Bool {
        switch filter {
        case .defaultFilter:
            return lhs.elevation < rhs.elevation
        case .alphabeticalFilter:
            return lhs.name < rhs.name
        case .countryFilter:
            return lhs.country < rhs.country
        }
    }
    var body: some View {
        NavigationSplitView {
            List(filteredResorts.sorted(by: sortedResorts)) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)}
            .searchable(text: $searchText, prompt: "Search Resorts")
            .toolbar {
                ToolbarItem {
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $filter) {
                            Text("Sort by Default")
                                .tag(FilterType.defaultFilter)
                            Text("Sort by Name")
                                .tag(FilterType.alphabeticalFilter)
                            Text("Sort by Country")
                                .tag(FilterType.countryFilter)
                        }
                    }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)

    }
}

#Preview {
    ContentView()
}
