//
//  NeuralNetController.swift
//  MWGuerraNeuralSim
//
//  Created by Marcelo Wanderley Guerra on 08/10/17.
//  Copyright © 2017 Marcelo Wanderley Guerra. All rights reserved.
//

import UIKit
import Accelerate

class NeuralNetController: NSObject {

    // Passar dados entre tabs
    // Usando uma classe separada: https://www.youtube.com/watch?v=Y4uwTdivl64

    // Training Data
    static var trainEpochs = 500
    static var neuronsHL = 2
    static var learningRate = 0.4
    static var inputLabels = ["Entrada #1", "Entrada #2", "Entrada #3"]
    static var outputLabels = ["Saída #1"]
    static var inputData = [[Double]]()
    static var outputData = [[Double]]()
    static var trainedResults = ["Rede não treinada"]
    static var trainedResultsFCU = ["Rede não treinada"] // Apenas para a dissertação da FCU
    static var network:Network?
    static var isTrained = false    // Verifica se a rede está treinada, para não travar o App ao mandar executar uma rede não treinada.
    static var isTraining = false   // Verifica se está treinando para controlar a habilitação ou não dos botões. Desabilita os botões se estiver trainando pra não dar problema.
    static var actFunction = "Sigmóide"
    
    // http://www.electronics-tutorials.ws/category/logic
    
    // ** XOR Padrão
    static let xorInputData = [[0.0,0.0,0.0],
                               [0.0,0.0,1.0],
                               [0.0,1.0,0.0],
                               [0.0,1.0,1.0],
                               [1.0,0.0,0.0],
                               [1.0,0.0,1.0],
                               [1.0,1.0,0.0],
                               [1.0,1.0,1.0]]
    static let xorOutputData = [[0.0],
                                [1.0],
                                [1.0],
                                [0.0],
                                [1.0],
                                [0.0],
                                [0.0],
                                [1.0]]
 
    // ** AND Padrão
    static let andInputData = [[0.0,0.0,0.0],
                               [0.0,0.0,1.0],
                               [0.0,1.0,0.0],
                               [0.0,1.0,1.0],
                               [1.0,0.0,0.0],
                               [1.0,0.0,1.0],
                               [1.0,1.0,0.0],
                               [1.0,1.0,1.0]]
    static let andOutputData = [[0.0],
                                [0.0],
                                [0.0],
                                [0.0],
                                [0.0],
                                [0.0],
                                [0.0],
                                [1.0]]
    
    // ** OR Padrão
    static let orInputData = [[0.0,0.0,0.0],
                              [0.0,0.0,1.0],
                              [0.0,1.0,0.0],
                              [0.0,1.0,1.0],
                              [1.0,0.0,0.0],
                              [1.0,0.0,1.0],
                              [1.0,1.0,0.0],
                              [1.0,1.0,1.0]]
    static let orOutputData = [[0.0],
                               [1.0],
                               [1.0],
                               [1.0],
                               [1.0],
                               [1.0],
                               [1.0],
                               [1.0]]
    
    // ** Vendas Padrão
    
    // Normalização das variáveis de entrada
    // - Salário: x/10000
    // - Sexo: Masculino = 0 ; Feminino = 1
    // - Idade (18 a 70): x/100
    // - (NÃO UTILIZADO) Estado Civil: Solteiro = 0; Separado = 0.33 ; Casado = 0.66 ; Viúvo = 1
    // Normalização das variáveis de entrada
    // - Cliente frequente: NÃO = 0 ; SIM = 1

    // http://www.mockaroo.com/
    // Dados utilizados para gerar os dados fictícios (1000 linhas - Excel):
    // Salário:     Money   entre 900 e 12000
    // Sexo:        Gender
    // Idade:       Number  entre 18 e 70
    // Clnte Freq:  Boolean
    
    // [Salário, Sexo, Idade, Cliente Frequente (SAÍDA)]
    
