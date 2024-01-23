#!flask/bin/python
import tempfile
import os.path
import base64
import logging
from flask import Flask, jsonify
from flask import request

app = Flask(__name__)
certFile = "/app/cert/anna_export.crt"
pemFile = "/app/cert/anna_export_pass_1234.pem"
passwd = "1234"

@app.route('/')
def index():
    return "Hello, World!"

@app.route('/sign', methods=['POST'])
def create_task():
    if not request.json or not 'content' in request.json:
        abort(400)
    if not os.path.isfile(certFile):
      return "No crt file exists", 500
    if not os.path.isfile(pemFile):
      return "No pem file exists", 500

    temp_name = next(tempfile._get_candidate_names())
    source_path = os.path.join(tempfile.mkdtemp(), temp_name)
    result_path = "{}.sgn".format(source_path)

    #logging.warning("request: {}".format(request.json))

    decoded = base64.b64decode(request.json['content'])
    with open(source_path, 'wb') as output_file:
       output_file.write(decoded)

    cmd = "openssl smime -sign -signer {} -inkey {} -engine gost -passin pass:{} -binary -noattr -outform DER -in {} -out {}".format(certFile, pemFile, passwd, source_path, result_path)
    result = os.popen(cmd).read()

    logging.warning('result file path is: {}'.format(result_path))
    if not os.path.isfile(result_path):
      return "No result file exists, somthing goes wrong...", 500

    with open(result_path, "rb") as result_file:
      result_json = base64.b64encode(result_file.read()).decode()
    os.remove(result_path)

    response = {
        'signature': result_json
    }
    return jsonify(response), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
