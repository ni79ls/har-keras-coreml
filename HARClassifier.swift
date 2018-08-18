//
// HARClassifier.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class HARClassifierInput : MLFeatureProvider {

    /// acceleration as 240 element vector of doubles
    public var acceleration: MLMultiArray

    public var featureNames: Set<String> {
        get {
            return ["acceleration"]
        }
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "acceleration") {
            return MLFeatureValue(multiArray: acceleration)
        }
        return nil
    }

    public init(acceleration: MLMultiArray) {
        self.acceleration = acceleration
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class HARClassifierOutput : MLFeatureProvider {

    /// Probability of each activity as dictionary of strings to doubles
    public let output: [String : Double]

    /// Labels of activity as string value
    public let classLabel: String

    public var featureNames: Set<String> {
        get {
            return ["output", "classLabel"]
        }
    }

    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "output") {
            return try! MLFeatureValue(dictionary: output as [NSObject : NSNumber])
        }
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        return nil
    }

    init(output: [String : Double], classLabel: String) {
        self.output = output
        self.classLabel = classLabel
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class HARClassifier {
    var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: HARClassifier.self)
        let assetPath = bundle.url(forResource: "HARClassifier", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as HARClassifierInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as HARClassifierOutput
    */
    public func prediction(input: HARClassifierInput) throws -> HARClassifierOutput {
        let outFeatures = try model.prediction(from: input)
        let result = HARClassifierOutput(output: outFeatures.featureValue(for: "output")!.dictionaryValue as! [String : Double], classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue)
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - acceleration as 240 element vector of doubles
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as HARClassifierOutput
    */
    public func prediction(acceleration: MLMultiArray) throws -> HARClassifierOutput {
        let input_ = HARClassifierInput(acceleration: acceleration)
        return try self.prediction(input: input_)
    }
}
