== Method

The SmartStock system is designed as a three-tier architecture: a web frontend (presentation tier), a Django REST backend (application tier), and a lightweight SQLite database (data tier). It integrates with external stock data providers (Finnhub as primary and yfinance as a fallback), using caching to optimize performance and API usage.

=== System Overview

![System Overview](Design%20Documents/diagrams/png/system-overview.png)

The platform consists of:
- A React.js single-page application frontend
- A Django REST Framework backend API
- A local SQLite database for persistence
- External APIs (Finnhub primary, yfinance fallback)

=== Backend Architecture

![Component Architecture](Design%20Documents/diagrams/png/component-architecture.png)

Key Backend Components:
- **Authentication Module**: Django’s session-based user authentication
- **Portfolio Service**: Manages holdings, transactions, and portfolio valuation
- **Stock Service**: Fetches stock data and news from external APIs with caching
- **News Service**: Aggregates news related to the user's portfolio
- **AI Advisor Module**: Provides simple diversification and opportunity tips by summarizing holdings through OpenAI

=== Database Schema

![Database Schema](Design%20Documents/diagrams/png/database-schema.png)

Database Tables:
- **User**: Authentication and profile data
- **Holding**: Current user holdings linked to stocks
- **Transaction**: Buy/sell records
- **Snapshot**: Daily portfolio value records
- **Stock**: Cached static data about stocks

=== Local Hosting & Dependency Management

- **Python Environment**: Managed with **Poetry** for virtualenvs and dependencies.
- **Frontend Environment**: Managed with **npm** or **yarn**.
- **Running Locally**:
  1. Clone the repository.
  2. Set up backend:
      ```bash
      cd backend
      poetry install
      poetry run python manage.py migrate
      poetry run python manage.py runserver
      ```
  3. Set up frontend:
      ```bash
      cd frontend
      npm install
      npm start
      ```
  4. Frontend (port 3000) and Backend (port 8000) run independently, communicating over REST APIs.

=== Environment Variables

Environment variables are managed using a `.env` file and loaded with `django-environ`:
- `FINNHUB_API_KEY` - API Key for Finnhub
- `OPENAI_API_KEY` - API Key for OpenAI (used by AI Advisor)
- `SECRET_KEY` - Django secret key
- `DEBUG` - Debug flag (`True`/`False`)
- `ALLOWED_HOSTS` - List of allowed hosts (localhost during development)

Environment files are excluded from Git (`.gitignore`) to protect secrets.
