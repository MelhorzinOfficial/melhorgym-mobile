export type FormLayout = 'single' | 'double' | 'triple' | 'auto';

export interface AppFormProps {
  title?: string;
  subtitle?: string;
  layout?: FormLayout;
  gap?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  containerClass?: string;
}

export interface AppFormEmits {
  submit: [event: Event];
}
