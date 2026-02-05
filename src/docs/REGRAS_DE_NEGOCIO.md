# Documentação de Regras de Negócio - Sistema Melhorzin Treino

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Módulo de Autenticação](#módulo-de-autenticação)
3. [Módulo de Usuários](#módulo-de-usuários)
4. [Módulo de Treinos](#módulo-de-treinos)
5. [Segurança e Autorização](#segurança-e-autorização)
6. [Estrutura de Dados](#estrutura-de-dados)

---

## 🎯 Visão Geral

O **Melhorzin Treino** é um sistema de gerenciamento de planos de treino que permite aos usuários criar, gerenciar e acompanhar seus treinos de forma estruturada. O sistema possui três módulos principais:

- **Autenticação**: Registro e login de usuários
- **Usuários**: Gerenciamento de perfis e permissões
- **Treinos**: Criação e gerenciamento de planos de treino, dias de treino e exercícios

---

## 🔐 Módulo de Autenticação

### Endpoints

#### 1. Registro de Usuário

**Endpoint:** `POST /register`  
**Autenticação:** Não requerida  
**Tags:** Auth

##### Regras de Negócio:

- ✅ Email deve ser válido (formato de email)
- ✅ Senha deve ter no mínimo 6 caracteres
- ✅ Nome é opcional
- ✅ Ao registrar, o usuário recebe automaticamente a role "user"
- ✅ Email deve ser único no sistema
- ✅ Senha é armazenada com hash (bcrypt)

##### Request Body:

```json
{
  "name": "string (opcional)",
  "email": "string (email válido)",
  "password": "string (mínimo 6 caracteres)"
}
```

##### Response (201):

```json
{
  "id": "number",
  "name": "string | null",
  "email": "string",
  "role": "string",
  "createdAt": "date"
}
```

---

#### 2. Login de Usuário

**Endpoint:** `POST /login`  
**Autenticação:** Não requerida  
**Tags:** Auth

##### Regras de Negócio:

- ✅ Email deve ser válido
- ✅ Senha é obrigatória
- ✅ Credenciais devem corresponder a um usuário existente
- ✅ Retorna um token JWT válido por tempo configurado
- ✅ Token contém informações do usuário (id, email, role)

##### Request Body:

```json
{
  "email": "string (email válido)",
  "password": "string"
}
```

##### Response (200):

```json
{
  "token": "string (JWT)",
  "user": {
    "id": "number",
    "name": "string | null",
    "email": "string",
    "role": "string",
    "createdAt": "date"
  }
}
```

---

## 👤 Módulo de Usuários

### Middleware de Autorização

- 🔒 Todas as rotas de usuários requerem autenticação via JWT
- 🔒 Token deve ser enviado no header Authorization: `Bearer <token>`
- 🔒 Token inválido ou ausente retorna erro 401

### Endpoints

#### 1. Buscar Perfil do Usuário Logado

**Endpoint:** `GET /me`  
**Autenticação:** Requerida (JWT)  
**Tags:** Users

##### Regras de Negócio:

- ✅ Retorna informações do usuário autenticado
- ✅ Usuário é identificado pelo token JWT
- ✅ Não expõe a senha do usuário

##### Response (200):

```json
{
  "id": "number",
  "name": "string | null",
  "email": "string",
  "role": "string",
  "createdAt": "date"
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente

---

#### 2. Listar Todos os Usuários

**Endpoint:** `GET /users`  
**Autenticação:** Requerida (JWT + Admin)  
**Tags:** Users

##### Regras de Negócio:

- ✅ Apenas usuários com role "admin" podem acessar
- ✅ Retorna lista completa de todos os usuários
- ✅ Não expõe senhas dos usuários
- ⚠️ Usuários com role "user" recebem erro 403 (Forbidden)

##### Response (200):

```json
[
  {
    "id": "number",
    "name": "string | null",
    "email": "string",
    "role": "string",
    "createdAt": "date"
  }
]
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **403**: Usuário não tem permissão (não é admin)

---

#### 3. Atualizar Usuário

**Endpoint:** `PATCH /users/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Users

##### Regras de Negócio:

- ✅ Usuário pode atualizar seus próprios dados
- ✅ Todos os campos são opcionais
- ✅ Email deve ser válido se fornecido
- ✅ Senha deve ter mínimo 6 caracteres se fornecida
- ✅ Role pode ser "admin" ou "user"
- ✅ Nova senha é armazenada com hash
- ⚠️ Usuário deve existir (404 se não encontrado)

##### Request Body:

```json
{
  "name": "string (opcional)",
  "email": "string (email válido, opcional)",
  "password": "string (mínimo 6 caracteres, opcional)",
  "role": "admin | user (opcional)"
}
```

##### Response (200):

```json
{
  "id": "number",
  "name": "string | null",
  "email": "string",
  "role": "string",
  "createdAt": "date"
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Usuário não encontrado

---

#### 4. Deletar Usuário

**Endpoint:** `DELETE /users/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Users

##### Regras de Negócio:

- ✅ Usuário pode deletar sua própria conta
- ✅ Admins podem deletar qualquer conta
- ✅ Deleta todos os dados relacionados (treinos, exercícios)
- ⚠️ Usuário deve existir (404 se não encontrado)
- ⚠️ Ação irreversível

##### Response (204):

Sem conteúdo (sucesso)

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Usuário não encontrado

---

## 💪 Módulo de Treinos

### Middleware de Autorização

- 🔒 Todas as rotas de treinos requerem autenticação via JWT
- 🔒 Token deve ser enviado no header Authorization: `Bearer <token>`
- 🔒 Token inválido ou ausente retorna erro 401

### Hierarquia de Entidades

```
Plano de Treino (TrainingPlan)
  └── Dia de Treino (DailyWorkout)
      └── Exercício (Exercise)
```

---

### 📊 Planos de Treino (Training Plans)

#### 1. Criar Plano de Treino

**Endpoint:** `POST /trainings`  
**Autenticação:** Requerida (JWT)  
**Tags:** Trainings

##### Regras de Negócio:

- ✅ Nome do plano é obrigatório
- ✅ Plano é automaticamente associado ao usuário autenticado
- ✅ Pode incluir dias de treino na criação
- ✅ Cada dia de treino pode incluir exercícios
- ✅ Dias de treino devem ter nome único dentro do plano
- ✅ Exercícios devem ter: nome, séries (número inteiro) e repetições (string)

##### Request Body:

```json
{
  "name": "string (obrigatório)",
  "dailyWorkouts": [
    {
      "dayName": "string",
      "exercises": [
        {
          "name": "string",
          "sets": "number (inteiro)",
          "reps": "string"
        }
      ]
    }
  ]
}
```

##### Response (201):

```json
{
  "id": "number",
  "name": "string",
  "userId": "number",
  "dailyWorkouts": [
    {
      "id": "number",
      "dayName": "string",
      "exercises": [
        {
          "id": "number",
          "name": "string",
          "sets": "number",
          "reps": "string"
        }
      ]
    }
  ]
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente

---

#### 2. Listar Planos de Treino

**Endpoint:** `GET /trainings`  
**Autenticação:** Requerida (JWT)  
**Tags:** Trainings

##### Regras de Negócio:

- ✅ Retorna apenas planos do usuário autenticado
- ✅ Inclui todos os dias de treino e exercícios
- ✅ Ordenação padrão por data de criação
- ✅ Usuário não pode ver planos de outros usuários

##### Response (200):

```json
[
  {
    "id": "number",
    "name": "string",
    "userId": "number",
    "dailyWorkouts": [...]
  }
]
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente

---

#### 3. Buscar Plano de Treino Específico

**Endpoint:** `GET /trainings/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Trainings

##### Regras de Negócio:

- ✅ ID deve ser um número válido
- ✅ Retorna plano completo com dias e exercícios
- ✅ Usuário só pode acessar seus próprios planos
- ⚠️ Retorna 404 se plano não existir ou não pertencer ao usuário

##### Response (200):

```json
{
  "id": "number",
  "name": "string",
  "userId": "number",
  "dailyWorkouts": [...]
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Plano não encontrado ou não pertence ao usuário

---

#### 4. Atualizar Plano de Treino

**Endpoint:** `PATCH /trainings/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Trainings

##### Regras de Negócio:

- ✅ ID deve ser um número válido
- ✅ Apenas o nome pode ser atualizado
- ✅ Nome é opcional na atualização
- ✅ Usuário só pode atualizar seus próprios planos
- ⚠️ Retorna 404 se plano não existir ou não pertencer ao usuário

##### Request Body:

```json
{
  "name": "string (opcional)"
}
```

##### Response (200):

```json
{
  "id": "number",
  "name": "string",
  "userId": "number",
  "dailyWorkouts": [...]
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Plano não encontrado ou não pertence ao usuário

---

#### 5. Deletar Plano de Treino

**Endpoint:** `DELETE /trainings/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Trainings

##### Regras de Negócio:

- ✅ ID deve ser um número válido
- ✅ Deleta o plano e todos os dias/exercícios relacionados (cascade)
- ✅ Usuário só pode deletar seus próprios planos
- ⚠️ Retorna 404 se plano não existir ou não pertencer ao usuário
- ⚠️ Ação irreversível

##### Response (204):

Sem conteúdo (sucesso)

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Plano não encontrado ou não pertence ao usuário

---

### 📅 Dias de Treino (Daily Workouts)

#### 1. Adicionar Dia de Treino

**Endpoint:** `POST /trainings/:id/workouts`  
**Autenticação:** Requerida (JWT)  
**Tags:** Daily Workouts

##### Regras de Negócio:

- ✅ ID do plano deve ser válido
- ✅ Nome do dia é obrigatório (ex: "Segunda - Peito", "A", "Push")
- ✅ Plano deve pertencer ao usuário autenticado
- ✅ Dia é criado sem exercícios inicialmente
- ⚠️ Retorna 404 se plano não existir ou não pertencer ao usuário

##### Request Body:

```json
{
  "dayName": "string (obrigatório)"
}
```

##### Response (201):

```json
{
  "id": "number",
  "dayName": "string",
  "exercises": []
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Plano não encontrado ou não pertence ao usuário

---

#### 2. Atualizar Dia de Treino

**Endpoint:** `PATCH /workouts/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Daily Workouts

##### Regras de Negócio:

- ✅ ID do dia deve ser válido
- ✅ Nome do dia é opcional
- ✅ Dia deve pertencer a um plano do usuário autenticado
- ⚠️ Retorna 404 se dia não existir ou não pertencer ao usuário

##### Request Body:

```json
{
  "dayName": "string (opcional)"
}
```

##### Response (200):

```json
{
  "id": "number",
  "dayName": "string",
  "exercises": [...]
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Dia de treino não encontrado ou não pertence ao usuário

---

#### 3. Deletar Dia de Treino

**Endpoint:** `DELETE /workouts/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Daily Workouts

##### Regras de Negócio:

- ✅ ID do dia deve ser válido
- ✅ Deleta o dia e todos os exercícios relacionados (cascade)
- ✅ Dia deve pertencer a um plano do usuário autenticado
- ⚠️ Retorna 404 se dia não existir ou não pertencer ao usuário
- ⚠️ Ação irreversível

##### Response (204):

Sem conteúdo (sucesso)

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Dia de treino não encontrado ou não pertence ao usuário

---

### 🏋️ Exercícios (Exercises)

#### 1. Adicionar Exercício

**Endpoint:** `POST /workouts/:id/exercises`  
**Autenticação:** Requerida (JWT)  
**Tags:** Exercises

##### Regras de Negócio:

- ✅ ID do dia de treino deve ser válido
- ✅ Nome do exercício é obrigatório
- ✅ Séries deve ser um número inteiro positivo
- ✅ Repetições é uma string (permite formatos como "8-12", "até a falha", "20 seg")
- ✅ Dia de treino deve pertencer ao usuário autenticado
- ⚠️ Retorna 404 se dia não existir ou não pertencer ao usuário

##### Request Body:

```json
{
  "name": "string (obrigatório)",
  "sets": "number (inteiro, obrigatório)",
  "reps": "string (obrigatório)"
}
```

##### Exemplos de repetições válidas:

- "10"
- "8-12"
- "até a falha"
- "30 segundos"
- "AMRAP"

##### Response (201):

```json
{
  "id": "number",
  "name": "string",
  "sets": "number",
  "reps": "string"
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Dia de treino não encontrado ou não pertence ao usuário

---

#### 2. Atualizar Exercício

**Endpoint:** `PATCH /exercises/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Exercises

##### Regras de Negócio:

- ✅ ID do exercício deve ser válido
- ✅ Todos os campos são opcionais
- ✅ Séries deve ser inteiro se fornecido
- ✅ Exercício deve pertencer ao usuário autenticado
- ⚠️ Retorna 404 se exercício não existir ou não pertencer ao usuário

##### Request Body:

```json
{
  "name": "string (opcional)",
  "sets": "number (inteiro, opcional)",
  "reps": "string (opcional)"
}
```

##### Response (200):

```json
{
  "id": "number",
  "name": "string",
  "sets": "number",
  "reps": "string"
}
```

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Exercício não encontrado ou não pertence ao usuário

---

#### 3. Deletar Exercício

**Endpoint:** `DELETE /exercises/:id`  
**Autenticação:** Requerida (JWT)  
**Tags:** Exercises

##### Regras de Negócio:

- ✅ ID do exercício deve ser válido
- ✅ Exercício deve pertencer ao usuário autenticado
- ⚠️ Retorna 404 se exercício não existir ou não pertencer ao usuário
- ⚠️ Ação irreversível

##### Response (204):

Sem conteúdo (sucesso)

##### Possíveis Erros:

- **401**: Token inválido ou ausente
- **404**: Exercício não encontrado ou não pertence ao usuário

---

## 🔒 Segurança e Autorização

### Autenticação JWT

#### Configuração

- **Algoritmo**: HS256 (padrão Fastify JWT)
- **Header**: `Authorization: Bearer <token>`
- **Payload**: Contém informações do usuário (id, email, role)

#### Middleware de Autorização

```typescript
// Função: authorizer
// Localização: src/middlewares/auth.ts
```

##### Comportamento:

1. Verifica presença do token no header
2. Valida assinatura do token
3. Decodifica payload do token
4. Anexa informações do usuário ao request
5. Retorna 401 se token inválido ou ausente

#### Rotas Protegidas

- ✅ **Todas as rotas de `/users`** requerem autenticação
- ✅ **Todas as rotas de `/trainings`** requerem autenticação
- ❌ **Rotas de `/register` e `/login`** são públicas

### Controle de Acesso por Role

#### Roles Disponíveis:

- **admin**: Acesso total ao sistema
- **user**: Acesso limitado aos próprios recursos

#### Regras de Acesso:

| Endpoint               | User                | Admin               |
| ---------------------- | ------------------- | ------------------- |
| GET /me                | ✅ Próprio perfil   | ✅ Próprio perfil   |
| GET /users             | ❌ Forbidden        | ✅ Todos usuários   |
| PATCH /users/:id       | ✅ Próprio perfil   | ✅ Qualquer usuário |
| DELETE /users/:id      | ✅ Própria conta    | ✅ Qualquer conta   |
| Todas rotas /trainings | ✅ Próprios treinos | ✅ Próprios treinos |

### Isolamento de Dados

#### Princípios:

1. **Usuários só acessam seus próprios dados**
   - Planos de treino são filtrados por userId
   - Dias de treino são validados via plano do usuário
   - Exercícios são validados via dia de treino do usuário

2. **Validação em cascata**

   ```
   User → TrainingPlan → DailyWorkout → Exercise
   ```

3. **Deleção em cascata**
   - Deletar usuário → deleta todos seus planos
   - Deletar plano → deleta todos seus dias
   - Deletar dia → deleta todos seus exercícios

---

## 📊 Estrutura de Dados

### Entidade: User (Usuário)

```typescript
{
  id: number; // ID único, auto-incremento
  name: string | null; // Nome do usuário (opcional)
  email: string; // Email único, obrigatório
  password: string; // Hash bcrypt, nunca exposto
  role: "admin" | "user"; // Papel do usuário
  createdAt: Date; // Data de criação
}
```

**Validações:**

- Email deve ser válido
- Senha mínimo 6 caracteres
- Email único no sistema
- Role padrão: "user"

---

### Entidade: TrainingPlan (Plano de Treino)

```typescript
{
  id: number;                    // ID único, auto-incremento
  name: string;                  // Nome do plano
  userId: number;                // FK para User
  dailyWorkouts: DailyWorkout[]; // Relação 1:N
}
```

**Validações:**

- Nome obrigatório
- Deve pertencer a um usuário válido
- Usuário só acessa próprios planos

---

### Entidade: DailyWorkout (Dia de Treino)

```typescript
{
  id: number;              // ID único, auto-incremento
  dayName: string;         // Nome do dia (ex: "Segunda - Peito")
  trainingPlanId: number;  // FK para TrainingPlan
  exercises: Exercise[];   // Relação 1:N
}
```

**Validações:**

- dayName obrigatório
- Deve pertencer a um plano válido
- Plano deve pertencer ao usuário

---

### Entidade: Exercise (Exercício)

```typescript
{
  id: number; // ID único, auto-incremento
  name: string; // Nome do exercício
  sets: number; // Número de séries (inteiro)
  reps: string; // Repetições (formato flexível)
  dailyWorkoutId: number; // FK para DailyWorkout
}
```

**Validações:**

- Nome obrigatório
- Sets deve ser inteiro positivo
- Reps é string (permite formatos variados)
- Deve pertencer a um dia válido

---

## 📝 Códigos de Status HTTP

### Sucesso

- **200 OK**: Operação bem-sucedida (GET, PATCH)
- **201 Created**: Recurso criado com sucesso (POST)
- **204 No Content**: Recurso deletado com sucesso (DELETE)

### Erros do Cliente

- **401 Unauthorized**: Token inválido ou ausente
- **403 Forbidden**: Usuário não tem permissão
- **404 Not Found**: Recurso não encontrado

### Erros do Servidor

- **500 Internal Server Error**: Erro interno do servidor

---

## 🔄 Fluxos de Uso Comuns

### 1. Novo Usuário Criando Primeiro Treino

```
1. POST /register
   → Cria conta com email e senha
   → Recebe dados do usuário

2. POST /login
   → Autentica com credenciais
   → Recebe token JWT

3. POST /trainings
   → Cria plano com dias e exercícios
   → Recebe plano completo

4. GET /trainings
   → Lista todos os planos
   → Visualiza treino criado
```

### 2. Editando Treino Existente

```
1. GET /trainings
   → Lista planos existentes

2. GET /trainings/:id
   → Busca plano específico

3. POST /trainings/:id/workouts
   → Adiciona novo dia

4. POST /workouts/:id/exercises
   → Adiciona exercícios ao dia

5. PATCH /exercises/:id
   → Ajusta séries/repetições
```

### 3. Admin Gerenciando Usuários

```
1. POST /login (como admin)
   → Autentica com conta admin

2. GET /users
   → Lista todos usuários

3. PATCH /users/:id
   → Atualiza role de usuário

4. DELETE /users/:id
   → Remove usuário problemático
```

---

## ⚠️ Observações Importantes

### Segurança

1. **Senhas nunca são retornadas** nas respostas da API
2. **Tokens JWT devem ser armazenados de forma segura** no cliente
3. **HTTPS deve ser usado em produção**
4. **Rate limiting deve ser implementado** para prevenir abuso

### Performance

1. **Eager loading** de relacionamentos em queries de listagem
2. **Índices** em campos de busca frequente (userId, email)
3. **Paginação** deve ser implementada para listas grandes

### Validações

1. **Validação de entrada** usando Zod em todas as rotas
2. **Validação de propriedade** antes de operações
3. **Sanitização** de dados de entrada

### Boas Práticas

1. **IDs numéricos** validados via regex
2. **Mensagens de erro descritivas** mas sem expor detalhes internos
3. **Logs** de operações críticas (autenticação, deleção)
4. **Testes** para todos os endpoints críticos

---

## 📚 Referências Técnicas

### Tecnologias Utilizadas

- **Framework**: Fastify
- **Validação**: Zod
- **ORM**: TypeORM
- **Autenticação**: Fastify JWT
- **Hash de Senha**: bcrypt
- **Banco de Dados**: PostgreSQL

### Padrões de Código

- **DTOs**: Definidos com Zod schemas
- **Controllers**: Separados por domínio
- **Use Cases**: Lógica de negócio isolada
- **Middlewares**: Reutilizáveis e compostos

---

**Versão do Documento**: 1.0  
**Última Atualização**: 2026-02-04  
**Autor**: Sistema Melhorzin Treino