    static let vendasInputData:[[Double]] = [[0.303545,1,0.69], // [3035,45,Female,69,FALSE]  :: [0.303545,1,0.69,0]
                                             [0.492854,1,0.61], // [4928,54,Female,61,FALSE]  :: [0.492854,1,0.61,0]
                                             [0.87872,0,0.2],   // [8787,2,Male,20,TRUE]      :: [0.87872,0,0.2,1]
                                             [0.738387,1,0.18], // [7383,87,Female,18,FALSE]  :: [0.738387,1,0.18,0]
                                             [0.685496,0,0.31], // [6854,96,Male,31,TRUE]     :: [0.685496,0,0.31,1]
                                             [0.192347,0,0.31], // [1923,47,Male,31,TRUE]     :: [0.192347,0,0.31,1]
                                             [0.67486,1,0.22],  // [6748,6,Female,22,TRUE]    :: [0.67486,1,0.22,1]
                                             [0.312014,1,0.68], // [3120,14,Female,68,FALSE]  :: [0.312014,1,0.68,0]
                                             [0.572383,1,0.46], // [5723,83,Female,46,FALSE]  :: [0.572383,1,0.46,0]
                                             [0.954982,0,0.32], // [9549,82,Male,32,TRUE]     :: [0.954982,0,0.32,1]
                                             [0.364274,0,0.69], // [3642,74,Male,69,TRUE]     :: [0.364274,0,0.69,1]
                                             [0.685901,1,0.69], // [6859,01,Female,69,FALSE]  :: [0.685901,1,0.69,0]
                                             [0.534114,0,0.35], // [5341,14,Male,35,TRUE]     :: [0.534114,0,0.35,1]
                                             [0.690853,1,0.46], // [6908,53,Female,46,FALSE]  :: [0.690853,1,0.46,0]
                                             [0.697742,1,0.49], // [6977,42,Female,49,FALSE]  :: [0.697742,1,0.49,0]
                                             [1.074086,1,0.29], // [10740,86,Female,29,FALSE] :: [1.074086,1,0.29,0]
                                             [0.263181,1,0.22], // [2631,81,Female,22,FALSE]  :: [0.263181,1,0.22,0]
                                             [0.265828,0,0.36], // [2658,28,Male,36,TRUE]     :: [0.265828,0,0.36,1]
                                             [0.230441,1,0.35], // [2304,41,Female,35,FALSE]  :: [0.230441,1,0.35,0]
                                             [0.317267,0,0.19], // [3172,67,Male,19,TRUE]     :: [0.317267,0,0.19,1]
                                             [0.679807,1,0.49], // [6798,07,Female,49,FALSE]  :: [0.679807,1,0.49,0]
                                             [0.698265,1,0.58], // [6982,65,Female,58,FALSE]  :: [0.698265,1,0.58,0]
                                             [1.088765,1,0.42], // [10887,65,Female,42,FALSE] :: [1.088765,1,0.42,0]
                                             [0.766463,1,0.53], // [7664,63,Female,53,FALSE]  :: [0.766463,1,0.53,0]
                                             [0.406304,1,0.49], // [4063,04,Female,49,FALSE]  :: [0.406304,1,0.49,0]
                                             [0.896704,0,0.18], // [8967,04,Male,18,TRUE]     :: [0.896704,0,0.18,1]
                                             [1.048532,1,0.3],  // [10485,32,Female,30,FALSE] :: [1.048532,1,0.3,0]
                                             [0.848672,0,0.24], // [8486,72,Male,24,TRUE]     :: [0.848672,0,0.24,1]
                                             [0.800097,0,0.44], // [8000,97,Male,44,FALSE]    :: [0.800097,0,0.44,0]
                                             [0.398515,0,0.42], // [3985,15,Male,42,FALSE]    :: [0.398515,0,0.42,0]
                                             [0.221064,0,0.41], // [2210,64,Male,41,FALSE]    :: [0.221064,0,0.41,0]
                                             [1.031242,0,0.31], // [10312,42,Male,31,TRUE]    :: [1.031242,0,0.31,1]
                                             [0.727013,1,0.46], // [7270,13,Female,46,FALSE]  :: [0.727013,1,0.46,0]
                                             [0.973554,0,0.31], // [9735,54,Male,31,TRUE]     :: [0.973554,0,0.31,1]
                                             [0.255025,0,0.4],  // [2550,25,Male,40,TRUE]     :: [0.255025,0,0.4,1]
                                             [0.154951,0,0.5],  // [1549,51,Male,50,TRUE]     :: [0.154951,0,0.5,1]
                                             [1.052477,0,0.61], // [10524,77,Male,61,TRUE]    :: [1.052477,0,0.61,1]
                                             [0.177783,0,0.27]] // [1777,83,Male,27,FALSE]    :: [0.177783,0,0.27,0]
    
