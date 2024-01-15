# Use the official Python image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the application and requirements to the container
COPY app.py /app
COPY requirements.txt /app

# Install any additional apt dependencies
# For example, if you need ffmpeg for video processing:
# RUN apt-get update && apt-get install -y ffmpeg

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that Gunicorn will run on
EXPOSE 5010

# Start the Gunicorn server
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5010", "app:app"]

