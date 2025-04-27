#!/bin/bash

# Make sure we're in the project directory
mkdir -p smart_stock
cd smart_stock

# Initialize Git repository
git init

# Create directories for Django project structure
mkdir -p core users portfolio tracking/static tracking/templates

# Create directories for React frontend
mkdir -p frontend/src/components frontend/src frontend/public

# Create initial Python files
touch core/models.py core/views.py core/urls.py core/admin.py
touch users/models.py users/views.py users/urls.py users/forms.py
touch portfolio/models.py portfolio/views.py portfolio/urls.py
touch tracking/models.py tracking/views.py tracking/urls.py
touch manage.py

# Create initial frontend files (after ensuring directories exist)
touch frontend/src/App.js frontend/src/index.js frontend/src/index.css frontend/public/index.html
touch frontend/src/components/Home.js frontend/src/components/Navbar.js frontend/src/components/StockList.js

# Create Docker and Docker Compose files if you're using Docker
touch Dockerfile docker-compose.yml

# Create basic requirements files
touch requirements.txt

# Create a gitignore file to ignore unnecessary files
echo "venv/" > .gitignore
echo "node_modules/" >> .gitignore
echo "*.pyc" >> .gitignore
echo "__pycache__/" >> .gitignore
echo ".env" >> .gitignore
echo ".vscode/" >> .gitignore

# Create a README file
echo "# SmartStock - Portfolio Tracker" > README.md
echo "This is a simple web app to track and manage stock portfolios." >> README.md

# Install Django and other necessary libraries via Poetry
# If you're using Poetry to manage dependencies, initialize poetry
poetry init -n

# Install Django, DRF, and other necessary dependencies
poetry add django djangorestframework psycopg2

# Initialize React project
npx create-react-app frontend

# Install necessary frontend libraries
cd frontend
npm install axios react-router-dom
cd ..

# Add sample API endpoints in core/urls.py
echo "from django.urls import path" > core/urls.py
echo "from . import views" >> core/urls.py
echo "" >> core/urls.py
echo "urlpatterns = [" >> core/urls.py
echo "    path('', views.index, name='index')," >> core/urls.py
echo "]" >> core/urls.py

# Add a sample view in core/views.py
echo "from django.http import HttpResponse" > core/views.py
echo "" >> core/views.py
echo "def index(request):" >> core/views.py
echo "    return HttpResponse('Hello, SmartStock!')" >> core/views.py

# Display success message
echo "Project structure initialized. You can now start developing your app!"

# End of script
