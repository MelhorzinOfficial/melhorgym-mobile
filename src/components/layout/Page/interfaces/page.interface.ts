export interface PageProps {
  /**
   * Padding da página
   * @default 'md'
   */
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';

  /**
   * Se deve incluir padding no topo (útil quando há header fixo)
   * @default true
   */
  paddingTop?: boolean;

  /**
   * Se deve incluir padding na parte inferior (útil quando há footer fixo)
   * @default true
   */
  paddingBottom?: boolean;

  /**
   * Cor de fundo da página
   */
  bgColor?: string;

  /**
   * Classe CSS adicional
   */
  class?: string;

  /**
   * Se o conteúdo deve ter largura máxima limitada
   * @default false
   */
  contained?: boolean;
}
