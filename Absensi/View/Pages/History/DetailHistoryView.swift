//
//  DetailHistoryView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 03/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    
    let event: EventEntity?
    
    init(event: EventEntity?) {
        self.event = event
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Capsule()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 30, height: 5)
                    .padding()
                Text("\(event?.nama ?? "")")
                    .font(.title3)
                    .padding()
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                    Text("\(event?.tempat ?? "")")
                        .foregroundColor(.gray)
                }
                Line()
                    .stroke(style: .init(dash: [5]))
                    .foregroundStyle(.gray)
                    .frame(height: 1)
                    .padding(.vertical, 10)
                Text("Waktu Absen")
                HStack {
                    Spacer()
                    HStack {
                        Text("Masuk:")
                            .fontWeight(.medium)
                        Text("\(Helpers.shared.timeFormatter(from: event?.absenMasukAtEpoch ?? 0))")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    HStack {
                        Text("Keluar:")
                            .fontWeight(.medium)
                        Text("\(Helpers.shared.timeFormatter(from: event?.absenKeluarAtEpoch ?? 0))")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
            }
        }
        .presentationDetents([.medium])
        .onDisappear {
            Helpers.shared.analyticsLog(itemID: "Detail History", itemName: "Keluar dari detail history", contentType: .button)
        }
    }
}


struct DetailHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        @State var showModal = true
        
        NavigationStack {
            Button("Show History", action: {
                showModal.toggle()
            })
            .sheet(isPresented: $showModal) {
                DetailHistoryView(event: nil)
            }
        }
    }
}
