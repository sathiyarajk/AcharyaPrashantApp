//
//  ViewController.swift
//  AcharyaPrashantApp
//
//  Created by Sathiyaraj on 04/05/24.
//
import UIKit
import Combine
// View
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = ImagesViewModel()
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
       
        collectionView.dataSource = self
        collectionView.delegate = self
        
        prepareData()
        handleError()
        
    } 
    func setupNavigationBar() {
        self.title = Constant.navigationTitle
    }
    
    func prepareData(){
        if InternetConnectionManager.isConnectedToNetwork(){
            viewModel.fetchImages()
        }else{
            let alert = UIAlertController(title: Constant.NoInternet, message: Constant.nointernetmessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constant.ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.imageDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    func handleError(){
        viewModel.errorHandler = { [weak self] error in
            // Display error message to the user
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
