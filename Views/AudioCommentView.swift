import SwiftUI
import AVFoundation

struct AudioCommentView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isRecording = false
    @State private var recordedAudioURL: URL?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false

    // Sample comments including audio comments
    @State var comments = [
        CommentItem(username: "ahmed_dev", text: "Amazing video! 🔥", isAudio: false, audioDuration: 0),
        CommentItem(username: "sarah_ios", text: "Check out this voice note 🎤", isAudio: true, audioDuration: 4.5),
        CommentItem(username: "mohamed_swift", text: "Very smooth playback!", isAudio: false, audioDuration: 0)
    ]

    @State private var newTextComment = ""

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Comments (\(comments.count))")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                .padding()

                Divider()

                // Comments List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(comments) { comment in
                            HStack(alignment: .top, spacing: 12) {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    )

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(comment.username)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.gray)

                                    if comment.isAudio {
                                        // Audio Comment Player Bubble
                                        HStack(spacing: 12) {
                                            Button(action: {
                                                togglePlayAudio(comment: comment)
                                            }) {
                                                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(.red)
                                            }

                                            // Waveform simulation
                                            HStack(spacing: 3) {
                                                ForEach(0..<15, id: \.self) { _ in
                                                    Capsule()
                                                        .fill(Color.red)
                                                        .frame(width: 3, height: CGFloat.random(in: 10...30))
                                                }
                                            }

                                            Text(String(format: "%.1fs", comment.audioDuration))
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                    } else {
                                        Text(comment.text)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }

                Divider()

                // Bottom Input Area (Text & Voice Recording)
                HStack(spacing: 12) {
                    TextField("Add a comment...", text: $newTextComment)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    // Voice Note Record Button
                    Button(action: {
                        isRecording.toggle()
                        if !isRecording {
                            // Simulate recording finished and added as audio comment
                            let newAudioComment = CommentItem(
                                username: "you_ios",
                                text: "",
                                isAudio: true,
                                audioDuration: 3.2
                            )
                            comments.append(newAudioComment)
                        }
                    }) {
                        Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(isRecording ? .red : .blue)
                    }

                    if !newTextComment.isEmpty {
                        Button(action: {
                            let comment = CommentItem(username: "you_ios", text: newTextComment, isAudio: false, audioDuration: 0)
                            comments.append(comment)
                            newTextComment = ""
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
        }
    }

    private func togglePlayAudio(comment: CommentItem) {
        isPlaying.toggle()
        // Audio playback simulation logic
    }
}

struct CommentItem: Identifiable {
    let id = UUID()
    let username: String
    let text: String
    let isAudio: Bool
    let audioDuration: Double
}
