//
//  LottieTestVC.swift
//  ARKitTest
//
//  Created by Artem Balashov on 06/08/2018.
//  Copyright © 2018 Artem Balashov. All rights reserved.
//

import UIKit
import Lottie

class LottieTestVC: UIViewController {

    @IBOutlet weak var lottieView: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieView.setAnimation(named: "Wait")
        lottieView.play()
        lottieView.autoReverseAnimation = true
        lottieView.loopAnimation = true
        view.backgroundColor = .darkGray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
