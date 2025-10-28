// Script para criar usuário via API
const axios = require('axios');

// Configure a URL do seu backend
const API_URL = 'http://localhost:3000/api';

async function criarUsuario() {
  try {
    console.log('Criando novo usuário...\n');

    const novoUsuario = {
      name: 'Usuario Teste',
      email: 'teste@clubepharma.com',
      password: 'senha123',
      phone: '11999999999',
      cpf: '12345678900'
    };

    const response = await axios.post(`${API_URL}/auth/register`, novoUsuario);

    console.log('✅ Usuário criado com sucesso!');
    console.log('\n📧 Email:', novoUsuario.email);
    console.log('🔑 Senha:', novoUsuario.password);
    console.log('\nToken:', response.data.token);
    console.log('\nDados do usuário:', JSON.stringify(response.data.user, null, 2));

  } catch (error) {
    console.error('❌ Erro ao criar usuário:');
    if (error.response) {
      console.error('Erro:', error.response.data);
    } else {
      console.error(error.message);
    }
  }
}

criarUsuario();