    static let vendasOutputData:[[Double]] = [[0], // [3035,45,Female,69,FALSE]  :: [0.303545,1,0.69,0]
                                              [0], // [4928,54,Female,61,FALSE]  :: [0.492854,1,0.61,0]
                                              [1], // [8787,2,Male,20,TRUE]      :: [0.87872,0,0.2,1]
                                              [0], // [7383,87,Female,18,FALSE]  :: [0.738387,1,0.18,0]
                                              [1], // [6854,96,Male,31,TRUE]     :: [0.685496,0,0.31,1]
                                              [1], // [1923,47,Male,31,TRUE]     :: [0.192347,0,0.31,1]
                                              [1], // [6748,6,Female,22,TRUE]    :: [0.67486,1,0.22,1]
                                              [0], // [3120,14,Female,68,FALSE]  :: [0.312014,1,0.68,0]
                                              [0], // [5723,83,Female,46,FALSE]  :: [0.572383,1,0.46,0]
                                              [1], // [9549,82,Male,32,TRUE]     :: [0.954982,0,0.32,1]
                                              [1], // [3642,74,Male,69,TRUE]     :: [0.364274,0,0.69,1]
                                              [0], // [6859,01,Female,69,FALSE]  :: [0.685901,1,0.69,0]
                                              [1], // [5341,14,Male,35,TRUE]     :: [0.534114,0,0.35,1]
                                              [0], // [6908,53,Female,46,FALSE]  :: [0.690853,1,0.46,0]
                                              [0], // [6977,42,Female,49,FALSE]  :: [0.697742,1,0.49,0]
                                              [0], // [10740,86,Female,29,FALSE] :: [1.074086,1,0.29,0]
                                              [0], // [2631,81,Female,22,FALSE]  :: [0.263181,1,0.22,0]
                                              [1], // [2658,28,Male,36,TRUE]     :: [0.265828,0,0.36,1]
                                              [0], // [2304,41,Female,35,FALSE]  :: [0.230441,1,0.35,0]
                                              [1], // [3172,67,Male,19,TRUE]     :: [0.317267,0,0.19,1]
                                              [0], // [6798,07,Female,49,FALSE]  :: [0.679807,1,0.49,0]
                                              [0], // [6982,65,Female,58,FALSE]  :: [0.698265,1,0.58,0]
                                              [0], // [10887,65,Female,42,FALSE] :: [1.088765,1,0.42,0]
                                              [0], // [7664,63,Female,53,FALSE]  :: [0.766463,1,0.53,0]
                                              [0], // [4063,04,Female,49,FALSE]  :: [0.406304,1,0.49,0]
                                              [1], // [8967,04,Male,18,TRUE]     :: [0.896704,0,0.18,1]
                                              [0], // [10485,32,Female,30,FALSE] :: [1.048532,1,0.3,0]
                                              [1], // [8486,72,Male,24,TRUE]     :: [0.848672,0,0.24,1]
                                              [0], // [8000,97,Male,44,FALSE]    :: [0.800097,0,0.44,0]
                                              [0], // [3985,15,Male,42,FALSE]    :: [0.398515,0,0.42,0]
                                              [0], // [2210,64,Male,41,FALSE]    :: [0.221064,0,0.41,0]
                                              [1], // [10312,42,Male,31,TRUE]    :: [1.031242,0,0.31,1]
                                              [0], // [7270,13,Female,46,FALSE]  :: [0.727013,1,0.46,0]
                                              [1], // [9735,54,Male,31,TRUE]     :: [0.973554,0,0.31,1]
                                              [1], // [2550,25,Male,40,TRUE]     :: [0.255025,0,0.4,1]
                                              [1], // [1549,51,Male,50,TRUE]     :: [0.154951,0,0.5,1]
                                              [1], // [10524,77,Male,61,TRUE]    :: [1.052477,0,0.61,1]
                                              [0]] // [1777,83,Male,27,FALSE]    :: [0.177783,0,0.27,0]
    
