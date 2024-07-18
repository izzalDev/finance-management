# Financial Management App

The Financial Management App is a Flutter-based application designed to help users manage their personal finances efficiently. This app includes features for user registration and login, viewing and managing transactions, and attaching images to transaction records.

## Features (WIP)

- **User Registration and Login**
  - [x] Create a new account with Full Name, Email, Phone Number, and Password.
  - [x] Login with Email and Password authentication.
  - [x] Beautifully designed registration and login screens.

- **Transaction Data List and Last Balance**
  - [x] View the list of transactions with details such as Transaction Name, Transaction Date, and Transaction Amount.
  - [x] Calculate the balance from total income minus total expenses.
  - [ ] View detailed transaction information, including an image upload feature.

- **Add New Transaction with Image Attachment**
  - [ ] Input details such as Transaction Name, Transaction Date, Amount, Transaction Type, Transaction Category, File (image), and Description.
  - [ ] Save the new transaction to the server and update the transaction list.

- **Edit and Delete Transactions**
  - [ ] Long tap on a transaction item to display the contextual menu for editing or deleting.
  - [ ] Edit transaction details with a pre-populated form and save changes to the server.
  - [x] Delete transaction data from the server.

## Installation (APK)

If you prefer to install the app directly on your Android device without building from the source code, follow these steps:

1. **Download the APK**

   - Navigate to the [Releases](https://github.com/yourusername/financial-management-app/releases) section of this repository.
   - Download the latest APK file (`app-release.apk`) from the latest release.

2. **Enable Unknown Sources**

   - Go to your device's Settings.
   - Navigate to Security (or Privacy on some devices).
   - Enable the option to install applications from Unknown Sources.

3. **Install the APK**

   - Open the downloaded APK file.
   - Tap on "Install" when prompted.
   - Once installation is complete, tap "Open" to launch the app.

4. **Permissions**

   - During installation, the app may request permissions for access to storage, camera (if uploading images), and network access.

5. **Enjoy Using the App**

   - You can now register, log in, and start managing your finances right from your Android device.

## Installation (Building from Source)

If you prefer to build the app from the source code, follow these steps:

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio / Visual Studio Code
- Firebase or any backend server for user authentication and data storage

### Steps

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/financial-management-app.git
   cd financial-management-app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up Firebase**

   - Follow the Firebase setup guide to configure your project for both Android and iOS.
   - Add `google-services.json` to `android/app` and `GoogleService-Info.plist` to `ios/Runner`.

4. **Run the app**

   ```bash
   flutter run
   ```

## Usage

### User Registration and Login

- **Sign Up**: Create a new account by providing your full name, email, phone number, and password.
- **Log In**: Use your email and password to log in to the app.

### Transaction Management

- **View Transactions**: Navigate to the Transactions page to view the list of transactions, your last balance, and transaction details.
- **Add Transaction**: Click on the "Add Transaction" button, fill in the transaction details, and attach an image if needed. Save the transaction to update the list.
- **Edit/Delete Transaction**: Long tap on any transaction to open the contextual menu. Choose to edit the transaction details or delete the transaction from the server.

## Project Structure

```bash
lib/
└── main.dart
```

## Contributing

We welcome contributions from the community. To contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feat/feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'feat: Add new feature'`).
5. Push to the branch (`git push origin feat/feature-branch`).
6. Open a pull request.

## Support Me

<div align="center" style="display: flex; justify-content: center; align-items: center;">
    <a href="https://www.nihbuatjajan.com/_qviyxykh" target="_blank"><img src="https://d4xyvrfd64gfm.cloudfront.net/buttons/default-cta.png" alt="Nih buat jajan" height="40px" style="height:40px !important;"></a>
    <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <a href="https://trakteer.id/izzalDev/tip" target="_blank"><img id="wse-buttons-preview" src="https://cdn.trakteer.id/images/embed/trbtn-red-1.png?date=18-11-2023" height="40px" style="border:0px;height:40px;" alt="Trakteer Saya"></a>
    <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
    <a href='https://ko-fi.com/B0B2ZCON1' target='_blank'><img height='40px' style='border:0px;height:40px;' src='https://storage.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com'></a>
</div>

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or support, please reach out to us at <rizal.fadlullah@gmail.com>.

---

Thank you for using the Financial Management App! We appreciate your patience as we continue to develop and enhance its features.
