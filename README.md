# 🛡️ BafnaVault

> **Independently architected and built during my internship at the DBafna Developers.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production--Ready-success?style=for-the-badge)

**BafnaVault** is a secure, cross-platform Document Management System (DMS) designed to centralize and protect internal company assets. Built to replace inefficient paper workflows, it ensures that critical blueprints, contracts, and financial documents are accessible securely from anywhere.

---

## 📸 Application Showcase

### 📱 Mobile View (Android)
*Optimized for Site Engineers on the go.*

| **1. Secure Login** | **2. Home Dashboard** | **3. Passkey Check** |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/c994f735-b181-4f20-9256-b7e50a0ad065" width="250" alt="Mobile Login"> | <img src="https://github.com/user-attachments/assets/89eea79d-8d32-4b10-b959-388733eadf4f" width="250" alt="Mobile Home"> | <img src="https://github.com/user-attachments/assets/7851a7af-1609-4519-b013-11fa3fb330fa" width="250" alt="Mobile Passkey"> |
| *Branded Firebase Auth* | *Active Project Grid* | *2nd Layer Security* |

| **4. The Archives** | **5. Document Preview** |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/7f81046d-a920-4b1c-ba48-99b71bb0a81b" width="250" alt="Mobile Archive"> | <img src="https://github.com/user-attachments/assets/f1b1e130-a928-4ed3-86b5-bb91322f3d90" width="250" alt="Mobile Preview"> |
| *Separate historical view* | *Built-in PDF Viewer* |

| **6. User Profile** | **7. App Settings** |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/c29c6241-56fb-4260-80b3-8c57c5e10d0f" width="250" alt="Mobile Profile"> | <img src="https://github.com/user-attachments/assets/0e697af3-6a8f-4a13-adb0-593a4b14dbce" width="250" alt="Mobile Settings"> |
| *User Details & Role* | *Basic Settings* |

<br>

### 💻 Desktop / Web View
*Optimized for Office Administration on large screens.*

#### 🖥️ The Admin Control Panel
*Centralized hub to create projects, manage archives.*
<img width="100%" alt="Admin Panel Desktop" src="https://github.com/user-attachments/assets/5967869a-9c6d-4567-82ea-bcfceef0b660">

<br>

#### 📑 The Document Grid Dashboard
*Wide-angle view for managing large sets of blueprints and project folders efficiently.*
<img width="100%" alt="Document Grid View" src="https://github.com/user-attachments/assets/8a000ad1-0b67-4254-a7b5-9c805ef983d5">

> **Note:** *Screenshots demonstrate the responsive UI architecture sharing 95% of the codebase between platforms.*

---

## 💡 The Problem & Solution

**The Challenge:**
During my internship, I observed that critical documents were scattered across physical files and local hard drives. This led to version conflicts, security risks, and slow retrieval times.

**My Solution:**
I architected a **centralized cloud "Vault"**.
* **Secure:** Sensitive files are protected by a custom 2-layer passkey system.
* **Fast:** Real-time search finds documents in milliseconds.
* **Ubiquitous:** Works seamlessly on the Site Engineer's phone and the Office Manager's desktop.

---

## ✨ Key Features

### 🔐 1. Advanced Security Architecture
* **Role-Based Access Control (RBAC):** Admin vs. Viewer roles via Firebase Auth.
* **The "Double-Lock" System:** Even after logging in, opening a confidential file requires a specific **6-digit dynamic passkey**.

### 📂 2. Smart Organization & Archiving
* **Project-Centric View:** Files are isolated by project folders (e.g., "Orchid Residency").
* **The Archive Vault:** Completed projects move to a separate 'Archive' section, keeping the main dashboard clean while preserving historical data.

### 👁️‍🗨️ 3. Integrated Document Preview
* **Built-in Viewer:** Preview PDFs and images directly within the app without downloading external files, enhancing speed and security.

### ⚡ 4. High-Performance Workflow
* **Cross-Platform Sync:** Instant synchronization between Desktop uploads and Mobile views.
* **Instant Filtering:** Client-side search logic allows users to filter through thousands of documents instantly.

---

## 🛠️ Tech Stack & Architecture

* **Frontend Framework:** Flutter (Dart)
    * *Reason:* Single codebase for Mobile, Web, and Windows target platforms.
* **Backend:** Firebase
    * **Auth:** Secure identity management.
    * **Firestore:** NoSQL database for real-time metadata syncing.
    * **Storage:** Scalable cloud storage for large PDF/Image files.
* **State Management:** `Provider` pattern for efficient UI rebuilding.
* **Security:** Custom AES encryption logic for passkey validation.

---

## 🚀 Installation (For Developers)

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/moonlitpayal/BafnaVault.git](https://github.com/moonlitpayal/BafnaVault.git)
    ```
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the App:**
    ```bash
    flutter run
    ```

---

## 👨‍💻 Internship Context
This project was developed as a solo initiative during my internship at **DBafna Developers**. It demonstrates the ability to identify business bottlenecks and independently engineer a full-stack solution to resolve them.

*Designed and Architected by **Payal Dharma Mehta**.*
