import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment = 0

    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Banner / Header Image
                        ZStack(alignment: .bottomLeading) {
                            Rectangle()
                                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 160)
                                .overlay(
                                    Button(action: {
                                        // Action to change banner image
                                    }) {
                                        HStack {
                                            Image(systemName: "camera.fill")
                                            Text("Edit Banner")
                                        }
                                        .font(.caption)
                                        .padding(6)
                                        .background(Color.black.opacity(0.5))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    }
                                    .padding(12),
                                    alignment: .topTrailing
                                )

                            // Avatar overlapping banner
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 90, height: 90)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.white)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 4)
                                )
                                .offset(x: 16, y: 45)
                        }

                        VStack(spacing: 16) {
                            // Spacer for avatar offset
                            Spacer().frame(height: 35)

                            // Username
                            HStack {
                                Text("@tiktok_ios_user")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                            }

                            // Stats (Following, Followers, Likes)
                            HStack(spacing: 32) {
                                VStack {
                                    Text("142")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Following")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                VStack {
                                    Text("12.4K")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Followers")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                VStack {
                                    Text("84.9K")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Likes")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            // Edit Profile Button
                            Button(action: {}) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 160, height: 36)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(4)
                            }

                            // Bio
                            Text("Creating awesome TikTok iOS experiences 📱✨ | Custom Banner & Voice Comments Supported!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Divider()
                                .background(Color.gray)

                            // Grid of Videos
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(0..<12, id: \.self) { index in
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.4))
                                        .aspectRatio(3/4, contentMode: .fit)
                                        .overlay(
                                            VStack {
                                                Spacer()
                                                HStack {
                                                    Image(systemName: "play.fill")
                                                    Text("\(Int.random(in: 100...9999))")
                                                }
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .padding(4)
                                            },
                                            alignment: .bottomLeading
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("@tiktok_ios_user")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
