import SwiftUI

struct TestView: View {
    let tags = [
        "PRIVACY",
        "TECHNOLOGY",
        "CONSTITUTIONAL LAW",
        "FACEBOOK",
        "GOOGLE",
        "SNAPCHAT",
        "Twitter"
    ]
    var body: some View {
        CreditsStack(rows: 2) {
            ForEach(tags, id: \.self) { tag in
                Text(tag.description)
                    .padding(5)
                    .background(Rectangle().stroke())
                    .foregroundColor(.gray)
            }
        }
    }
    
    struct TestView_Previews: PreviewProvider {
        static var previews: some View {
            TestView()
        }
    }
    
    
    struct CreditsStack: Layout {
        var rows: Int
        var spacing: Double
        
        init(rows: Int = 3, spacing: Double = 10) {
            self.rows = max(1, rows)
            self.spacing = spacing
        }
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
            let height = proposal.replacingUnspecifiedDimensions().height
            let viewFrames = frames(for: subviews, in: height)
            let width = viewFrames.max { $0.maxX < $1.maxX } ?? .zero
            return CGSize(width: width.maxX, height: height)
        }
        
        func placeSubviews(in bounds: CGRect, proposal _: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
            let viewFrames = frames(for: subviews, in: bounds.height)
            
            for index in subviews.indices {
                let frame = viewFrames[index]
                let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY)
                subviews[index].place(at: position, proposal: ProposedViewSize(frame.size))
            }
        }
        
        func frames(for subviews: Subviews, in totalHeight: Double) -> [CGRect] {
            let totalSpacing = spacing * Double(rows - 1)
            let rowHeight = (totalHeight - totalSpacing) / Double(rows)
            let rowHeightWithSpacing = rowHeight + spacing
            let proposedSize = ProposedViewSize(width: nil, height: rowHeight)
            
            var viewFrames = [CGRect]()
            var rowWidths = Array(repeating: 0.0, count: rows)
            
            for subview in subviews {
                var selectedRow = 0
                var selectedWidth = Double.greatestFiniteMagnitude
                
                for (rowIndex, width) in rowWidths.enumerated() {
                    if width < selectedWidth {
                        selectedRow = rowIndex
                        selectedWidth = width
                    }
                }
                
                let x = rowWidths[selectedRow]
                let y = Double(selectedRow) * rowHeightWithSpacing
                let size = subview.sizeThatFits(proposedSize)
                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                
                rowWidths[selectedRow] += size.width + spacing
                viewFrames.append(frame)
            }
            
            return viewFrames
        }
    }
}

