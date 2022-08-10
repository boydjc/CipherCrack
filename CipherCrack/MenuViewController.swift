//
//  MenuViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 8/5/22.
//

import UIKit

class MenuViewController: UIViewController {

    
    
    
    @IBOutlet weak var jumbleModeButton: UIButton!
    @IBOutlet weak var wordModeButton: UIButton!
    @IBOutlet weak var numberModeButton: UIButton!
    
    @IBAction func MenuBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setBackgroundImage()
        
        jumbleModeButton.tag = 1
        wordModeButton.tag = 2
        numberModeButton.tag = 3
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationView = segue.destination as! GameViewController
        destinationView.sourceButtonTag = (sender as! UIButton).tag
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
