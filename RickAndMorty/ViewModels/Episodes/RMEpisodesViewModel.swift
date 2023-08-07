//
//  RMEpisodesViewModel.swift
//  RickAndMorty
//
//  Created by  on 19/05/23.
//

import UIKit

protocol RMEpisodesViewModelDelegate: AnyObject {
    
    func didLoadInitialEpisodes()
    func didLoadAdditionalEpisodes(at indexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

final class RMEpisodesViewModel: NSObject {
    
    public weak var delegate: RMEpisodesViewModelDelegate?
    
    private var isLoadingEpisodes: Bool = true
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            cellModels = episodes.map({ RMEpisodeCollectionViewCellModel(episodeCode: $0.episode, episodeName: $0.name, episodeAirDate: $0.air_date) })
        }
    }
    
    private var cellModels: [RMEpisodeCollectionViewCellModel] = []
    
    private var apiInfo: RMAllEpisodesResponse.Info? = nil
    
    public func fetchEpisodes() {
        
        isLoadingEpisodes = true
        
        RMService.shared.execute(.allEpisodesRequest, expecting: RMAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let allEpisodesResponse):
                let results = allEpisodesResponse.results
                let info = allEpisodesResponse.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                    self?.isLoadingEpisodes = false
                }
                break
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingEpisodes = false
                break
            }
        }
    }
    
    public func fetchAdditionalEpisodes() {
        
        guard !isLoadingEpisodes else { return }
        guard let nextUrlString = apiInfo?.next, let nextUrl = URL(string: nextUrlString) else { return }
        
        let strong_self = self
        isLoadingEpisodes = true
        
        let request = RMRequest(url: nextUrl)!
        RMService.shared.execute(request, expecting: RMAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let allEpisodesResponse):
                let info = allEpisodesResponse.info
                let results = allEpisodesResponse.results
                
                let firstIdx = strong_self.episodes.count
                let lastIdx = strong_self.episodes.count + results.count - 1
                let newIndexPaths: [IndexPath] = Array(firstIdx...lastIdx).map({ IndexPath(item: $0, section: 0) })
    
                self?.apiInfo = info
                self?.episodes.append(contentsOf: results)
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadAdditionalEpisodes(at: newIndexPaths)
                    self?.isLoadingEpisodes = false
                }
                break
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingEpisodes = false
                break
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool { return (apiInfo?.next != nil) }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension RMEpisodesViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeCollectionViewCell else {
            fatalError("Not supported cell")
        }
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported!")
        }
        
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath)
        if(!shouldShowLoadMoreIndicator) { footer.isHidden = true }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let episode = episodes[indexPath.item]
        delegate?.didSelectEpisode(episode)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("collectionViewLayout must be UICollectionViewFlowLayout") }
        
        let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
        let height = RMEpisodeCollectionViewCell.intrinsicHeight(with: cellModels[indexPath.item], width: width)

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let width = collectionView.frame.width
        let height = shouldShowLoadMoreIndicator ? 100.0 : 0.0
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate
extension RMEpisodesViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingEpisodes else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height

        if(contentOffsetY >= contentHeight-scrollViewHeight-100.0) {
//            print("Should start fetching more episodes")
            fetchAdditionalEpisodes()
        }
    }
}
