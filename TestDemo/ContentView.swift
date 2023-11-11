//
//  ContentView.swift
//  TestDemo
//
//  Created by JunMing on 2023/11/11.
//

import SwiftUI

enum Tab: CaseIterable {
    case all, share, header
    
    var sysImage: String {
        switch self {
        case .all:
            return "figure.american.football"
        case .share:
            return "figure.bowling"
        case .header:
            return "figure.badminton"
        }
    }
    
    var name: String {
        switch self {
        case .all:
            return "足球"
        case .share:
            return "篮球"
        case .header:
            return "跑步"
        }
    }
    
    var value: CGFloat {
        switch self {
        case .all:
            return 0
        case .share:
            return 0.5
        case .header:
            return 1
        }
    }
}

struct ContentView: View {
    @State var selectTab: Tab = .all
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "line.3.horizontal.decrease")
                    .imageScale(.medium)
                    .foregroundStyle(.black)
                    .font(.title3.weight(.medium))
                
                Text("Message")
                    .font(.title2.weight(.bold))
                    .frame(maxWidth: .infinity)
                
                Image(systemName: "bell.badge")
                    .imageScale(.medium)
                    .foregroundStyle(.black)
                    .font(.title3.weight(.medium))
                    .symbolVariant(.fill)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            customtabBar()
            
            TabView(selection: $selectTab) {
                ForEach(Tab.allCases, id: \.self) { type in
                    switch type {
                    case .all:
                        customtabBar(color: .purple)
                    case .share:
                        customtabBar(color: .red)
                    case .header:
                        customtabBar(color: .green)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    @ViewBuilder
    func customtabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                HStack {
                    Image(systemName: tab.sysImage)
                    Text(tab.name)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        self.selectTab = tab
                    }
                }
            }
        }
        .tabmask(self.$selectTab)
        .background(content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: self.selectTab.value * (size.width - capsuleWidth))
                    .animation(.easeInOut, value: self.selectTab)
            })
        })
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func customtabBar(color: Color) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...20, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                }
            })
            .padding(15)
            .coordinateSpace(name: "tabscroll")
            .offsetY { value in
                print(value)
            }
        }
    }
}

#Preview {
    ContentView()
}
