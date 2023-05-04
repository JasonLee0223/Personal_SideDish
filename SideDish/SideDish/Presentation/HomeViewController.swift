//
//  HomeViewController.swift
//  SideDish
//
//  Created by Jason on 2023/04/22.
//

import UIKit

private enum Section: Int, CaseIterable {
    case main = 0
    case soup
    case sideDish
}

class HomeViewController: UIViewController {
    
    let networkService = NetworkService()
    
    //MARK: - Private Property
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Food>!
    
    private var mainFoodResult: [FoodInformationDTO]? {
        didSet {
            print(mainFoodResult)
        }
    }
    
    private var soupFoodResult: [FoodInformationDTO]? {
        didSet {
            print(soupFoodResult)
        }
    }
    
    private var sideDishResult: [FoodInformationDTO]? {
        didSet {
            print(sideDishResult)
        }
    }

    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        configureHierarchy()
        configureOfSuperViewLayout()
        setupCollectionView()
    }
    
    //MARK: - Private Method
    
    private func configureOfSuperViewLayout() {
        let superViewSafeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: superViewSafeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: superViewSafeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: superViewSafeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: superViewSafeArea.bottomAnchor)
        ])
    }
}

//MARK: - Configure Of Layout
extension HomeViewController {
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureOfCollectionViewLayout())
        collectionView.showsVerticalScrollIndicator = true
        collectionView.clipsToBounds = true
    }
    
    private func configureOfCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(343),
                                              heightDimension: .absolute(130))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(343),
                                               heightDimension: .estimated(1200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .estimated(343),
                                                     heightDimension: .estimated(96))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: HomeHeaderView.identifier, alignment: .leading)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

//MARK: - Configure Of DataSource
extension HomeViewController {
    private func setupCollectionView() {
        
        /// HeaderView Regist
        let headerRegistration = UICollectionView.SupplementaryRegistration<HomeHeaderView>(elementKind: HomeHeaderView.identifier) {
            supplementaryView, elementKind, indexPath in
            
            let sectionType = Section.allCases[indexPath.section]
            
            switch sectionType {
            case .main:
                supplementaryView.setTitle(headerText: "모두가 좋아하는 \n든든한 메인 요리")
            case .soup:
                supplementaryView.setTitle(headerText: "정선이 담긴 \n뜨끈뜨끈 국물 요리")
            case .sideDish:
                supplementaryView.setTitle(headerText: "식탁을 풍성하게 하는 \n정갈한 밑반찬")
            }
        }
        
        /// Cell Regist
        let cellRegistration = UICollectionView.CellRegistration<HomeViewCell, Food> { (cell, indexPath, food) in
            
            //MARK: - Cell하고 Food Entity를 연결
            cell.setFoodImage(image: <#T##UIImage#>)
            cell.prepareForReuse()
        }
        
        /// DataSource
        
        fetchOfDataSource(with: cellRegistration)
        
        dataSource.supplementaryViewProvider = { (view, kind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,
                                                                              for: indexPath)
        }
        
        /// Snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Food>()
        
        snapshot.appendSections([.main, .soup, .sideDish])
        snapshot.appendItems([Food]())
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func fetchOfDataSource(with CellRegistration: UICollectionView.CellRegistration<HomeViewCell, Food>) {
        dataSource = UICollectionViewDiffableDataSource<Section, Food>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, food) in
            
            guard let currentSection = Section(rawValue: indexPath.section) else { fatalError("잘못된 Section") }
            
            switch currentSection {
            case .main:
                let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: food)
                cell.prepareForReuse()
                return cell
            case .soup:
                let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: food)
                cell.prepareForReuse()
                return cell
            case .sideDish:
                let cell = collectionView.dequeueConfiguredReusableCell(using: CellRegistration, for: indexPath, item: food)
                cell.prepareForReuse()
                return cell
            }
        })
    }
    
}

//MARK: - loadData
extension HomeViewController {
    
    private func loadData() {
        let mainFoodRequestDTO = APIEndpoint.supplyFoodInformation(with: APIMagicLiteral.main)
        let soupFoodRequestDTO = APIEndpoint.supplyFoodInformation(with: APIMagicLiteral.soup)
        let sideDishRequestDTO = APIEndpoint.supplyFoodInformation(with: APIMagicLiteral.side)
        
        Task {
            mainFoodResult = try await networkService.request(with: mainFoodRequestDTO).body
            soupFoodResult = try await networkService.request(with: soupFoodRequestDTO).body
            sideDishResult = try await networkService.request(with: sideDishRequestDTO).body
        }
        
    }
}