    // Configura um padrão de dados de treinamento, completo, pré-definido
    class func configTrainingPreset (presetType:String) {
        switch presetType {
        case "and":
            NeuralNetController.inputData = NeuralNetController.andInputData
            NeuralNetController.outputData = NeuralNetController.andOutputData
            NeuralNetController.inputLabels = ["Entrada #1", "Entrada #2", "Entrada #3"]
            NeuralNetController.outputLabels = ["Saída #1"]
        case "or":
            NeuralNetController.inputData = NeuralNetController.orInputData
            NeuralNetController.outputData = NeuralNetController.orOutputData
            NeuralNetController.inputLabels = ["Entrada #1", "Entrada #2", "Entrada #3"]
            NeuralNetController.outputLabels = ["Saída #1"]
        case "xor":
            NeuralNetController.inputData = NeuralNetController.xorInputData
            NeuralNetController.outputData = NeuralNetController.xorOutputData
            NeuralNetController.inputLabels = ["Entrada #1", "Entrada #2", "Entrada #3"]
            NeuralNetController.outputLabels = ["Saída #1"]
        case "vendas":
            NeuralNetController.inputData = NeuralNetController.vendasInputData
            NeuralNetController.outputData = NeuralNetController.vendasOutputData
            NeuralNetController.inputLabels = ["Salário", "Sexo", "Idade"]
            NeuralNetController.outputLabels = ["Cliente Frequente"]
        default:
            NeuralNetController.inputData = NeuralNetController.xorInputData
            NeuralNetController.outputData = NeuralNetController.xorOutputData
        }
    }
    
    
    // Funções para adicionar e remover dados a partir da tableview de dados de treino
    class func addData (trainingData:[Double], expectedOutput:[Double]) {
        NeuralNetController.inputData.append(trainingData)
        NeuralNetController.outputData.append(expectedOutput)
    }
    
    class func removeData (atIndex:Int) {
        NeuralNetController.inputData.remove(at: atIndex)
        NeuralNetController.outputData.remove(at: atIndex)
    }

    // ## Funções de ativação ################
    // Linear                   : return x
    // Gaussiana                : return exp(-((xˆ2)/(2)))
    // Sigmóide                 : return 1.0 / (1.0 + exp(-x))
    // Degrau                   : return
    //      if x < 0 { resp = 0 }
    //      if x >= 0 { resp = 1 }
    // Degrau Bipolar           : return
    //      if x < 0 { resp = -1 }
    //      if x = 0 { resp = 0 }
    //      if x > 0 { resp = 1 }
    // Tangente Hiperbólica     : return tanh(x)
    // Retificadora Linear      : return
    //      if x < 0 { resp = 0 }
    //      if x >= 0 { resp = x }
    
    // Gaussiana, Sigmóide e Tangente Hiperbólica
    // https://theclevermachine.wordpress.com/tag/backpropagation-algorithm/
    
    // Varia no x: -2 a +2
    // Varia no y: 0 a 1
    class func sigmoidFunction(_ x: Double) -> Double {
        return 1.0 / (1.0 + exp(-x))
    }
    
