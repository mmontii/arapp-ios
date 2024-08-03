import SwiftUI

// View displaying a single row for a building in a list
struct BuildingRowView: View {
    var building: Building  // The building to display in this row
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // AsyncImage to load and display the building's image
            AsyncImage(url: URL(string: building.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
            
            // VStack for the building details
            VStack(alignment: .leading, spacing: 5) {
                Text(building.name)
                    .font(.headline)  // Building name as a headline
                Text(building.address)
                    .font(.subheadline)  // Building address as subheadline
                    .lineLimit(2)  // Limit address to 2 lines
                Text(building.campus)
                    .font(.footnote)  // Campus name as a footnote
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 1)
    }
}
