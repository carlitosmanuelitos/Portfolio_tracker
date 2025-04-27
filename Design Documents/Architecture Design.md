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

| **Method** | **Endpoint**                          | **Description**                                                                                 | **Request Payload**                                                                                         | **Response Example**                                                                                                                                                                                               |
|------------|---------------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **GET**    | `/api/holdings`                       | Retrieve current stock holdings for the user.                                                     | None                                                                                                      | ```json [{"symbol": "AAPL", "quantity": 10, "avgPrice": 145.20, "lastPrice": 150.30}, {"symbol": "MSFT", "quantity": 5, "avgPrice": 300.00, "lastPrice": 310.50}]```                                                |
| **POST**   | `/api/transactions`                   | Record a buy/sell transaction. Updates the user's holdings accordingly.                          | `{ "symbol": "AAPL", "type": "BUY", "quantity": 5, "price": 155.00, "date": "2025-04-27" }`                 | ```json { "transaction": { "symbol": "AAPL", "type": "BUY", "quantity": 5, "price": 155.00, "date": "2025-04-27" }, "updatedHolding": { "symbol": "AAPL", "quantity": 15, "avgPrice": 148.67 } }``` |
| **DELETE** | `/api/holdings/{symbol}`              | Delete a holding by symbol or POST a sell transaction.                                           | None (symbol to delete in URL)                                                                             | ```json { "message": "Holding deleted successfully." }```                                                                                                                                 |
| **GET**    | `/api/portfolio/value-history`        | Retrieve the portfolio value history for charting.                                                | None                                                                                                      | ```json [{"date": "2025-04-20", "totalValue": 15000.00}, {"date": "2025-04-21", "totalValue": 15230.50}, {"date": "2025-04-27", "totalValue": 15510.75}]```                                                        |
| **GET**    | `/api/stocks/search?query={query}`     | Search for stocks by name or symbol (using Finnhub symbol lookup).                               | `{ "query": "AAPL" }`                                                                                      | ```json [{"symbol": "TSLA", "name": "Tesla Inc", "exchange": "NASDAQ"}, {"symbol": "AAPL", "name": "Apple Inc", "exchange": "NASDAQ"}]```                                                           |
| **GET**    | `/api/stocks/{symbol}/history?range=1y`| Retrieve historical price data for a stock symbol (e.g., 1-year range).                           | None                                                                                                      | ```json { "symbol": "AAPL", "history": [["2024-04-01", 170.0], ["2024-04-02", 172.5], ...] }```                                                                 |
| **GET**    | `/api/stocks/{symbol}/stats`          | Retrieve stock statistics such as market cap, P/E ratio, and sector.                             | None                                                                                                      | ```json { "symbol": "AAPL", "marketCap": 2500000000000, "peRatio": 28.4, "sector": "Technology" }```                                                         |
| **GET**    | `/api/news`                           | Get the latest news headlines/snippets for all symbols in the user's portfolio.                  | None                                                                                                      | ```json [{ "symbol": "AAPL", "headline": "Apple releases new iPhone model", "snippet": "Apple unveiled...", "url": "...", "datetime": "2025-04-25T10:00Z" }, { "symbol": "MSFT", "headline": "Microsoft reports record revenue", "snippet": "Microsoft Corp announced...", "url": "...", "datetime": "2025-04-25T11:00Z" }]```|

---

## 2.2 Detailed API Endpoints

### 2.2.1 Holdings / Transactions

#### **GET /api/holdings**
- **Description**: Retrieves the user's current stock holdings.
- **Request Example**: No request payload.
- **Response Example**:
    ```json
    [
      {"symbol": "AAPL", "quantity": 10, "avgPrice": 145.20, "lastPrice": 150.30},
      {"symbol": "MSFT", "quantity": 5, "avgPrice": 300.00, "lastPrice": 310.50}
    ]
    ```

#### **POST /api/transactions**
- **Description**: Record a stock transaction (buy/sell).
- **Request Payload Example**:
    ```json
    {
      "symbol": "AAPL",
      "type": "BUY",
      "quantity": 5,
      "price": 155.00,
      "date": "2025-04-27"
    }
    ```
