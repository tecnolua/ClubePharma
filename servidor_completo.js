// Servidor simples que serve o frontend web e faz proxy para o backend
const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = 8080;
const BACKEND_URL = 'http://localhost:3000';

// CORS
app.use(cors());

// Proxy para API - redireciona /api/* para o backend
app.use('/api', createProxyMiddleware({
  target: BACKEND_URL,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    console.log(`[PROXY] ${req.method} ${req.path} -> ${BACKEND_URL}${req.path}`);
  }
}));

// Proxy para uploads
app.use('/uploads', createProxyMiddleware({
  target: BACKEND_URL,
  changeOrigin: true
}));

// Proxy para health check
app.use('/health', createProxyMiddleware({
  target: BACKEND_URL,
  changeOrigin: true
}));

// Servir arquivos estáticos do Flutter Web
const webDir = path.join(__dirname, 'clube_pharma_frontend', 'build', 'web');
app.use(express.static(webDir));

// SPA - todas as outras rotas servem o index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(webDir, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log('\n========================================');
  console.log('  🚀 CLUBE PHARMA - Servidor Completo');
  console.log('========================================\n');
  console.log(`✅ Frontend Web: http://localhost:${PORT}`);
  console.log(`✅ Backend API: ${BACKEND_URL}`);
  console.log(`✅ Proxy: /api/* -> ${BACKEND_URL}/api/*\n`);
  console.log('🌐 Para acesso externo, use:');
  console.log(`   ngrok http ${PORT}\n`);
  console.log('========================================\n');
});
