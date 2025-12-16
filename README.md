# 🛡️ BafnaVault

> **Independently architected and built during my internship at the D. Bafna Group.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Status](https://img.shields.io/badge/Status-Production--Ready-success?style=for-the-badge)

**BafnaVault** is a secure, cross-platform Document Management System (DMS) designed to centralize and protect internal company assets. Built to replace inefficient paper workflows, it ensures that critical blueprints, contracts, and financial documents are accessible securely from anywhere.

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
* **The "Double-Lock" System:** Even after logging in, opening a confidential file requires a specific **6-digit dynamic passkey**, ensuring that an unlocked phone doesn't mean leaked data.

### 📂 2. Smart Project Organization
* **Project-Centric View:** Files are isolated by project (e.g., "Orchid Residency", "D. Bafna One").
* **Archive System:** Completed projects can be archived by Admins to keep the active dashboard clutter-free.

### ⚡ 3. High-Performance Workflow
* **Cross-Platform Sync:** Upload a blueprint from the Desktop App, and it appears instantly on the Mobile App at the construction site.
* **Instant Filtering:** Client-side search logic allows users to filter through thousands of documents instantly without API latency.

---

## 📸 Application Showcase

### 📱 Mobile View (Android)
*Designed for Site Engineers on the go.*

| **Secure Login Screen** | **Home Dashboard** | **Passkey Security Check** |
|:---:|:---:|:---:|
| ![Login Screen Mobile](screenshots/mobile_login.png) <br> *Clean, branded login with Firebase Auth.* | ![Home Dashboard Mobile](screenshots/mobile_home.png) <br> *List of active projects.* | ![Passkey Mobile](screenshots/mobile_passkey.png) <br> *6-Digit Pin required for sensitive files.* |

### 💻 Desktop / Web View
*Designed for Office Administration.*

| **Admin Control Panel** | **Document Grid View** |
|:---:|:---:|
| <img width="1919" height="1079" alt="Screenshot 2025-12-16 233704" src="https://github.com/user-attachments/assets/5967869a-9c6d-4567-82ea-bcfceef0b660" />
 <br> *Create projects, manage archives, and users.* | ![Grid View Desktop](screenshots/desktop_grid.png) <br> *Wide view for managing large sets of blueprints.* |

> **Note:** *Screenshots demonstrate the responsive UI architecture sharing 95% of the codebase.*

---

## 🛠️ Tech Stack & Architecture

* **Frontend Framework:** Flutter (Dart)
    * *Reason:* Single codebase for Mobile, Web, and Windows.
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
