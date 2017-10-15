//
//  TestVC.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 07/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit

class TestVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var input1TextField: UITextField!
    @IBOutlet weak var input2TextField: UITextField!
    @IBOutlet weak var input3TextField: UITextField!
    @IBOutlet weak var input1Label: UILabel!
    @IBOutlet weak var input2Label: UILabel!
    @IBOutlet weak var input3Label: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var retreinarButton: UIBarButtonItem!
    @IBOutlet weak var runButton: UIBarButtonItem!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoSegControl: UISegmentedControl!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var aIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Activity Indicator
        aIndicator.center = self.view.center
        aIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(aIndicator)
        
        // ProgressView
        if !NeuralNetController.isTraining {
            progressView.isHidden = true
        } else {
            progressView.isHidden = false
        }

        // Textfield delagate feito através do storyboard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ProgressView
        if !NeuralNetController.isTraining {
            progressView.isHidden = true
        } else {
            progressView.isHidden = false
        }
        
        // Atualiza os Labels das variáveis de entrada
        input1Label.text = NeuralNetController.inputLabels[0]
        input2Label.text = NeuralNetController.inputLabels[1]
        input3Label.text = NeuralNetController.inputLabels[2]

        // Atualiza a informação da view segmentada
        switch infoSegControl.selectedSegmentIndex {
        case 0:
            
            // Atualiza a view de Informações: TREINAMENTO
            infoTextView.text.removeAll()
            
            if !NeuralNetController.trainedResults.isEmpty {
                for iAux in 0...(NeuralNetController.trainedResults.count - 1) {
                    infoTextView.text.append(NeuralNetController.trainedResults[iAux])
                }
            }
            
        case 1:
            
            // Atualiza a view de Informações: CONFIGURAÇÃO
            infoTextView.text.removeAll()
            
            infoTextView.text.append("Rodadas de treinamanto: \(NeuralNetController.trainEpochs)\n")
            infoTextView.text.append("Neurônios na camada intermediária: \(NeuralNetController.neuronsHL)\n")
            infoTextView.text.append("Taxa de aprendizado: \(NeuralNetController.learningRate)\n")
            
        default:
            print("Erro no controle segmentado da infoView")
        }
    }
    
    // Esconde a view de informações de treinamento e configuração para o dispositivo na horizontal. Mostra novamente ao virar para a vertical.
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
    {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight{
            infoView.isHidden = true
        }
        else{
            infoView.isHidden = false
        }
    }
    
    // Oculta o teclado
    // Tem que colocar o protocolo TextFieldDelagate e atribuir o delegate no storyboard para self.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func runAction(_ sender: Any) {
        
        // ExecutaTestesParaFCU()   // Só foi executado para gerar o apêndice para fazer as análises para a dissertação Neurônio Digital da FCU
        
        if NeuralNetController.isTrained {
            
            // Ajusta pontos e vírgulas para pontos (para proteção da internacionalização para cálculo nas variáveis do código)
            let in1 = input1TextField?.text?.replacingOccurrences(of: ",", with: ".")
            let in2 = input2TextField?.text?.replacingOccurrences(of: ",", with: ".")
            let in3 = input3TextField?.text?.replacingOccurrences(of: ",", with: ".")
            
            var inputData = [Double]()
            var returnValue:Double = 0.0
            var isNumber = false
            var isBlank = false
            
            // Verifica se são números válidos (pontuação, separadores, algarismos, etc). Se for, prossegue, senão, mostra mensagem.
            if in1!.count > 0 && in2!.count > 0 && in3!.count > 0 {
                if let d1 = Double(in1!) {
                    if let d2 = Double(in2!) {
                        if let d3 = Double(in3!) {
                            // Prepara os Arrays para serem incluídos como elemento de testa da rede neural
                            inputData.append(d1)
                            inputData.append(d2)
                            inputData.append(d3)
                        
                            // Confirma que todos os números são números
                            isNumber = true
                        }
                    }
                }
            } else {
                isBlank = true
            }
        
            // Se estiver tudo Ok com as entradas, pode processar e rodar na rede neural
            if isNumber && !isBlank {
                returnValue = NeuralNetController.runNeuralNet(inputData: inputData)
                resultLabel.text = "Valor de resposta: \(returnValue)"
            } else {
                // Mensagem de dados de entrada inválidos
                
                let alert = UIAlertController(title: "Atenção", message: "Alguns dados que você digitou não foram entendidos como numéricos. Verifique se há letras, pontuações erradas ou espeços nos campos de entrada.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
            }

        } else {
            
            // Mensagem de rede não treinada
            
            let alert = UIAlertController(title: "Rede não treinada", message: "Acesse a aba de treinamento para popular os dados já conhecidos. São necessários, pelo menos, 2 dados na tabela para que a rede possa ser treinada.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    @IBAction func retreinarAction(_ sender: Any) {
        
        var progressStep:Float = 0.0
        progressView.setProgress(progressStep, animated: false)
        
        // Verifica se há dados para treinamento na tabela (ao menos 2 linhas)
        if NeuralNetController.inputData.count > 1 {
            
            retreinarButton.isEnabled = false
            runButton.isEnabled = false
            aIndicator.startAnimating()
            NeuralNetController.isTrained = true    // pode executar testes a partir deste momento
            NeuralNetController.isTraining = true
            
            // Threading: https://www.youtube.com/watch?v=sOnvsZwNsp0
            DispatchQueue.global(qos: .userInitiated).async {
                
                DispatchQueue.main.async{
                    self.progressView.isHidden = false
                }
                
                // EXECUTA O TREINAMENTO DA REDE
                NeuralNetController.trainNetworkPrepare()
                for iAux in 0..<NeuralNetController.trainEpochs {
                    progressStep = Float(iAux) / Float(NeuralNetController.trainEpochs)
                    NeuralNetController.trainNetworkSteps()
                    
                    DispatchQueue.main.async{
                        // Atualiza progressView
                        self.progressView.setProgress(progressStep, animated: true)
                        print("iAux: \(iAux) :: Epochs: \(NeuralNetController.trainEpochs) :: PROGRESS STEP: \(progressStep)")
                    }
                }
                NeuralNetController.trainNetworkFinish()
                
                DispatchQueue.main.async{
                    self.progressView.isHidden = true
                    
                    // Reabilita os botões
                    NeuralNetController.isTraining = false
                    
                    // códigos que mexem com a UI, como reloaddata de tableviews
                    self.aIndicator.stopAnimating()
                    self.retreinarButton.isEnabled = true
                    self.runButton.isEnabled = true
                    
                    // Após treinar, leva para a aba de execução
                    let tabBarController = self.parent as! UITabBarController
                    tabBarController.selectedIndex = 3 // Quarta Aba (3 em índice 0) : Execução de teste de validação
                    
                    ////////////////
                    
                    // Atualiza a informação da view segmentada
                    switch self.infoSegControl.selectedSegmentIndex {
                    case 0:
                        
                        // Atualiza a view de Informações: TREINAMENTO
                        self.infoTextView.text.removeAll()
                        
                        if !NeuralNetController.trainedResults.isEmpty {
                            for iAux in 0...(NeuralNetController.trainedResults.count - 1) {
                                self.infoTextView.text.append(NeuralNetController.trainedResults[iAux])
                            }
                        }
                        
                    case 1:
                        
                        // Atualiza a view de Informações: CONFIGURAÇÃO
                        self.infoTextView.text.removeAll()
                        
                        self.infoTextView.text.append("Rodadas de treinamanto: \(NeuralNetController.trainEpochs)\n")
                        self.infoTextView.text.append("Neurônios na camada intermediária: \(NeuralNetController.neuronsHL)\n")
                        self.infoTextView.text.append("Taxa de aprendizado: \(NeuralNetController.learningRate)\n")
                        
                    default:
                        print("Erro no controle segmentado da infoView")
                    }
                    
                }
            }
            
        } else {
            
            // Mensagem: Não há dados suficientes cadastrados para treinamento
            
            let alert = UIAlertController(title: "Atenção", message: "Para que possa treinar sua rede neural, é necessário que você tenha, pelo menos, 2 conjuntos de dados (2 linhas) na tabela de dados para treinamento.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)

        }

    }
    
    @IBAction func SegmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            // Atualiza a view de Informações: TREINAMENTO
            infoTextView.text.removeAll()
            
            if !NeuralNetController.trainedResults.isEmpty {
                for iAux in 0...(NeuralNetController.trainedResults.count - 1) {
                    infoTextView.text.append(NeuralNetController.trainedResults[iAux])
                }
            }
            
        case 1:
            
            // Atualiza a view de Informações: CONFIGURAÇÃO
            infoTextView.text.removeAll()
            
            infoTextView.text.append("Rodadas de treinamanto: \(NeuralNetController.trainEpochs)\n")
            infoTextView.text.append("Neurônios na camada intermediária: \(NeuralNetController.neuronsHL)\n")
            infoTextView.text.append("Taxa de aprendizado: \(NeuralNetController.learningRate)\n")

        default:
            print("Erro no controle segmentado da infoView")
        }

    }
    
    /////////////////////////////////////////////////
    // MWGuerra: Rotina para a dissertação da FCU
    /////////////////////////////////////////////////
    func ExecutaTestesParaFCU () -> String {
        
        var stringParaTextView = ""
    
        // Epoch: 200, 500, 1000
        // NeuroniosHL: 2, 5, 10
        // LearningRate: 20%, 40%, 80%
        
        infoTextView.text.removeAll()
        
        for iAux1 in 0...2 {
            
            switch iAux1 {
            case 0:
                NeuralNetController.trainEpochs = 200
            case 1:
                NeuralNetController.trainEpochs = 500
            case 2:
                NeuralNetController.trainEpochs = 1000
            default:
                print("Erro FCU: Epoch")
            }
            
            for iAux2 in 0...2 {
                
                switch iAux2 {
                case 0:
                    NeuralNetController.neuronsHL = 2
                case 1:
                    NeuralNetController.neuronsHL = 5
                case 2:
                    NeuralNetController.neuronsHL = 10
                default:
                    print("Erro FCU: NeuronioHL")
                }

                for iAux3 in 0...2 {
                    
                    switch iAux3 {
                    case 0:
                        NeuralNetController.learningRate = 0.2
                    case 1:
                        NeuralNetController.learningRate = 0.4
                    case 2:
                        NeuralNetController.learningRate = 0.8
                    default:
                        print("Erro FCU: LearningRate")
                    }
                    
                    // EXECUTA O TESTE
                    NeuralNetController.trainNetwork()
                    
                    // Atualiza a view de Informações: TREINAMENTO
                    infoTextView.text.append("#######################\n")
                    infoTextView.text.append("#### Epoch: \(NeuralNetController.trainEpochs)\n")
                    infoTextView.text.append("#### NeuroniosHL: \(NeuralNetController.neuronsHL)\n")
                    infoTextView.text.append("#### LearningRate: \(NeuralNetController.learningRate)\n\n")
                    
                    if !NeuralNetController.trainedResults.isEmpty {
                        for iAux in 0...(NeuralNetController.trainedResultsFCU.count - 1) {
                            infoTextView.text.append(NeuralNetController.trainedResultsFCU[iAux])
                        }
                    }
                    
                    print("#######################")
                    print("#### Epoch: \(NeuralNetController.trainEpochs)")
                    print("#### NeuroniosHL: \(NeuralNetController.neuronsHL)")
                    print("#### LearningRate: \(NeuralNetController.learningRate)")
                    
                }
            }
        }
        
        return stringParaTextView
    
    }
    
    
}