    class func derivativeSigmoidFunction(_ x: Double) -> Double {
        return NeuralNetController.sigmoidFunction(x) * (1 - NeuralNetController.sigmoidFunction(x))
    }

    // Varia no x: -2 a +2
    // Varia no y: 0 a 1
    class func gaussianFunction(_ x: Double) -> Double {
        return exp(-(pow(x ,2)))
    }
    
    class func derivativeGaussianFunction(_ x: Double) -> Double {
        return (-2 * (exp(-(pow(x, 2)))))
    }
    
    // Varia no x: -1.5 a +1.5
    // Varia no y: -1 a 1
    class func tanhFunction(_ x: Double) -> Double {
        return tanh(x)
    }
    
    class func derivativeTanhFunction(_ x: Double) -> Double {
        return (1 - (pow(tanh(x), 2)))
    }

    // #######################################
    
    class func randomWeights(number: Int) -> [Double] {
        return (0..<number).map{ _ in Double(arc4random()) / Double(UInt32.max)}
    }
    
    class func trainNetwork() {
        
        // ALTERAR AQUI A FUNCAO DE ATIVAÇÃO
        
        NeuralNetController.network = Network(layerStructure: [3,NeuralNetController.neuronsHL,1], activationFunction: NeuralNetController.sigmoidFunction, derivativeActivationFunction: NeuralNetController.derivativeSigmoidFunction, learningRate: NeuralNetController.learningRate)
        
        for _ in 0..<NeuralNetController.trainEpochs {
            NeuralNetController.network!.train(inputs: NeuralNetController.inputData, expecteds: NeuralNetController.outputData)
        }
        
        /*
         print ("\n\n=============================")
         print ("\nWeights of hidden layer")
         for neuron in NeuralNetController.network!.layers[1].neurons {
         print("\(neuron.weights)")
         }
         
         print ("\n\n=============================")
         print ("\nWeights of output layer")
         for neuron in NeuralNetController.network!.layers[2].neurons {
         print("\(neuron.weights)\n")
         }
         print ("\n\n=============================")
         */
        
        NeuralNetController.trainedResults.removeAll()
        NeuralNetController.trainedResultsFCU.removeAll()   // Apenas para a dissertação da FCU. Sem utilidade para o App.

        for i in 0..<NeuralNetController.inputData.count {
            let results = NeuralNetController.network!.validate(input: NeuralNetController.inputData[i], expected: NeuralNetController.outputData[i][0])
            
            let trainedResult = "Entrada:\(NeuralNetController.inputData[i])\nSaída:\(results.result)\nEsperado:\(results.expected)\n\n"
            let trainedResultFCU = "\(results.result)\n"
            
            // print(trainedResult)
            
            // Salva o texto para mostrar na view de informações
            NeuralNetController.trainedResults.append(trainedResult)
            NeuralNetController.trainedResultsFCU.append(trainedResultFCU)    // Apenas para a dissertação da FCU. Sem utilidade para o App.
        }
    }
    
    // Subdivisão de trainNetwork para mostrar a evolução em progressViews.
    // 1. trainNetworkPrepare
    // 2. trainNetworkSteps
    // 3. trainNetworkFinish
    // trainNetwork continua fazendo o trabalho completo se não quiser usar o trainNetworkStep
    class func trainNetworkPrepare() {
        NeuralNetController.network = Network(layerStructure: [3,NeuralNetController.neuronsHL,1], activationFunction: NeuralNetController.sigmoidFunction, derivativeActivationFunction: NeuralNetController.derivativeSigmoidFunction, learningRate: NeuralNetController.learningRate)
    }
    
