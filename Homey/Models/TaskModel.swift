//
//  TaskModel.swift
//  Scoers
//

import Foundation

enum InstructionType {
    case voiceNote
    case notes
}

struct TaskModel {
    var title: String = ""
    var photoData: Data? = nil
    var date: Date = Date()
    var time: Date = Date()
    var instructionType: InstructionType = .voiceNote
    var notes: String = ""
    var voiceNoteURL: URL? = nil
    var assigneeId: UUID? = nil
}
