//
//  TemplateCarousel.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 03/09/2021.
//

import SwiftUI

struct TemplateCarousel: View {
    @Binding var value: Int
    var templateGroup: TemplateGroup
    
    @State private var showingSheet = false
    @ObservedObject var appState = AppState.shared
    
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(templateGroup.title.uppercased())
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Text("See all").foregroundColor(.accentColor)
                }
                .buttonStyle(PlainButtonStyle())
                .layoutPriority(1)
            }
            
            #if targetEnvironment(macCatalyst)
                SnapCarousel_Mac(index: $value, items: templateGroup.templates) { template in
                    GeometryReader{ proxy in
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Color(.white)
                                
                                Image("\(templateGroup.prefix)\(template.id)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width)
                                    .clipped()
                            }
                            
                            if !appState.isPremium && template.isPremium {
                                PremiumLabel()
                                    .padding(5)
                            }
                        }
                        .overlay(
                            Rectangle()
                                .stroke(value == template.id ? Color.accentColor : Color.gray, lineWidth: 3)
                        )
                    }
                }
            #else
                SnapCarousel(index: $value, items: templateGroup.templates) { template in
                    GeometryReader{ proxy in
                        ZStack(alignment: .bottomTrailing) {
                            ZStack {
                                Color(.white)
                                
                                Image("\(templateGroup.prefix)\(template.id)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width)
                                    .clipped()
                            }
                            
                            if !appState.isPremium && template.isPremium {
                                PremiumLabel()
                                    .padding(5)
                            }
                        }
                        .overlay(
                            Rectangle()
                                .stroke(value == template.id ? Color.accentColor : Color.gray, lineWidth: 3)
                        )
                    }
                }
            #endif
        }
        .sheet(isPresented: $showingSheet) {
            TemplatePicker(value: $value, isPresented: $showingSheet, templateGroup: templateGroup)
        }
        .frame(height: 100)
    }
}

struct MacButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.accentColor)
    }
}


struct TemplateCarousel_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCarousel(value: .constant(0), templateGroup: TemplateStore.shared.items)
            .previewLayout(.sizeThatFits).frame(width: 320, height: 100)
    }
}

struct SnapCarousel_Mac<Content: View,T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    @Binding var index: Int
    
    
    init(spacing: CGFloat = 10, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self._index = index
        self.content = content
    }
    
    var body: some View{
        ZStack {
            GeometryReader { proxy in
                let width = proxy.size.width + spacing
                let adjustMentWidth = 0 - spacing
                let offset = (CGFloat(index) * -width) + adjustMentWidth
                
                HStack(spacing: spacing){
                    ForEach(list){item in
                        content(item)
                            .frame(width: proxy.size.width)
                    }
                }
                .padding(.horizontal,spacing)
                .offset(x: offset)
                .animation(.easeInOut, value: offset)
            }
            
            .clipped()
            .padding(.horizontal, 30)
            
            HStack(spacing: 0) {
                if index > 0 {
                    Image(systemName: "chevron.compact.left")
                        .font(.system(size: 50, weight: .ultraLight))
                        .foregroundColor(.accentColor)
                        .frame(width: 30, height: 50)
                        .gesture(
                            TapGesture().onEnded { _ in
                                index = index - 1
                            }
                        )
                }
                    
                Spacer()
                
                if index < list.count-1 {
                    Image(systemName: "chevron.compact.right")
                        .font(.system(size: 50, weight: .ultraLight))
                        .foregroundColor(.accentColor)
                        .frame(width: 30, height: 50)
                        .gesture(
                            TapGesture().onEnded { _ in
                                index = index + 1
                            }
                        )
                }
            }
        }
    }
}


struct SnapCarousel<Content: View,T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    @GestureState var offset: CGFloat = 0
    
    
    init(spacing: CGFloat = 10,trailingSpace: CGFloat = 150, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View{
        
        GeometryReader { proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing){
                ForEach(list){item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal,spacing)
            .offset(x: (CGFloat(index) * -width) + adjustMentWidth + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(index + Int(roundIndex), list.count - 1), 0)
                        
                    })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}

