//
//  ConfigTableVC.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 07/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit

class ConfigTableVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var epochSlider: UISlider!
    @IBOutlet weak var actionFunctionPicker: UIPickerView!
    @IBOutlet weak var neuroniosSlider: UISlider!
    @IBOutlet weak var learningRateSlider: UISlider!
    @IBOutlet weak var epochLabel: UILabel!
    @IBOutlet weak var neuroniosLabel: UILabel!
    @IBOutlet weak var learningRateLabel: UILabel!
    @IBOutlet weak var inTitle1: UITextField!
    @IBOutlet weak var inTitle2: UITextField!
    @IBOutlet weak var inTitle3: UITextField!
    @IBOutlet weak var outTitle1: UITextField!
    
    // let afPickerData = ["Sigmóide", "Gaussiana", "Tangente Hiperbólica"]
    let afPickerData = ["Sigmóide"]
    var selectedAF: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Delegate e Datasource do picker da Função de Ativação feitos pelo Storyboard.
        
        // -------------
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Atualiza os dados dos campos que podem variar com o carregamento de sets de exemplo (XOR, Vendas, etc.)
        inTitle1.text = NeuralNetController.inputLabels[0]
        inTitle2.text = NeuralNetController.inputLabels[1]
        inTitle3.text = NeuralNetController.inputLabels[2]
        outTitle1.text = NeuralNetController.outputLabels[0]

    }

    ////////////////
    // http://amiadevyet.com/swiftly-dismissing-keyboards-pt-2-of-2/

    // Oculta o teclado ao pressionar Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if textField == self.nomeDoOutletDoTextfield {
        textField.resignFirstResponder()
        // }
        
        print("ENTER PRESSED ::")
        return true
    }
    
    ////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Sliders: Ajuste dos labels com o valor do slider
    @IBAction func epochChange(_ sender: Any) {
        self.epochLabel.text = String(Int(epochSlider.value))
        NeuralNetController.trainEpochs = Int(epochSlider.value)
    }
    
    @IBAction func neuroniosChange(_ sender: Any) {
        self.neuroniosLabel.text = String(Int(neuroniosSlider.value))
        NeuralNetController.neuronsHL = Int(neuroniosSlider.value)
    }
    
    @IBAction func learningRateChange(_ sender: Any) {
        // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
        self.learningRateLabel.text = String(format: "%.3f", learningRateSlider.value)
        NeuralNetController.learningRate = Double(learningRateSlider.value)
    }
    
    // Labels dos dados para Treinamento
    
    @IBAction func inTitleChange1(_ sender: Any) {
        NeuralNetController.inputLabels[0] = inTitle1.text!
    }
    
    @IBAction func inTitleChange2(_ sender: Any) {
        NeuralNetController.inputLabels[1] = inTitle2.text!
    }
    
    @IBAction func inTitleChange3(_ sender: Any) {
        NeuralNetController.inputLabels[2] = inTitle3.text!
    }
    
    @IBAction func outTitleChange1(_ sender: Any) {
        NeuralNetController.outputLabels[0] = outTitle1.text!
   }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Variáveis de Entrada
            return 3
        case 1: // Rede Neural
            return 4
        case 2: // Variáveis de Saída
            return 1
        case 3: // Dados de Treinamento
            return 4    // ESCONDENDO A IMPORTAÇÃO QUE VAI SER DESENVOLVIDA DEPOIS
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tabBarController = self.parent?.parent as! UITabBarController
        
        // Dados de Treinamento (section 3)
        // Exemplo XOR (row 0)
        if indexPath.section == 3 && indexPath.row == 0 {
            NeuralNetController.configTrainingPreset(presetType: "xor")
            tabBarController.selectedIndex = 2 // Terceira Aba (2 em índice 0) : Dados de Treinamento - Vai para a aba Treinamento
        }
        
        // Dados de Treinamento (section 3)
        // Exemplo AND (row 1)
        if indexPath.section == 3 && indexPath.row == 1 {
            NeuralNetController.configTrainingPreset(presetType: "and")
            tabBarController.selectedIndex = 2 // Terceira Aba (2 em índice 0) : Dados de Treinamento - Vai para a aba Treinamento
        }
        
        // Dados de Treinamento (section 3)
        // Exemplo OR (row 2)
        if indexPath.section == 3 && indexPath.row == 2 {
            NeuralNetController.configTrainingPreset(presetType: "or")
            tabBarController.selectedIndex = 2 // Terceira Aba (2 em índice 0) : Dados de Treinamento - Vai para a aba Treinamento
        }
        
        // Dados de Treinamento (section 3)
        // Exemplo Vendas (row 3)
        if indexPath.section == 3 && indexPath.row == 3 {
            NeuralNetController.configTrainingPreset(presetType: "vendas")
            tabBarController.selectedIndex = 2 // Terceira Aba (2 em índice 0) : Dados de Treinamento - Vai para a aba Treinamento
        }
        
    }
}
extension ConfigTableVC: UIPickerViewDelegate, UIPickerViewDataSource {

    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return afPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return afPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NeuralNetController.actFunction = afPickerData[row]
    }
    
}

