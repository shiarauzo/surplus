import SwiftUI

@main
struct CercaApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    @State private var showsSplash = true

    var body: some View {
        ZStack {
            PagerView()
                .accessibilityHidden(showsSplash)
            if showsSplash {
                SplashView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1400))
            withAnimation(.easeOut(duration: 0.25)) {
                showsSplash = false
            }
        }
    }
}

struct SplashView: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Theme.blue, lineWidth: 4)
                    .frame(width: 56, height: 56)
                Circle()
                    .fill(Color.white)
                    .frame(width: 18, height: 18)
            }
            Text("Cerca")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Cerca")
    }
}
