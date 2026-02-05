export interface HeaderProps {
  /**
   * Título do header
   */
  title?: string;

  /**
   * Se deve mostrar o logo
   */
  showLogo?: boolean;

  /**
   * URL do logo customizado
   */
  logoUrl?: string;

  /**
   * Se o header deve ter posição fixa
   */
  fixed?: boolean;

  /**
   * Classe CSS adicional
   */
  class?: string;

  /**
   * Se o header deve ter elevação (sombra)
   */
  elevated?: boolean;
}
