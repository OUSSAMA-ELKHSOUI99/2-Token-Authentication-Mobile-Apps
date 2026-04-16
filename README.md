# 1. Key Concepts & Definitions
these are the architectural patterns that make the app scaleable and secure:

## Feature-First Clean Architecture: 
Separating your code by feature (e.g., auth, profile) rather than strictly by layer. Inside each feature, you separate the Domain (rules/entities), Data (network/storage), and Presentation (UI/State).

## Dependency Injection (DI): 
The practice of passing tools (like a Database or API client) into your classes rather than creating them inside the class. We used Riverpod to handle this completely.

## The Token Pair (OAuth 2.0 Pattern):

Access Token: A short-lived "keycard" (e.g., 15 minutes) sent with every API request to prove who you are.

Refresh Token: A long-lived "master key" (e.g., 30 days) stored securely. Its only job is to silently fetch a new Access Token when the old one expires.

## The Interceptor ("The Traffic Cop"): 
A network layer tool that intercepts outgoing HTTP requests to attach tokens, and catches incoming errors (like a 401 Unauthorized) to automatically refresh the session without the user noticing.

## Circular Dependency: 
A fatal crash where Object A needs Object B to build, but Object B needs Object A. We encountered this when the Interceptor needed the AuthRepository, but the AuthRepository needed the Interceptor.

## The "Naked" Dio: 
The solution to the circular dependency. A bare-bones, secondary HTTP client used strictly inside the Interceptor to make the /refresh call, preventing an infinite loop.

# 2. The Tech Stack (Packages Used)
The exact stack that make this architecture work.

Environment,Package,Purpose
Flutter (Core),flutter_riverpod,State management and Dependency Injection (DI).
Flutter (Network),dio,"Advanced HTTP client. Handles requests, headers, and interceptors."
Flutter (Storage),flutter_secure_storage,Encrypts and safely stores the Access and Refresh tokens on the device.
Flutter (Auth),dart_jsonwebtoken,"Used strictly to decode the JWT payload locally to extract user data (ID, email) without making an API call."
Python (Server),fastapi & uvicorn,The high-performance web framework and server hosting your API.
Python (DB),psycopg2-binary,The driver that allows Python to talk to your PostgreSQL database.
Python (Auth),bcrypt & pyjwt,bcrypt securely hashes/salts passwords. pyjwt generates the Access and Refresh tokens.

# 3. Step-by-Step Implementation Summary
the chronological order of how the architecture comes together.

## Step 1: The Python API (The Source of Truth)
Instead of Flutter talking directly to a database (which is a massive security risk), we built a Python intermediary.

Database: Set up a local PostgreSQL database with a users table.

Endpoints: Created /register, /login, and /refresh endpoints using FastAPI.

Logic: The server hashes passwords via bcrypt, checks the database, and uses pyjwt to generate and return the Access and Refresh tokens.

## Step 2: The Flutter Domain & Data Layers
We stripped the heavy logic out of Flutter, turning it into a fast, "dumb" client.

Repository (NetworkAuthRepository): Built a class that relies entirely on Dio to make POST requests to the Python API. It reads the JSON response, grabs the tokens, and saves them via FlutterSecureStorage.

Decoding: Implemented getCurrentUser() to read the saved token and decode the payload locally to instantly know who is logged in.

## Step 3: The Interceptor & Riverpod Injection
This is where the magic happens for seamless user experience.

The Interceptor (AuthInterceptor): We wrote a class that catches 401 Unauthorized errors. It pauses the app, uses a "Naked Dio" to hit the Python /refresh endpoint, saves the new tokens, and silently retries the failed request.

The Provider (dioProvider): We injected this interceptor into our main Dio instance using Riverpod, meaning any future feature you build (like fetching user posts) will automatically handle token refreshes.

## Step 4: The Presentation Layer (UI & Forms)
We separated the UI strictly from the business logic.

Form Controllers: Created RegistrationFormController and LoginFormController (Riverpod Notifiers) to handle text input, regex validation (valid emails/passwords), and loading states.

Auth Controller: Created the main AuthController that listens to the form controllers and actually triggers the repository.

The Wrapper (AuthWrapper): A root widget sitting in main.dart that watches the AuthController. If the user has a valid token, it immediately draws the HomeScreen. If not, it draws the AuthSwitchScreen (Login/Register).

## Step 5: Connecting the Two Worlds (ADB Reverse)
Because Android Emulators and physical phones have different network rules than your PC, we had to bridge the gap.

Cleartext: Added android:usesCleartextTraffic="true" to the Android Manifest to allow local http:// testing.

The Tunnel: Used the adb reverse tcp:8000 tcp:8000 command via a USB cable. This securely mapped the phone's port 8000 directly to the PC's localhost, allowing Flutter to hit http://127.0.0.1:8000 just as if it were the computer itself.

<!-- // TODO: in AndroidManifest.xml, delete this android:usesCleartextTraffic="true" before deploying -->
