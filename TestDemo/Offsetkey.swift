//
//  Offsetkey.swift
//  TestDemo
//
//  Created by JunMing on 2023/11/11.
//

import Foundation
import SwiftUI

struct Offsetkey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader(content: { geometry in
                if #available(iOS 17, *) {
                    let minx = geometry.frame(in: .scrollView(axis: .horizontal)).minX
                    Color.clear
                        .preference(key: Offsetkey.self, value: minx)
                        .onPreferenceChange(Offsetkey.self, perform: completion)
                } else {
                    let minx = geometry.frame(in: .named("tabscroll")).minX
                    Color.clear
                        .preference(key: Offsetkey.self, value: minx)
                        .onPreferenceChange(Offsetkey.self, perform: completion)
                }
            })
        }
    }
    
    @ViewBuilder
    func offsetY(completion: @escaping (CGFloat) -> ()) -> some View {
        self.overlay {
            GeometryReader(content: { geometry in
                if #available(iOS 17, *) {
                    let minx = geometry.frame(in: .scrollView(axis: .horizontal)).minY
                    Color.clear
                        .preference(key: Offsetkey.self, value: minx)
                        .onPreferenceChange(Offsetkey.self, perform: completion)
                } else {
                    let minx = geometry.frame(in: .named("tabscroll")).minY
                    Color.clear
                        .preference(key: Offsetkey.self, value: minx)
                        .onPreferenceChange(Offsetkey.self, perform: completion)
                }
            })
        }
    }
    
    @ViewBuilder
    func tabmask(_ selectTab: Binding<Tab>) -> some View {
        self.modifier(MaskModifer(selectTab: selectTab))
    }
}

struct MaskModifer: ViewModifier {
    @Binding var selectTab: Tab
    
    func body(content: Content) -> some View {
        ZStack(content: {
            content.foregroundStyle(.gray)
            content.symbolVariant(.fill)
                .mask {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: selectTab.value * (size.width - capsuleWidth))
                            .animation(.easeInOut, value: selectTab)
                    })
                }
        })
    }
}
