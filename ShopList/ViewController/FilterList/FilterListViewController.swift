//
//  FilterListViewController.swift
//  ShopList
//
//  Created by Louis on 2022/11/29.
//

import Foundation
import UIKit
import ReactorKit
import RxDataSources
import RxOptional

final class FilterListViewController: UIViewController, ReactorKit.View, DeviceUIInfo {
    internal var disposeBag: DisposeBag = DisposeBag()
     
    private let naviView = FilterListNaviView()
    private let completeButton = UIButton().then {
        $0.setTitle("선택완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.roundCorner(value: 5)
    }
    
    typealias FilterDataSource = UICollectionViewDiffableDataSource<FilterBaseSection, Item>
    enum Item: Hashable {
        case ageFilter(Int)
        case styleFilter(String)
    }
    
    private lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .white        
        $0.contentInsetAdjustmentBehavior = .never
        $0.register(FilterCell.self, forCellWithReuseIdentifier: String(describing: FilterCell.self))
        $0.register(TitleSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleSectionHeaderView.self))
    }
    
    private lazy var dataSource: FilterDataSource = configureDataSource()
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            let itemCount = self.dataSource.snapshot().numberOfItems(inSection: section)
            return section.createLayout(itemCount: itemCount)
        }
        return layout
    }
    
    init(reactor: ShopListReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.classForCoder) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        makeUI()
        addSubView()
        setupConstraints()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
    }
    
    private func addSubView() {
        view.addSubview(naviView)
        view.addSubview(filterCollectionView)
        view.addSubview(completeButton)
    }
    
    private func setupConstraints() {
        naviView.snp.makeConstraints { make in
            make.top.equalTo(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top)
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(homeIndicatorHeight + 10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func bind(reactor: ShopListReactor) {
        setSupplementaryView(dataSource: dataSource)
        initDataSource(dataSource: dataSource)
        
        rx.viewDidLoad
            .bind { [weak self] _ in
                self?.reactor?.action.onNext(.setTempFilterData)
            }
            .disposed(by: disposeBag)
        
        naviView.rxCustom.xButtonTap
            .when(.recognized)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                
                self?.dismiss(animated: true)
                
            }.disposed(by: disposeBag)
        
        naviView.rxCustom.resetButtonTap
            .when(.recognized)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                 
                self?.reactor?.action.onNext(.resetFilter)
                self?.filterCollectionView.reloadData()
                
            }.disposed(by: disposeBag)
        
        completeButton.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                                  
                self?.reactor?.action.onNext(.applyFilter)
                self?.dismiss(animated: true)
                
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.ageFilterList }
            .filterNil()
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] ageFilterList in
                if let section = self?.getSection(by: FilterBaseSection.ModuleName.ageFilterSection.moduleIndex) as? AgeFilterSection {
                    section.headerTitle = "연령대"
                    self?.dataSource.replaceItems(ageFilterList.map { .ageFilter($0) }, in: section)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.styleFilterList }
            .filterNil()
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] styleFilterList in
                if let section = self?.getSection(by: FilterBaseSection.ModuleName.styleFilterSection.moduleIndex) as? StyleFilterSection {
                    section.headerTitle = "스타일"
                    self?.dataSource.replaceItems(styleFilterList.map { .styleFilter($0) }, in: section)
                }
            }
            .disposed(by: disposeBag)
        
        filterCollectionView.rx.itemSelected
            .bind(with: self, onNext: {owner, indexPath in

                if indexPath.section == FilterBaseSection.ModuleName.ageFilterSection.moduleIndex {
                    owner.reactor?.action.onNext(.selectedAgeFilter(index: indexPath.row))
                } else {
                    owner.reactor?.action.onNext(.selectedStyleFilter(index: indexPath.row))
                }
                 
                owner.filterCollectionView.reloadData()
                
            }).disposed(by: disposeBag)
    }
}

// MARK: - DataSource Setting
extension FilterListViewController {
    private func configureDataSource() -> FilterDataSource {
        return UICollectionViewDiffableDataSource<FilterBaseSection, Item>(collectionView: filterCollectionView) { [weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
              
            switch identifier {
            case .ageFilter(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCell.self), for: indexPath) as? FilterCell else { return UICollectionViewCell() }

                var tag = ""
                switch AgeTag(rawValue: item) {
                case .teenage:
                    tag = "10대"
                case .earlyTwenties:
                    tag = "20대초반"
                case .halfTwenties:
                    tag = "20대중반"
                case .lateTwenties:
                    tag = "20대후반"
                case .earlyThirties:
                    tag = "30대초반"
                case .halfThirties:
                    tag = "30대중반"
                case .lateThirties:
                    tag = "30대후반"
                default:
                    break
                }
                
                cell.setFilterName(filterName: tag)
                
                if self?.reactor?.currentState.tempSelectedAgeFilters.contains(item) == true {
                    cell.backgroundColor = .systemYellow
                } else {
                    cell.backgroundColor = .clear
                }
                
                return cell
                
            case .styleFilter(let item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilterCell.self), for: indexPath) as? FilterCell else { return UICollectionViewCell() }
                
                cell.setFilterName(filterName: item)
                
                if self?.reactor?.currentState.tempSelectedStyleFilters.contains(item) == true {
                    cell.backgroundColor = .systemYellow
                } else {
                    cell.backgroundColor = .clear
                }
                
                return cell
            }
        }
    }
    
    private func setSupplementaryView(dataSource: FilterDataSource) {
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self, let section = self.getSection(by: indexPath.section) else { return nil }
            
            return section.supplementaryView(kind: kind, for: nil, at: indexPath, in: collectionView)
        }
    }
    
    private func initDataSource(dataSource: FilterDataSource) {
        var snapshot = dataSource.snapshot()
        let ageFilterSection = AgeFilterSection(moduleName: .ageFilterSection)
        let styleFilterSection = StyleFilterSection(moduleName: .styleFilterSection)
        
        let sections = [ageFilterSection,
                        styleFilterSection]
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func getSection(by sectionIndex: Int) -> FilterBaseSection? {
        let snapshot = dataSource.snapshot()
        let section = snapshot.sectionIdentifiers[safe: sectionIndex]
        return section
    }
}

