export interface NavigationItem {
  /**
   * Identificador único do item de navegação
   */
  id: string;

  /**
   * Nome do item a ser exibido
   */
  label: string;

  /**
   * Ícone do item (nome do ícone do Material Icons ou outro)
   */
  icon?: string;

  /**
   * Rota do vue-router
   */
  to?: string;

  /**
   * Se o item está ativo
   */
  active?: boolean;

  /**
   * Badge/contador a ser exibido
   */
  badge?: string | number;
}

export interface FooterProps {
  /**
   * Itens de navegação do footer
   */
  navigationItems?: NavigationItem[];

  /**
   * Se o footer deve ter posição fixa
   */
  fixed?: boolean;

  /**
   * Classe CSS adicional
   */
  class?: string;
}
