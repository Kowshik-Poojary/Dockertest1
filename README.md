# CampusFit Application

A Node.js student registration application for learning Docker.

## 🚀 Quick Start

### 1. Setup

```bash
# Install dependencies
npm install

# Configure environment
cp .env.example .env
```

### 2. Start MongoDB

**Create MongoDB user:**
```bash
mongosh << 'EOF'
use admin
db.createUser({
  user: "campusfit_user",
  pwd: "campusfit_password",
  roles: [{ role: "readWrite", db: "campusfit_db" }]
})
exit
EOF
```

### 3. Run Application

```bash
npm start
```

Expected output:
```
✅ MongoDB connected successfully
🚀 CampusFit Application Started
📍 Server running on port 3000
```

## 📡 API Endpoints

### Health Check
```bash
curl http://localhost:3000/health
```

### Register Student
```bash
curl -X POST http://localhost:3000/student \
  -H "Content-Type: application/json" \
  -d '{"name":"Rahul","membership":"Premium"}'
```

**Membership types:** `Basic`, `Premium`, `Elite`

## 🧪 Test Everything

```bash
chmod +x test-api.sh
./test-api.sh
```

## 📦 What's Next?

This application runs locally. Your assignment is to **containerize it using Docker**.

You will:
- Write a `Dockerfile`
- Build and run Docker images
- Fix the MongoDB networking issue (hint: `localhost` won't work in containers!)
- Create `docker-compose.yml`
- Configure volumes for data persistence
- Push your image to Docker Hub

**The application is intentionally NOT Dockerized - that's your job!**

## 🐛 Troubleshooting

**MongoDB connection failed?**
```bash
sudo systemctl start mongod
mongosh --eval "db.version()"  # verify MongoDB is running
```

**Port already in use?**
```bash
lsof -ti:3000 | xargs kill -9
```

---

Good luck! 🚀
