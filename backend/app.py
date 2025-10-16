from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os
import uuid
from datetime import datetime
import hashlib
import json
from werkzeug.utils import secure_filename
import io
import gzip
import shutil
from pathlib import Path

app = Flask(__name__)
CORS(app)

# Configuration
UPLOAD_FOLDER = os.environ.get('UPLOAD_FOLDER', 'uploads')
ALLOWED_EXTENSIONS = os.environ.get('ALLOWED_EXTENSIONS', 'txt,pdf,png,jpg,jpeg,gif,doc,docx').split(',')
ALLOWED_EXTENSIONS = set(ALLOWED_EXTENSIONS)

# File size limit configuration - can be changed as needed
MAX_FILE_SIZE = int(os.environ.get('MAX_FILE_SIZE', 5 * 1024 * 1024))  # Default 5MB, configurable via environment variable

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = MAX_FILE_SIZE
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///medical_records.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

def compress_file(input_path, output_path):
    """Compress a file using gzip"""
    with open(input_path, 'rb') as f_in:
        with gzip.open(output_path, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

def decompress_file(input_path, output_path):
    """Decompress a gzip file"""
    with gzip.open(input_path, 'rb') as f_in:
        with open(output_path, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

# Database Models
class Patient(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    crn = db.Column(db.String(50), unique=True, nullable=False)
    uhid = db.Column(db.String(50), nullable=False)
    patient_name = db.Column(db.String(100), nullable=False)
    dob = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationship with files
    files = db.relationship('File', backref='patient', lazy=True)

class File(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey('patient.id'), nullable=False)
    filename = db.Column(db.String(200), nullable=False)
    filepath = db.Column(db.String(300), nullable=False)
    file_size = db.Column(db.Integer)
    upload_date = db.Column(db.DateTime, default=datetime.utcnow)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    employee_id = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(100), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class OtpCode(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    mobile = db.Column(db.String(15), unique=True, nullable=False)
    otp = db.Column(db.String(10), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)

def allowed_file(filename):
    """Check if the file extension is allowed"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/login/employee', methods=['POST'])
def login_employee():
    """Login with employee credentials"""
    try:
        data = request.get_json()
        employee_id = data.get('employee_id')
        password = data.get('password')
        
        if not employee_id or not password:
            return jsonify({'error': 'Employee ID and password are required'}), 400
        
        user = User.query.filter_by(employee_id=employee_id).first()
        
        if user:
            password_hash = hashlib.sha256(password.encode()).hexdigest()
            if user.password_hash == password_hash:
                return jsonify({
                    'success': True,
                    'user': {
                        'id': user.id,
                        'employee_id': user.employee_id,
                        'name': user.name
                    }
                }), 200
        
        return jsonify({'error': 'Invalid credentials'}), 401
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/login/send-otp', methods=['POST'])
def send_otp():
    """Send OTP to mobile number (mock implementation)"""
    try:
        data = request.get_json()
        mobile = data.get('mobile')
        
        if not mobile:
            return jsonify({'error': 'Mobile number is required'}), 400
        
        # Generate a 6-digit OTP
        import random
        otp = f"{random.randint(100000, 999999)}"
        
        # In a real app, you would send the OTP via SMS
        # For now, we'll just store it in the database
        
        # Calculate expiry time (5 minutes from now)
        from datetime import timedelta
        expiry_time = datetime.utcnow() + timedelta(minutes=5)
        
        # Remove any existing OTP for this mobile
        existing_otp = OtpCode.query.filter_by(mobile=mobile).first()
        if existing_otp:
            db.session.delete(existing_otp)
        
        # Insert new OTP
        new_otp = OtpCode(
            mobile=mobile,
            otp=otp,
            expires_at=expiry_time
        )
        db.session.add(new_otp)
        db.session.commit()
        
        # For demo purposes, return the OTP in the response
        # In a real app, you would only return a success message
        return jsonify({
            'success': True,
            'message': 'OTP sent successfully',
            'otp': otp  # This is only for demo purposes
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/login/verify-otp', methods=['POST'])
def verify_otp():
    """Verify OTP sent to mobile number"""
    try:
        data = request.get_json()
        mobile = data.get('mobile')
        otp = data.get('otp')
        
        if not mobile or not otp:
            return jsonify({'error': 'Mobile and OTP are required'}), 400
        
        otp_record = OtpCode.query.filter_by(mobile=mobile, otp=otp).first()
        
        if otp_record:
            # Check if OTP has expired
            current_time = datetime.utcnow()
            if current_time > otp_record.expires_at:
                return jsonify({'error': 'OTP has expired'}), 400
            
            # OTP is valid, return success
            return jsonify({
                'success': True,
                'message': 'OTP verified successfully'
            }), 200
        else:
            return jsonify({'error': 'Invalid OTP'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/patients', methods=['POST'])
def create_patient():
    """Create a new patient record with files"""
    try:
        # Get form data
        crn = request.form.get('crn')
        uhid = request.form.get('uhid')
        patient_name = request.form.get('patient_name')
        dob = request.form.get('dob')
        
        if not all([crn, uhid, patient_name, dob]):
            return jsonify({'error': 'All fields are required'}), 400
        
        # Check if CRN already exists
        existing_patient = Patient.query.filter_by(crn=crn).first()
        
        if existing_patient:
            return jsonify({'error': 'Patient with this CRN already exists'}), 400
        
        # Create patient record
        patient = Patient(
            crn=crn,
            uhid=uhid,
            patient_name=patient_name,
            dob=dob
        )
        db.session.add(patient)
        db.session.flush()  # Get the patient ID without committing
        
        # Handle file uploads
        uploaded_files = request.files.getlist('files')
        file_info = []
        
        for file in uploaded_files:
            if file and file.filename and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                unique_filename = f"{uuid.uuid4()}_{filename}"
                compressed_filepath = os.path.join(app.config['UPLOAD_FOLDER'], f"{unique_filename}.gz")
                
                # Save the already compressed file from the frontend
                file.save(compressed_filepath)
                
                # Check if the compressed file exceeds the size limit
                compressed_size = os.path.getsize(compressed_filepath)
                if compressed_size > MAX_FILE_SIZE:
                    os.remove(compressed_filepath)
                    return jsonify({'error': f'File {filename} exceeds maximum size limit of {MAX_FILE_SIZE} bytes'}), 400
                
                # Create file record
                file_record = File(
                    patient_id=patient.id,
                    filename=filename,
                    filepath=compressed_filepath,
                    file_size=compressed_size
                )
                db.session.add(file_record)
                
                file_info.append({
                    'filename': filename,
                    'size': compressed_size
                })
        
        db.session.commit()
        
        return jsonify({
            'success': True,
            'message': 'Patient record created successfully',
            'patient_id': patient.id,
            'files_uploaded': len(file_info)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/patients/search', methods=['GET'])
def search_patients():
    """Search for patient records"""
    try:
        search_type = request.args.get('search_type', '').lower()
        search_term = request.args.get('search_term', '')
        
        if not search_type or not search_term:
            return jsonify({'error': 'Search type and search term are required'}), 400
        
        # Build query based on search type
        if search_type == 'crn':
            patients = Patient.query.filter(Patient.crn.like(f'%{search_term}%')).all()
        elif search_type == 'uhid':
            patients = Patient.query.filter(Patient.uhid.like(f'%{search_term}%')).all()
        elif search_type == 'patient_name':
            patients = Patient.query.filter(Patient.patient_name.like(f'%{search_term}%')).all()
        else:
            return jsonify({'error': 'Invalid search type'}), 400
        
        # Get files for each patient
        results = []
        for patient in patients:
            patient_dict = {
                'id': patient.id,
                'crn': patient.crn,
                'uhid': patient.uhid,
                'patient_name': patient.patient_name,
                'dob': patient.dob,
                'created_at': patient.created_at.isoformat() if patient.created_at else None,
                'files': [{'id': f.id, 'filename': f.filename} for f in patient.files]
            }
            results.append(patient_dict)
        
        return jsonify(results), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/patients/<int:patient_id>', methods=['GET'])
def get_patient(patient_id):
    """Get patient details by ID"""
    try:
        patient = Patient.query.get(patient_id)
        
        if not patient:
            return jsonify({'error': 'Patient not found'}), 404
        
        patient_dict = {
            'id': patient.id,
            'crn': patient.crn,
            'uhid': patient.uhid,
            'patient_name': patient.patient_name,
            'dob': patient.dob,
            'created_at': patient.created_at.isoformat() if patient.created_at else None,
            'files': [{
                'id': f.id,
                'filename': f.filename,
                'file_size': f.file_size,
                'upload_date': f.upload_date.isoformat() if f.upload_date else None
            } for f in patient.files]
        }
        
        return jsonify(patient_dict), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/files/<int:file_id>', methods=['GET'])
def download_file(file_id):
    """Download a file by ID"""
    try:
        file_record = File.query.get(file_id)
        
        if not file_record:
            return jsonify({'error': 'File not found'}), 404
        
        compressed_filepath = file_record.filepath
        
        if not os.path.exists(compressed_filepath):
            return jsonify({'error': 'File not found on server'}), 404
        
        # Create a temporary decompressed file
        temp_decompressed_path = f"{compressed_filepath}.tmp"
        decompress_file(compressed_filepath, temp_decompressed_path)
        
        try:
            # Send the decompressed file
            return send_file(temp_decompressed_path, as_attachment=True, download_name=file_record.filename)
        finally:
            # Clean up the temporary decompressed file after sending
            if os.path.exists(temp_decompressed_path):
                os.remove(temp_decompressed_path)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/config', methods=['GET'])
def get_config():
    """Get server configuration including file size limits"""
    try:
        return jsonify({
            'max_file_size': MAX_FILE_SIZE,
            'allowed_extensions': list(ALLOWED_EXTENSIONS)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/sync', methods=['POST'])
def sync_data():
    """Sync local data with server"""
    try:
        # In a real implementation, this would handle synchronization
        # between local and server databases
        return jsonify({
            'success': True,
            'message': 'Data synced successfully',
            'synced_records': 0
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
        
        # Create a sample user for testing if it doesn't exist
        sample_user = User.query.filter_by(employee_id='EMP001').first()
        if not sample_user:
            sample_password_hash = hashlib.sha256("password123".encode()).hexdigest()
            sample_user = User(
                employee_id='EMP001',
                password_hash=sample_password_hash,
                name='Test User'
            )
            db.session.add(sample_user)
            db.session.commit()
    
    # Get host and port from environment variables with defaults
    host = os.environ.get('HOST', '0.0.0.0')
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_DEBUG', 'True').lower() == 'true'
    
    app.run(debug=debug, host=host, port=port)