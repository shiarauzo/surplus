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
    @State private var showsOnboarding = RootView.shouldShowOnboarding

    var body: some View {
        ZStack {
            if showsOnboarding {
                OnboardingView(onFinish: finishOnboarding)
            } else {
                PagerView()
            }
            if showsSplash {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.2), value: showsOnboarding)
        .task {
            if ProcessInfo.processInfo.arguments.contains("--hold-splash") {
                return
            }
            try? await Task.sleep(for: .milliseconds(1400))
            withAnimation(.easeOut(duration: 0.25)) {
                showsSplash = false
            }
        }
    }

    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "didSeeOnboarding")
        showsOnboarding = false
    }

    private static var shouldShowOnboarding: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("--skip-onboarding") {
            return false
        }
        if arguments.contains("--show-onboarding") {
            return true
        }
        return !UserDefaults.standard.bool(forKey: "didSeeOnboarding")
    }
}

struct OnboardingView: View {
    let onFinish: () -> Void
    @State private var page = 0

    var body: some View {
        ZStack {
            if page == 0 {
                VStack(spacing: 10) {
                    mark
                    Text("Food you already know.")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    nextButton("Next", identifier: "next") {
                        page = 1
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
            } else {
                VStack(spacing: 8) {
                    Text("Swipe left to pass.")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text("Swipe right to take it.")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    nextButton("Start", identifier: "start", action: onFinish)
                        .padding(.top, 8)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
        .animation(.easeOut(duration: 0.2), value: page)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }

    private func nextButton(_ title: String, identifier: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(Theme.blue, in: Capsule())
        }
        .buttonStyle(PressedScale())
        .accessibilityIdentifier(identifier)
        .padding(.horizontal, 16)
    }

    private var mark: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 64, height: 64)
            Image("Carrito")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
        }
    }
}

struct SplashView: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 76, height: 76)
                Image("Carrito")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52, height: 52)
            }
            Text("Surplus")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Surplus")
    }
}
