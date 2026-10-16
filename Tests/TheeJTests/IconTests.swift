#if canImport(AppKit)
import AppKit
import Testing
@testable import TheeJ

// In the menu bar, mixer and dial are not templates yet stay black on a light menu bar and white on a dark one.
@Test(arguments: IconStyle.allCases.filter { $0 != .app }, [false, true])
func menuBarIconFollowsTheMenuBar(style: IconStyle, parked: Bool) {
    let icon = menuBarIcon(style, parked: parked)
    #expect(!icon.isTemplate)
    #expect(ink(icon, .aqua) < 0.5 && ink(icon, .darkAqua) > 0.5)
}

// The profile HUD shows where the profile sits as WeeJ's does: dots up to 9 profiles, then "n/m", and nothing for one.
@Test func profileHUDCountsAsWeeJDoes() {
    #expect(profilePlace(0, of: 1) == (0, nil) && profilePlace(1, of: 2) == (2, nil) && profilePlace(8, of: 9) == (9, nil))
    #expect(profilePlace(1, of: 10) == (0, "2/10"))
}

// The colour of the icon's most opaque pixel, drawn under `appearance`.
private func ink(_ icon: NSImage, _ appearance: NSAppearance.Name) -> CGFloat {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(icon.size.width), pixelsHigh: Int(icon.size.height),
                               bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
                               bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
    NSAppearance(named: appearance)!.performAsCurrentDrawingAppearance { icon.draw(at: .zero, from: .zero, operation: .copy, fraction: 1) }
    NSGraphicsContext.current = nil
    let pixels = (0..<rep.pixelsHigh).flatMap { y in (0..<rep.pixelsWide).map { x in rep.colorAt(x: x, y: y)! } }
    return pixels.max { $0.alphaComponent < $1.alphaComponent }!.redComponent
}
#endif
