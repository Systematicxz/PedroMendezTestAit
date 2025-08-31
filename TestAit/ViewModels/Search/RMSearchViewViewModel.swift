//
//  RMSearchViewViewModel.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 31/08/25.
//

import Foundation

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var optionMapUpdateblock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultHandler: (() -> Void)?
    
    private var searchResulModel: Codable?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    public func registerNoResultHandler(_ block: @escaping () -> Void) {
        self.noResultHandler = block
    }
    
    public func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
               
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        ]
                
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({_, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.querryArgument, value: value)
        }))
        
        // Create req
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self]
            result in
            switch result {
            case .success(let model):
                self?.proccessSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    private func proccessSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
            nextUrl = characterResults.info.next
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
            nextUrl = episodesResults.info.next
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationsResults.info.next
        }
        if let results = resultsVM {
            self.searchResulModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        } else {
            // Error no Results view
            handleNoResults()
        }
    }
    
    private func handleNoResults(){
        noResultHandler?()
    }
    
    public func set(querry text: String) {
        self.searchText = text
    }
    
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateblock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping((RMSearchInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateblock = block
    }
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResulModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    public func characterSearchResult(at index: Int) -> RMCharacter? {
        guard let searchModel = searchResulModel as? RMGetAllCharactersResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    public func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModel = searchResulModel as? RMGetAllEpisodesResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}
