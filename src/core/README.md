# API Service - Sistema de Requisições com Axios

Sistema genérico de requisições HTTP usando Axios com suporte a decorators, paginação e tipagem completa.

## 📋 Índice

1. [Instalação](#instalação)
2. [Conceitos Básicos](#conceitos-básicos)
3. [Como Usar](#como-usar)
4. [Exemplos Práticos](#exemplos-práticos)
5. [API Reference](#api-reference)

---

## Instalação

As dependências já estão instaladas:

- `axios` - Cliente HTTP
- `reflect-metadata` - Suporte a decorators

---

## Conceitos Básicos

### 1. Entities

Entities são classes que representam seus modelos de dados e são decoradas com `@Entity` para definir o endpoint da API.

```typescript
import { Entity } from 'src/core/decorators';

@Entity('/workouts')
export class Workout {
  id?: number;
  name!: string;
  description?: string;
}
```

### 2. Decorator @Entity

O decorator `@Entity` define o endpoint base para as requisições:

```typescript
// Endpoint: /workouts
@Entity('/workouts')
export class Workout {}

// Endpoint: /v1/users (com versão)
@Entity('/users', 'v1')
export class User {}
```

### 3. ApiService

Serviço genérico que fornece métodos CRUD e customizados baseados na entity.

---

## Como Usar

### Passo 1: Criar uma Entity

```typescript
// src/entities/workout.entity.ts
import { Entity } from 'src/core/decorators';

@Entity('/workouts')
export class Workout {
  id?: number;
  name!: string;
  description?: string;
  exercises?: Exercise[];
  createdAt?: Date;
}
```

### Passo 2: Criar um Service (Opcional)

Você pode usar diretamente o `ApiService` ou criar um service customizado:

#### Opção A: Uso Direto

```typescript
import { ApiService } from 'src/core/services';
import { Workout } from 'src/entities/workout.entity';

const workoutService = new ApiService(Workout);

// Usar o serviço
const workouts = await workoutService.findAll();
```

#### Opção B: Service Customizado

```typescript
// src/services/workout.service.ts
import { ApiService } from 'src/core/services';
import { Workout } from 'src/entities/workout.entity';

class WorkoutService extends ApiService<Workout> {
  constructor() {
    super(Workout);
  }

  // Adicionar métodos customizados
  async findByType(type: string): Promise<Workout[]> {
    return this.custom<Workout[]>('GET', undefined, undefined, { type });
  }

  async duplicate(id: number): Promise<Workout> {
    return this.custom<Workout>('POST', `/${id}/duplicate`);
  }
}

export const workoutService = new WorkoutService();
```

### Passo 3: Usar o Service

```typescript
import { workoutService } from 'src/services/workout.service';

// Buscar todos
const workouts = await workoutService.findAll();

// Buscar com paginação
const paginated = await workoutService.findAll({
  page: 1,
  limit: 10,
});

// Buscar por ID
const workout = await workoutService.findById(1);

// Criar
const newWorkout = await workoutService.create({
  name: 'Treino A',
  description: 'Treino de peito e tríceps',
});

// Atualizar
const updated = await workoutService.update(1, {
  name: 'Treino A - Atualizado',
});

// Deletar
await workoutService.delete(1);

// Método customizado
const strengthWorkouts = await workoutService.findByType('strength');
```

---

## Exemplos Práticos

### Uso em Componentes Vue

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { workoutService } from 'src/services/workout.service';
import type { Workout } from 'src/entities/workout.entity';

const workouts = ref<Workout[]>([]);
const loading = ref(false);

async function loadWorkouts() {
  loading.value = true;
  try {
    workouts.value = await workoutService.findAll();
  } catch (error) {
    console.error('Erro ao carregar treinos:', error);
  } finally {
    loading.value = false;
  }
}

async function createWorkout(data: Partial<Workout>) {
  try {
    const newWorkout = await workoutService.create(data);
    workouts.value.push(newWorkout);
  } catch (error) {
    console.error('Erro ao criar treino:', error);
  }
}

onMounted(() => {
  loadWorkouts();
});
</script>
```

### Paginação

```typescript
import type { PaginatedResponse } from 'src/core/interfaces';

// Buscar página 2 com 20 itens
const response = (await workoutService.findAll({
  page: 2,
  limit: 20,
  sortBy: 'createdAt',
  sortOrder: 'desc',
})) as PaginatedResponse<Workout>;

console.log(response.data); // Array de workouts
console.log(response.meta.totalPages); // Total de páginas
console.log(response.meta.hasNextPage); // Tem próxima página?
```

### Filtros e Query Params

```typescript
// Filtros customizados
const activeWorkouts = await workoutService.findAll({
  active: true,
  type: 'strength',
  page: 1,
  limit: 10,
});
```

### Requisições Customizadas

```typescript
// GET customizado
const stats = await workoutService.custom('GET', '/stats');

// POST customizado
const result = await workoutService.custom(
  'POST',
  '/bulk-create',
  { workouts: [...] }
);

// Com query params
const filtered = await workoutService.custom(
  'GET',
  '/search',
  undefined,
  { query: 'treino', category: 'strength' }
);
```

### Composables (Reutilização)

```typescript
// src/composables/useWorkouts.ts
import { ref } from 'vue';
import { workoutService } from 'src/services/workout.service';
import type { Workout } from 'src/entities/workout.entity';

export function useWorkouts() {
  const workouts = ref<Workout[]>([]);
  const loading = ref(false);
  const error = ref<Error | null>(null);

  async function load() {
    loading.value = true;
    error.value = null;
    try {
      workouts.value = await workoutService.findAll();
    } catch (e) {
      error.value = e as Error;
    } finally {
      loading.value = false;
    }
  }

  async function create(data: Partial<Workout>) {
    const workout = await workoutService.create(data);
    workouts.value.push(workout);
    return workout;
  }

  async function remove(id: number) {
    await workoutService.delete(id);
    workouts.value = workouts.value.filter((w) => w.id !== id);
  }

  return {
    workouts,
    loading,
    error,
    load,
    create,
    remove,
  };
}
```

Uso do composable:

```vue
<script setup lang="ts">
import { useWorkouts } from 'src/composables/useWorkouts';

const { workouts, loading, load, create, remove } = useWorkouts();

onMounted(() => load());
</script>

<template>
  <div v-if="loading">Carregando...</div>
  <div v-else>
    <div v-for="workout in workouts" :key="workout.id">
      {{ workout.name }}
      <button @click="remove(workout.id!)">Deletar</button>
    </div>
  </div>
</template>
```

---

## API Reference

### ApiService<T>

#### Métodos

##### `findAll(params?, config?)`

Busca todos os registros.

**Parâmetros:**

- `params?: QueryParams` - Parâmetros de query (paginação, filtros)
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<T[] | PaginatedResponse<T>>`

---

##### `findById(id, config?)`

Busca um registro por ID.

**Parâmetros:**

- `id: string | number` - ID do registro
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<T>`

---

##### `create(data, config?)`

Cria um novo registro.

**Parâmetros:**

- `data: Partial<T>` - Dados do registro
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<T>`

---

##### `update(id, data, config?)`

Atualiza um registro (PUT).

**Parâmetros:**

- `id: string | number` - ID do registro
- `data: Partial<T>` - Dados para atualização
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<T>`

---

##### `patch(id, data, config?)`

Atualiza parcialmente um registro (PATCH).

**Parâmetros:**

- `id: string | number` - ID do registro
- `data: Partial<T>` - Dados para atualização
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<T>`

---

##### `delete(id, config?)`

Deleta um registro.

**Parâmetros:**

- `id: string | number` - ID do registro
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<void>`

---

##### `custom<R>(method, path?, data?, params?, config?)`

Requisição customizada.

**Parâmetros:**

- `method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'` - Método HTTP
- `path?: string` - Caminho adicional ao endpoint
- `data?: any` - Dados da requisição
- `params?: QueryParams` - Query params
- `config?: RequestConfig` - Configurações da requisição

**Retorna:** `Promise<R>`

---

### Interfaces

#### QueryParams

```typescript
interface QueryParams {
  page?: number;
  limit?: number;
  perPage?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
  [key: string]: any;
}
```

#### PaginatedResponse<T>

```typescript
interface PaginatedResponse<T> {
  data: T[];
  meta: PaginationMeta;
}
```

#### PaginationMeta

```typescript
interface PaginationMeta {
  currentPage: number;
  totalPages: number;
  totalItems: number;
  itemsPerPage: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}
```

---

## Estrutura de Pastas

```
src/
├── core/
│   ├── decorators/
│   │   ├── entity.decorator.ts
│   │   └── index.ts
│   ├── interfaces/
│   │   ├── api.interface.ts
│   │   └── index.ts
│   ├── services/
│   │   ├── api.service.ts
│   │   └── index.ts
│   └── index.ts
├── entities/
│   ├── workout.entity.ts
│   ├── user.entity.ts
│   └── index.ts
└── services/
    ├── workout.service.ts
    ├── user.service.ts
    └── index.ts
```

---

## Configuração da API Base URL

Edite o arquivo `src/boot/axios.ts`:

```typescript
const api = axios.create({
  baseURL: 'https://sua-api.com/api',
});
```

---

## Próximos Passos

1. Configure a baseURL no `src/boot/axios.ts`
2. Crie suas entities em `src/entities/`
3. Crie seus services em `src/services/`
4. Use nos seus componentes Vue! 🚀
