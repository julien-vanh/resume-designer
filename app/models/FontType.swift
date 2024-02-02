//
//  FontType.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 17/08/2021.
//

import Foundation

enum FontType: String, CaseIterable, Identifiable {
    case arial = "Arial"
    case arialNarrow = "Arial Narrow"
    case avantgarde = "Avantgarde"
    case georgia = "Georgia"
    case gill = "Gill Sans"
    case helvetica = "Helvetica"
    case lucida = "Lucida Sans"
    case noto = "Noto Sans"
    case optima = "Optima"
    case palatino = "Palatino"
    case sansSerif = "Sans-serif"
    case tahoma = "Tahoma"
    case timesNewRoman = "Times New Roman"
    case trebuchet = "Trebuchet MS"
    case verdana = "Verdana"

    var id: String { self.rawValue }
    
    static func cssFor(_ option: FontType) -> String {
        switch option {
        case .arial: return "Arial, sans-serif"
        case .helvetica: return "Helvetica, sans-serif"
        case .verdana: return "Verdana, sans-serif"
        case .trebuchet: return "Trebuchet MS, sans-serif"
        case .gill: return "Gill Sans, sans-serif"
        case .noto: return "Noto Sans, sans-serif"
        case .avantgarde: return "Avantgarde, TeX Gyre Adventor, URW Gothic L, sans-serif"
        case .optima: return "Optima, sans-serif"
        case .arialNarrow: return "Arial Narrow, sans-serif"
        case .sansSerif: return "sans-serif"
        case .georgia: return "Georgia, serif"
        case .lucida: return "Lucida Sans, serif"
        case .palatino: return "Palatino, URW Palladio L, serif"
        case .tahoma: return "Tahoma, serif"
        case .timesNewRoman: return "Times New Roman, serif"
        }
    }
}
