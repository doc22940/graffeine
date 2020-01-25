import UIKit

open class GraffeinePlotLayer: GraffeineLayer {

    public var unitWidth: GraffeineLayer.DimensionalUnit = .relative

    public var diameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)

    override open func generateSublayer() -> CALayer {
        return Plot()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.values.count

        for (index, plot) in sublayers.enumerated() {
            guard let plot = plot as? Plot, index < numberOfUnits else { continue }
            plot.frame = self.bounds

            plot.diameter = resolveDiameter(diameter: diameter, bounds: bounds)

            unitFill.apply(to: plot)
            unitLine.apply(to: plot)
            unitShadow.apply(to: plot)

            applySelectionState(plot, index: index)
            applyRadialSelectionState(plot, index: index)

            plot.reposition(for: index,
                            in: data,
                            unitWidth: unitWidth,
                            unitMargin: unitMargin,
                            containerSize: bounds.size,
                            animator: animator as? GraffeinePlotDataAnimating)
        }
    }

    open func applyRadialSelectionState(_ plot: Plot, index: Int) {
        if (data.selectedIndex == index) {
            if let selectedDiameter = selection.radial.diameter {
                plot.diameter = resolveDiameter(diameter: selectedDiameter, bounds: bounds)
            }
        }
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, region: Region = .main) {
        self.init()
        self.id = id
        self.region = region
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.unitWidth = layer.unitWidth
            self.diameter = layer.diameter
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePlotLayer) -> ()) -> GraffeinePlotLayer {
        conf(self)
        return self
    }
}
