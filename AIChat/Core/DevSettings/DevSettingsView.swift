//
//  DevSettingsView.swift
//  AIChat
//
//  Created by Jan Koczuba on 22/07/2025.
//
import SwiftUI
import SwiftfulUtilities

struct DevSettingsView: View {

    @Environment(AuthManager.self) private var authManager
    @Environment(UserManager.self) private var userManager
    @Environment(ABTestManager.self) private var abTestManager

    @Environment(\.dismiss) private var dismiss

    @State private var createAccountTest: Bool = false
    @State private var onboardingCommunityTest: Bool = false
    @State private var categoryRowTest: CategoryRowTestOption = .default

    var body: some View {
        NavigationStack {
            List {
                abTestSection
                authSection
                userSection
                deviceSection
            }
            .navigationTitle("Dev Settings 🫨")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButtonView
                }
            }
            .screenAppearAnalytics(name: "DevSettings")
            .onFirstAppear {
                loadABTests()
            }
        }
    }

    private func loadABTests() {
        createAccountTest = abTestManager.activeTests.createAccountTest
        onboardingCommunityTest = abTestManager.activeTests.onboardingCommunityTest
        categoryRowTest = abTestManager.activeTests.categoryRowTest
    }

    private var backButtonView: some View {
        Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.black)
            .anyButton {
                onBackButtonPressed()
            }
    }

    private func onBackButtonPressed() {
        dismiss()
    }

    private func handleCreateAccountChange(oldValue: Bool, newValue: Bool) {
        updateTest(
            property: &createAccountTest,
            newValue: newValue,
            savedValue: abTestManager.activeTests.createAccountTest,
            updateAction: { tests in
                tests.update(createAccountTest: newValue)
            }
        )
    }

    private func handleOnbCommunityChange(oldValue: Bool, newValue: Bool) {
        updateTest(
            property: &onboardingCommunityTest,
            newValue: newValue,
            savedValue: abTestManager.activeTests.onboardingCommunityTest,
            updateAction: { tests in
                tests.update(onboardingCommunityTest: newValue)
            }
        )
    }

    private func handleCategoryRowOptionChange(oldValue: CategoryRowTestOption, newValue: CategoryRowTestOption) {
        updateTest(
            property: &categoryRowTest,
            newValue: newValue,
            savedValue: abTestManager.activeTests.categoryRowTest,
            updateAction: { tests in
                tests.update(categoryRowTest: newValue)
            }
        )
    }

    private func updateTest<Value: Equatable>(
        property: inout Value,
        newValue: Value,
        savedValue: Value,
        updateAction: (inout ActiveABTests) -> Void
    ) {
        if newValue != savedValue {
            do {
                var tests = abTestManager.activeTests
                updateAction(&tests)
                try abTestManager.override(updateTests: tests)
            } catch {
                property = savedValue
            }
        }
    }

    private var abTestSection: some View {
        Section {
            Toggle("Create Account Test", isOn: $createAccountTest)
                .onChange(of: createAccountTest, handleCreateAccountChange)

            Toggle("Onb Community Test", isOn: $onboardingCommunityTest)
                .onChange(of: onboardingCommunityTest, handleOnbCommunityChange)

            Picker("Category Row Test", selection: $categoryRowTest) {
                ForEach(CategoryRowTestOption.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .id(option)
                }
            }
            .onChange(of: categoryRowTest, handleCategoryRowOptionChange)

        } header: {
            Text("AB Tests")
        }
        .font(.caption)
    }

    private var authSection: some View {
        Section {
            let array = authManager.auth?.eventParameters.asAlphabeticalArray ?? []
            ForEach(array, id: \.key) { item in
                itemRow(item: item)
            }
        } header: {
            Text("Auth Info")
        }
    }

    private var userSection: some View {
        Section {
            let array = userManager.currentUser?.eventParameters.asAlphabeticalArray ?? []
            ForEach(array, id: \.key) { item in
                itemRow(item: item)
            }
        } header: {
            Text("User Info")
        }
    }

    private var deviceSection: some View {
        Section {
            let array = Utilities.eventParameters.asAlphabeticalArray
            ForEach(array, id: \.key) { item in
                itemRow(item: item)
            }
        } header: {
            Text("Device Info")
        }
    }

    private func itemRow(item: (key: String, value: Any)) -> some View {
        HStack {
            Text(item.key)
            Spacer(minLength: 4)

            if let value = String.convertToString(item.value) {
                Text(value)
            } else {
                Text("Unknown")
            }
        }
        .font(.caption)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
    }
}

#Preview {
    DevSettingsView()
        .previewEnvironment()
}
