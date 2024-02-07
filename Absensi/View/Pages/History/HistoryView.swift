//
//  HistoryView.swift
//  Absensi
//
//  Created by I putu Rama anadya on 15/09/23.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject private var vm = HistoryViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.histories, id:\.id) { section in
                    Section {
                        Text("\(section.section)")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                    }
                    Group {
                        ForEach(section.histories, id: \.uuid) { history in
                            Button(action: {
                                vm.fetchSingleEvent(id: history.acaraID ?? 0)
                            }, label: {
                                HStack(spacing: 0){
                                    VStack(spacing: 10) {
                                        HStack {
                                            Text(history.nama ?? "")
                                                .font(.body)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Text("\(Helpers.shared.dateFormatter(from: history.tanggal ?? 0))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity )
                                        HStack {
                                            HStack {
                                                Image(systemName: "mappin.and.ellipse")
                                                    .foregroundColor(.gray)
                                                Text(history.tempat ?? "")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                            Text("\(Helpers.shared.timeFormatter(from: history.waktu ?? 0))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity )
                                    }.padding(.horizontal, 20)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.05), lineWidth: 1.5)
                                }
                                .shadow(color: .gray.opacity(0.1), radius: 5, x: -1, y: 5)
                                .animation(Animation.spring())
                            })
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .sheet(isPresented: $vm.showSheet) {
                DetailHistoryView(event: vm.event)
            }
        }
        .navigationTitle("Riwayat Absen")
        .onAppear {
            Helpers.shared.analyticsLog(itemID: "History", itemName: "User berada di halaman history", contentType: .automatic
            )
            vm.fetchHistories()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView()
        }
    }
}
