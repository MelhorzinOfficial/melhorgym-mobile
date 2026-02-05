export interface PageContentProps {
  /**
   * Título da seção de conteúdo
   */
  title?: string;

  /**
   * Subtítulo ou descrição
   */
  subtitle?: string;

  /**
   * Se deve exibir uma linha divisória após o título
   * @default false
   */
  divider?: boolean;

  /**
   * Padding interno do conteúdo
   * @default 'md'
   */
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';

  /**
   * Cor de fundo do card de conteúdo
   * @default 'bg-white'
   */
  bgColor?: string;

  /**
   * Se deve exibir sombra no card
   * @default true
   */
  shadow?: boolean;

  /**
   * Arredondamento das bordas
   * @default 'md'
   */
  rounded?: 'none' | 'sm' | 'md' | 'lg' | 'xl' | 'full';

  /**
   * Classe CSS adicional
   */
  class?: string;
}
