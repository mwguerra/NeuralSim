//
//  TrainingVC.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 07/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit

class TrainingVC: UIViewController {
    
    // Passar dados entre tabs
    // Usando uma classe separada: https://www.youtube.com/watch?v=Y4uwTdivl64
    
    @IBOutlet weak var trainingTableView: UITableView!
    @IBOutlet weak var treinarButton: UIBarButtonItem!
    
    var aIndicator = UIActivityIndicatorView()
    var trainingData: [Float]?

    var inputTitle1TextField: UITextField?
    var inputTitle2TextField: UITextField?
    var inputTitle3TextField: UITextField?
    var outputTitle1TextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        aIndicator.center = self.view.center
        aIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(aIndicator)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Recarrega a tabela com o conteúdo da Classe de treinamento.
        trainingTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func treinarAction(_ sender: Any) {
        
        // Verifica se há dados para treinamento na tabela (ao menos 2 linhas)
        if NeuralNetController.inputData.count > 1 {
        
            treinarButton.isEnabled = false
            aIndicator.startAnimating()
            NeuralNetController.isTrained = true    // pode executar testes a partir deste momento

            // Threading: https://www.youtube.com/watch?v=sOnvsZwNsp0
            DispatchQueue.global(qos: .userInitiated).async {
                NeuralNetController.trainNetwork()
                
                DispatchQueue.main.async{ 
                    // códigos que mexem com a UI, como reloaddata de tableviews
                    self.aIndicator.stopAnimating()
                    self.treinarButton.isEnabled = true
                    
                    // Após treinar, leva para a aba de execução
                    let tabBarController = self.parent as! UITabBarController
                    tabBarController.selectedIndex = 3 // Quarta Aba (3 em índice 0) : Execução de teste de validação
                    
                }
            }

        } else {

            // Mensagem: Não há dados suficientes cadastrados para treinamento
            
            let alert = UIAlertController(title: "Atenção", message: "Para que possa treinar sua rede neural, é necessário que você tenha, pelo menos, 2 conjuntos de dados (2 linhas) nesta tabela.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    @IBAction func addTrainingData(_ sender: Any) {
        
        // AlertController: https://www.youtube.com/watch?v=jCAWRFOvI_s
        
        let alertController = UIAlertController(title: "Adicione uma nova linha para treinamento", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: inputTitle1TextField)
        alertController.addTextField(configurationHandler: inputTitle2TextField)
        alertController.addTextField(configurationHandler: inputTitle3TextField)
        alertController.addTextField(configurationHandler: outputTitle1TextField)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    func inputTitle1TextField(textField: UITextField) {
        inputTitle1TextField = textField
        inputTitle1TextField?.placeholder = "Input \(NeuralNetController.inputLabels[0])"
    }
    
    func inputTitle2TextField(textField: UITextField) {
        inputTitle2TextField = textField
        inputTitle2TextField?.placeholder = "Input \(NeuralNetController.inputLabels[1])"
    }
    
    func inputTitle3TextField(textField: UITextField) {
        inputTitle3TextField = textField
        inputTitle3TextField?.placeholder = "Input \(NeuralNetController.inputLabels[2])"
    }
    
    func outputTitle1TextField(textField: UITextField) {
        outputTitle1TextField = textField
        outputTitle1TextField?.placeholder = "Output \(NeuralNetController.outputLabels[0])"
    }
    
    func okHandler(alert: UIAlertAction) {
        
        // Ajusta pontos e vírgulas para pontos (para proteção da internacionalização para cálculo nas variáveis do código)
        let in1 = inputTitle1TextField?.text?.replacingOccurrences(of: ",", with: ".")
        let in2 = inputTitle2TextField?.text?.replacingOccurrences(of: ",", with: ".")
        let in3 = inputTitle3TextField?.text?.replacingOccurrences(of: ",", with: ".")
        let out1 = outputTitle1TextField?.text?.replacingOccurrences(of: ",", with: ".")

        var inputData = [Double]()
        var outputData = [Double]()
        var isNumber = false
        var isBlank = false
        
        // Verifica se são números válidos (pontuação, separadores, algarismos, etc). Se for, prossegue, senão, mostra mensagem.

        if in1!.count > 0 && in2!.count > 0 && in3!.count > 0 && out1!.count > 0 {
            if let d1 = Double(in1!) {
                if let d2 = Double(in2!) {
                    if let d3 = Double(in3!) {
                        if let d4 = Double(out1!) {
                            
                            // Prepara os Arrays para serem incluídos como elemento de testa da rede neural
                            inputData.append(d1)
                            inputData.append(d2)
                            inputData.append(d3)
                            outputData.append(d4)
                            
                            // Confirma que todos os números são números
                            isNumber = true
                        }
                    }
                }
            }
        } else {
            isBlank = true
        }

        // Log de controle
        print("\n\n===========================")
        print("\nAlgum está vazio: \(isBlank)")
        print("\nTodos são números: \(isNumber)")
        print("\n---------------")
        print("\nInput 1: \(in1!)")
        print("\nInput 2: \(in2!)")
        print("\nInput 3: \(in3!)")
        print("\nOutput 1: \(out1!)")
        print("\n---------------")
        print("\nArray de Inputs : \(inputData)")
        print("\nArray de Outputs: \(outputData)")
        print("\n===========================\n")
        
        if isNumber {
        
            // Adiciona o dado na tabela de treinamento da rede
            NeuralNetController.addData(trainingData: inputData, expectedOutput: outputData)
            
            // Atualiza a tableview
            trainingTableView.reloadData()
        
        } else {
            
            var mensagem:String = ""
            
            if isBlank {
                mensagem = "Foi identificado ao menos um dos campos em branco. Todos os campos devem ser preenchidos. Caso não deseje utilizar todos em seu teste, atribua em todos os dados para treinamento um valor único, como 0 (zero) ou 1 (um)."
            } else {
                mensagem = "Alguns dos dados inseridos foram identificados como não sendo numéricos. Repita a entrada e se certifique de que todos os valores estão preenchidos corretamente."
            }
            
            // Mensagem: todos os campos devem ser preenchidos com valores numéricos
            let alert = UIAlertController(title: "Atenção", message: mensagem, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        
        }
    }
}
extension TrainingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NeuralNetController.inputData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell", for: indexPath) as! TrainingTVCell
        let currentInputData = NeuralNetController.inputData[indexPath.row]
        let currentOutputData = NeuralNetController.outputData[indexPath.row]
        
        // cell.textLabel?.text = "Teste \(indexPath.row)"
        // cell.textLabel?.text = currentInputData.map({"\($0)"}).joined(separator: " :: ") // "1 :: 2 :: 3"
        
        cell.cellInputLabel1.text = String(currentInputData[0])
        cell.cellInputLabel2.text = String(currentInputData[1])
        cell.cellInputLabel3.text = String(currentInputData[2])
        cell.cellOutputLabel1.text = String(currentOutputData[0])

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NeuralNetController.removeData(atIndex: indexPath.row)
            trainingTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
