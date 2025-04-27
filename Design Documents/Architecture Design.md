== Method

The SmartStock system will be built as a three-tier architecture: a web frontend (presentation tier), a Django REST backend (application tier), and a lightweight SQLite database (data tier). It will integrate with external stock data providers (Finnhub as primary and yfinance as a fallback) and cache results to optimize performance and API call usage.

=== System Overview
[plantuml,system-overview,format=png]
----
@startuml
actor User
rectangle "SmartStock Web Frontend\n(React.js SPA)" {
}
rectangle "SmartStock API Backend\n(Django + Django REST Framework)" {
}
database "SQLite Database" {
}
rectangle "External Data Providers\n(Finnhub, yfinance)" {
}

User --> "SmartStock Web Frontend\n(React.js SPA)"
"SmartStock Web Frontend\n(React.js SPA)" --> "SmartStock API Backend\n(Django + Django REST Framework)"
"SmartStock API Backend\n(Django + Django REST Framework)" --> "SQLite Database"
"SmartStock API Backend\n(Django + Django REST Framework)" --> "External Data Providers\n(Finnhub, yfinance)"
@enduml
----

=== Backend Architecture
- **Framework**: Django 4.x with Django REST Framework (DRF)
- **Authentication**: Django built-in user authentication system (session-based)
- **External Data Handling**:
  - Primary stock and news data via **Finnhub** API.
  - Fallback to **yfinance** when Finnhub is unavailable or limits exceeded.
  - **Caching** of API responses (simple in-memory or Django cache system).
- **Environment Variables**: API keys and secrets managed via `.env` files loaded by Django.
- **Database**: SQLite3 for development and local hosting, maintaining portability and simplicity.
- **AI Advisor Module**: Rule-based diversification tips, concentration alerts, and opportunity prompts. Query OpenAI API with a custom prompt including the user's holdings snapshot to provide suggestions.

=== Frontend Architecture
- **Framework**: React.js 18+ (with React Router)
- **Design System**: Minimalist, clean ("Apple-like"), using TailwindCSS or Material-UI for fast and consistent styling.
- **Charts**: Recharts (React wrapper over D3.js) or Chart.js.
- **Navigation**: Single-page layout with sections: Dashboard / Portfolio / Market / News / AI Advisor.
- **API Communication**: Axios for HTTP calls to Django backend.

=== Local Hosting & Dependency Management
- **Python Environment**: Poetry for Python dependency management.
- **Frontend Environment**: npm / yarn for managing React dependencies.
- **Running the App**:
  1. Clone the repository.
  2. Set up the Python virtual environment via Poetry.
  3. Set up Node environment and install React app dependencies.
  4. Run Django backend (`poetry run python manage.py runserver`).
  5. Run React frontend (`npm start`).
  6. Both frontend and backend run locally, communicating via different ports (e.g., 3000 frontend, 8000 backend).
  
=== Environment Variables
- `.env` file in the Django project root.
- Recommended keys:
  - `FINNHUB_API_KEY`
  - `OPENAI_API_KEY`
  - `SECRET_KEY` (Django secret)
  - `DEBUG`
  - `ALLOWED_HOSTS`
- Usage: Load using `django-environ` or `python-decouple` for minimal complexity and better security.

