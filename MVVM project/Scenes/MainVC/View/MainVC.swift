//
//  MainVC.swift
//  MVVM project
//
//  Created by 2B on 02/05/2023.
//

import UIKit

class MainVC: UIViewController {

    
   //MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    //MARK: - Variables
    
    var viewModel = MainViewModel()
    var cellDataSource : [MainCellViewModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getData()
         
    }
    
    
    
    
    //MARK: - Functions

    
    func configView(){
        setupTableView()
    }
    
    func setupTableView(){
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        
        title = "Movies"
        self.regesterCell()
    }
 
    func regesterCell(){
        moviesTableView.register(UINib(nibName:MainTableViewCell.ID, bundle: nil), forCellReuseIdentifier: MainTableViewCell.ID)
    }
    
    func openDetails(movieID : Int){
        guard let movie = viewModel.retrieMovie(movieID: movieID) else {return}
        
        let detailsViewModel = DetailsViewModel(movie: movie)
        let detailsVC = DetailsVC(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func bindViewModel(){
        viewModel.isLoading.bind { [weak self] isLoading in
            
            guard let isLoading = isLoading else {return}
            
            if isLoading {
                self?.activityIndicator.startAnimating()
                print("start")
            }else{
                self?.activityIndicator.stopAnimating()
                print("stop")
            }
        }
        
        
        viewModel.cellDataSourse.bind { [weak self] movies in
            guard let movies = movies else {return}
            self?.cellDataSource = movies
            self?.moviesTableView.reloadData()
        }
    }
    
    //MARK: - IBActions
    
    
}



extension MainVC : UITableViewDelegate , UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfsections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.ID , for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        let movie = cellDataSource[indexPath.row]
        cell.setupCellData(viewModel: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetails(movieID: cellDataSource[indexPath.row].id)
        
    }
      
}
