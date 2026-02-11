# 🍃 TeaSmart: Tea Factory Management System (Sri Lanka)
**Document Version:** 2.0
**Target Platform:** Flutter (Android/iOS)
**Context:** A production-grade mobile application for managing Green Leaf collection, supplier payments, and factory operations in Sri Lanka.
**Key Constraint:** The "Collector" module must work **100% Offline** and sync data when internet is available.

---

## 🤖 System Instruction for the AI Developer
**Role:** You are a Senior Flutter Architect specializing in "Offline-First" applications.
**Objective:** Build a robust, scalable mobile app following the requirements below.
**Coding Standards:**
* Use **Riverpod** for state management (Caching & Sync state).
* Use **Clean Architecture** (Data, Domain, Presentation layers).
* Strictly type all JSON data models.
* Prioritize performance: The app must run on low-end Android devices commonly used by truck drivers.

---

## 1. User Personas & Flows

### A. The Leaf Collector (Field Officer)
*User Context:* A truck driver or clerk traveling to remote tea estates.
* **Primary Goal:** Weigh tea sacks quickly and print a receipt.
* **Pain Points:** No internet signal, rain (wet screen), illegible handwriting.
* **Key Features:**
    * **Offline Login:** Pin-based entry.
    * **Bluetooth Scale Connect:** Auto-read weight to prevent fraud.
    * **Bluetooth Print:** Issue thermal receipt immediately.
    * **Route Select:** Choose "Collection Route" (e.g., *Deniyaya Route 1*).

### B. The Tea Planter (Supplier)
*User Context:* A smallholder farmer.
* **Primary Goal:** Check how much weight was recorded and view estimated income.
* **Key Features:**
    * **Dashboard:** Daily weight summary.
    * **Financials:** View "Gross Pay" vs "Deductions" (Fertilizer, Advances).
    * **Requests:** Order fertilizer or request cash advances.

### C. The Admin (Factory Manager)
*User Context:* Office staff.
* **Primary Goal:** Monitor daily intake and approve requests.
* **Key Features:** Dashboard overview, Approve/Reject loans.

---

## 2. Technical Stack & Packages

| Feature | Recommended Package | Usage Note |
| :--- | :--- | :--- |
| **Local Database** | `hive` + `hive_flutter` | **CRITICAL:** Store all weight records here first. |
| **Backend Sync** | `cloud_firestore` (or Supabase) | Sync Hive data to Cloud when online. |
| **State Mgt** | `flutter_riverpod` | Manage async states and offline sync status. |
| **Bluetooth Scale** | `flutter_blue_plus` | Read `Characteristic` from BLE scales. |
| **Printing** | `blue_thermal_printer` | Send ESC/POS commands to 58mm printers. |
| **Localization** | `easy_localization` or `intl` | **Must support Sinhala, Tamil, English.** |
| **QR Scan** | `mobile_scanner` | To scan Planter Identity Cards. |

---

## 3. UI/UX Design System

### A. Color Palette
* **Primary Green:** `#2E7D32` (Fresh Tea Leaf - Use for headers, primary buttons)
* **Secondary Brown:** `#795548` (Tea/Earth - Use for "History" or secondary elements)
* **Alert Red:** `#D32F2F` (Deductions, Errors, Offline Status)
* **Sync Amber:** `#FFC107` (Data pending sync)
* **Background:** `#F1F8E9` (Very light green - reduces glare in sunlight)

### B. Typography & Icons
* **Font:** *Poppins* (English), *Noto Sans Sinhala* (Sinhala), *Noto Sans Tamil* (Tamil).
* **Icons (Material Symbols):**
    * `scale` (Weighing Mode)
    * `print` (Print Receipt)
    * `wifi_off` (Offline Mode Indicator)
    * `local_shipping` (Transport/Route)
    * `payments` (Salary/Advance)
    * `eco` (Fertilizer)

### C. Asset Requirements
*(Placeholders to be used in code)*
* `assets/logo_factory.png`: App Logo.
* `assets/icons/tea_sack.png`: Custom marker for collection points.
* `assets/sounds/success_beep.mp3`: Audio feedback when weight is saved.

---

## 4. Functional Requirements (Business Logic)

### Module 1: The "Weighing" Screen (Collector)
**Input Fields:**
1.  **Supplier ID:** Text Input or QR Scan.
2.  **Sack Count:** Integer (Default: 1).
3.  **Gross Weight:** Double (Read from Bluetooth or Manual Entry).
4.  **Deductions (Toggles):**
    * `Bag Tare`: -1.0kg per sack (Configurable).
    * `Water %`: Slider (0-15%) for wet leaf deduction.
    * `Coarse Leaf`: Checkbox (Flags quality issue).

**Calculation Logic:**
```dart
double calculateNetWeight(double gross, int sackCount, double waterPercent) {
  double bagDeduction = sackCount * 1.0; // 1kg per bag
  double afterTare = gross - bagDeduction;
  double waterDeduction = afterTare * (waterPercent / 100);
  return afterTare - waterDeduction;
}