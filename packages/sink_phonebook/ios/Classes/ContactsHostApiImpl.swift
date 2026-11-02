import Foundation
import Contacts

public class ContactsHostApiImpl: NSObject, ContactsHostApi {
    private let contactStore = CNContactStore()

    public func getPermissionStatus() throws -> NativePermissionStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        return mapStatus(status)
    }

    public func requestPermission(completion: @escaping (Result<NativePermissionStatus, Error>) -> Void) {
        contactStore.requestAccess(for: .contacts) { [weak self] granted, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let self = self {
                let status = CNContactStore.authorizationStatus(for: .contacts)
                completion(.success(self.mapStatus(status)))
            } else {
                completion(.success(granted ? .granted : .denied))
            }
        }
    }

    public func readAllContacts(completion: @escaping (Result<[NativeContact], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                var results: [NativeContact] = []
                let keysToFetch: [CNKeyDescriptor] = [
                    CNContactIdentifierKey as CNKeyDescriptor,
                    CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor
                ]

                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
                fetchRequest.unifyResults = false // Read across all containers without hiding duplicates (FR-PB-022)

                try self.contactStore.enumerateContacts(with: fetchRequest) { contact, _ in
                    let fullName = [contact.givenName, contact.familyName]
                        .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
                        .joined(separator: " ")

                    let numbers = contact.phoneNumbers.map { $0.value.stringValue }
                    if !numbers.isEmpty {
                        results.append(
                            NativeContact(
                                contactId: contact.identifier,
                                displayName: fullName,
                                phoneNumbers: numbers,
                                accountLabel: nil
                            )
                        )
                    }
                }

                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func getAvailableAccounts(completion: @escaping (Result<[NativeAccount], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                var accounts: [NativeAccount] = []
                let containers = try self.contactStore.containers(matching: nil)

                for container in containers {
                    let isLocal = (container.type == .local)
                    let syncsToCloud = !isLocal

                    accounts.append(
                        NativeAccount(
                            name: container.name.isEmpty ? "iPhone Storage" : container.name,
                            type: "\(container.type.rawValue)",
                            isDeviceLocal: isLocal,
                            syncsToCloud: syncsToCloud
                        )
                    )
                }

                if accounts.isEmpty {
                    accounts.append(
                        NativeAccount(
                            name: "On My iPhone",
                            type: "local",
                            isDeviceLocal: true,
                            syncsToCloud: false
                        )
                    )
                }

                completion(.success(accounts))
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func writeContactsBatch(
        candidates: [NativeCandidate],
        accountName: String?,
        accountType: String?,
        completion: @escaping (Result<NativeWriteResult, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                let saveRequest = CNSaveRequest()
                var addedIds: [String] = []
                var createdRecordIds: [String] = []

                for candidate in candidates {
                    let newContact = CNMutableContact()
                    newContact.givenName = candidate.displayName

                    for number in candidate.numbers {
                        if let number = number, !number.trimmingCharacters(in: .whitespaces).isEmpty {
                            let phoneValue = CNPhoneNumber(stringValue: number)
                            let labeled = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: phoneValue)
                            newContact.phoneNumbers.append(labeled)
                        }
                    }

                    saveRequest.add(newContact, toContainerWithIdentifier: nil)
                    addedIds.append(candidate.id)
                    createdRecordIds.append(newContact.identifier)
                }

                try self.contactStore.execute(saveRequest)

                let result = NativeWriteResult(
                    successfullyAddedIds: addedIds,
                    failedCandidateIds: [],
                    createdRecordIds: createdRecordIds
                )
                completion(.success(result))
            } catch {
                let result = NativeWriteResult(
                    successfullyAddedIds: [],
                    failedCandidateIds: candidates.map { $0.id },
                    createdRecordIds: []
                )
                completion(.success(result))
            }
        }
    }

    public func undoCreatedContacts(
        recordIds: [String],
        completion: @escaping (Result<Int64, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                let saveRequest = CNSaveRequest()
                var deletedCount: Int64 = 0

                for id in recordIds {
                    let predicate = CNContact.predicateForContacts(withIdentifiers: [id])
                    let keys = [CNContactIdentifierKey as CNKeyDescriptor]
                    let contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys)

                    for contact in contacts {
                        if let mutableContact = contact.mutableCopy() as? CNMutableContact {
                            saveRequest.delete(mutableContact)
                            deletedCount += 1
                        }
                    }
                }

                try self.contactStore.execute(saveRequest)
                completion(.success(deletedCount))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func mapStatus(_ status: CNAuthorizationStatus) -> NativePermissionStatus {
        switch status {
        case .authorized:
            return .granted
        case .denied:
            return .denied
        case .restricted:
            return .permanentlyDenied
        case .notDetermined:
            return .denied
        @unknown default:
            if #available(iOS 18.0, *) {
                // Check if limited access is triggered on iOS 18 (FR-PB-012)
                if status.rawValue == 4 { // .limited
                    return .limitedIos
                }
            }
            return .denied
        }
    }
}
