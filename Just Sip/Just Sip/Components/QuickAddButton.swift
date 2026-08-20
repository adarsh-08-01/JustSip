import SwiftUI

struct QuickAddView: View {

    let onAdd: (Int) -> Void

    @Environment(\.dismiss)
    private var dismiss

    private let amounts = [150, 250, 500, 750]

    var body: some View {
        VStack(spacing: 24) {

            // MARK: - Header

            VStack(spacing: 6) {

                Text("Add Water")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("How much did you drink?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // MARK: - Quick Add Buttons

            HStack(spacing: 12) {

                ForEach(amounts, id: \.self) { amount in

                    Button {

                        onAdd(amount)
                        dismiss()

                    } label: {

                        VStack(spacing: 8) {

                            Image(systemName: "drop.fill")
                                .font(.system(size: 22))

                            Text("\(amount)")
                                .font(.headline)

                            Text("ml")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .foregroundStyle(.indigo)
                        .frame(maxWidth: .infinity)
                        .frame(height: 95)
                        .background(
                            Color.indigo.opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

// MARK: - Preview

#Preview {
    QuickAddView { amount in
        print("Added \(amount) ml")
    }
}
