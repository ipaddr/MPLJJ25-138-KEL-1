from flask import Flask, request, jsonify
from inference_sdk import InferenceHTTPClient
from PIL import Image
import os

app = Flask(__name__)

# Gunakan endpoint serverless untuk workflow Roboflow
client = InferenceHTTPClient(
    api_url="https://serverless.roboflow.com",
    api_key="PppevgAxvPjhWqSRB7zn"
)

def prepare_image_for_roboflow(image_path):
    """Convert dan resize gambar agar cocok untuk workflow."""
    img = Image.open(image_path).convert("RGB")
    img = img.resize((640, 640))  # Sesuaikan dengan input model jika berbeda
    base, _ = os.path.splitext(image_path)
    processed_path = f"{base}_processed.jpg"
    img.save(processed_path, format="JPEG", quality=90)
    return processed_path

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'Image file is required'}), 400

    image = request.files['image']
    original_path = "./temp.jpg"
    image.save(original_path)

    processed_path = prepare_image_for_roboflow(original_path)

    try:
        result = client.run_workflow(
            workspace_name="testing-uuoqi",
            workflow_id="custom-workflow",
            images={"image": processed_path},
            use_cache=False  # gunakan False saat testing biar tidak ambil cache
        )
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        # Hapus file temporer setelah selesai
        if os.path.exists(original_path):
            os.remove(original_path)
        if os.path.exists(processed_path):
            os.remove(processed_path)

if __name__ == "__main__":
    app.run(debug=True)
