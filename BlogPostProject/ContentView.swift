//
//  ContentView.swift
//  BlogPostProject
//
//  Created by Michele Manniello on 07/08/21.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State var valori : [Dati] = []
    var body: some View {
        VStack {
           /* Button(action: {
                fetchHealtData()
            }, label: {
                Text("Fetch data")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.white)
            })
 */
//            .frame(width: 350, height: 350)
//            .background(Color.black)
//            .cornerRadius(40)
//            .border(Color.black)
//            .cornerRadius(40)
            List(valori,id:\.self){elemento in
                VStack{
                    Text("\(elemento.valore)")
                    Text("\(elemento.date)")
                }
            }
        }
        .onAppear(perform: {
            fetchHealtData()
        })
    }
    func fetchHealtData() -> Void {
        let healthStore = HKHealthStore()
        if HKHealthStore.isHealthDataAvailable(){
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ])
            healthStore.requestAuthorization(toShare: [], read: readData) { succes, error in
                if succes{
                    let calendar = NSCalendar.current
                    var anchorComponents = calendar.dateComponents([.day,.month,.year,.weekday], from: NSDate() as Date)
                    let offset = (7 + anchorComponents.weekday! - 2) % 7
                    anchorComponents.day! -= offset
                    anchorComponents.hour = 2
                    
                    guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                        fatalError("*** unable to create a valid date from the given components ***")
                    }
                        let interval = NSDateComponents()
                        interval.minute = 30
                        let endDate = Date()
                        guard let startDate = calendar.date(byAdding: .month,value: -1, to: endDate) else {
                            fatalError("*** Unable to calculate a step count type ***")
                        }
                        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                            fatalError("*** Unable ti create a step count type ***")
                        }
                        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                                quantitySamplePredicate: nil,
                                                                options: .discreteAverage,
                                                                anchorDate: anchorDate,
                                                                intervalComponents: interval as DateComponents)
                    query.initialResultsHandler = {
                        query,results,error in
                        guard let statsCollection = results else {
                            fatalError("*** An error occured while calculation the statics:\(String(describing: error?.localizedDescription))***")
                        }
                        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statics, stop in
                            if let quantity = statics.averageQuantity(){
                                let date = statics.startDate
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                print("done")
                                print(value)
                                print(date)
                                self.valori.append(Dati(valore: value, date: date))
                            }
                        }
                    }
                    healthStore.execute(query)
                }else{
                    print("Autorizzazione fallita")
                }
            }
        }else{
            print("NO helatKit data available ")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Dati: Hashable {
    var id = UUID().uuidString
    var valore : Double
    var date : Date
}
