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

## 📸 Application Showcase

### 📱 Mobile View (Android)
*Optimized specifically for on-site engineers needing quick access.*

| **1. Secure Login** | **2. Home Dashboard** | **3. Passkey Check** |
|:---:|:---:|:---:|
| ![Mobile Login](screenshots/mobile_login.png) | ![Mobile Home](screenshots/mobile_home.png) | ![Mobile Passkey](screenshots/mobile_passkey.png) |
| *Branded Firebase Auth* | *Active Project Grid* | *2nd Layer Security* |

| **4. The Archives** | **5. Settings & Profile** | **6. Document Preview** |
|:---:|:---:|:---:|
| ![Mobile Archive](screenshots/mobile_archive.png) | ![Mobile Settings](screenshots/mobile_settings.png) | ![Mobile Preview](screenshots/mobile_preview.png) |
| *Separate historical view* | *User controls & config* | *Built-in PDF Viewer* |

<br>

### 💻 Desktop / Web View
*Optimized for Office Administration on large screens.*

#### 🖥️ The Main Dashboard & Project Grid
*A wide-angle view for managing multiple active projects simultaneously.*
![Desktop Dashboard View](PASTE_YOUR_DESKTOP_DASHBOARD_URL_HERE)

#### 📑 Document Preview & Archives
*Split-screen functionality showing the integrated PDF viewer and access to archived folders.*
![Desktop Preview and Archive View](PASTE_YOUR_DESKTOP_PREVIEW_URL_HERE)

> **Note:** *Screenshots demonstrate the responsive UI architecture sharing 95% of the codebase between platforms.*

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
