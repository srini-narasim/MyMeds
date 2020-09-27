/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A view showing the details for a medication.
 */

import SwiftUI

extension Medicine {
//    @NSManaged public var name: String?
    public var wrappedName: String {
        get{name ?? "NoName"}
        set{name = newValue}
    }
}

struct TopView: View {
    @ObservedObject var medication: FetchedResults<Medicine>.Element

    var body: some View {
        //        CircleImage(image: medication.image)
        //            .padding(.top)
        HStack() {
            TextField("Enter text", text: $medication.wrappedName)
            Text(verbatim: medication.name ?? "name")
                .font(.title)
            EssentailButtonView(medication: medication)
            Spacer()
        }
    }
}

struct EssentailButtonView: View {
    var medication: FetchedResults<Medicine>.Element
    //    var medicationindex: Int {
    //        userData.medications.firstIndex(where: { $0.id == medication.id })!
    //    }
    
    var body: some View {
        Button(action: {
            medication.essentail.toggle()
        }) {
            if medication.essentail {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            } else {
                Image(systemName: "star")
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct DosageView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        let frequency = medication.frequeny
        Section(header: Text("Dosage")
                    .font(.subheadline)
        ) {
            HStack(alignment: .top) {
                let dose = medication.dosage
                let dosageString = "\(dose) \(medication.kind ?? "kind")"
                Text(dosageString)
                    .font(.subheadline)
                if frequency == 1 {
                    Text("Every Hour")
                } else {
                    Text("Every \(frequency)")
                    
                }
                Spacer()
            }
            .padding(.top, 2.0)
        }
    }
}

struct FrequencyView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        HStack(alignment: .top) {
            let frequency = medication.frequeny
            let interval = medication.interval
            Text("Frequency:")
                .font(.headline)
            if frequency == 1 {
                Text("Every Hour")
            } else {
                Text("Every \(frequency)")
                
            }
            Spacer()
        }
        
    }
}

struct RemainingView: View {
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        HStack {
            Text("Remaining: ")
                .font(.headline)
            Text("\(medication.quantity)")
            Text("\(medication.kind ?? "kind")s")
            Spacer()
        }
    }
}

struct RefillView: View {
    var medication: FetchedResults<Medicine>.Element
    static var formatter = DateFormatter()
    var body: some View {
        let refilled = medication.refilled
        //        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        //        formatter.timeStyle = .short
        
        HStack {
            //            Self.formatter.dateStyle = .long
            Text("Refill Date: ")
            if #available(iOS 14.0, *) {
                Text(Date().addingTimeInterval(0),style: .date)
            } else {
                // Fallback on earlier versions
            }
            Spacer()
        }
    }
}

struct NotifyButtonOnOff: ButtonStyle {
    let onoff: Bool
    
    init(_ switsh: Bool) {
        self.onoff = switsh
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 110, height: 35, alignment: .center)
            .background(self.onoff ? Color.blue : Color.white)
            .foregroundColor(self.onoff ? Color.white : Color.gray)
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30) .stroke(self.onoff ? Color.blue : Color.gray, lineWidth: 1))
    }
}

struct NotifyButtonView: View {
    @EnvironmentObject var userData: UserData
    @State private var n = true
    var medication: FetchedResults<Medicine>.Element
    var body: some View {
        Toggle(isOn: $n) {
            Text("Notify")
        }
    }
}


struct NotifyView: View {
    var medication: FetchedResults<Medicine>.Element
    @State internal var recipeName: String = ""
    @State internal var ingredient: String = ""
    @State internal var ingredients = [String]()
    var body: some View {
        Text("Notification")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
        HStack {
            Spacer()
        }
        Form {
            Section(header: Text("Notify at percentage left")) {
                TextField("enter percentage", text: $recipeName)
            }
            NotifyButtonView(medication: medication)
        }
        
    }
}

struct MedicationDetail: View {
    var medication: FetchedResults<Medicine>.Element
    
    var body: some View {
        VStack() {
            VStack() {
                TopView(medication: medication)
                DosageView(medication: medication)
                FrequencyView(medication: medication)
                RemainingView(medication: medication)
                RefillView(medication: medication)
                NotifyView(medication: medication)
            }
            Spacer()
        }
    }
}




struct MedicationDetail_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) private var viewContext
    
    static var previews: some View {
        let p = PersistenceController.preview1
//        MedicationDetail(medication:p.container.)
    }
    
}
