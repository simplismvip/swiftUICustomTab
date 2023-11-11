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
    @State var selItem: String = ""
    @State var selectTab: Tab = .all
    @State var isBottomTabShow: Bool = true
    @State var isViewShow: Bool = false
    
    @Environment(\.colorScheme) private var scheme
    @Namespace var nspace
    
    var body: some View {
        ZStack {
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
                            customtabBar(tab: type.name, color: .purple)
                        case .share:
                            customtabBar(tab: type.name, color: .red)
                        case .header:
                            customtabBar(tab: type.name, color: .green)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea(.all)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(.gray.opacity(0.1))
            .overlay(alignment: .bottom) {
                TabBarView()
                    .offset(y: isBottomTabShow ? 0 : 100)
                    .opacity(isBottomTabShow ? 1 : 0)
                    .animation(.default, value: isBottomTabShow)
            }
            
            if isViewShow {
                Rectangle()
                    .fill(.red)
                    .ignoresSafeArea(.all)
                    .matchedGeometryEffect(id: selItem, in: nspace)
                    .onTapGesture {
                        withAnimation {
                            isViewShow.toggle()
                            isBottomTabShow = true
                        }
                    }
            }
        }
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
    func customtabBar(tab: String, color: Color) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...20, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .matchedGeometryEffect(id: "rect_\(tab)_\(index)", in: nspace)
                        .onTapGesture {
                            withAnimation(.default) {
                                self.selItem = "rect_\(tab)_\(index)"
                                self.isBottomTabShow = false
                                self.isViewShow.toggle()
                            }
                        }
                        .overlay(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 50)
                                Rectangle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 100,height: 10)
                                
                                Rectangle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 80,height: 10)
                                Rectangle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 60,height: 10)
                            }
                            .padding(.leading)
                        }
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

struct TabBarView: View {
    @State var selTab = 1
    
    var body: some View {
        HStack {
            ForEach(1...4, id: \.self) { item in
                Button {
                    selTab = item
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "heart")
                            .font(.title3.weight(.medium))
                        Text("HA\(item)")
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .symbolVariant(selTab == item ? .fill : .none)
                    .foregroundStyle(selTab == item ? .red : .secondary)
                    .scaleEffect(CGSize(width: selTab == item ? 1.2 : 1.0, height: selTab == item ? 1.2 : 1.0))
                }
            }
        }
        .frame(height: 72)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 28)
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
