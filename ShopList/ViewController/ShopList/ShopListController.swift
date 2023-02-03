//
//  ShopListController.swift
//  ShopList
//
//  Created by Louis on 2022/11/25.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
  
final class ShopListController: UIViewController, ReactorKit.View, DeviceUIInfo {
    internal var disposeBag: DisposeBag = DisposeBag()
    
    private let headerView = ShopListHeaderView()
    private let shopListTableView = UITableView(frame: CGRect.zero, style: .plain).then {        
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(ShopListCell.self, forCellReuseIdentifier: String(describing: ShopListCell.self))
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
        view.addSubview(headerView)
        view.addSubview(shopListTableView)
    }
    
    private func setupConstraints() {      
        headerView.snp.makeConstraints { make in
            make.top.equalTo(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        shopListTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: ShopListReactor) {       
        rx.viewDidLoad.map { _ in Reactor.Action.parseJson }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.week }
            .filterNil()
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] week in
                self?.headerView.setWeek(week: week)
            }
            .disposed(by: disposeBag)
         
        let dataSource = RxTableViewSectionedReloadDataSource<ShopListSectionModel>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                switch item {
                case .shopList(let model):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShopListCell.self), for: indexPath) as? ShopListCell else { return UITableViewCell() }
                    
                    cell.setData(index: indexPath.row, model: model)
                    
                    return cell
                }
            }
        )
         
        reactor.state.map { $0.shopListWithFilters }
            .filterNil()
//            .distinctUntilChanged()
            .map { (result) -> [ShopListSectionModel] in
                let model = result.map { ShopListCellModel.shopList($0) }
                return [ ShopListSectionModel(index: 0, items: model) ]
            }
            .bind(to: shopListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$shouldTopScroll)
            .filterNil()
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                
                if let shopListTableView = self?.shopListTableView,
                    shopListTableView.numberOfRows(inSection: 0) > 0 {
                    
                    self?.shopListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        headerView.rxCustom.filterButtonTap
            .when(.recognized)
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in

                if let reactor = self?.reactor {
                    let viewController = FilterListViewController(reactor: reactor)
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true)
                }

            }.disposed(by: disposeBag)
    }
}
 
