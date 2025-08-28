# 😺🐶Pet App 
Minimal backend for the Flutter (GetX) app. Supports register/login with JWT, CRUD for pets, and optional pet photos stored in MongoDB **GridFS** (no files left on disk).
<p align="center">
  <a href="https://flutter.dev/"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-Mobile-02569B?logo=flutter&logoColor=white"></a>
  <a href="https://pub.dev/packages/get"><img alt="GetX" src="https://img.shields.io/badge/GetX-State%20%26%20Routes-8A2BE2"></a>
  <a href="https://www.python.org/"><img alt="Python" src="https://img.shields.io/badge/Python-3.11%2B-3776AB?logo=python&logoColor=white"></a>
  <a href="https://fastapi.tiangolo.com/"><img alt="FastAPI" src="https://img.shields.io/badge/FastAPI-💨-009688?logo=fastapi&logoColor=white"></a>
  <a href="https://www.uvicorn.org/"><img alt="Uvicorn" src="https://img.shields.io/badge/Uvicorn-ASGI-2E8B57"></a>
  <a href="https://www.mongodb.com/"><img alt="MongoDB" src="https://img.shields.io/badge/MongoDB-Atlas/Local-47A248?logo=mongodb&logoColor=white"></a>
  <a href="https://motor.readthedocs.io/"><img alt="Motor" src="https://img.shields.io/badge/Motor-async%20Mongo%20driver-4B8BBE"></a>
  <a href="https://github.com/mpdavis/python-jose"><img alt="JWT (python-jose)" src="https://img.shields.io/badge/JWT-python--jose-000000?logo=jsonwebtokens&logoColor=white"></a>


</p>

---

## Tech
- **FastAPI** (ASGI)
- **MongoDB** via **Motor**
- **JWT** (python-jose) + **Passlib[bcrypt]**
- **GridFS** for image storage
---

## Project Layout
backend/
├─ app/ <br>
│ ├─ main.py # FastAPI app, CORS, routers<br>
│ ├─ config.py # loads .env (URIs, secrets)<br>
│ ├─ database.py # Motor client, connect/close<br>
│ ├─ models.py # Pydantic models (schemas)<br>
│ ├─ auth.py # hashing + JWT helpers<br>
│ ├─ deps.py # auth dependency (Bearer)<br>
│ └─ routers/<br>
│ ├─ auth.py # /auth/register, /auth/login<br>
│ └─ pets.py # /pets CRUD + photo upload/Get<br>
├─ requirements.txt<br>
├─ .env # your environment (not committed)<br>
└─ README.md<br>

---

## Prerequisites

- **Python 3.11+** (3.12/3.13 also OK)
- **MongoDB**
  - Local: MongoDB Community Server
  - or Cloud: MongoDB **Atlas** (free M0)
- Windows PowerShell or macOS/Linux shell

---

## 1) Create & activate a virtual environment

**Windows (PowerShell):**
```powershell
cd backend
py -m venv .venv
.\.venv\Scripts\activate
```

macOS/Linux:
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
```
## 2) Install dependencies
```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## 3) Configure environment (.env)
Local MongoDB
```bash
Create backend/.env (same folder as requirements.txt).

MONGODB_URI=mongodb://localhost:27017
MONGO_DB=pets_app

JWT_SECRET=change-this-to-a-long-random-string
ACCESS_TOKEN_EXPIRE_MINUTES=60

# Comma-separated list of web origins for CORS (leave empty to allow all)
ALLOWED_ORIGINS=
```
MongoDB Atlas
```bash
MONGODB_URI=mongodb+srv://<username>:<URL-ENCODED-PASSWORD>@<cluster>.mongodb.net/?retryWrites=true&w=majority
MONGO_DB=pets_app

JWT_SECRET=replace-with-strong-secret
ACCESS_TOKEN_EXPIRE_MINUTES=60
ALLOWED_ORIGINS=
```

## 4) Run the server

Windows:
```bash
# from backend/
.\.venv\Scripts\python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

macOS/Linux:
```bash
# from backend/
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
Open:
Health: http://localhost:8000/ <br>
Docs (Swagger): http://localhost:8000/docs<br>
If accessing from a phone on the same Wi-Fi, use your PC’s LAN IP, e.g. http://192.168.1.36:8000<br>

---
## API Overview

### Auth
- `POST /auth/register` — Body: `{ "email": string, "password": string }` → **201 Created**
- `POST /auth/login` — Body: `{ "email": string, "password": string }` → `{ "token": string }`

### Pets
- `GET /pets` — List your pets
- `POST /pets` — Create pet; Body: `{ "name": string, "type": string, "age": number, "notes": string }` → Created pet
- `PATCH /pets/{id}` — Update any of `{ name, type, age, notes }` (partial body allowed) → Updated pet
- `DELETE /pets/{id}` — Delete pet (also deletes its photo if present)

### Photos (GridFS; no disk files)
- `POST /pets/{id}/photo` — `multipart/form-data` with field **`file`** (`jpeg/png/webp` ≤ 5MB)  
  - On success, sets `photo_url` to `"/pets/{id}/photo"`.
- `GET /pets/{id}/photo` — Returns image bytes  
  - **Auth required:** `Authorization: Bearer <token>`

---
### 🤝 Contributing
```bash
git checkout -b feature/your-feature
git commit -m "Add: new feature"
git push origin feature/your-feature
```
## 🌍 Contact
**💻 Author: Utkarsh**<br>
**📧 Email: ubhatt2004@gmail.com**<br>
**🐙 GitHub: https://github.com/UKbhatt**<br>
