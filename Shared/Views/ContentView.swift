import SwiftUI

struct ContentView: View {
	@StateObject var viewModel: PokemonViewModel = .init()

	var body: some View {
		TabView {
			NavigationView {
				ScrollView {
					ScrollView(.horizontal) {
						HStack {
							Button {
								Task {
									try await viewModel.fetchGeneration(number: 1)
								}
							} label: {
								Text("Gen 1")
							}

							Button {
								Task {
									try await viewModel.fetchGeneration(number: 2)
								}
							} label: {
								Text("Gen 2")
							}
						}
						.font(.body)
						.foregroundColor(.pink)
					}
					.padding()
					LazyVGrid(columns: [.init(), .init(), .init()]) {
						ForEach(viewModel.searchPokemonEntry.isEmpty ? viewModel.pokemons : viewModel.filteredPokemons, id: \.name) { pokemon in
							PokemonCardView(pokemon: pokemon)
						}

						Rectangle()
							.onAppear(perform: {
								Task {
									try await viewModel.fetchNext()
								}
							})
							.foregroundColor(.clear)
					}
					.padding()
				}
				.listStyle(PlainListStyle())
				.searchable(text: $viewModel.searchPokemonEntry)
				.navigationTitle("Pokedex")
			}
			.tabItem {
				Label("Pokedex", systemImage: "house")
			}
			.onAppear {
				Task {
					try await viewModel.fetchPokemon()
				}
			}

			NavigationView {
				Text("ellipsis")
			}
			.tabItem {
				Label("Items", systemImage: "key")
			}

			NavigationView {
				Text("ellipsis")
			}
			.tabItem {
				Label("Favorites", systemImage: "star")
			}

			NavigationView {
				Text("ellipsis")
			}
			.tabItem {
				Label("Settings", systemImage: "ellipsis")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
