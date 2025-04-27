# Business Design Document

## 1. Project Title
SmartStock: Portfolio Tracker with Market Insights and AI Advisor

---

## 2. Executive Summary
SmartStock aims to be a simple, intuitive platform for individuals to monitor their stock portfolios, stay updated on market movements, and receive intelligent recommendations. The platform will offer portfolio management tools, live market overview dashboards, curated news related to user-owned stocks, and AI-driven suggestions for portfolio optimization or new investment ideas.

---

## 3. Problem Statement
Many individual investors struggle to keep track of their stock holdings, understand market trends at a glance, or stay informed about company-specific news. Additionally, balancing portfolios and discovering new investment opportunities often requires navigating multiple apps or websites. SmartStock consolidates these needs into a single platform.

---

## 4. Goals and Objectives
- Allow users to track, manage, and view the performance of their stock portfolios.
- Provide users with a real-time overview of the US stock market.
- Offer curated news based on companies in the user’s portfolio.
- Deliver AI-powered suggestions for portfolio balancing and new investment ideas.
- Maintain a simple, elegant, and user-friendly experience.

---

## 5. Core Capabilities and Features

### 5.1 User Management
- Account registration with username, password, and confirmation.
- Secure login/logout system.
- Personalized dashboard after login.

### 5.2 Portfolio Management
- Add new stock holdings to a personal portfolio (specifying ticker and number of shares).
- Edit or delete existing holdings.
- View real-time valuation of each stock and the entire portfolio.
- Monitor profit or loss for each position.
- **Flexible search & autocomplete**: lookup by ticker or company name (e.g. “Apple”, “Nvidia”).  
- **CRUD holdings**: add / edit / delete with fields: ticker, shares, purchase price, date.  
- **Transaction history**: paginated table showing every buy/sell.  
- **Overview table** (columns):  
  - Ticker  
  - Shares  
  - Paid Value (Σ shares × purchase price)  
  - Market Value (live price × shares)  
  - Current Price  
  - % Gain (vs. paid value)  
  - % Daily Change  
  - Avg. Purchase Price  
  - Last Purchase Date  

5.3 Market Overview Dashboard
- Display the current status of major US stock indexes (e.g., S&P 500, NASDAQ, Dow Jones).
- Showcase top market movers: largest gainers and losers of the day.
- Present sector-wise performance (e.g., Technology, Healthcare, Financials).
- Provide a simple, easily digestible snapshot of the market at a glance.

### 5.4 News Feed
- Curate and display recent news articles related to companies in the user's portfolio.
- Allow users to click on news items for full articles.
- **Portfolio-filtered**: only articles for tickers you own.  
- **NLP-lite filtering**: remove low-relevance noise.  
- **Click-through**: full-article links open in new tab.

### 5.5 Stock Viewer
Accessible via portfolio table or global search:  
- **Interactive price chart** (1 W, 1 M, YTD) with Chart.js.  
- **Key stats**: market cap, P/E, dividend yield, volume.  
- **Latest news**: two top headlines with “why it matters” snippet.
  
### 5.6 AI Advisor
- Suggest portfolio balancing actions based on diversification and stock performance.
- Recommend potential new stock opportunities tailored to user interests and portfolio gaps.
- Provide basic reasoning behind each recommendation in a user-friendly manner.
- Every time the dashboard loads, run simple checks:
1. **Diversification Tip**  
   - If any sector > 50 % of portfolio, recommend “trim X to Y %.”  
2. **Concentration Alert**  
   - If top 2 holdings > 60 % of value, suggest “spread risk across other stocks.”  
3. **Opportunity Prompt**  
   - If user has a simulated cash balance, highlight a top-market-cap stock not held. 
---

## 6. User Flows

### 6.1 First-Time Visitor
1. Land on **Home** → register (email/password).  
2. Verify redirect → **Dashboard** (empty).  
3. Search/Add first holding → see Overview table populate.

### 6.2 Returning User
1. Log in → go straight to **Dashboard**.  
2. Review Overview table, Market Snapshot, AI Tips.  
3. Click into **Portfolio** tab to edit or view history.  
4. Drill into any ticker via **Stock Viewer**.

### 6.3 Navigation & Actions
- Top nav: Home / Dashboard / Portfolio / Market / News / Advisor / Logout  
- Global search bar always present for ticker lookup.  
- Buttons on each table row: “View” (Stock Viewer), “Edit,” “Delete.”

---

## 7. Key Pages and Content

| Page | Content |
|:-----|:--------|
| **Home** | Registration/Login |
| **Dashboard** | Market overview, portfolio summary, news feed, AI suggestions |
| **Portfolio** | Detailed list of user's holdings, ability to manage portfolio |
| **Market Overview** | Expanded view of indexes, movers, sector performance |
| **News Feed** | News articles relevant to user’s holdings |
| **AI Advisor** | Suggested balancing actions and new opportunities |

---

## 8. Out of Scope
- No international stocks (focus solely on US market).
- No real-money trading (tracking and simulation only).
- No complex financial instruments like options or futures.

---

## 9. Success Criteria
- Users can easily register and manage portfolios without confusion.
- The dashboard loads clear, relevant market and portfolio information.
- News feed reliably shows fresh and related articles.
- AI recommendations feel intuitive and useful.
- The interface remains clean, simple, and easy to navigate.

---
