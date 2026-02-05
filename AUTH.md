# Sistema de Autenticação - Meu Treino

Sistema completo de autenticação usando Google OAuth, JWT tokens e Pinia store.

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Configuração](#configuração)
3. [Como Funciona](#como-funciona)
4. [Como Usar](#como-usar)
5. [API Reference](#api-reference)
6. [Exemplos](#exemplos)

---

## Visão Geral

### Componentes do Sistema

- **Auth Store** (`src/stores/auth.store.ts`) - Gerencia estado de autenticação
- **Auth Interfaces** (`src/core/interfaces/auth.interface.ts`) - Tipagens TypeScript
- **useAuth Composable** (`src/composables/useAuth.ts`) - Helper para componentes
- **Axios Interceptors** (`src/boot/axios.ts`) - Adiciona token automaticamente
- **Route Guards** (`src/router/index.ts`) - Protege rotas privadas
- **Login Page** (`src/pages/LoginPage.vue`) - Página de login
- **Callback Page** (`src/pages/AuthCallbackPage.vue`) - Processa callback do Google

### Fluxo de Autenticação

```
1. Usuário clica em "Entrar com Google"
2. Redireciona para /login/google (backend)
3. Usuário autentica no Google
4. Google redireciona para /login/google/callback (backend)
5. Backend valida e retorna { accessToken: "JWT_TOKEN" }
6. Frontend recebe token e salva no localStorage
7. Faz requisição GET /me para buscar dados do usuário
8. Salva usuário no store
9. Redireciona para home (/)
```

---

## Configuração

### 1. Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
VITE_API_URL=http://localhost:3000
VITE_APP_NAME=Meu Treino
```

### 2. Configuração do Backend

Certifique-se que o backend tenha:

- **POST /login/google** - Inicia fluxo OAuth
- **GET /login/google/callback** - Retorna `{ accessToken: "JWT_TOKEN" }`
- **GET /me** - Retorna dados do usuário autenticado

### 3. URL de Callback

Configure no Google Cloud Console:

```
http://localhost:9000/#/auth/callback (desenvolvimento)
https://seuapp.com/#/auth/callback (produção)
```

---

## Como Funciona

### Auth Store

O store mantém o estado da autenticação:

```typescript
interface AuthState {
  user: AuthUser | null;
  token: string | null;
  loading: boolean;
  authenticating: boolean;
}
```

#### Actions Principais

- `loginWithGoogle()` - Redireciona para OAuth do Google
- `handleGoogleCallback(token)` - Processa token recebido
- `checkAuth()` - Verifica autenticação no localStorage
- `logout()` - Remove token e redireciona para login
- `fetchUser()` - Busca dados do usuário

### Axios Interceptors

Automaticamente adiciona o token JWT em todas as requisições:

```typescript
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('auth_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Route Guards

Protege rotas privadas verificando autenticação:

```typescript
Router.beforeEach(async (to, from, next) => {
  const publicRoutes = ['/login', '/auth/callback'];

  if (!publicRoutes.includes(to.path)) {
    const isAuth = await authStore.checkAuth();
    if (!isAuth) {
      next('/login');
      return;
    }
  }

  next();
});
```

---

## Como Usar

### Em Componentes Vue

```vue
<script setup lang="ts">
import { useAuth } from 'src/composables/useAuth';

const { user, isAuthenticated, loading, loginWithGoogle, logout } = useAuth();
</script>

<template>
  <div v-if="loading">Carregando...</div>

  <div v-else-if="isAuthenticated">
    <h1>Bem-vindo, {{ user?.name }}!</h1>
    <button @click="logout">Sair</button>
  </div>

  <div v-else>
    <button @click="loginWithGoogle">Entrar com Google</button>
  </div>
</template>
```

### Fazer Requisições Autenticadas

O token é adicionado automaticamente:

```typescript
import { api } from 'src/boot/axios';

// Token JWT é incluído automaticamente
const response = await api.get('/trainings');
```

### Verificar Autenticação

```typescript
import { useAuth } from 'src/composables/useAuth';

const { isAuthenticated, checkAuth } = useAuth();

// Verificar no mount
onMounted(async () => {
  const isAuth = await checkAuth();
  if (!isAuth) {
    router.push('/login');
  }
});

// Ou usar computed
if (isAuthenticated.value) {
  // Usuário autenticado
}
```

### Atualizar Dados do Usuário

```typescript
const { updateUser } = useAuth();

updateUser({
  name: 'Novo Nome',
  avatar: 'https://...',
});
```

---

## API Reference

### useAuth()

Retorna:

```typescript
{
  // Estado
  user: ComputedRef<AuthUser | null>;
  token: ComputedRef<string | null>;
  loading: ComputedRef<boolean>;
  authenticating: ComputedRef<boolean>;

  // Getters
  isAuthenticated: ComputedRef<boolean>;
  userName: ComputedRef<string>;
  userEmail: ComputedRef<string | null>;
  userAvatar: ComputedRef<string | null>;

  // Actions
  loginWithGoogle: () => void;
  handleGoogleCallback: (token: string) => Promise<void>;
  fetchUser: () => Promise<void>;
  logout: () => Promise<void>;
  checkAuth: () => Promise<boolean>;
  updateUser: (updates: Partial<AuthUser>) => void;
}
```

### AuthUser Interface

```typescript
interface AuthUser {
  id: number;
  email: string;
  name: string;
  avatar?: string;
  createdAt?: Date;
}
```

### AuthState Interface

```typescript
interface AuthState {
  user: AuthUser | null;
  token: string | null;
  loading: boolean;
  authenticating: boolean;
}
```

---

## Exemplos

### Página de Login Completa

```vue
<template>
  <div class="login-page">
    <h1>Bem-vindo</h1>

    <button @click="handleLogin" :disabled="authenticating">
      {{ authenticating ? 'Redirecionando...' : 'Entrar com Google' }}
    </button>
  </div>
</template>

<script setup lang="ts">
import { useAuth } from 'src/composables/useAuth';
import { useRouter } from 'vue-router';

const router = useRouter();
const { isAuthenticated, authenticating, loginWithGoogle } = useAuth();

// Redireciona se já estiver logado
if (isAuthenticated.value) {
  router.push('/');
}

function handleLogin() {
  loginWithGoogle();
}
</script>
```

### Header com Menu do Usuário

```vue
<template>
  <header>
    <h1>Meu App</h1>

    <div v-if="isAuthenticated" class="user-menu">
      <img :src="userAvatar || '/default-avatar.png'" />
      <span>{{ userName }}</span>
      <button @click="handleLogout">Sair</button>
    </div>
  </header>
</template>

<script setup lang="ts">
import { useAuth } from 'src/composables/useAuth';

const { isAuthenticated, userName, userAvatar, logout } = useAuth();

async function handleLogout() {
  await logout();
}
</script>
```

### Guard em Rota Específica

```typescript
// src/router/routes.ts
{
  path: '/admin',
  component: () => import('pages/AdminPage.vue'),
  beforeEnter: async (to, from, next) => {
    const authStore = useAuthStore();
    const isAuth = await authStore.checkAuth();

    if (!isAuth) {
      next('/login');
    } else {
      next();
    }
  }
}
```

### Composable Customizado

```typescript
// src/composables/useProtectedData.ts
import { ref, onMounted } from 'vue';
import { useAuth } from 'src/composables/useAuth';
import { api } from 'src/boot/axios';

export function useProtectedData() {
  const { isAuthenticated, checkAuth } = useAuth();
  const data = ref(null);
  const loading = ref(false);

  async function loadData() {
    // Verifica autenticação primeiro
    const isAuth = await checkAuth();
    if (!isAuth) return;

    loading.value = true;
    try {
      const response = await api.get('/protected-data');
      data.value = response.data;
    } finally {
      loading.value = false;
    }
  }

  onMounted(() => {
    if (isAuthenticated.value) {
      loadData();
    }
  });

  return { data, loading, loadData };
}
```

---

## Estrutura de Arquivos

```
src/
├── boot/
│   └── axios.ts (interceptors configurados)
├── composables/
│   └── useAuth.ts
├── core/
│   └── interfaces/
│       └── auth.interface.ts
├── stores/
│   └── auth.store.ts
├── pages/
│   ├── LoginPage.vue
│   └── AuthCallbackPage.vue
├── router/
│   ├── index.ts (guards configurados)
│   └── routes.ts
└── components/
    └── layout/
        └── Header/
            └── HeaderWithAuth.vue
```

---

## Troubleshooting

### Token não está sendo enviado

Verifique se o axios está usando a instância `api` e não `axios`:

```typescript
// ❌ Errado
import axios from 'axios';
axios.get('/trainings');

// ✅ Correto
import { api } from 'src/boot/axios';
api.get('/trainings');
```

### Redirecionamento infinito

Certifique-se que as rotas de login estão nas rotas públicas:

```typescript
const publicRoutes = ['/login', '/auth/callback'];
```

### Token expira mas não faz logout

O interceptor do axios já trata isso automaticamente ao receber 401.

### Dados do usuário não aparecem

Verifique se o endpoint `/me` está retornando os dados corretos.

---

## Segurança

### Boas Práticas

1. **Nunca** armazene senhas no localStorage
2. Use HTTPS em produção
3. Configure CORS corretamente no backend
4. Implemente refresh token (recomendado)
5. Defina tempo de expiração do token
6. Valide tokens no backend em cada requisição

### Refresh Token (Futuro)

Considere implementar refresh token para melhor segurança:

```typescript
// Exemplo básico
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Tenta renovar token
      const refreshToken = localStorage.getItem('refresh_token');
      if (refreshToken) {
        const newToken = await renewToken(refreshToken);
        // Retry requisição com novo token
      }
    }
    return Promise.reject(error);
  },
);
```

---

## Próximos Passos

1. Configure o `.env` com a URL da sua API
2. Teste o fluxo de login completo
3. Customize as páginas de login/callback
4. Implemente tratamento de erros mais robusto
5. Adicione loading states visuais
6. Configure analytics para login/logout

🎉 Seu sistema de autenticação está pronto para uso!
