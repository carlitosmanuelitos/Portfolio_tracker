## 0. System Overview

SmartStock is a **free, local portfolio-tracking web application** that allows users to manage their stock portfolios, track buy/sell operations, and visualize portfolio performance. The platform does not involve real cash balances, simplifying the user experience to focus purely on stock tracking and analysis.

The **Frontend** is a single-page application built with **React.js**, leveraging a charting library like **ApexCharts** or **Chart.js** to render interactive visualizations such as:
- **Portfolio value over time**: Line chart depicting the historical performance of the user's portfolio.
- **Stock and sector allocation**: Pie charts for visualizing the distribution of portfolio investments by stock and sector.

The **Backend** serves as a RESTful API that handles user authentication, stock holdings, transactions, portfolio snapshots, stock searches, and news aggregation. It is implemented using **Django REST Framework** for flexibility, scalability, and integration with external data sources.

The **Database** is a lightweight **SQLite** system for storing user information, portfolio data, transactions, and historical portfolio value snapshots. Key tables include:
- **User**: Stores user credentials and profile.
- **Holding**: User’s stock holdings including ticker, shares owned, purchase details.
- **Transaction**: Records each buy/sell transaction.
- **Snapshot**: Tracks portfolio value changes over time for graphing.

SmartStock integrates with external APIs to retrieve real-time market data and news. **Finnhub** serves as the primary data provider, offering real-time stock prices, historical quotes, company fundamentals, and news. **Yahoo Finance** (via **yfinance**) acts as a fallback for price and news data, ensuring reliability and robustness.

The system is architected in a **three-tier model**:
- **Presentation Tier**: The web frontend built with **React.js**, presenting real-time data and interactive charts.
- **Application Tier**: The **Django REST** backend that handles business logic, API calls, and data management.
- **Data Tier**: The **SQLite** database for persistent storage of user data and portfolio information.

This architecture ensures that the platform remains simple, efficient, and focused on portfolio tracking and analysis, while also being easily extensible for future enhancements.

---


## 1. Method

The SmartStock system follows a **three-tier architecture**:
- **Presentation Tier**: A **React.js** frontend for a seamless, responsive user experience.
- **Application Tier**: The backend built on **Django REST Framework**, providing APIs for frontend interactions and handling core business logic.
- **Data Tier**: **SQLite** database for local, lightweight data storage and persistence.

SmartStock integrates with external stock data providers (primarily **Finnhub** and fallback to **yfinance**) for real-time market data. Caching is employed to optimize performance and limit the number of API requests made to external providers.

### System Overview

![System Overview](https://raw.githubusercontent.com/carlitosmanuelitos/Portfolio_tracker/21bc6490727e3972b847924412558245df199180/Design%20Documents/diagrams/png/system-overview.png)

The platform consists of:
- A **React.js** single-page application frontend that provides dynamic updates based on user actions.
- A **Django REST Framework** backend API that serves data related to stock holdings, portfolio valuation, news, and AI recommendations.
- A local **SQLite database** that persists user accounts, portfolio data, transactions, and snapshots.
- External APIs (**Finnhub**, **yfinance**) that provide real-time stock prices and news for user-owned stocks.

### Backend Architecture

![Component Architecture](https://raw.githubusercontent.com/carlitosmanuelitos/Portfolio_tracker/21bc6490727e3972b847924412558245df199180/Design%20Documents/diagrams/png/component-architecture.png)

**Key Backend Components**:
- **Authentication Module**: Utilizes Django’s session-based user authentication to allow secure login and registration.
- **Portfolio Service**: Manages user portfolios, including stock holdings, transactions (buy/sell), and portfolio valuation. This service interacts with the database to perform CRUD operations on stock holdings.
- **Stock Service**: Retrieves real-time stock data and news using external APIs (primarily Finnhub and yfinance) and caches the results to reduce external requests.
- **News Service**: Aggregates and filters relevant news for the stocks in the user's portfolio. It fetches articles from external sources, applies NLP filtering, and stores relevant articles for quick access.
- **AI Advisor Module**: Offers insights for portfolio diversification and recommends potential new stocks based on user portfolio analysis. The module utilizes the OpenAI API to provide simple, actionable recommendations like risk mitigation strategies and stock diversification.

### Database Schema

![Database Schema](https://raw.githubusercontent.com/carlitosmanuelitos/Portfolio_tracker/21bc6490727e3972b847924412558245df199180/Design%20Documents/diagrams/png/database-schema.png)

Relationships are one-to-many: a User has many Holdings and Transactions. The Holding–Stock and Transaction–Stock relations associate records with stock symbols/instruments. (This is analogous to standard portfolio models: “an account can place many trades and an instrument can participate in many trades, but a trade is always associated with only one account and one instrument”​
datastax.com For example, a simplified ERD might include tables Users, Holdings, Transactions, Snapshots, and Stocks, with foreign keys linking holdings/transactions/snapshots to the user and stock tables. (Derived attributes like portfolio value or sector totals are computed at runtime or in snapshots; they need not be stored.) The design follows standard portfolio data modeling principles.

**Key Database Tables**:
**User**: (id, name, email, etc.) – A user may have one portfolio.
**Holding**: (id, user_id, symbol, quantity, avg_price, last_price) – A holding record for each stock the user owns. Each Holding belongs to one User​.
**Transaction**: (id, user_id, symbol, type [“BUY”/“SELL”], quantity, price, date) – A record of each buy/sell operation. Each Transaction is tied to one User and one stock symbol​. Buying increases a Holding (or creates one), selling decreases it.
**Snapshot**: (date, user_id, total_value) – Daily snapshot of the portfolio’s total value for trend analysis. Each Snapshot belongs to one User (or portfolio).
**Stock** (optional cache): (symbol, company_name, sector, exchange, etc.) – Static company info to avoid repeated lookups. Each Holding or Transaction refers to one Stock.

### Local Hosting & Dependency Management

- **Python Environment**: Managed with **Poetry** to handle virtual environments and package dependencies.
- **Frontend Environment**: Managed with **npm** or **yarn** for JavaScript dependencies.
- **Running Locally**:
  1. Clone the repository.
  2. Set up the backend:
      ```bash
      cd backend
      poetry install
      poetry run python manage.py migrate
      poetry run python manage.py runserver
      ```
  3. Set up the frontend:
      ```bash
      cd frontend
      npm install
      npm start
      ```
  4. The frontend (port 3000) and backend (port 8000) run independently and communicate via REST APIs.

### Environment Variables

**Environment variables** are managed using a `.env` file and loaded with `django-environ`:
- `FINNHUB_API_KEY` - API Key for Finnhub.
- `OPENAI_API_KEY` - API Key for OpenAI (used for AI Advisor).
- `SECRET_KEY` - Django secret key for session management.
- `DEBUG` - Debug flag (`True`/`False`).
- `ALLOWED_HOSTS` - List of allowed hosts, such as `localhost` for development.

Environment files are excluded from Git (`.gitignore`) for security purposes, ensuring sensitive data is not exposed in version control.

---
