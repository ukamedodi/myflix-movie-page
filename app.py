import os
from flask import Flask, render_template, send_file
from google.cloud import storage
import io

app = Flask(__name__)

# Replace with your GCP credentials file path
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/Users/ukamedodi/Downloads/my-flix/movie-page/devopsproject-411113-62da0264fd4f.json"

# Replace with your GCP bucket name and folder name
bucket_name = "myflix-movies"
folder_name = "movies"

# Initialize GCP storage client
client = storage.Client()

@app.route('/')
def movie():
    # List all files in the GCP bucket
    bucket = client.get_bucket(bucket_name)
    blobs = bucket.list_blobs(prefix=folder_name)
    video_links = [blob.name for blob in blobs]

    return render_template('movie.html', video_links=video_links)



@app.route('/play/<path:video_name>')
def play(video_name):
    # Fetch the video from GCP bucket
    bucket = client.get_bucket(bucket_name)
    blob = bucket.blob(video_name)
    videoString = blob.download_as_string()

    # Read the video content into BytesIO
    video_content = io.BytesIO(videoString)

    return send_file(video_content, mimetype='video/mp4',as_attachment=True,download_name=video_name)


if __name__ == '__main__':
    app.run(debug=True,port=5010)
