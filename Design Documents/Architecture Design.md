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


## 2.0 Integration API Documentation

SmartStock provides a simple portfolio tracking system with stock buy/sell functionality, portfolio value history, stock news aggregation, and external stock data integrations with **Finnhub** and **Yahoo Finance** (via **yfinance**).

The API follows RESTful conventions and all responses use JSON.

---

## 2.1. Endpoints Overview

All endpoints are now versioned under `/api/v1/`, support pagination and filtering where appropriate, and follow JSON request/response conventions.

| **Method** | **Endpoint**                                             | **Description**                                                                                         | **Request Payload / Query Params**                                                                                                                        | **Response Example**                                                                                                                                                                                                     |
|------------|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **GET**    | `/api/v1/holdings`                                       | Retrieve current stock holdings for the user.                                                            | None                                                                                                                                                      | ```json\n[ { "symbol": "AAPL", "quantity": 10, "avgPrice": 145.20, "lastPrice": 150.30 }, { "symbol": "MSFT", "quantity": 5, "avgPrice": 300.00, "lastPrice": 310.50 } ]```                                            |
| **POST**   | `/api/v1/transactions`                                   | Record a buy or sell transaction; updates the user's holdings accordingly.                               | ```json\n{ "symbol": "AAPL", "type": "BUY", "quantity": 5, "price": 155.00, "date": "2025-04-27" }```                                                        | ```json\n{ "transaction": { "symbol": "AAPL", "type": "BUY", "quantity": 5, "price": 155.00, "date": "2025-04-27" }, "updatedHolding": { "symbol": "AAPL", "quantity": 15, "avgPrice": 148.67 } }```                         |
| **DELETE** | `/api/v1/holdings/{symbol}`                              | Delete a holding by symbol (or use POST `/transactions` with `"type":"SELL"` to reduce quantity).       | None (symbol in URL)                                                                                                                                      | ```json\n{ "message": "Holding deleted successfully." }```                                                                                                                                                               |
| **GET**    | `/api/v1/transactions?page={page}&per_page={n}`          | List past transactions, paginated.                                                                      | Query params: `page` (default 1), `per_page` (default 20)                                                                                                  | ```json\n[ { "symbol":"AAPL","type":"BUY","quantity":5,"price":155.00,"date":"2025-04-27" }, … ]```                                                                                                                        |
| **GET**    | `/api/v1/portfolio/value-history?start={YYYY-MM-DD}&end={YYYY-MM-DD}` | Retrieve portfolio total value over time (optionally filter by date range).                             | Query params: `start`, `end` (both optional)                                                                                                              | ```json\n[ { "date":"2025-04-20","totalValue":15000.00 }, { "date":"2025-04-27","totalValue":15510.75 } ]```                                                                                                             |
| **GET**    | `/api/v1/stocks/search?query={query}`                    | Search for stocks by company name or ticker.                                                             | Query param: `query`                                                                                                                                    | ```json\n[ { "symbol":"TSLA","name":"Tesla Inc","exchange":"NASDAQ" }, { "symbol":"AAPL","name":"Apple Inc","exchange":"NASDAQ" } ]```                                                                                      |
| **GET**    | `/api/v1/stocks/{symbol}/history?range={1m;3m;1y;ytd}`    | Retrieve historical price data for a stock symbol over a specified range.                                | Query param: `range` (e.g. `1m`, `3m`, `1y`, `ytd`)                                                                                                        | ```json\n{ "symbol":"AAPL","history":[ ["2024-04-01",170.0],["2024-04-02",172.5], … ] }```                                                                                                                                        |
| **GET**    | `/api/v1/stocks/{symbol}/stats`                          | Retrieve key stock statistics (market cap, P/E ratio, sector, etc.).                                     | None                                                                                                                                                      | ```json\n{ "symbol":"AAPL","marketCap":2500000000000,"peRatio":28.4,"sector":"Technology" }```                                                                                                                              |
| **GET**    | `/api/v1/news?page={page}&per_page={n}`                  | Get latest news headlines/snippets for all symbols in the user's portfolio, paginated.                  | Query params: `page` (default 1), `per_page` (default 20)                                                                                                  | ```json\n[ { "symbol":"AAPL","headline":"Apple releases new iPhone model","snippet":"Apple unveiled...", "url":"…","datetime":"2025-04-25T10:00Z" }, … ]```                                                                            |

---

## 2.2. External Data Integration

SmartStock relies on **Finnhub.io** for real-time financial data (stock quotes, historical prices, news) and **Yahoo Finance** (via **yfinance**) as a fallback when Finnhub’s quota is exceeded.

### Finnhub API
- **Stock Quotes**: `https://finnhub.io/api/v1/quote?symbol=GOOG`
- **Company News**: `https://finnhub.io/api/v1/news?category=general`
- **Historical Data**: `https://finnhub.io/api/v1/stock/candle?symbol=GOOG&resolution=D1&from=1609459200&to=1612137600`

### Yahoo Finance (yfinance)
- **Ticker History**: `https://yfinance-api.com/v1/tickers/{symbol}/history`
- **Stock Data**: Retrieved using the `yfinance` Python library.


