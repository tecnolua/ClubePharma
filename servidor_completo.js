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
console.log(`📁 Servindo arquivos de: ${webDir}`);

// Verificar se o diretório existe
const fs = require('fs');
if (!fs.existsSync(webDir)) {
  console.error(`❌ ERRO: Diretório não encontrado: ${webDir}`);
  console.error(`Execute: cd clube_pharma_frontend && flutter build web`);
} else {
  console.log(`✅ Diretório encontrado!`);
}

app.use(express.static(webDir));

// Log de todas as requisições
app.use((req, res, next) => {
  console.log(`📥 ${req.method} ${req.path}`);
  next();
});

// SPA - todas as outras rotas servem o index.html
app.get('*', (req, res) => {
  const indexPath = path.join(webDir, 'index.html');
  console.log(`📄 Enviando: ${indexPath}`);
  res.sendFile(indexPath);
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
