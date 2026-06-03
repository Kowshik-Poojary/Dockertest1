# Instructor Guide

## Quick Verification (5 min)

```bash
npm install
cp .env.example .env

# Create MongoDB user
mongosh << 'EOF'
use admin
db.createUser({
  user: "campusfit_user",
  pwd: "campusfit_password",
  roles: [{ role: "readWrite", db: "campusfit_db" }]
})
EOF

# Start and test
npm start
./test-api.sh
```

## What Students Will Learn

### Day 1: Single Container
- Write `Dockerfile`
- Build image
- **Debug the `localhost` networking issue** (key learning moment!)
- Run containerized app

### Day 2: Multi-Container
- Create `docker-compose.yml`
- Configure MongoDB container
- Setup Docker networks
- Configure persistent volumes
- Push to Docker Hub

## The Intentional Bug 🎯

`.env.example` has `localhost` in `MONGO_URI`. This **WILL FAIL** when containerized.

Students must discover:
- Why `localhost` doesn't work in containers
- How to use `host.docker.internal` or container names
- Docker networking basics

**This is the main learning moment - don't fix it for them!**

## Expected Docker Files (Students Create These)

**Dockerfile:**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - MONGO_URI=mongodb://campusfit_user:campusfit_password@mongodb:27017/campusfit_db?authSource=admin
    depends_on:
      - mongodb
  mongodb:
    image: mongo:7
    environment:
      - MONGO_INITDB_ROOT_USERNAME=campusfit_user
      - MONGO_INITDB_ROOT_PASSWORD=campusfit_password
    volumes:
      - mongodb_data:/data/db
volumes:
  mongodb_data:
```

## Success Criteria

Students complete when:
- ✅ `docker-compose up -d` starts everything
- ✅ Both API endpoints work
- ✅ Data persists after restart
- ✅ Image on Docker Hub
- ✅ Can explain networking & volumes

## Common Issues

| Issue | Solution |
|-------|----------|
| MongoDB auth failed | Recreate user with provided commands |
| Port in use | `lsof -ti:3000 \| xargs kill -9` |
| localhost not working | Teach Docker networking (don't fix it!) |

---

**Time estimate:** 6-8 hours total (2 days)
