// Servidor SUPER SIMPLES - Só serve os arquivos web
const express = require('express');
const path = require('path');

const app = express();
const PORT = 8080;

// Servir arquivos da pasta build/web
const webDir = path.resolve(__dirname, 'clube_pharma_frontend', 'build', 'web');
console.log(`\nServindo arquivos de: ${webDir}\n`);

app.use(express.static(webDir));

// Todas as rotas servem o index.html (SPA)
app.get('*', (req, res) => {
  res.sendFile(path.join(webDir, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`\n✅ Servidor rodando em: http://localhost:${PORT}\n`);
  console.log(`Para acesso externo:`);
  console.log(`   ngrok http ${PORT}\n`);
});