- **Response Example**:
    ```json
    {
      "transaction": {
        "symbol": "AAPL",
        "type": "BUY",
        "quantity": 5,
        "price": 155.00,
        "date": "2025-04-27"
      },
      "updatedHolding": {
        "symbol": "AAPL",
        "quantity": 15,
        "avgPrice": 148.67
      }
    }
    ```

#### **DELETE /api/holdings/{symbol}**
- **Description**: Remove a stock from the portfolio (or use POST with "SELL" type to reduce the holding).
- **Request Example**: No request payload (symbol is in the URL).
- **Response Example**:
    ```json
    {
      "message": "Holding deleted successfully."
    }
    ```

---

### 2.2.2 Portfolio Snapshot / Value History

#### **GET /api/portfolio/value-history**
- **Description**: Retrieve the history of the portfolio's total value over time for charting.
- **Request Example**: No request payload.
- **Response Example**:
    ```json
    [
      {"date": "2025-04-20", "totalValue": 15000.00},
      {"date": "2025-04-21", "totalValue": 15230.50},
      {"date": "2025-04-27", "totalValue": 15510.75}
    ]
    ```

---

### 2.2.3. Stock Data

#### **GET /api/stocks/search?query={query}**
- **Description**: Search for stocks using the Finnhub symbol lookup.
- **Request Example**:
    ```json
    {"query": "AAPL"}
    ```
- **Response Example**:
    ```json
    [
      {"symbol": "TSLA", "name": "Tesla Inc", "exchange": "NASDAQ"},
      {"symbol": "AAPL", "name": "Apple Inc", "exchange": "NASDAQ"}
    ]
    ```

#### **GET /api/stocks/{symbol}/history?range=1y**
- **Description**: Fetch historical price data for a specific stock symbol.
- **Request Example**: No request payload.
- **Response Example**:
    ```json
    {
      "symbol": "AAPL",
      "history": [["2024-04-01", 170.0], ["2024-04-02", 172.5], ...]
    }
    ```

#### **GET /api/stocks/{symbol}/stats**
- **Description**: Retrieve stock statistics like market cap, P/E ratio, and sector.
- **Request Example**: No request payload.
- **Response Example**:
    ```json
    {
      "symbol": "AAPL",
      "marketCap": 2500000000000,
      "peRatio": 28.4,
      "sector": "Technology"
    }
    ```

---

### 2.2.4. News Feed

#### **GET /api/news**
- **Description**: Retrieve the latest news headlines/snippets for all stocks in the user's portfolio.
- **Request Example**: No request payload.
- **Response Example**:
    ```json
    [
      {"symbol": "AAPL", "headline": "Apple releases new iPhone model", "snippet": "Apple unveiled...", "url": "...", "datetime": "2025-04-25T10:00Z"},
      {"symbol": "MSFT", "headline": "Microsoft reports record revenue", "snippet": "Microsoft Corp announced...", "url": "...", "datetime": "2025-04-25T11:00Z"}
    ]
    ```

---

## 2.3. External Data Integration

SmartStock relies on **Finnhub.io** for real-time financial data (stock quotes, historical prices, news) and **Yahoo Finance** (via **yfinance**) as a fallback when Finnhub’s quota is exceeded.

### Finnhub API
- **Stock Quotes**: `https://finnhub.io/api/v1/quote?symbol=GOOG`
- **Company News**: `https://finnhub.io/api/v1/news?category=general`
- **Historical Data**: `https://finnhub.io/api/v1/stock/candle?symbol=GOOG&resolution=D1&from=1609459200&to=1612137600`

### Yahoo Finance (yfinance)
- **Ticker History**: `https://yfinance-api.com/v1/tickers/{symbol}/history`
- **Stock Data**: Retrieved using the `yfinance` Python library.

--- 

This concludes the API design for SmartStock’s stock tracking system. It simplifies the requirements to the essentials for a POC while integrating with external APIs to provide stock data and portfolio tracking features.


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
