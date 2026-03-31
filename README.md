# 😊 Smile Game

A full-stack browser-based game with user authentication, session management, and a MySQL database backend — built with PHP and Laragon.

---

## Features

- User authentication — signup, login, logout
- Session management across game screens
- MySQL database for persisting user data
- Game logic with home screen, active game, and game over screen
- Clean CSS frontend

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | PHP |
| Database | MySQL |
| Frontend | HTML, CSS |
| Dev Environment | Laragon |

---

## Project Structure

```
group-smile-game/
├── index.php           # Entry point / landing page
├── home.php            # Home screen
├── game.php            # Main game screen
├── gameover.php        # Game over screen
├── login.php           # User login
├── signup.php          # User registration
├── signup-check.php    # Registration validation
├── logout.php          # Session termination
├── db_conn.php         # Database connection
├── css/                # Stylesheets
├── images/             # Game assets
└── db/                 # Database schema
```

---

## How to Run Locally

### Prerequisites
- [Laragon](https://laragon.org/) installed on Windows
- PHP and MySQL enabled in Laragon

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/stoppa5107/Smile-Game.git
   ```

2. **Move to Laragon's web root**
   ```
   C:\laragon\www\Smile-Game\
   ```

3. **Import the database**
   - Open Laragon → click **Database** (HeidiSQL or phpMyAdmin)
   - Create a new database e.g. `smile_game`
   - Import the SQL file from the `db/` folder

4. **Update database connection**
   - Open `db_conn.php`
   - Update the credentials to match your local setup:
   ```php
   $host = 'localhost';
   $dbname = 'smile_game';
   $username = 'root';
   $password = '';
   ```

5. **Start Laragon and visit**
   ```
   http://localhost/Smile-Game/
   ```

---

## Author

**Adikwu Joseph Ochigbo**
- GitHub: [stoppa5107](https://github.com/stoppa5107)
- Portfolio: [stoppa5107.github.io](https://stoppa5107.github.io)
