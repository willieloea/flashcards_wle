# Markdown Flashcards

A cross-platform flashcards application for the lifelong learner, built with Flutter for Android and Linux. The app uses local Markdown (`.md`) files as the source of truth for your flashcards, allowing you to edit and manage your notes with any text editor.

This application was written by the Gemini CLI.

## Features

*   **Markdown-First:** Your flashcards are simple `.md` files. Own and control your data.
*   **Cross-Platform:** Runs on Linux desktop and Android from a single codebase.
*   **Markdown & Math:** Renders Markdown, including code blocks and mathematical notation using KaTeX (`$$...$$`).
*   **Card Review:** A clean and simple UI for reviewing cards, with a flip animation and swipe navigation.
*   **Knowledge Graph:** Connect ideas using a built-in tagging system. Browse all cards associated with a specific tag, regardless of their deck.
*   **Simple Sync:** A straightforward Backup & Restore feature lets you sync your `.md` files between devices using a local folder (e.g., a Google Drive or Dropbox folder).

## Getting Started

### 1. Running the Application

You can run the application on your desired platform:

*   **For Linux Desktop:**
    ```bash
    flutter run -d linux
    ```
*   **For Android:**
    Connect your Android device (with developer mode and USB debugging enabled) or start an emulator, and then run:
    ```bash
    flutter run
    ```

### 2. Creating Flashcards

1.  When you first launch the app, it will display the path to its documents directory.
2.  Create your first deck by adding a new `.md` file (e.g., `Calculus.md`) to that directory.
3.  Format your flashcards within the file as follows:

    *   The first line of a card is its **front**.
    *   All subsequent lines make up the **back**.
    *   Separate individual cards with `---` on a new line.
    *   Add tags to the end of a card's back using the `tags:` keyword.

    **Example: `Calculus.md`**
    ```markdown
    What is the derivative of x^2?
    It is 2x.
    
    ---
    What is the power rule?
    $$\frac{d}{dx}x^n = nx^{n-1}$$
    tags: calculus, derivatives, rules
    ```
4.  Launch the app and tap the "Refresh" button on the main screen. Your new deck will appear.

## Development

This application was built using:

*   **Framework:** Flutter
*   **Language:** Dart

### Project Structure

*   `lib/main.dart`: The main application entry point.
*   `lib/src/models/`: Contains the Dart data classes for `Deck` and `Flashcard`.
*   `lib/src/services/`: Contains the business logic, including:
    *   `markdown_parser.dart`: For reading and parsing `.md` files.
    *   `backup_service.dart`: For handling the backup and restore logic.
*   `lib/src/screens/`: Contains the application's UI screens.
*   `lib/src/widgets/`: Contains reusable UI components, like the `FlashcardWidget`.