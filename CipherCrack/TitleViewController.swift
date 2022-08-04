//
//  TitleViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 7/31/22.
//

import UIKit

class TitleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setBackgroundImage()
    }
    
    func setBackgroundImage() {
        let backgroundImage = UIImage(named: "cipherbg")
        
        var bgImageView : UIImageView!
        bgImageView = UIImageView(frame: view.bounds)
        bgImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.image = backgroundImage
        bgImageView.center = view.center
        view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
