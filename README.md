# 🧿 Linked In

A complete full-stack job portal application where users can register, view job listings, and apply for jobs. Built using Flutter for the frontend and Spring Boot for the backend.


[Click here to watch the project video](https://drive.google.com/file/d/1w4jyNka3il6aOzovxAjrmrINjRzxJJ6M/view?usp=sharing)

## 🖼️ Project Screenshots
![LinkedIn](https://github.com/user-attachments/assets/dd6b2000-5c26-4a84-b686-adf1fa8bade5)


## 🛠️ Technologies Used

📱 **Frontend**

* Flutter
* Dart
* HTTP (for API calls)

💻 **Backend**

* Spring Boot
* Spring Security with JWT
* MySQL
* Spring Data JPA
* MVC Pattern

## ✅ Features

* User registration and login
* View all job listings
* View job details
* Apply for a job
* Secure login using JWT
* Backend CRUD operations for posts
* Backend CRUD operations for user's Profile
* Complete User Authentication.
* Splash Screen.
* Bottom Navigation Bar.
* Profile Management
* Job Posting and Details
* Search Functionality
* Responsive Design
* Asynchronous data handling

## 📁 Project Structure

Frontend (/frontend)lib/├── main.dart             # Entry point├── models/             # Dart models (Job, User)├── Providers/          # For State Management├── screens/            # UI Screens (Home, Login, JobDetail, profileScreen)└── widgets/            # Reusable UI components

Backend (/backend)src/main/java/├── controller/         # REST API controllers├── service/            # Business logic├── repository/         # Data access layer (JPA)├── model/              # Java entities (User, Job)├── security/           # JWT filter, provider, config└── BackendApplication.java # Main class
## 🔐 Authentication Flow (Spring Security + JWT)

1.  User/Admin logs in → receives JWT token.
2.  JWT stored in frontend (e.g., `shared_preferences`).
3.  For every secure request, token is added in `Authorization` header.
4.  Backend verifies token and checks user.

## 🧪 Running the Project

### 🔧 Backend

1.  Create a MySQL database (e.g., `linkedin`).
2.  Update `application.properties`:

    ```properties
    spring.datasource.url=jdbc:mysql://localhost:3306/your_database_name
    spring.datasource.username=your_db_user
    spring.datasource.password=your_db_password
    jwt.secret=your_secret_key
    ```

### 📱 Frontend

#### 📦 Installation

1.  Clone the repository:

    ```bash
    git clone [https://github.com/mrArtist2582/LinkedIn-FLutter-sprting-boot.git](https://github.com/mrArtist2582/LinkedIn-FLutter-sprting-boot.git)
    ```

2.  Navigate to the frontend:

    ```bash
    cd linked_in
    ```

3.  Get dependencies:

    ```bash
    flutter pub get
    ```

4.  Run the app:

    ```bash
    flutter run
    ```
