# MPLJJ25-138-KEL-1
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/ipaddr/MPLJJ25-138-KEL-1)

## Overview

This repository, `mpljj25-138-kel-1`, hosts a comprehensive system designed for reporting and managing school-related issues. It comprises three main components: a Laravel-based backend API, a Flutter mobile application for user interaction, and a Python-based AI model for image analysis, likely integrated with Roboflow.

The system allows users to register, log in, submit reports with images, rate reports, and view the progress of submitted issues. Administrators have additional capabilities to manage reports, users, schools, and analyze submitted images using the AI model.

## Project Structure

The repository is organized into three primary directories:

*   `backend/`: Contains the Laravel PHP web application that serves as the backend API for the system.
*   `model_ai/`: Houses the Python Flask application responsible for AI-powered image analysis, integrated with a Roboflow workflow.
*   `report_school/`: Includes the Flutter mobile application, providing the user interface for reporting and tracking school issues.

## Backend (Laravel)

The backend is a Laravel application responsible for handling data, business logic, and providing APIs for the mobile application.

### Key Functionalities
*   **Authentication**: User registration with email verification, login, logout, password reset, and role-based access (admin, user).
*   **Laporan (Report) Management**: CRUD operations for reports, status updates (pending, accepted, rejected), user ratings for reports, and linking reports to progress updates.
*   **Progress Management**: CRUD operations for progress updates on reports, including percentage tracking and associating photos.
*   **Sekolah (School) Management**: CRUD operations for school data.
*   **Foto (Photo) & TagFoto (Photo Tag) Management**: Handling image uploads and associating them with tags.
*   **Analisis (Analysis) Management**: Storing results from AI model analysis of report images.
*   **API Endpoints**: A comprehensive set of API routes defined in `routes/web.php` for all functionalities.

### Setup

1.  **Clone the repository and navigate to the `backend` directory:**
    ```bash
    cd backend
    ```

2.  **Install PHP dependencies:**
    ```bash
    composer install
    ```

3.  **Create and configure the environment file:**
    Copy `.env.example` to `.env`:
    ```bash
    cp .env.example .env
    ```
    Update your `.env` file with your database credentials (e.g., `DB_CONNECTION`, `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`) and application URL (`APP_URL`). By default, it's configured for SQLite.

4.  **Generate an application key:**
    ```bash
    php artisan key:generate
    ```

5.  **Run database migrations:**
    This will create the necessary tables in your database_
    ```bash
    php artisan migrate
    ```

6.  **Seed the database (optional but recommended for initial data):**
    This will populate the database with initial admin, user, and school data.
    ```bash
    php artisan db:seed
    ```

7.  **Install JavaScript dependencies (if using frontend assets beyond API):**
    ```bash
    npm install
    ```

8.  **Build frontend assets (if applicable):**
    ```bash
    npm run build
    # or for development
    # npm run dev
    ```

### Running the Backend

To start the Laravel development server (typically on `http://localhost:8000`):
```bash
php artisan serve
```

## AI Model (Python/Flask Roboflow Integration)

This component uses a Python Flask server to provide an endpoint for image analysis, leveraging a Roboflow workflow.

### Setup

1.  **Navigate to the `model_ai` directory:**
    ```bash
    cd model_ai
    ```

2.  **Create and activate a Python virtual environment:**
    *   On Windows:
        ```bash
        python -m venv venv
        venv\Scripts\activate
        ```
    *   On macOS/Linux:
        ```bash
        python3 -m venv venv
        source venv/bin/activate
        ```

3.  **Install Python dependencies:**
    ```bash
    pip install -r requirement.txt
    ```
    Note: The `main.py` file uses a hardcoded API key (`PppevgAxvPjhWqSRB7zn`), workspace name (`testing-uuoqi`), and workflow ID (`custom-workflow`) for Roboflow. You might need to adjust these for your specific Roboflow project.

### Running the AI Model Server

To start the Flask development server (typically on `http://localhost:5000`):
```bash
python main.py
```

### Endpoint

*   **`POST /predict`**: Accepts a multipart/form-data request with an `image` field containing the image file (JPG/PNG) to be analyzed.
    Example using cURL:
    ```bash
    curl -X POST -F image=@your_image.jpg http://localhost:5000/predict
    ```

## Mobile Application (Flutter - `report_school`)

The `report_school` directory contains the Flutter mobile application that serves as the frontend for users to interact with the system.

### Key Features
*   User authentication (Login, Registration with email verification).
*   Dashboard/Home page displaying announcements and recent reports.
*   Viewing lists and details of reports and progress updates.
*   Creating new reports with image uploads and tagging.
*   Submitting progress updates for ongoing issues.
*   Rating reports.
*   Admin-specific features for report analysis and status management.
*   Image compression before upload.

### API Integration
The Flutter application communicates with the Laravel backend. API endpoints are configured in `lib/config/api.dart`.
By default, for Android emulator development, `apiHost` is set to `http://10.0.2.2`. For physical device testing, this may need to be updated to the local IP address of the machine running the backend. The `hostFilePendukung` for image display also needs to be configured correctly.

### Setup

1.  **Ensure you have the Flutter SDK installed.**
2.  **Navigate to the `report_school` directory:**
    ```bash
    cd report_school
    ```
3.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

### Running the Mobile Application
To run the application on a connected device or emulator:
```bash
flutter run
