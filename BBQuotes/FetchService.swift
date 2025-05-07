//
//  FetchService.swift
//  BBQuotes
//
//  Created by Collin Schmitt on 1/12/25.
//

import Foundation

struct FetchService{
   private enum FetchError: Error {
        case badResponse //if server doesnt give us right data or right response
    }
    
    private let baseURL = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    
    //fetch function (argument is either going to be BB or Better Call Saul
    func fetchQuote(from show: String) async throws -> Quote {
        //Build Fetch URL
        let quoteURL = baseURL.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        
        //Fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        //Handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        //If response is good, decode data and put into quote model
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        //return quote
        return quote
    } //end fetchQuote
    
    func fetchCharacter(_ name: String) async throws -> Char{
        //ex: fetchCharacter(Walter White)
        
        let characterURL = baseURL.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        //have to deal with snake case in our character model for the decode step
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Char].self, from: data)
        
        return characters[0]
    }
    
    func fetchDeath(for character: String) async throws -> Death? {
        
        let fetchURL = baseURL.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        //have to deal with snake case in our character model for the decode step
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
    
    
}
