# Componentes de Layout

Esta pasta contém os componentes de layout principais da aplicação, desenvolvidos com Tailwind CSS 3.4.

## Componentes

### Header

Componente de cabeçalho fixo no topo da página.

**Props:**

- `title`: Título do header (padrão: "Meu Treino")
- `showLogo`: Se deve mostrar o logo (padrão: true)
- `logoUrl`: URL do logo customizado
- `fixed`: Se o header deve ter posição fixa (padrão: true)
- `class`: Classe CSS adicional

**Slots:**

- `actions`: Ações/botões à direita do header

**Exemplo de uso:**

```vue
<Header title="Meu App">
  <template #actions>
    <button>Login</button>
  </template>
</Header>
```

---

### Footer

Componente de navegação fixo na parte inferior da página.

**Props:**

- `navigationItems`: Array de itens de navegação
- `fixed`: Se o footer deve ter posição fixa (padrão: true)
- `class`: Classe CSS adicional

**Interface NavigationItem:**

```typescript
{
  id: string;
  label: string;
  icon?: string;
  to?: string;
  active?: boolean;
  badge?: string | number;
}
```

**Exemplo de uso:**

```vue
<Footer :navigation-items="navItems" />
```

---

### Page

Container principal da página com padding e responsividade.

**Props:**

- `padding`: Tamanho do padding ('none' | 'sm' | 'md' | 'lg' | 'xl') (padrão: 'md')
- `paddingTop`: Se deve incluir padding no topo (padrão: true)
- `paddingBottom`: Se deve incluir padding na parte inferior (padrão: true)
- `bgColor`: Cor de fundo da página (padrão: 'bg-gray-50')
- `contained`: Se o conteúdo deve ter largura máxima limitada (padrão: false)
- `class`: Classe CSS adicional

**Exemplo de uso:**

```vue
<Page padding="lg" :contained="true">
  <PageContent title="Conteúdo">
    <!-- conteúdo aqui -->
  </PageContent>
</Page>
```

---

### PageContent

Card de conteúdo com título, subtítulo e estilos.

**Props:**

- `title`: Título da seção
- `subtitle`: Subtítulo ou descrição
- `divider`: Se deve exibir linha divisória após o título (padrão: false)
- `padding`: Padding interno ('none' | 'sm' | 'md' | 'lg' | 'xl') (padrão: 'md')
- `bgColor`: Cor de fundo (padrão: 'bg-white')
- `shadow`: Se deve exibir sombra (padrão: true)
- `rounded`: Arredondamento das bordas ('none' | 'sm' | 'md' | 'lg' | 'xl' | 'full') (padrão: 'md')
- `class`: Classe CSS adicional

**Slots:**

- `default`: Conteúdo principal
- `footer`: Conteúdo do rodapé

**Exemplo de uso:**

```vue
<PageContent title="Meu Título" subtitle="Descrição" :divider="true">
  <p>Conteúdo principal</p>
  
  <template #footer>
    <button>Ação</button>
  </template>
</PageContent>
```

## Importação

```typescript
// Importar componentes individualmente
import { Header, Footer, Page, PageContent } from 'components/layout';

// Importar tipos
import type {
  HeaderProps,
  FooterProps,
  NavigationItem,
  PageProps,
  PageContentProps,
} from 'components/layout';
```

## Estrutura de Pastas

```
layout/
├── Header/
│   ├── Header.vue
│   └── interfaces/
│       └── header.interface.ts
├── Footer/
│   ├── Footer.vue
│   └── interfaces/
│       └── footer.interface.ts
├── Page/
│   ├── Page.vue
│   └── interfaces/
│       └── page.interface.ts
├── PageContent/
│   ├── PageContent.vue
│   └── interfaces/
│       └── page-content.interface.ts
├── index.ts
└── README.md
```

## Exemplo Completo

```vue
<template>
  <div class="app-layout">
    <Header title="Meu Treino" />

    <Page>
      <PageContent title="Dashboard" subtitle="Visão geral dos seus treinos" :divider="true">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <!-- Cards aqui -->
        </div>

        <template #footer>
          <button class="btn-primary">Ver mais</button>
        </template>
      </PageContent>
    </Page>

    <Footer />
  </div>
</template>

<script setup lang="ts">
import { Header, Footer, Page, PageContent } from 'components/layout';
</script>
```
