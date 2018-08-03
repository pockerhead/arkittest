//
//  RampPickerVC.swift
//  ARKitTest
//
//  Created by Artem Balashov on 02/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    var sceneView: SCNView!
    var size: CGSize!
    var completion: ((String) -> Void)?
    var collectionView: UICollectionView!
    var onAppeared: (()->Void)?
    var nodeNames = ["pipe","pyramid","quarter", "dodge","charger","maneken"]
    let sceneViewCellIdentifier = "CollectionViewCell"
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect.init(origin: CGPoint.zero, size: size)
        view.frame = frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
        view.insertSubview(collectionView, at: 1)
        collectionView.register(UINib.init(nibName: sceneViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: sceneViewCellIdentifier)
    }

    override func viewDidLayoutSubviews() {
        collectionView.frame = view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onAppeared?()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodeNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height / 3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sceneViewCellIdentifier, for: indexPath) as! CollectionViewCell
        cell.configureWithSceneName(name: nodeNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nodeName = nodeNames[indexPath.row]
        completion?(nodeName)
    }
}


