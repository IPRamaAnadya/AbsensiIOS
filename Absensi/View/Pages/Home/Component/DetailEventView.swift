//
//  DetailEventView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 14/09/23.
//

import SwiftUI

struct DetailEventView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Judul")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(Color("primary"))
                    Text("Lokasi")
                        .foregroundColor(.gray)
                }
                Line()
                    .stroke(style: .init(dash: [1]))
                    .foregroundStyle(.gray)
                    .frame(height: 1)
                Text("Waktu Absen")
                    .font(.title3)
                    .fontWeight(.semibold)
                HStack {
                    HStack {
                        Text("Masuk:")
                            .fontWeight(.semibold)
                        Text("Jam")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Keluar:")
                            .fontWeight(.semibold)
                        Text("Jam")
                            .foregroundColor(.gray)
                    }
                }
                Text("Kuota terpakai")
                HStack(alignment: .bottom, spacing: 0) {
                    Text("10")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Text("/10")
                        .foregroundColor(.gray)
                }
                Line()
                    .stroke(style: .init(dash: [1]))
                    .foregroundStyle(.gray)
                    .frame(height: 1)
                Grid {
                    GridRow {
                        NavigationLink(destination: {
                            AbsentView(isPresented: $isPresented)
                        }, label: {
                            VStack {
                                Text("11.20")
                                    .padding(.all, 10)
                                    .background(Color.green)
                                    .cornerRadius(50)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .opacity(1)
                                Rectangle()
                                    .fill(Color.green)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay {
                                        Image(systemName: "figure.walk.arrival")
                                            .resizable()
                                            .padding(.all, 50)
                                            .foregroundColor(.white)
                                        
                                    }
                                    .cornerRadius(40)
                                    .shadow(color: .green.opacity(0.3), radius: 5, x: -1, y: 5)
                                Text("Absen Masuk")
                                    .fontWeight(.bold)
                            }
                        })
                        VStack {
                            Text("11.20")
                                .padding(.all, 10)
                                .background(Color.red)
                                .cornerRadius(50)
                                .foregroundColor(.white)
                                .font(.body)
                                .opacity(1)
                            Rectangle()
                                .fill(Color.red)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    Image(systemName: "figure.walk.departure")
                                        .resizable()
                                        .padding(.all, 50)
                                        .foregroundColor(.white)
                                        
                                }
                                .cornerRadius(40)
                                .shadow(color: .red.opacity(0.3), radius: 5, x: -1, y: 5)
                            Text("Absen Keluar")
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
                
                
                NavigationLink(destination: {
                    MapView()
                }, label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(Color("primary"))
                        Text("Lokasi Anda")
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(25)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: -1, y: 5)
                })
                
            }
        }
        .background(.ultraThinMaterial)
    }
}

struct DetailEventView_Previews: PreviewProvider {
    static var previews: some View {
        @State var example = false
        DetailEventView(isPresented: $example)
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
