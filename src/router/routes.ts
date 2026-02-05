import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  // Rotas públicas (sem autenticação)
  {
    path: '/login',
    name: 'login',
    component: () => import('pages/LoginPage.vue'),
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('pages/RegisterPage.vue'),
  },
  {
    path: '/auth/callback',
    name: 'auth-callback',
    component: () => import('pages/AuthCallbackPage.vue'),
  },

  // Rotas protegidas (com autenticação)
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      {
        path: '',
        name: 'home',
        component: () => import('pages/IndexPage.vue'),
      },
      {
        path: 'workouts',
        name: 'workouts',
        component: () => import('pages/WorkoutsPage.vue'),
      },
      {
        path: 'workouts/create',
        name: 'workouts-create',
        component: () => import('pages/CreateWorkoutPage.vue'),
      },
      {
        path: 'workouts/:id/edit',
        name: 'workouts-edit',
        component: () => import('pages/CreateWorkoutPage.vue'),
      },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
];

export default routes;
