# Deployment Guide

This guide covers various deployment options for the AI Demo App.

## 🚀 Quick Start

### Local Development
```bash
# Clone and setup
git clone https://github.com/obidhonyi/ai-demo-app.git
cd ai-demo-app
npm install

# Start development servers
npm run dev      # Frontend (http://localhost:3000)
npm run api      # Backend (http://localhost:3001)
```

### Production Build
```bash
# Build the application
npm run build

# Start production servers
npm run preview  # Frontend
npm run api      # Backend
```

## 🐳 Docker Deployment

### Single Container
```bash
# Build Docker image
docker build -t ai-demo-app .

# Run container
docker run -p 3000:3000 -p 3001:3001 ai-demo-app
```

### Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Multi-stage Build
The Dockerfile uses multi-stage builds for optimization:
- **deps**: Install production dependencies
- **builder**: Build the application
- **runner**: Create minimal production image

## ☁️ Cloud Deployment

### Vercel (Frontend)
1. Connect your GitHub repository to Vercel
2. Set build command: `npm run build`
3. Set output directory: `dist`
4. Deploy automatically on push to main

### Railway (Full-stack)
1. Connect your GitHub repository to Railway
2. Set environment variables if needed
3. Railway will automatically detect and deploy

### Heroku
1. Create a `Procfile`:
   ```
   web: npm run preview & node server.js
   ```
2. Deploy using Heroku CLI or GitHub integration

### AWS EC2
1. Launch an EC2 instance (Ubuntu 20.04+)
2. Install Node.js 18+ and Docker
3. Clone repository and run setup script
4. Configure security groups for ports 3000 and 3001
5. Use PM2 for process management

### Google Cloud Run
1. Build and push Docker image to Google Container Registry
2. Deploy using Cloud Run with port 3000 and 3001
3. Configure load balancing if needed

## 🔧 Environment Configuration

### Environment Variables
Create a `.env` file for production:
```env
NODE_ENV=production
PORT=3001
FRONTEND_URL=http://localhost:3000
API_URL=http://localhost:3001
```

### Production Optimizations
- Enable gzip compression
- Set up CDN for static assets
- Configure caching headers
- Use HTTPS in production
- Set up monitoring and logging

## 📊 Monitoring and Health Checks

### Health Check Endpoints
- **API Health**: `GET /api/health`
- **Demo Data**: `GET /api/demo`

### Monitoring Setup
```bash
# Using PM2 for process management
npm install -g pm2
pm2 start server.js --name "ai-demo-api"
pm2 start "npm run preview" --name "ai-demo-frontend"
pm2 monit
```

### Logging
```javascript
// Add to server.js for production logging
const winston = require('winston');
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

## 🔒 Security Considerations

### Production Security
- Use HTTPS in production
- Set up CORS properly for your domain
- Implement rate limiting
- Add input validation
- Use environment variables for secrets
- Regular security updates

### CORS Configuration
```javascript
// In server.js
const corsOptions = {
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true,
  optionsSuccessStatus: 200
};
app.use(cors(corsOptions));
```

## 📈 Performance Optimization

### Frontend Optimizations
- Enable Vite's production optimizations
- Use code splitting
- Optimize images and assets
- Implement lazy loading
- Use service workers for caching

### Backend Optimizations
- Enable compression middleware
- Implement caching strategies
- Use connection pooling
- Monitor memory usage
- Optimize database queries

## 🚨 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Find process using port
lsof -i :3000
lsof -i :3001

# Kill process
kill -9 <PID>
```

#### Build Failures
```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm run build
```

#### Docker Issues
```bash
# Clean up Docker
docker system prune -a
docker build --no-cache -t ai-demo-app .
```

### Debug Mode
```bash
# Enable debug logging
DEBUG=* npm run dev
DEBUG=* npm run api
```

## 📋 Deployment Checklist

### Pre-deployment
- [ ] All tests pass
- [ ] Build succeeds locally
- [ ] Environment variables configured
- [ ] Security review completed
- [ ] Performance testing done

### Post-deployment
- [ ] Health checks passing
- [ ] All endpoints responding
- [ ] Monitoring configured
- [ ] Logs being collected
- [ ] Backup strategy in place

## 🔄 CI/CD Pipeline

The project includes GitHub Actions workflow for:
- Automated testing
- Type checking
- Linting
- Docker image building
- Deployment to staging/production

### Manual Deployment
```bash
# Build and test
npm run build
npm run type-check

# Deploy to production
docker build -t ai-demo-app:latest .
docker push your-registry/ai-demo-app:latest
```

## 📞 Support

For deployment issues:
- Check the [GitHub Issues](https://github.com/obidhonyi/ai-demo-app/issues)
- Review the [Troubleshooting](#troubleshooting) section
- Contact the maintainers

---

*This deployment guide covers the most common deployment scenarios. For specific platform requirements, refer to the platform's official documentation.*
