//
//  PetViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for managing pet-related operations
@MainActor
class PetViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pets: [Pet] = []
    @Published var selectedPet: Pet?
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Private Properties
    private let persistenceService: PersistenceService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService.shared) {
        self.persistenceService = persistenceService
        loadPets()
    }

    // MARK: - Public Methods

    /// Load all pets from storage
    func loadPets() {
        isLoading = true
        error = nil

        do {
            pets = try persistenceService.loadPets()
        } catch {
            self.error = error
            pets = []
        }

        isLoading = false
    }

    /// Add a new pet
    func addPet(_ pet: Pet) async throws {
        isLoading = true
        defer { isLoading = false }

        var newPet = pet
        newPet.updatedAt = Date()

        do {
            try await persistenceService.savePet(newPet)
            pets.append(newPet)
            sortPets()
        } catch {
            self.error = error
            throw error
        }
    }

    /// Update an existing pet
    func updatePet(_ pet: Pet) async throws {
        isLoading = true
        defer { isLoading = false }

        var updatedPet = pet
        updatedPet.updatedAt = Date()

        do {
            try await persistenceService.updatePet(updatedPet)
            if let index = pets.firstIndex(where: { $0.id == pet.id }) {
                pets[index] = updatedPet
                sortPets()
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Delete a pet
    func deletePet(_ pet: Pet) async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            try await persistenceService.deletePet(pet.id)
            pets.removeAll { $0.id == pet.id }
            if selectedPet?.id == pet.id {
                selectedPet = nil
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Select a pet
    func selectPet(_ pet: Pet?) {
        selectedPet = pet
    }

    /// Get active pets only
    var activePets: [Pet] {
        pets.filter { $0.isActive }
    }

    /// Get pets by type
    func petsByType(_ type: PetType) -> [Pet] {
        pets.filter { $0.type == type && $0.isActive }
    }

    /// Get pet by ID
    func petById(_ id: UUID) -> Pet? {
        pets.first { $0.id == id }
    }

    // MARK: - Private Methods
    private func sortPets() {
        pets.sort { (pet1, pet2) -> Bool in
            // Active pets first, then by name
            if pet1.isActive != pet2.isActive {
                return pet1.isActive && !pet2.isActive
            }
            return pet1.name < pet2.name
        }
    }
}

// MARK: - Pet Statistics
extension PetViewModel {
    /// Get total number of active pets
    var totalActivePets: Int {
        activePets.count
    }

    /// Get pets by type counts
    var petsByTypeCounts: [PetType: Int] {
        var counts: [PetType: Int] = [:]
        for pet in activePets {
            counts[pet.type, default: 0] += 1
        }
        return counts
    }

    /// Get average age of pets
    var averageAge: Double? {
        let ages = activePets.compactMap { $0.age }.filter { $0 > 0 }
        guard !ages.isEmpty else { return nil }
        return Double(ages.reduce(0, +)) / Double(ages.count)
    }
}