This concludes the API design for SmartStock’s stock tracking system. It simplifies the requirements to the essentials for a POC while integrating with external APIs to provide stock data and portfolio tracking features.

--- 

## 3. Operational Requirements

### 3.1 Logging & Monitoring

The SmartStock application **must** include a robust logging and monitoring framework to capture operational data and diagnose issues:

- **Log Levels & Handlers**  
  - **INFO**: Record all incoming HTTP requests (method, URL, user ID), cache hits/misses, and scheduled snapshot executions.  
  - **WARNING**: Capture unexpected but recoverable conditions (e.g., API rate-limit warnings, partial data).  
  - **ERROR**: Log all exceptions, external-API failures (endpoint, status code, response body), and transaction validation failures.  
  - **Rotating File Handler**: Configure logs to roll over once the file reaches 10 MB, retaining at least 5 backup files.

- **Structured Log Format**  
  - Timestamp  
  - Logger name  
  - Severity level  
  - Correlation ID (per incoming request)  
  - Message and context (user ID, payload summary)

- **Error Aggregation (Optional)**  
  - Integrate with Sentry (DSN provided via environment variable) to capture uncaught exceptions and performance traces.

- **Health Checks**  
  - Expose a `/health` endpoint returning HTTP 200 when the application, database connection, and cache layer are operational.

---

### 3.2 Testing Strategy

SmartStock **must** include both unit and integration test suites to verify business logic and end-to-end API behavior:

- **Unit Tests**  
  - Exercise core services in isolation (portfolio calculation, transaction validation, snapshot scheduler).  
  - Use pytest’s fixtures and `sqlite:///:memory:` for an in-memory database.  
  - Validate boundary cases (e.g., zero or negative share quantities, non-existent symbols).

- **Integration Tests**  
  - Issue HTTP requests against the live REST API (e.g., `GET /api/v1/holdings`, `POST /api/v1/transactions`) using Flask’s or Django’s test client.  
  - Operate against a dedicated SQLite test database file (`test_finance.db`) that is created and torn down per test session.  
  - Validate full request/response cycles, including database persistence.

- **Test Coverage**  
  - Aim for at least 80 % coverage on all core modules (services, controllers, data models).

- **Continuous Verification**  
  - Provide a `make test` or `npm test` command to execute all tests locally.  
  - Include sample CI configuration (GitHub Actions or similar) to run tests on each commit.

---

## 3.3 Data Backup & Migrations

- **Schema Migrations**  
  - Employ Django’s built-in migration framework (or, if using SQLAlchemy, Alembic) to version and apply schema changes.  
  - Each migration script must be checked into version control and synchronized across environments.

- **Database Backups**  
  - Implement a simple daily dump of the SQLite file:  
    ```bash
    sqlite3 finance.db ".dump" > backups/finance_$(date +%F).sql
    ```  
  - Retain a configurable number of backup files (e.g., 7 days).

- **Recovery Procedures**  
  - Document steps to restore from backup (e.g., loading `.sql` dump into a new SQLite file).

---


# Security Considerations

Although SmartStock is a local/hobby app, standard security best practices should apply:

- **HTTPS**: All API endpoints must be served over HTTPS (even localhost with a self-signed cert) so that any credentials or API keys in transit are encrypted. [OWASP HTTPS Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/HTTPS_Cheat_Sheet.html).
  
- **API Keys Management**: Finnhub API keys (and any other secrets) must be kept out of source code and stored in environment variables or a secure vault. The server should never expose these keys to the client.

- **Input Validation**: All inputs (API request payloads) should be validated and sanitized to prevent injection attacks. For example, symbol strings or numeric quantities should be checked before use.

- **Rate Limiting**: Implement server-side throttling to prevent abuse (e.g., too many transactions or lookups). Also, abide by external API rate limits (cache results and queue excess requests).

- **Error Handling**: Do not leak internal errors or stack traces in API responses. Use proper HTTP status codes and messages.

For example, the [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html) recommends that REST endpoints enforce HTTPS to protect API keys and tokens in transit. Given the personal nature of financial data, securing the API is crucial even for a free app.

---

# Scalability and Performance

SmartStock is intended as a local/personal app, so it will not have massive scale demands. However, some design choices can improve performance and future scalability:

- **Caching**: Cache external API calls. For example, stock price and news data that changes daily can be stored in Redis or the database with a timestamp, reducing calls to Finnhub/Yahoo.

- **Pagination and Filtering**: For endpoints that may return many records (like news or long transaction histories), implement pagination.

- **Horizontal Scaling (future)**: If deployed to more users or a server environment, the frontend and API can be containerized (e.g., Docker). The backend can be scaled horizontally behind a load balancer. The database can be replicated or moved to a cloud DB service for reliability.

- **Database Indexes**: Ensure indexes on commonly queried fields (e.g. user_id, date in snapshots). For example, querying snapshot by date to build the chart should be fast.

The design is stateless and modular: any number of backend instances can be added if needed. Cached and scheduled data reduce real-time load, and modern databases like PostgreSQL can handle moderate data volumes easily.
