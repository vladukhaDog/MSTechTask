import SwiftUI


struct OnboardingView: View {
    @State private var selectedTab = 0
    @State private var viewedTabs: Set<Int> = [0] // mark first as viewed by default

    // Computed condition for enabling the Continue button
    private var canContinue: Bool {
        viewedTabs.count == 2
    }

    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                onboardingFirstTab
                    .tag(0)
                onboardingSecondTab
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .onChange(of: selectedTab) { oldValue, newValue in
                viewedTabs.insert(newValue)
            }
            Button {
                // Can be moved to a ViewModel in the future, especially if any new logic is needed for the view
                UserDefaultsService.shared.setOnboardingShown(true)
                AppFlowEventPoster.post(.onboardingCompleted)
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canContinue ? Color.accentColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            .disabled(!canContinue)
        }
        .padding(.vertical)
    }

    private var onboardingFirstTab: some View {
        VStack(spacing: 24) {
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.accentColor)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque euismod, urna eu tincidunt consectetur, nisi nisl aliquam.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }

    private var onboardingSecondTab: some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent viverra, enim sit amet aliquam laoreet, sed.")
            .multilineTextAlignment(.center)
            .padding()
    }
}

#Preview {
    OnboardingView()
}
