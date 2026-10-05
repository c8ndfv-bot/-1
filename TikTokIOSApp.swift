import SwiftUI

@main
struct TikTokIOSApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            VideoFeedView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
                .tag(1)

            Text("Upload Video")
                .tabItem {
                    Label("Post", systemImage: "plus.app.fill")
                }
                .tag(2)

            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "message.fill")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

struct DiscoverView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Text("Discover / Search Feed")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .navigationTitle("Discover")
        }
    }
}

struct InboxView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Text("Inbox / Messages")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .navigationTitle("Inbox")
        }
    }
}
