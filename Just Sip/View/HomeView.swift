import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = WaterViewModel()
    @State private var showQuickAdd = false
    @State private var showHistory = false
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \WaterEntry.date)
    private var entries: [WaterEntry]
    var body: some View {
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: Top Bar
                HStack {
                    
                    Button {
                        print("Profile tapped")
                    } label: {
                        Image(systemName: "person")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.indigo)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 8,
                                y: 3
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Notification tapped")
                    } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.indigo)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 8,
                                y: 3
                            )
                    }
                }
                .padding(.horizontal, 20)
                
                // MARK: Water Amount
                VStack(spacing: 4) {
                    
                    Text("\(viewModel.waterConsumed) ml")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.indigo)
                    
                    Text("of \(viewModel.dailyGoal) ml Goal")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)
                
                Spacer(minLength: 10)
                
                // MARK: Bottle
                WaterBottleView(
                    waterProgress: CGFloat(viewModel.progress)
                )
                .frame(height: 420)
                .padding(.top, 56)
                Spacer(minLength: 5)
                
                // MARK: Add Button
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)){
                        showQuickAdd = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.indigo)
                        .frame(width: 70, height: 70)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.12),
                            radius: 10,
                            y: 5
                        )
                }
                
                Spacer(minLength: 5)
                
                // MARK: Bottom Navigation
                HStack {
                    
                    bottomButton(
                        icon: "drop",
                        title: "Water"
                    )
                    
                    Spacer()
                    
                    Button{
                        showHistory = true
                    } label: {
                        VStack(spacing: 4){
                            Image(systemName: "chart.bar")
                                .font(.system(size: 20))
                            
                            Text("history")
                                .font(.caption2)
                        }
                        .foregroundStyle(.indigo)
                    }
                    
                    Spacer()
                    
                    bottomButton(
                        icon: "gearshape",
                        title: "Settings"
                    )
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            }
        }
        .task{
            viewModel.loadTodayWater(
                context: modelContext
            )
        }.onAppear {
            viewModel.loadToday(from: entries)
        }
        .sheet(isPresented: $showQuickAdd) {
            QuickAddView { amount in
                withAnimation(.easeInOut(duration: 0.8)) {
                    viewModel.addWater(
                        amount,
                        context: modelContext)
                }
            } .presentationDetents([.height(330)])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showHistory){
            HistoryView()
        }
    }
    //Bottom Naviagetion
    
    private func bottomButton(icon: String, title: String) -> some View {
        Button{
            print("\(title)tapped")
        } label: {
            VStack(spacing: 4) {
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.caption2)
            }
            .foregroundStyle(.indigo)
        }
    }
    }
#Preview {
    HomeView()
}
