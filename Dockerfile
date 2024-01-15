# Use the official Python image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the whole working directory into the container
COPY . /app

# Set the environmental variable for GCP credentials file
ENV GOOGLE_APPLICATION_CREDENTIALS /app/devopsproject-411113-62da0264fd4f.json

# Install any additional apt dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that Gunicorn will run on
EXPOSE 5010

# Start the Gunicorn server
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5010", "app:app"]
