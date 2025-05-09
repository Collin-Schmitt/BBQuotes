//
//  QuoteView.swift
//  BBQuotes
//
//  Created by Collin Schmitt on 1/12/25.
//

import SwiftUI

struct QuoteView: View {
    
    let vm = ViewModel()
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack{
                    VStack{
                        Spacer(minLength: 60)
                        
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .success:
                            Text("\" \(vm.quote.quote) \"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom){
                                AsyncImage(url: vm.character.images[0]){ image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width/1.1, height: geo.size.height/1.8)
                            .padding()
                            .clipShape(.rect(cornerRadius: 75))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            .sheet(isPresented: $showCharacterInfo){
                                CharacterView(character: vm.character, show: show)
                            }
                            
                            
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        
                        
                        Spacer()
                    }
                    
                    //since button is not in switch statement, it will always be on the screen
                    Button{
                        Task{
                            await vm.getData(for: show)
                        }
                    }label:{
                        Text("Get Random Quote")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color("\(show.replacingOccurrences(of: " ", with: ""))Button"))
                        .clipShape(.rect(cornerRadius: 7))
                        .shadow(color: Color("\(show.replacingOccurrences(of: " ", with: ""))Shadow"), radius: 2)
                    }
                    Spacer(minLength: 95)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
            }//end ZStackk
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    QuoteView(show: "Breaking Bad")
        .preferredColorScheme(.dark)
}