    // Subdivisão de trainNetwork para mostrar a evolução em progressViews.
    // 1. trainNetworkPrepare
    // 2. trainNetworkSteps
    // 3. trainNetworkFinish
    // trainNetwork continua fazendo o trabalho completo se não quiser usar o trainNetworkSteps
    // trainNetworkSteps deve ser executado dentro de um loop de Epochs:
    // for _ in 0..<NeuralNetController.trainEpochs { NeuralNetController.trainNetworkSteps() }
    class func trainNetworkSteps() {
        NeuralNetController.network!.train(inputs: NeuralNetController.inputData, expecteds: NeuralNetController.outputData)
    }
    
    // Subdivisão de trainNetwork para mostrar a evolução em progressViews.
    // 1. trainNetworkPrepare
    // 2. trainNetworkSteps
    // 3. trainNetworkFinish
    // trainNetwork continua fazendo o trabalho completo se não quiser usar o trainNetworkStep
    class func trainNetworkFinish() {
        NeuralNetController.trainedResults.removeAll()
        
        for i in 0..<NeuralNetController.inputData.count {
            let results = NeuralNetController.network!.validate(input: NeuralNetController.inputData[i], expected: NeuralNetController.outputData[i][0])
            
            let trainedResult = "Entrada:\(NeuralNetController.inputData[i])\nSaída:\(results.result)\nEsperado:\(results.expected)\n\n"
            
            // print(trainedResult)
            
            // Salva o texto para mostrar na view de informações
            NeuralNetController.trainedResults.append(trainedResult)
        }
    }
    
    class func runNeuralNet(inputData:[Double]) -> Double {
        
        let results = NeuralNetController.network!.runData(input: inputData)

        // print ("\n\n=============================")
        // print("For input:\(inputData) the prediction is:\(results)")
        
        return results
    }
}

// Neurônio
class Neuron {
    var weights: [Double]
    var activationFunction: (Double) -> Double
    var derivativeActivationFunction: (Double) -> Double
    var delta: Double = 0.0
    var inputCache: Double = 0.0
    var learningRate: Double
    init(weights: [Double],
         activationFunction: @escaping (Double) -> Double,
         derivativeActivationFunction: @escaping (Double) -> Double,
         learningRate: Double) {
        
        self.weights = weights
        self.activationFunction = activationFunction
        self.derivativeActivationFunction = derivativeActivationFunction
        self.learningRate = learningRate
    }
}
extension Neuron {
    func neuronOutput(inputs: [Double]) -> Double {
        
        ////////////////////////
        // GUERRA
        
        // print(". Neurônio: \(inputs)")
        
        // Sigmóide: converte de 0 a 1 (saída padrão da função sigmóide) para os sinais aceitos na entrada (-2 a +2)
        let normalizedInputs = inputs.map { ($0 * 4) - 2.0 }
        
        // Tanh
        // inputs.map($0 * 1.5)

        inputCache = zip(normalizedInputs, self.weights).map(*).reduce(0, +)
        
        // GUERRA
        ////////////////////////
        
        // inputCache = zip(inputs, self.weights).map(*).reduce(0, +)   // Comentado por Guerra - linha original
        return activationFunction(inputCache)
    }
}

// Camadas
class Layer {
    let previousLayer: Layer?
    var neurons: [Neuron]
    var layerOutputCache: [Double]
    
    init(previousLayer: Layer? = nil,
         numberOfNeurons: Int,
         activationFunction: @escaping (Double) -> Double,
         derivativeActivationFunction: @escaping (Double)-> Double,
         learningRate: Double) {
        
        self.previousLayer = previousLayer
        self.neurons = Array<Neuron>()
        for _ in 0..<numberOfNeurons {
            self.neurons.append (Neuron(weights: NeuralNetController.randomWeights(number: previousLayer?.neurons.count ?? 0),
                                        activationFunction: activationFunction,
                                        derivativeActivationFunction: derivativeActivationFunction,
                                        learningRate: learningRate))
        }
        self.layerOutputCache = Array<Double>(repeating: 0.0,
                                              count: neurons.count)
    }
    
