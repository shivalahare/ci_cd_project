#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting deployment process..."

# 1. Pull the latest code
echo "Pulling latest code..."
git pull origin main

# 2. Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate || source .venv/bin/activate

# 3. Install/update dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# 4. Run migrations
echo "Running database migrations..."
python manage.py migrate

# 5. Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# 6. Deactivate virtual environment
echo "Deactivating virtual environment..."
deactivate

# 7. Create a restart flag file (will be handled by a separate process)
echo "Restarting Application Services..."
# Restart Gunicorn (no sudo password required)
sudo /bin/systemctl restart projects_gunicorn || exit 1
sudo /bin/systemctl restart nginx || exit 1
echo "Services restarted successfully"

echo "Deployment completed successfully!"

