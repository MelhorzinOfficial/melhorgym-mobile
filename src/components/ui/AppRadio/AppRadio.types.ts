export type RadioSize = 'sm' | 'md' | 'lg';

export interface RadioOption {
  label: string;
  value: string | number;
  disabled?: boolean;
  helperText?: string;
}

export interface AppRadioProps {
  modelValue: string | number;
  options: RadioOption[];
  name: string;
  label?: string;
  disabled?: boolean;
  required?: boolean;
  error?: string;
  helperText?: string;
  size?: RadioSize;
  orientation?: 'vertical' | 'horizontal';
  containerClass?: string;
}

export interface AppRadioEmits {
  'update:modelValue': [value: string | number];
  change: [value: string | number];
}
