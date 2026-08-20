import SwiftUI

struct SplashView: View {

    // MARK: - Animation State

    @State private var logoVisible = false
    @State private var logoScale: CGFloat = 0.65
    @State private var textVisible = false
    @State private var floating = false
    @State private var disappearing = false

    // MARK: - Completion

    var onFinished: () -> Void

    // MARK: - Body

    var body: some View {

        ZStack {

            // MARK: - Background

            Color(.systemBackground)
                .ignoresSafeArea()

            // MARK: - Main Content

            VStack(spacing: 22) {

                // Logo

                Image("withoutbg")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 190,
                        height: 190
                    )
                    .scaleEffect(logoScale)
                    .opacity(
                        logoVisible ? 1 : 0
                    )
                    .offset(
                        y: floating ? -6 : 6
                    )

                // App Name

                VStack(spacing: 7) {

                    Text("Just Sip")
                        .font(
                            .system(
                                size: 34,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.indigo)

                    Text("Stay hydrated. Stay healthy.")
                        .font(
                            .system(
                                size: 15,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.secondary)
                }
                .opacity(
                    textVisible ? 1 : 0
                )
                .offset(
                    y: textVisible ? 0 : 12
                )
            }
            .scaleEffect(
                disappearing ? 0.96 : 1
            )
            .opacity(
                disappearing ? 0 : 1
            )

            // MARK: - Crafted By

            VStack {
                Spacer()

                Text("Crafted by")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                Text("Adarsh Kashyap")
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.primary)
            }
            .padding(.bottom, 40)
            .opacity(
                disappearing ? 0 : 1
            )
        }

        // MARK: - Animation

        .onAppear {

            // Logo entrance

            withAnimation(
                .spring(
                    response: 0.7,
                    dampingFraction: 0.72
                )
            ) {
                logoVisible = true
                logoScale = 1.0
            }

            // Text entrance

            withAnimation(
                .easeOut(duration: 0.6)
                    .delay(0.35)
            ) {
                textVisible = true
            }

            // Gentle floating animation

            withAnimation(
                .easeInOut(duration: 1.4)
                    .repeatForever(
                        autoreverses: true
                    )
            ) {
                floating = true
            }

            // MARK: - Finish Splash

            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.5
            ) {

                withAnimation(
                    .easeInOut(duration: 0.45)
                ) {
                    disappearing = true
                }

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.45
                ) {
                    onFinished()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {

    SplashView {

        print("Splash finished")

    }
}
