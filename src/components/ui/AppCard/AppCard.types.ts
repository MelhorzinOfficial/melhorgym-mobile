export type CardVariant = 'default' | 'primary' | 'secondary';
export type CardPadding = 'none' | 'sm' | 'md' | 'lg';

export interface AppCardProps {
  title?: string;
  variant?: CardVariant;
  padding?: CardPadding;
  hoverable?: boolean;
  clickable?: boolean;
  headerPadding?: boolean;
  contentPadding?: boolean;
  footerPadding?: boolean;
}

export interface AppCardEmits {
  click: [event: MouseEvent];
}
