# Blackjack

A modern, web-based Blackjack card game built with Rails 8.1.

## Overview

This is a fully-featured Blackjack game application featuring real-time game logic, and smooth interactive gameplay. Built with the latest Rails framework and Hotwire for dynamic, SPA-like experiences without complex JavaScript.

## Version Information

- **Rails:** 8.1.2
- **Ruby:** 3.4.8
- **Node/JavaScript:** ES Modules with Importmap
- **CSS:** Propshaft asset pipeline

## System Requirements

- Ruby 3.4.8 or higher
- SQLite 3
- Docker (for containerized deployment)
- Node.js (for development)

## Development Setup

### Prerequisites

Ensure you have Ruby 3.4.8 installed. You can use [rbenv](https://github.com/rbenv/rbenv) or [asdf](https://asdf-vm.com/) to manage your Ruby version.

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd blackjack
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   bin/rails db:setup
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

The application will be available at `http://localhost:3000`.

## Key Features

- **Modern Rails Stack:** Rails 8.1 with Turbo and Stimulus
- **Game Logic:** Complete Blackjack rules implementation
- **Database:** SQLite for development/production flexibility
- **Asset Pipeline:** Propshaft with CSS and JavaScript bundling
- **Job Processing:** Built-in with Solid Queue
- **Security:** Credentials management with Rails encrypted config

## Project Structure

```
app/
  ├── controllers/        # Game, Card controllers
  ├── models/            # Card, Deck, Game, Hand models
  ├── views/             # Game UI and components
  ├── javascript/        # Stimulus controllers
  └── assets/            # Stylesheets and images

config/
  ├── deploy.yml         # Kamal deployment config
  ├── routes.rb          # URL routing
  └── environments/      # Environment-specific config

db/
  └── migrate/           # Database migrations
```

## Available Commands

- `bin/dev` - Start development server (web + assets)
- `bin/rails server` - Start Puma web server
- `bin/rails db:migrate` - Run database migrations

## Support

For issues or questions, please open an issue in the repository.

---

**Last Updated:** March 2026
