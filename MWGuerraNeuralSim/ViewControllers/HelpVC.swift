//
//  HelpVC.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 06/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // https://academy.realm.io/posts/tryswift-katsumi-kishikawa-mastering-textkit-swift-ios/
    
    @IBAction func IniciarAction(_ sender: Any) {
        // Leva para a aba de configuração
        let tabBarController = self.parent as! UITabBarController
        tabBarController.selectedIndex = 1 // Segunda Aba (1 em índice 0) : Configuração da Rede Neural
    }
    
}

