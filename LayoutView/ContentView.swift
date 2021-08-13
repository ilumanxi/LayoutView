//
//  ContentView.swift
//  LayoutView
//
//  Created by 风起兮 on 2021/8/13.
//
// The SwiftUI Lab
// Website: https://swiftui-lab.com
// Article: https://swiftui-lab.com/alignment-guides

import SwiftUI


struct ContentView: View {
    
    @State private var width: CGFloat  = 100
    
    let containerInWidths: [CGFloat] = [100, 200, 250, 350]
    
    let texts: [String] = ["推荐", "要闻", "视频", "抗疫", "北京", "新时代", "娱乐", "体育", "军事", "NBA", "科技", "财经", "时尚"]
    
    var body: some View {
        Spacer()
        LayoutView(width: width, texts: texts)
        Spacer()
        HStack {
            Text("容器宽度：")
            ForEach(containerInWidths, id: \.self) { w in
                Button {
                    withAnimation(.easeInOut) {
                        width = w
                    }
                } label: {
                    Text("\(Int(w))")
                }
                
            }
        }
    }
}

struct LayoutView: View {
    
    let width: CGFloat
    var texts: [String]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            var offsetX: CGFloat = 0
            var offsetY: CGFloat = 0
            ForEach(texts.indices, id: \.self) { index in
                item(for: texts[index])
                    .padding([.trailing, .bottom], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        
                        if (abs(offsetX - d.width) > width) {
                            offsetX = 0
                            offsetY -= d.height
                        }
                        let lastOffsetX = offsetX
                        if index == texts.count - 1 { // 计算多次，导致offsetX出现异常，需要重置起始值。
                            offsetX = 0 //last item
                        } else {
                            offsetX -= d.width
                        }

                        return lastOffsetX
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let lastOffsetY = offsetY
                        
                        if index == texts.count - 1 { // 计算多次，导致offsetY出现异常，需要重置起始值。
                            offsetY = 0
                        }
                        return lastOffsetY
                    })
            }
        }
        .background(.red)
    }
    
    
    private func item(for text: String) -> some View {
        Text(text)
            .padding(.horizontal, 8)
            .frame(height: 30)
            .font(.subheadline)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(15)
            .onTapGesture {
                print(text)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