    func outputSinapses(inputs: [Double]) -> [Double] {
        
        ////////////////////////
        // GUERRA
        
        /*
        print()
        if previousLayer == nil { //Input layer
            print(":: Layer INICIAL")
        } else { //Hidden and output layers
            print(":: Layer Hidden ou Saída")
        }
         */
        
        // GUERRA
        ////////////////////////
        
        if previousLayer == nil { //Input layer
            layerOutputCache = inputs
        } else { //Hidden and output layers
            layerOutputCache = neurons.map { $0.neuronOutput(inputs: inputs) }
        }
        return layerOutputCache
    }
    
    func calculateDeltasForOutputLayer(expected: [Double]) {
        for n in 0..<neurons.count {
            neurons[n].delta = neurons[n].derivativeActivationFunction( neurons[n].inputCache) * (expected[n] - layerOutputCache[n])
        }
    }
    
    //Backward propagation deltas calc
    func calculateDeltasForHiddenLayer(nextLayer: Layer) {
        for (index, neuron) in neurons.enumerated() {
            let nextWeights = nextLayer.neurons.map { $0.weights[index] }
            let nextDeltas = nextLayer.neurons.map { $0.delta }
            let sumOfWeightsXDeltas = zip(nextWeights, nextDeltas).map(*).reduce(0, +)
            neuron.delta = neuron.derivativeActivationFunction( neuron.inputCache) * sumOfWeightsXDeltas
        }
    }
}

// Rede Neural
class Network {
    var layers: [Layer]
    
    init(layerStructure:[Int],
         activationFunction: @escaping (Double) -> Double = NeuralNetController.sigmoidFunction,
         derivativeActivationFunction: @escaping (Double) -> Double = NeuralNetController.derivativeSigmoidFunction,
         learningRate: Double) {
        
        layers = [Layer]()
        
        //Create input layer
        layers.append (Layer(numberOfNeurons: layerStructure[0],
                             activationFunction: activationFunction,
                             derivativeActivationFunction: derivativeActivationFunction,
                             learningRate: learningRate))
        
        //Create hidden layers and output layer
        for layer in layerStructure.enumerated() where layer.offset != 0 {
            layers.append (Layer(previousLayer: layers[layer.offset - 1],
                                 numberOfNeurons: layer.element,
                                 activationFunction: activationFunction,
                                 derivativeActivationFunction: derivativeActivationFunction,
                                 learningRate: learningRate))
        }
    }
    
    
    func outputs(input: [Double]) -> [Double] {
        return layers.reduce(input) { $1.outputSinapses(inputs: $0) }
    }
    
    
    func backwardPropagationMethod(expected: [Double]) {
        layers.last?.calculateDeltasForOutputLayer(expected: expected)
        for l in 1..<layers.count - 1 {
            layers[l].calculateDeltasForHiddenLayer(nextLayer: layers[l + 1])
        }
    }
    
    func updateWeightsAfterLearn() {
        for layer in layers {
            for neuron in layer.neurons {
                for w in 0..<neuron.weights.count {
                    neuron.weights[w] = neuron.weights[w] + (neuron.learningRate * (layer.previousLayer?.layerOutputCache[w])! * neuron.delta)
                }
            }
        }
    }
    func train(inputs:[[Double]], expecteds:[[Double]]) {
        for (position, input) in inputs.enumerated() {
            let expectedOutputs = expecteds[position]
            let currentOutputs = outputs(input: input)
            let differencesBetweenPredictionAndExpected = zip(currentOutputs, expectedOutputs).map{$0-$1}
            let meanSquaredError = sqrt(differencesBetweenPredictionAndExpected.map{$0*$0}.reduce(0,+))
            // print("Training loss: \(meanSquaredError)")
            backwardPropagationMethod(expected: expectedOutputs)
            updateWeightsAfterLearn()
        }
    }
    func validate(input:[Double], expected:Double) -> (result: Double, expected:Double) {
        let result = outputs(input: input)[0]
        return (result,expected)
    }
    func runData(input:[Double]) -> Double {
        let result = outputs(input: input)[0]
        return result
    }
}


