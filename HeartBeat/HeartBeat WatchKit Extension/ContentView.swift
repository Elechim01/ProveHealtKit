//
//  ContentView.swift
//  HeartBeat WatchKit Extension
//
//  Created by Michele Manniello on 08/08/21.
//

import SwiftUI
import HealthKit

//struct ContentView: View {
//    private var healtStore = HKHealthStore()
//    let heartRateQuantity = HKUnit(from: "count/min")
//    @State private var value = 0
//    var body: some View {
//        VStack{
//            HStack{
//                Text("❤️")
//                    .font(.system(size: 50))
//                Spacer()
//            }
//            HStack{
//                Text("\(value)")
//                    .fontWeight(.regular)
//                    .font(.system(size: 70))
//                Text("BPM")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                    .foregroundColor(.red)
//                    .padding(.bottom,28.0)
//                Spacer()
//            }
//        }
//        .padding()
//        .onAppear(perform: {
//            start()
//        })
//    }
//    func start(){
//        autorizaHealtKit()
//        startHeartRatequery(quantityTypeIdentifier: .heartRate)
//    }
//
//    func autorizaHealtKit(){
////        used ti define the identifiers thart create quantity type objects.
//        let heathKitTypes : Set = [
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
//        ]
////        Request permission to save e read the specify data types
//        healtStore.requestAuthorization(toShare: heathKitTypes, read: heathKitTypes) { succed, error in
//            print("Error\(String(describing: error))")
//        }
//    }
//    private func startHeartRatequery(quantityTypeIdentifier: HKQuantityTypeIdentifier){
////        We want data poitns from our current device
//        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
////        A query that returns change to the healtKit store, including a sanpshot of new changes and continus moniotring as a long-running query.
//        let updateHandler : (HKAnchoredObjectQuery,[HKSample]?,[HKDeletedObject]?,HKQueryAnchor?,Error?) -> Void = { query,samples,deletedObjects,queryAnchor,error in
////            A sample that represent a quantity including the value an the units.
//            guard let samples = samples as? [HKQuantitySample] else {
//                return
//            }
//            self.process(samples,type: quantityTypeIdentifier)
//        }
////        it provides us with both the ability to recive a sanpshot of data, and then on subsequent calls, a snapshot of what has changed.
//        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
//        query.updateHandler = updateHandler
////        esecuzione query
//        healtStore.execute(query)
//    }
//    private func process(_ samples: [HKQuantitySample],type: HKQuantityTypeIdentifier){
////        variable initialization
//        var lastheartRate = 0.0
////        cycle and value assignemnt
//        for sample in samples{
//            if type == .heartRate{
//                lastheartRate = sample.quantity.doubleValue(for: heartRateQuantity)
//            }
//            self.value = Int(lastheartRate)
//        }
//    }
//}
struct ContentView: View {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @State private var value = 0
    
    var body: some View {
        VStack{
            HStack{
                Text("❤️")
                    .font(.system(size: 50))
                Spacer()

            }
            
            HStack{
                Text("\(value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
                
                Spacer()
                
            }

        }
        .padding()
        .onAppear(perform: start)
    }

    
    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
            
        self.process(samples, type: quantityTypeIdentifier)

        }
        
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        
        query.updateHandler = updateHandler
        
        // 5
        
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            
            self.value = Int(lastHeartRate)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
