//
//  ValidationHelper.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Helper class for input validation
class ValidationHelper {
    static let shared = ValidationHelper()

    private init() {}

    // MARK: - Pet Validation

    /// Validate pet name
    func validatePetName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("Pet adı boş olamaz")
        }

        if trimmed.count < 2 {
            return .invalid("Pet adı en az 2 karakter olmalıdır")
        }

        if trimmed.count > 50 {
            return .invalid("Pet adı en fazla 50 karakter olabilir")
        }

        // Check for valid characters (letters, spaces, numbers, basic punctuation)
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .-'")
        if trimmed.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .invalid("Pet adı geçersiz karakter içeriyor")
        }

        return .valid
    }

    /// Validate pet breed
    func validatePetBreed(_ breed: String?) -> ValidationResult {
        guard let breed = breed else { return .valid }

        let trimmed = breed.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        if trimmed.count > 50 {
            return .invalid("Cins adı en fazla 50 karakter olabilir")
        }

        // Check for valid characters
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .-'")
        if trimmed.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .invalid("Cins adı geçersiz karakter içeriyor")
        }

        return .valid
    }

    /// Validate pet weight
    func validatePetWeight(_ weight: Double?) -> ValidationResult {
        guard let weight = weight else { return .valid }

        if weight <= 0 {
            return .invalid("Ağırlık 0'dan büyük olmalıdır")
        }

        if weight > 200 {
            return .invalid("Ağırlık 200 kg'dan fazla olamaz")
        }

        return .valid
    }

    /// Validate pet birth date
    func validatePetBirthDate(_ birthDate: Date?) -> ValidationResult {
        guard let birthDate = birthDate else { return .valid }

        let now = Date()
        if birthDate > now {
            return .invalid("Doğum tarihi gelecekte olamaz")
        }

        // Check if pet is not older than 50 years (reasonable limit for pets)
        let fiftyYearsAgo = Calendar.current.date(byAdding: .year, value: -50, to: now)!
        if birthDate < fiftyYearsAgo {
            return .invalid("Doğum tarihi çok eski görünüyor")
        }

        return .valid
    }

    // MARK: - Task Validation

    /// Validate task title
    func validateTaskTitle(_ title: String) -> ValidationResult {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("Görev başlığı boş olamaz")
        }

        if trimmed.count < 3 {
            return .invalid("Görev başlığı en az 3 karakter olmalıdır")
        }

        if trimmed.count > 100 {
            return .invalid("Görev başlığı en fazla 100 karakter olabilir")
        }

        return .valid
    }

    /// Validate task description
    func validateTaskDescription(_ description: String?) -> ValidationResult {
        guard let description = description else { return .valid }

        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        if trimmed.count > 500 {
            return .invalid("Açıklama en fazla 500 karakter olabilir")
        }

        return .valid
    }

    /// Validate task due date
    func validateTaskDueDate(_ dueDate: Date?) -> ValidationResult {
        guard let dueDate = dueDate else { return .valid }

        // Due date can be in the past (for overdue tasks)
        // but not too far in the future (1 year limit)
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        if dueDate > oneYearFromNow {
            return .invalid("Son tarih çok uzak bir tarihte olamaz")
        }

        return .valid
    }

    // MARK: - Reminder Validation

    /// Validate reminder title
    func validateReminderTitle(_ title: String) -> ValidationResult {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("Hatırlatma başlığı boş olamaz")
        }

        if trimmed.count < 3 {
            return .invalid("Hatırlatma başlığı en az 3 karakter olmalıdır")
        }

        if trimmed.count > 100 {
            return .invalid("Hatırlatma başlığı en fazla 100 karakter olabilir")
        }

        return .valid
    }

    /// Validate reminder message
    func validateReminderMessage(_ message: String?) -> ValidationResult {
        guard let message = message else { return .valid }

        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        if trimmed.count > 250 {
            return .invalid("Mesaj en fazla 250 karakter olabilir")
        }

        return .valid
    }

    /// Validate reminder scheduled date
    func validateReminderScheduledDate(_ scheduledDate: Date) -> ValidationResult {
        let now = Date()
        if scheduledDate < now {
            return .invalid("Hatırlatma tarihi geçmişte olamaz")
        }

        // Not too far in the future (1 year limit)
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now)!
        if scheduledDate > oneYearFromNow {
            return .invalid("Hatırlatma tarihi çok uzak bir tarihte olamaz")
        }

        return .valid
    }

    // MARK: - Vaccine Validation

    /// Validate vaccine name
    func validateVaccineName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("Aşı adı boş olamaz")
        }

        if trimmed.count < 2 {
            return .invalid("Aşı adı en az 2 karakter olmalıdır")
        }

        if trimmed.count > 100 {
            return .invalid("Aşı adı en fazla 100 karakter olabilir")
        }

        return .valid
    }

    /// Validate vaccine administered date
    func validateVaccineAdministeredDate(_ administeredDate: Date) -> ValidationResult {
        let now = Date()
        if administeredDate > now {
            return .invalid("Uygulama tarihi gelecekte olamaz")
        }

        // Not too far in the past (5 years limit)
        let fiveYearsAgo = Calendar.current.date(byAdding: .year, value: -5, to: now)!
        if administeredDate < fiveYearsAgo {
            return .invalid("Uygulama tarihi çok eski görünüyor")
        }

        return .valid
    }

    /// Validate vaccine next due date
    func validateVaccineNextDueDate(_ nextDueDate: Date?, administeredDate: Date) -> ValidationResult {
        guard let nextDueDate = nextDueDate else { return .valid }

        if nextDueDate <= administeredDate {
            return .invalid("Sonraki doz tarihi uygulama tarihinden sonra olmalıdır")
        }

        // Not too far in the future (5 years limit)
        let fiveYearsFromNow = Calendar.current.date(byAdding: .year, value: 5, to: Date())!
        if nextDueDate > fiveYearsFromNow {
            return .invalid("Sonraki doz tarihi çok uzak bir tarihte olamaz")
        }

        return .valid
    }

    // MARK: - Medication Validation

    /// Validate medication name
    func validateMedicationName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("İlaç adı boş olamaz")
        }

        if trimmed.count < 2 {
            return .invalid("İlaç adı en az 2 karakter olmalıdır")
        }

        if trimmed.count > 100 {
            return .invalid("İlaç adı en fazla 100 karakter olabilir")
        }

        return .valid
    }

    /// Validate medication dosage
    func validateMedicationDosage(_ dosage: String) -> ValidationResult {
        let trimmed = dosage.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .invalid("Dozaj bilgisi boş olamaz")
        }

        if trimmed.count > 50 {
            return .invalid("Dozaj bilgisi en fazla 50 karakter olabilir")
        }

        return .valid
    }

    /// Validate medication start date
    func validateMedicationStartDate(_ startDate: Date) -> ValidationResult {
        let now = Date()
        // Allow start dates up to 1 month in the past
        let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!

        if startDate < oneMonthAgo {
            return .invalid("Başlangıç tarihi çok eski görünüyor")
        }

        if startDate > now.addingTimeInterval(86400) { // Allow 1 day in future
            return .invalid("Başlangıç tarihi gelecekte olamaz")
        }

        return .valid
    }

    /// Validate medication end date
    func validateMedicationEndDate(_ endDate: Date?, startDate: Date) -> ValidationResult {
        guard let endDate = endDate else { return .valid }

        if endDate <= startDate {
            return .invalid("Bitiş tarihi başlangıç tarihinden sonra olmalıdır")
        }

        // Not too far in the future (2 years limit)
        let twoYearsFromNow = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        if endDate > twoYearsFromNow {
            return .invalid("Bitiş tarihi çok uzak bir tarihte olamaz")
        }

        return .valid
    }

    /// Validate medication instructions
    func validateMedicationInstructions(_ instructions: String?) -> ValidationResult {
        guard let instructions = instructions else { return .valid }

        let trimmed = instructions.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        if trimmed.count > 500 {
            return .invalid("Talimatlar en fazla 500 karakter olabilir")
        }

        return .valid
    }

    // MARK: - General Validation

    /// Validate email address
    func validateEmail(_ email: String) -> ValidationResult {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: trimmed) {
            return .invalid("Geçersiz e-posta adresi")
        }

        return .valid
    }

    /// Validate phone number
    func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .valid // Optional field
        }

        // Turkish phone number validation (basic)
        let phoneRegex = "^[0-9+\\-\\s()]{10,15}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)

        if !phonePredicate.evaluate(with: trimmed) {
            return .invalid("Geçersiz telefon numarası")
        }

        return .valid
    }
}

// MARK: - Validation Result

enum ValidationResult {
    case valid
    case invalid(String)

    var isValid: Bool {
        switch self {
        case .valid: return true
        case .invalid: return false
        }
    }

    var errorMessage: String? {
        switch self {
        case .valid: return nil
        case .invalid(let message): return message
        }
    }
}
