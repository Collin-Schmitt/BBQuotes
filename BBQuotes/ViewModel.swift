//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Collin Schmitt on 1/12/25.
//

import Foundation

@Observable
@MainActor
class ViewModel {
    enum FetchStatus{
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService() //now we can run the fetch functions
    
    var quote: Quote
    var character: Char
    
    init(){
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Char.self, from: characterData)
        
    }
    
    func getData(for show: String) async{
        //the function that runs when the user taps the "get random quote" button
        status = .fetching
        
        do{
            //try to run the fetch functions created
            
            
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .success
            
        } catch{
            status = .failed(error: error)
        }
    }
    
}
