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

# 7. Restart services
echo "🔁 Restarting Application Services..."

if ! sudo -n /bin/systemctl restart projects_gunicorn; then
  echo "❌ Gunicorn restart failed"
  exit 1
fi

if ! sudo -n /bin/systemctl restart nginx; then
  echo "❌ Nginx restart failed"
  exit 1
fi

echo "✅ Services restarted successfully"
echo "🎉 Deployment completed successfully!"

exit 0