import SwiftUI
import AVKit
import Photos

struct VideoFeedView: View {
    @State private var currentVideoIndex = 0

    // Sample video URLs for demonstration
    let sampleVideos = [
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4"
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Vertical Paging ScrollView (TikTok style smooth feed)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<sampleVideos.count, id: \.self) { index in
                        VideoPlayerCell(videoURL: sampleVideos[index])
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .id(index)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
        }
    }
}

struct VideoPlayerCell: View {
    let videoURL: String
    @State private var player: AVPlayer?
    @State private var isLiked = false
    @State private var likeCount = 1240
    @State private var showComments = false
    @State private var showDownloadAlert = false
    @State private var downloadStatus = ""

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .disabled(true)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        player.actionAtItemEnd = .none
                        NotificationCenter.default.addObserver(
                            forName: .AVPlayerItemDidPlayToEndTime,
                            object: player.currentItem,
                            queue: .main
                        ) { _ in
                            player.seek(to: .zero)
                            player.play()
                        }
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                Color.gray.opacity(0.3)
                    .onAppear {
                        if let url = URL(string: videoURL) {
                            player = AVPlayer(url: url)
                        }
                    }
            }

            // Overlay UI elements (Caption, User Info, Actions)
            VStack {
                Spacer()

                HStack(alignment: .bottom) {
                    // Left side: User details & caption
                    VStack(alignment: .leading, spacing: 8) {
                        Text("@tiktok_user_ios")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Smooth playback + Watermark-free download enabled! 🚀 #tiktok #ios")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        HStack {
                            Image(systemName: "music.note")
                            Text("Original Sound - TikTok You iOS")
                        }
                        .font(.caption)
                        .foregroundColor(.white)
                    }
                    .padding(.leading, 16)

                    Spacer()

                    // Right side: Interaction buttons (Like, Comment, Download, Share)
                    VStack(spacing: 20) {
                        // Profile Avatar
                        ZStack(alignment: .bottom) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 48, height: 48)
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                            Circle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width: 48, height: 48)
                        }

                        // Like Button
                        Button(action: {
                            isLiked.toggle()
                            likeCount += isLiked ? 1 : -1
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 32))
                                    .foregroundColor(isLiked ? .red : .white)
                                Text("\(likeCount)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }

                        // Comment Button (Opens Audio Comments Sheet)
                        Button(action: {
                            showComments.toggle()
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "text.bubble.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                Text("342")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .sheet(isPresented: $showComments) {
                            AudioCommentView()
                                .presentationDetents([.medium, .large])
                        }

                        // Download Without Watermark Button
                        Button(action: {
                            downloadVideoWithoutWatermark()
                        }) {
                            VStack(spacing: 4) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("Save")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                        .alert(isPresented: $showDownloadAlert) {
                            Alert(title: Text("Download"), message: Text(downloadStatus), dismissButton: .default(Text("OK")))
                        }

                        // Share Button
                        VStack(spacing: 4) {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            Text("Share")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 80)
            }
        }
    }

    // Function to download video without watermark (saves clean stream to Photos)
    private func downloadVideoWithoutWatermark() {
        guard let url = URL(string: videoURL) else { return }
        downloadStatus = "Downloading video without watermark..."
        showDownloadAlert = true

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("clean_tiktok_video.mp4")
                try? data.write(to: tempURL)

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: tempURL)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            downloadStatus = "Video saved successfully to Photos without watermark! ✅"
                        } else {
                            downloadStatus = "Failed to save: \(error?.localizedDescription ?? "Unknown error")"
                        }
                        showDownloadAlert = true
                    }
                }
            }
        }
    }
}
